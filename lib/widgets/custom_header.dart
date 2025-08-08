import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart'; // CORRIGIDO: Usa a nova classe de cores

class CustomHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final AppThemeData appColors; // ADICIONADO: Parâmetro para as cores dinâmicas

  const CustomHeader({
    super.key,
    required this.title,
    required this.appColors, // ADICIONADO: ao construtor
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 48,
            child: leading ?? const SizedBox.shrink(),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: appColors.primaryText, // ALTERADO: Usa cor dinâmica
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
          ),
          SizedBox(
            width: 48,
            child: trailing ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}