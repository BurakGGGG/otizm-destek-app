import 'package:flutter/material.dart';

import '../../i18n/strings.g.dart';
import '../theme/app_colors.dart';

/// Doldurulmuş bir formdan geri çıkılırken onay ister.
///
/// Android'de kenardan kaydırma, uygulama çubuğundaki geri oku ve donanım
/// geri tuşu aynı yola çıkar; onaysız çıkışta uzun bir gözlem notu ya da
/// çocuk profili tek dokunuşta kayboluyordu. [hasChanges] pop anında
/// çağrılır, böylece formun her tuş vuruşunda yeniden çizilmesi gerekmez.
class UnsavedChangesGuard extends StatelessWidget {
  const UnsavedChangesGuard({
    super.key,
    required this.hasChanges,
    required this.child,
  });

  final ValueGetter<bool> hasChanges;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Her çıkışı yakalayıp kararı geri çağrıda veriyoruz; form temizse
      // kullanıcı hiçbir şey fark etmeden çıkar.
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (!hasChanges() || await confirmDiscardChanges(context)) {
          navigator.pop();
        }
      },
      child: child,
    );
  }
}

/// "Çıkarsan kaybolur" onayı. Çıkılacaksa `true` döner.
Future<bool> confirmDiscardChanges(BuildContext context) async {
  final t = context.t;
  final leave = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(t.common.unsaved.title),
      content: Text(t.common.unsaved.body),
      actions: [
        // Veriyi silen eylem daha sönük dursun; vurgulu düğme formda tutar.
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: context.colors.error,
          ),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(t.common.unsaved.leave),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(t.common.unsaved.stay),
        ),
      ],
    ),
  );
  return leave ?? false;
}
