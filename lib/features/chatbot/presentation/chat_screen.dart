import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../i18n/strings.g.dart';
import '../data/chatbot_repository.dart';
import '../domain/chat_message.dart';

/// AI Asistan sohbet ekranı — `/api/chatbot/stream` SSE akışı.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final List<ChatMessage> _messages = [];
  StreamSubscription<String>? _sub;
  bool _streaming = false;
  bool _greeted = false;

  @override
  void dispose() {
    _sub?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
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

  void _send() {
    final text = _input.text.trim();
    if (text.isEmpty || _streaming) return;

    // Geçmiş = mevcut mesajdan önceki konuşma.
    final history = List<ChatMessage>.from(_messages);

    setState(() {
      _messages.add(ChatMessage(role: ChatRole.user, text: text));
      _messages.add(const ChatMessage(role: ChatRole.assistant, text: ''));
      _streaming = true;
      _input.clear();
    });
    _scrollToBottom();

    final stream = ref
        .read(chatbotRepositoryProvider)
        .streamReply(message: text, history: history);

    _sub = stream.listen(
      (chunk) {
        if (!mounted) return;
        setState(() {
          final last = _messages.last;
          _messages[_messages.length - 1] =
              last.copyWith(text: last.text + chunk);
        });
        _scrollToBottom();
      },
      onError: (Object e) {
        if (!mounted) return;
        final msg = e is ApiException ? e.message : context.t.chat.errorGeneric;
        setState(() {
          // Boş asistan baloncuğunu hata mesajıyla doldur.
          if (_messages.isNotEmpty && _messages.last.text.isEmpty) {
            _messages[_messages.length - 1] =
                _messages.last.copyWith(text: msg);
          }
          _streaming = false;
        });
      },
      onDone: () {
        if (!mounted) return;
        setState(() {
          // Yanıt boş geldiyse hata göster.
          if (_messages.isNotEmpty && _messages.last.text.isEmpty) {
            _messages[_messages.length - 1] =
                _messages.last.copyWith(text: context.t.chat.errorGeneric);
          }
          _streaming = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    if (!_greeted) {
      _greeted = true;
      _messages.add(ChatMessage(role: ChatRole.assistant, text: t.chat.greeting));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.smart_toy_outlined, size: 20),
            const SizedBox(width: 8),
            Text(t.chat.title),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(AppSpacing.margin),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final isLast = i == _messages.length - 1;
                return _Bubble(
                  message: m,
                  showTyping: _streaming && isLast && m.text.isEmpty,
                );
              },
            ),
          ),
          _InputBar(
            controller: _input,
            enabled: !_streaming,
            onSend: _send,
            hint: t.chat.inputHint,
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, this.showTyping = false});
  final ChatMessage message;
  final bool showTyping;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final bg = isUser ? AppColors.primary : AppColors.surfaceVariant;
    final fg = isUser ? Colors.white : AppColors.textPrimary;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
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
            bottomLeft: Radius.circular(isUser ? AppRadius.lg : 4),
            bottomRight: Radius.circular(isUser ? 4 : AppRadius.lg),
          ),
        ),
        child: showTyping
            ? const SizedBox(
                height: 18,
                width: 30,
                child: Center(
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : Text(message.text, style: TextStyle(color: fg, height: 1.35)),
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
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                decoration: InputDecoration(
                  hintText: hint,
                  fillColor: AppColors.surfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
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
