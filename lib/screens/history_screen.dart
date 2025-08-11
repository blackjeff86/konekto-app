// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';

class HistoryScreen extends StatelessWidget {
  final AppThemeData appColors;

  const HistoryScreen({
    super.key,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      appBar: AppBar(
        backgroundColor: appColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColors.primaryText),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Histórico',
          style: TextStyle(
            color: appColors.primaryText,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Conteúdo da tela de Histórico será implementado aqui.',
          style: TextStyle(
            color: appColors.secondaryText,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}