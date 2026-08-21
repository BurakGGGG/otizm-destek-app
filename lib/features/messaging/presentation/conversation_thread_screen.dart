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
import '../../../core/widgets/user_avatar.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../profile/data/block_repository.dart';
import '../data/messaging_repository.dart';
import '../domain/conversation.dart';
import '../domain/message.dart';
import '../domain/pecs_cards.dart';

/// Sohbet thread ekranı — REST geçmiş + STOMP canlı mesajlar + REST gönderim.
class ConversationThreadScreen extends ConsumerStatefulWidget {
  const ConversationThreadScreen({
    super.key,
    required this.conversationId,
    required this.title,
    this.otherUserId,
    this.isGroup = false,
  });

  final String conversationId;
  final String title;

  /// Birebir sohbette karşı tarafın kimliği — engelleme için gerekir.
  /// Grup sohbetlerinde null.
  final String? otherUserId;

  /// Grup sohbeti mi (ad değiştirme ve üye yönetimi için).
  final bool isGroup;

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
  /// Karşı tarafı engeller (mesaj gönderemez hâle gelir).
  Future<void> _blockUser() async {
    final userId = widget.otherUserId;
    if (userId == null) return;
    final t = context.t;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.messages.blockUser),
        content: Text(t.messages.blockConfirm(name: widget.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.messages.blockUser),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await ref.read(blockRepositoryProvider).block(userId);
      ref.invalidate(blockedUsersProvider);
      ref.invalidate(conversationsProvider);
      Haptics.warning();
      messenger.showSnackBar(SnackBar(content: Text(t.messages.blocked)));
      navigator.pop();
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

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
            // Silme yalnızca kendi mesajında; sunucu da sahipliği doğruluyor.
            if (message.isMine(ref.read(authControllerProvider).user?.id))
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: context.colors.error,
                ),
                title: Text(
                  t.messages.deleteMessage,
                  style: TextStyle(color: context.colors.error),
                ),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _deleteMessage(message);
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

  Future<void> _deleteMessage(Message message) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(messagingRepositoryProvider).deleteMessage(message.id);
      if (!mounted) return;
      setState(() {
        _messages.removeWhere((m) => m.id == message.id);
        _ids.remove(message.id);
      });
      ref.invalidate(conversationsProvider);
    } on ApiException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
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
          if (widget.isGroup)
            IconButton(
              tooltip: t.messages.groupSettings,
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) =>
                    _GroupSettingsSheet(conversationId: widget.conversationId),
              ),
              icon: const Icon(Icons.group_outlined),
            ),
          if (widget.otherUserId != null)
            IconButton(
              tooltip: t.messages.blockUser,
              onPressed: _blockUser,
              icon: const Icon(Icons.block),
            ),
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
            tooltip: context.t.common.a11y.cancelReply,
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
              tooltip: context.t.common.a11y.send,
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
                  tooltip: context.t.common.a11y.close,
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

/// Grup sohbeti ayarları — ad değiştirme ve üye ekleme/çıkarma
/// (web `MessagesPage` içindeki "Grup Ayarları" paneli).
class _GroupSettingsSheet extends ConsumerStatefulWidget {
  const _GroupSettingsSheet({required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<_GroupSettingsSheet> createState() =>
      _GroupSettingsSheetState();
}

class _GroupSettingsSheetState extends ConsumerState<_GroupSettingsSheet> {
  final _name = TextEditingController();
  final _search = TextEditingController();
  Timer? _debounce;
  Conversation? _conversation;
  List<Participant> _results = const [];
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _name.dispose();
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final conversation = await ref
          .read(messagingRepositoryProvider)
          .findConversation(widget.conversationId);
      if (!mounted) return;
      setState(() {
        _conversation = conversation;
        _name.text = conversation?.title ?? '';
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  void _onSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (value.trim().length < 2) {
        if (mounted) setState(() => _results = const []);
        return;
      }
      try {
        final users =
            await ref.read(messagingRepositoryProvider).searchUsers(value);
        if (mounted) setState(() => _results = users);
      } on ApiException catch (_) {
        // Arama hatası sessiz: panel çalışmaya devam eder.
      }
    });
  }

  Future<void> _apply(
    Future<Conversation> Function() action,
    String okMessage,
  ) async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final updated = await action();
      ref.invalidate(conversationsProvider);
      if (!mounted) return;
      setState(() {
        _conversation = updated;
        _busy = false;
      });
      Haptics.selection();
      messenger.showSnackBar(SnackBar(content: Text(okMessage)));
    } on ApiException catch (e) {
      if (mounted) setState(() => _busy = false);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final repo = ref.read(messagingRepositoryProvider);
    final currentUserId = ref.watch(authControllerProvider).user?.id;
    final members = _conversation?.participants
            .where((p) => p.id != currentUserId)
            .toList() ??
        const <Participant>[];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.margin,
          right: AppSpacing.margin,
          top: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.messages.groupSettings, style: text.titleMedium),
              const SizedBox(height: 12),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                          labelText: t.messages.groupNameLabel,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: AppButtonStyles.inlineFilled,
                      onPressed: _busy
                          ? null
                          : () => _apply(
                                () => repo.updateGroupTitle(
                                  widget.conversationId,
                                  _name.text,
                                ),
                                t.messages.groupRenamed,
                              ),
                      child: Text(t.messages.groupRename),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(t.messages.groupAddMember, style: text.labelLarge),
                const SizedBox(height: 6),
                TextField(
                  controller: _search,
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    hintText: t.messages.searchUserHint,
                    prefixIcon: const Icon(Icons.search, size: 20),
                  ),
                ),
                for (final user in _results.take(4))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: UserAvatar(
                      name: user.fullName,
                      imageUrl: user.profileImageUrl,
                      radius: 16,
                    ),
                    title: Text(user.fullName),
                    trailing: const Icon(Icons.person_add_alt_1_outlined),
                    onTap: _busy
                        ? null
                        : () => _apply(
                              () => repo.addMember(
                                widget.conversationId,
                                user.id,
                              ),
                              t.messages.groupMemberAdded,
                            ),
                  ),
                const SizedBox(height: 16),
                Text(t.messages.groupMembers, style: text.labelLarge),
                for (final member in members)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: UserAvatar(
                      name: member.fullName,
                      imageUrl: member.profileImageUrl,
                      radius: 16,
                    ),
                    title: Text(member.fullName),
                    subtitle: member.role == 'EXPERT'
                        ? Text(context.t.roles.expert)
                        : null,
                    trailing: IconButton(
                      tooltip: t.messages.groupMemberRemoved,
                      icon: Icon(
                        Icons.person_remove_outlined,
                        color: context.colors.error,
                      ),
                      onPressed: _busy
                          ? null
                          : () => _apply(
                                () => repo.removeMember(
                                  widget.conversationId,
                                  member.id,
                                ),
                                t.messages.groupMemberRemoved,
                              ),
                    ),
                  ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
