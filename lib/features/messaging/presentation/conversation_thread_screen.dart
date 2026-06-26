import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/realtime/stomp_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../../auth/presentation/auth_controller.dart';
import '../data/messaging_repository.dart';
import '../domain/message.dart';

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

      // Canlı mesajlar için STOMP aboneliği.
      _unsub = await ref.read(stompServiceProvider).subscribe(
            '/topic/conversation/${widget.conversationId}',
            _onFrame,
          );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
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
      _input.clear();
      _addMessage(sent); // STOMP echo'su id ile tekilleştirilecek
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
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
          _InputBar(
            controller: _input,
            enabled: !_sending,
            onSend: _send,
            hint: t.messages.inputHint,
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
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
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
    final bg = mine ? AppColors.primary : AppColors.surfaceVariant;
    final fg = mine ? Colors.white : AppColors.textPrimary;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(mine ? AppRadius.lg : 4),
            bottomRight: Radius.circular(mine ? 4 : AppRadius.lg),
          ),
        ),
        child: Text(message.content, style: TextStyle(color: fg, height: 1.35)),
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
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: hint,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: enabled ? onSend : null,
              icon: const Icon(Icons.send),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.border,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
