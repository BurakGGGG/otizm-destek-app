import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/media.dart';
import '../../../core/network/upload_repository.dart';
import '../../../core/providers.dart';
import '../../../core/realtime/stomp_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/messaging_repository.dart';
import '../domain/message.dart';
import '../domain/pecs_cards.dart';

/// Sohbet thread ekranı — REST geçmiş + STOMP canlı mesajlar + REST gönderim.
class ConversationThreadScreen extends ConsumerStatefulWidget {
  const ConversationThreadScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });

  final String conversationId;
  final String title;

  @override
  ConsumerState<ConversationThreadScreen> createState() =>
      _ConversationThreadScreenState();
}

class _ConversationThreadScreenState
    extends ConsumerState<ConversationThreadScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<Message> _messages = [];
  final Set<String> _ids = {};

  bool _loading = true;
  bool _error = false;
  bool _sending = false;
  bool _showPecs = false;
  Message? _replyTo;
  void Function()? _unsub;
  void Function()? _unsubReactions;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _unsub?.call();
    _unsubReactions?.call();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      final history = await ref
          .read(messagingRepositoryProvider)
          .getMessages(widget.conversationId);
      for (final m in history) {
        if (_ids.add(m.id)) _messages.add(m);
      }
      if (!mounted) return;
      setState(() => _loading = false);
      _scrollToBottom();
      _markRead();

      // Canlı mesajlar ve tepkiler için STOMP abonelikleri.
      final stomp = ref.read(stompServiceProvider);
      _unsub = await stomp.subscribe(
        '/topic/conversation/${widget.conversationId}',
        _onFrame,
      );
      _unsubReactions = await stomp.subscribe(
        '/topic/conversation/${widget.conversationId}/reactions',
        _onReactionFrame,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  /// Konuşmayı okundu işaretler ve listedeki rozeti tazeler. Hata kullanıcıya
  /// gösterilmez: okuma bildirimi başarısız olsa da sohbet çalışmalı.
  Future<void> _markRead() async {
    try {
      await ref
          .read(messagingRepositoryProvider)
          .markAsRead(widget.conversationId);
      ref.invalidate(conversationsProvider);
    } catch (_) {
      // yok say
    }
  }

  void _onFrame(StompFrame frame) {
    final body = frame.body;
    if (body == null || body.isEmpty) return;
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return;
      if (!Message.isMessagePayload(decoded)) return; // READ_RECEIPT vb. atla
      _addMessage(Message.fromJson(decoded));
    } catch (_) {
      // bozuk frame yok say
    }
  }

  /// Tepki güncellemesi: sunucu mesajın güncel hâlini yayınlar.
  void _onReactionFrame(StompFrame frame) {
    final body = frame.body;
    if (body == null || body.isEmpty) return;
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return;
      _replaceMessage(Message.fromJson(decoded));
    } catch (_) {
      // bozuk frame yok say
    }
  }

  void _replaceMessage(Message updated) {
    if (updated.id.isEmpty || !mounted) return;
    final index = _messages.indexWhere((m) => m.id == updated.id);
    if (index < 0) return;
    setState(() => _messages[index] = updated);
  }

  Future<void> _toggleReaction(Message message, String emoji) async {
    try {
      final updated = await ref
          .read(messagingRepositoryProvider)
          .toggleReaction(message.id, emoji);
      Haptics.selection();
      _replaceMessage(updated);
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  /// Mesaja uzun basınca: yanıtla + hızlı tepki seçenekleri.
  Future<void> _openMessageActions(Message message) async {
    final t = context.t;
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.margin,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final emoji in kQuickReactions)
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      onTap: () {
                        Navigator.of(sheetContext).pop();
                        _toggleReaction(message, emoji);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.reply_outlined),
              title: Text(t.messages.reply),
              onTap: () {
                Navigator.of(sheetContext).pop();
                setState(() => _replyTo = message);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addMessage(Message m) {
    if (m.id.isEmpty || !_ids.add(m.id)) return; // tekilleştir
    if (!mounted) return;
    setState(() => _messages.add(m));
    _scrollToBottom();
  }

  /// PECS kartı: etiket metni `PECS` türüyle gönderilir (web birebir).
  Future<void> _sendPecs(PecsCard card) async {
    setState(() => _showPecs = false);
    _input.text = card.label;
    await _send(messageType: kMessageTypePecs);
  }

  /// Ekli dosyayı açar: uç nokta kimlik doğrulaması istediği için dosya
  /// Bearer'lı indirilip paylaşım sayfasına verilir (tarayıcıda açılamaz).
  Future<void> _openAttachment(Message message) async {
    final url = absoluteMediaUrl(message.fileUrl);
    if (url == null) return;
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sending = true);
    try {
      final bytes = await ref
          .read(messagingRepositoryProvider)
          .downloadAttachment(url);
      final dir = await getTemporaryDirectory();
      final name = message.fileName?.trim().isNotEmpty ?? false
          ? message.fileName!.trim()
          : 'ek';
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: message.fileType)],
          fileNameOverrides: [name],
        ),
      );
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(t.common.loadError)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  /// Fotoğraf eki: galeriden seçilip yüklenir, sonra IMAGE mesajı gönderilir.
  Future<void> _attachPhoto() async {
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() => _sending = true);
    try {
      final url = await ref.read(uploadRepositoryProvider).upload(
            picked.path,
            picked.name,
            scope: UploadScope(type: 'CONVERSATION', id: widget.conversationId),
          );
      final sent = await ref.read(messagingRepositoryProvider).sendMessage(
            widget.conversationId,
            _input.text.trim(),
            messageType: kMessageTypeImage,
            replyToId: _replyTo?.id,
            fileUrl: url,
            fileName: picked.name,
            fileType: picked.mimeType ?? 'image/jpeg',
          );
      _input.clear();
      if (mounted) setState(() => _replyTo = null);
      _addMessage(sent);
      messenger.showSnackBar(SnackBar(content: Text(t.messages.photoSent)));
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send({String messageType = kMessageTypeText}) async {
    final content = _input.text.trim();
    if (content.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final sent = await ref.read(messagingRepositoryProvider).sendMessage(
            widget.conversationId,
            content,
            messageType: messageType,
            replyToId: _replyTo?.id,
          );
      Haptics.selection();
      _input.clear();
      if (mounted) setState(() => _replyTo = null);
      _addMessage(sent); // STOMP echo'su id ile tekilleştirilecek
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final currentUserId = ref.watch(authControllerProvider).user?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: t.messages.searchInChat,
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) =>
                  _MessageSearchSheet(conversationId: widget.conversationId),
            ),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _body(t, currentUserId)),
          if (_replyTo != null)
            _ReplyBanner(
              message: _replyTo!,
              onCancel: () => setState(() => _replyTo = null),
            ),
          if (_showPecs)
            _PecsPanel(
              onSelect: _sendPecs,
              onClose: () => setState(() => _showPecs = false),
            ),
          _InputBar(
            controller: _input,
            enabled: !_sending,
            onSend: _send,
            hint: t.messages.inputHint,
            pecsOpen: _showPecs,
            onTogglePecs: () => setState(() => _showPecs = !_showPecs),
            onAttach: _sending ? null : _attachPhoto,
          ),
        ],
      ),
    );
  }

  Widget _body(Translations t, String? currentUserId) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: context.colors.error),
            const SizedBox(height: 12),
            Text(t.common.loadError),
          ],
        ),
      );
    }
    if (_messages.isEmpty) {
      return Center(child: Text(t.messages.noMessages));
    }
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(AppSpacing.margin),
      itemCount: _messages.length,
      itemBuilder: (context, i) => _Bubble(
        message: _messages[i],
        mine: _messages[i].isMine(currentUserId),
        onLongPress: () => _openMessageActions(_messages[i]),
        onReaction: (emoji) => _toggleReaction(_messages[i], emoji),
        onOpenFile: () => _openAttachment(_messages[i]),
      ),
    );
  }
}

class _Bubble extends ConsumerWidget {
  const _Bubble({
    required this.message,
    required this.mine,
    required this.onLongPress,
    required this.onReaction,
    required this.onOpenFile,
  });

  final Message message;
  final bool mine;
  final VoidCallback onLongPress;
  final ValueChanged<String> onReaction;
  final VoidCallback onOpenFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // İçerik bir PECS kartıysa emojisiyle birlikte gösterilir (web birebir).
    final card = pecsCardForContent(message.content);
    final bg = mine ? context.colors.primary : context.colors.surfaceVariant;
    final fg = mine ? Colors.white : context.colors.textPrimary;
    final image = message.hasImage
        ? mediaImageProvider(message.fileUrl, ref.watch(dioProvider))
        : null;

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: onLongPress,
            child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(mine ? AppRadius.lg : 4),
            bottomRight: Radius.circular(mine ? 4 : AppRadius.lg),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.replyToContent?.isNotEmpty ?? false)
              _QuotedMessage(message: message, mine: mine),
            if (image != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image(image: image, fit: BoxFit.cover),
              ),
              if (message.content.isNotEmpty) const SizedBox(height: 6),
            ] else if (message.hasFile) ...[
              InkWell(
                onTap: onOpenFile,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, size: 16, color: fg),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        message.fileName ?? message.fileUrl!,
                        style: TextStyle(
                          color: fg,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          decorationColor: fg,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (message.content.isNotEmpty) const SizedBox(height: 6),
            ],
            if (card != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(card.emoji, style: const TextStyle(fontSize: 34)),
                  const SizedBox(height: 2),
                  Text(
                    card.label,
                    style: TextStyle(color: fg, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            else if (message.content.isNotEmpty)
              Text(message.content, style: TextStyle(color: fg, height: 1.35)),
          ],
        ),
            ),
          ),
          if (message.reactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Wrap(
                spacing: 6,
                children: [
                  for (final entry in message.reactions.entries)
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      onTap: () => onReaction(entry.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: entry.value.reactedByMe
                              ? context.colors.primary.withValues(alpha: .12)
                              : context.colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          border: Border.all(
                            color: entry.value.reactedByMe
                                ? context.colors.primary.withValues(alpha: .4)
                                : context.colors.border,
                          ),
                        ),
                        child: Text(
                          '${entry.key} ${entry.value.count}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Yanıtlanan mesajın alıntısı (balon içinde).
class _QuotedMessage extends StatelessWidget {
  const _QuotedMessage({required this.message, required this.mine});

  final Message message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final color = mine ? Colors.white : context.colors.textSecondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color.withValues(alpha: .6), width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.replyToSenderName?.isNotEmpty ?? false)
            Text(
              message.replyToSenderName!,
              style: TextStyle(
                color: color.withValues(alpha: .9),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          Text(
            message.replyToContent ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color.withValues(alpha: .9), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Yanıtlanacak mesajı gösteren şerit (giriş çubuğunun üstünde).
class _ReplyBanner extends StatelessWidget {
  const _ReplyBanner({required this.message, required this.onCancel});

  final Message message;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      color: colors.surfaceVariant,
      child: Row(
        children: [
          Container(width: 3, height: 32, color: colors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.messages.replyingTo(
                    name: message.senderName ?? t.messages.someone,
                  ),
                  style: text.labelSmall?.copyWith(color: colors.primary),
                ),
                Text(
                  message.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.labelSmall
                      ?.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onCancel,
            icon: const Icon(Icons.close, size: 18),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.enabled,
    required this.onSend,
    required this.hint,
    required this.pecsOpen,
    required this.onTogglePecs,
    required this.onAttach,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  final String hint;
  final bool pecsOpen;
  final VoidCallback onTogglePecs;
  final VoidCallback? onAttach;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            IconButton(
              tooltip: context.t.messages.attachPhoto,
              onPressed: onAttach,
              icon: const Icon(Icons.attach_file, size: 20),
            ),
            IconButton(
              tooltip: context.t.messages.pecsTitle,
              onPressed: onTogglePecs,
              icon: Text(
                '🧸',
                style: TextStyle(
                  fontSize: 20,
                  color: pecsOpen ? context.colors.primary : null,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: hint,
                  fillColor: context.colors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(
                backgroundColor: context.colors.primary,
                disabledBackgroundColor: context.colors.border,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// PECS kart galerisi — kategori başlıkları ve etiketler paylaşılan veridir.
class _PecsPanel extends StatelessWidget {
  const _PecsPanel({required this.onSelect, required this.onClose});

  final ValueChanged<PecsCard> onSelect;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final text = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(t.messages.pecsTitle, style: text.labelLarge),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, size: 18),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            for (final category in kPecsCategories) ...[
              Text(
                category,
                style: text.labelSmall?.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final card in pecsCardsOf(category))
                    InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      onTap: () {
                        Haptics.selection();
                        onSelect(card);
                      },
                      child: Container(
                        width: 78,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.surfaceVariant,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          children: [
                            Text(
                              card.emoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              card.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: text.labelSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sohbet içinde mesaj arama — `GET /conversations/{id}/search?q=`.
/// Sonuca dokunmak listede o mesaja atlamaz (mesaj sayfalı geldiği için
/// konum garanti edilemiyor); sonuç metni sayfada okunur.
class _MessageSearchSheet extends ConsumerStatefulWidget {
  const _MessageSearchSheet({required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<_MessageSearchSheet> createState() =>
      _MessageSearchSheetState();
}

class _MessageSearchSheetState extends ConsumerState<_MessageSearchSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<Message> _results = const [];
  bool _searching = false;
  bool _searched = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String value) async {
    if (value.trim().isEmpty) {
      setState(() {
        _results = const [];
        _searched = false;
      });
      return;
    }
    setState(() => _searching = true);
    try {
      final results = await ref
          .read(messagingRepositoryProvider)
          .searchMessages(widget.conversationId, value);
      if (mounted) {
        setState(() {
          _results = results;
          _searched = true;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.margin,
          right: AppSpacing.margin,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.messages.searchInChat, style: text.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: t.messages.searchInChat,
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
            ),
            const SizedBox(height: 12),
            if (_searching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (_results.isEmpty && _searched)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  t.messages.searchNoResults,
                  style: text.labelSmall
                      ?.copyWith(color: context.colors.textSecondary),
                ),
              )
            else if (_results.isNotEmpty)
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 340),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final message = _results[i];
                    final sent = message.sentAt?.toLocal();
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        message.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        [
                          if (message.senderName?.isNotEmpty ?? false)
                            message.senderName!,
                          if (sent != null)
                            '${sent.day} ${t.common.monthsShort[sent.month - 1]}',
                        ].join(' · '),
                        style: text.labelSmall,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
