import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String message,
  required AppThemeData appColors,
  String okButtonText = 'OK', // Parâmetro para o texto do botão
  VoidCallback? onOkPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: appColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: appColors.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appColors.secondaryText,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Primeiro, executa a ação personalizada (navegação)
                  onOkPressed?.call();
                  // Depois, fecha o diálogo
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  okButtonText, // O texto do botão agora usa o novo parâmetro
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: appColors.buttonText,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}