import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/haptics.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../i18n/strings.g.dart';
import '../../../messaging/data/messaging_repository.dart';
import '../../../messaging/domain/conversation.dart';

/// Zorlanılan oyun için uzmana kısa not gönderme sayfası (web "Uzmana Bildir").
/// Mevcut DIRECT uzman konuşmalarından biri seçilir; mesaj REST ile gönderilir.
class NotifyExpertSheet extends ConsumerStatefulWidget {
  const NotifyExpertSheet({super.key, required this.gameTitle});

  final String gameTitle;

  @override
  ConsumerState<NotifyExpertSheet> createState() => _NotifyExpertSheetState();
}

class _NotifyExpertSheetState extends ConsumerState<NotifyExpertSheet> {
  late final TextEditingController _note;
  List<Conversation>? _expertConversations;
  String? _selectedId;
  bool _loading = true;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _note = TextEditingController();
    _loadExperts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_note.text.isEmpty) {
      _note.text = context.t.treatment.notifyDefaultMsg(game: widget.gameTitle);
    }
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _loadExperts() async {
    try {
      final conversations =
          await ref.read(messagingRepositoryProvider).getConversations();
      if (!mounted) return;
      final experts = conversations
          .where((c) =>
              c.type == 'DIRECT' &&
              c.participants.any((p) => p.role == 'EXPERT'))
          .toList();
      setState(() {
        _expertConversations = experts;
        _selectedId = experts.firstOrNull?.id;
        _loading = false;
      });
    } on ApiException {
      if (!mounted) return;
      setState(() {
        _expertConversations = const [];
        _loading = false;
      });
    }
  }

  Future<void> _send() async {
    final id = _selectedId;
    if (id == null || _note.text.trim().isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(messagingRepositoryProvider)
          .sendMessage(id, _note.text.trim());
      if (!mounted) return;
      Haptics.success();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.treatment.notifySent)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  String _expertName(Conversation c) {
    final expert =
        c.participants.where((p) => p.role == 'EXPERT').firstOrNull;
    return expert?.fullName ?? c.title ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final text = Theme.of(context).textTheme;
    final experts = _expertConversations;

    return Padding(
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
            Text(t.treatment.notifyExpert, style: text.titleMedium),
            const SizedBox(height: 6),
            Text(
              t.treatment.notifyBody(game: widget.gameTitle),
              style: text.bodySmall,
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (experts == null || experts.isEmpty) ...[
              Text(t.treatment.notifyNoExpert, style: text.bodySmall),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/home');
                  },
                  child: Text(t.treatment.notifySeeExperts),
                ),
              ),
            ] else ...[
              if (experts.length > 1) ...[
                DropdownButtonFormField<String>(
                  initialValue: _selectedId,
                  items: [
                    for (final c in experts)
                      DropdownMenuItem(
                        value: c.id,
                        child: Text(_expertName(c)),
                      ),
                  ],
                  onChanged: _sending
                      ? null
                      : (v) => setState(() => _selectedId = v),
                ),
                const SizedBox(height: 10),
              ],
              TextField(
                controller: _note,
                enabled: !_sending,
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _sending ? null : _send,
                  icon: _sending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send, size: 16),
                  label: Text(t.treatment.notifySend),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
