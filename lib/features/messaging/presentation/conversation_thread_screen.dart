import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../core/haptics.dart';
import '../../../core/network/api_exception.dart';
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
  void Function()? _unsub;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _unsub?.call();
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

      // Canlı mesajlar için STOMP aboneliği.
      _unsub = await ref
          .read(stompServiceProvider)
          .subscribe('/topic/conversation/${widget.conversationId}', _onFrame);
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

  void _addMessage(Message m) {
    if (m.id.isEmpty || !_ids.add(m.id)) return; // tekilleştir
    if (!mounted) return;
    setState(() => _messages.add(m));
    _scrollToBottom();
  }

  /// PECS kartı: etiket metni mesaj olarak gönderilir (paylaşılan veri).
  Future<void> _sendPecs(PecsCard card) async {
    setState(() => _showPecs = false);
    _input.text = card.label;
    await _send();
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

  Future<void> _send() async {
    final content = _input.text.trim();
    if (content.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final sent = await ref
          .read(messagingRepositoryProvider)
          .sendMessage(widget.conversationId, content);
      Haptics.selection();
      _input.clear();
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
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Expanded(child: _body(t, currentUserId)),
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
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});
  final Message message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    // İçerik bir PECS kartıysa emojisiyle birlikte gösterilir (web birebir).
    final card = pecsCardForContent(message.content);
    final bg = mine ? context.colors.primary : context.colors.surfaceVariant;
    final fg = mine ? Colors.white : context.colors.textPrimary;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
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
        child: card == null
            ? Text(message.content, style: TextStyle(color: fg, height: 1.35))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(card.emoji, style: const TextStyle(fontSize: 34)),
                  const SizedBox(height: 2),
                  Text(
                    card.label,
                    style: TextStyle(color: fg, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
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
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  final String hint;
  final bool pecsOpen;
  final VoidCallback onTogglePecs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
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
