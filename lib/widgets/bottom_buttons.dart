import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';

class BottomButtons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final AppThemeData appColors; // ADICIONADO: Parâmetro para as cores dinâmicas

  const BottomButtons({
    super.key,
    required this.text,
    required this.onPressed,
    required this.appColors, // ADICIONADO: ao construtor
  });

  @override
  Widget build(BuildContext context) {
    final safeAreaPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + safeAreaPadding),
      child: SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.primary, // ALTERADO: Usa cor dinâmica
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}