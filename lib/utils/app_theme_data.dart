import 'package:flutter/material.dart';

class AppThemeData {
  final Color primary;
  final Color accent;
  final Color primaryText;
  final Color secondaryText;
  final Color background;
  final Color borderColor;
  final Color success;
  final Color warning;
  final Color error;
  final Color shadowColor;
  final Color buttonText; // Adicionado: Nova propriedade para a cor do texto do botão

  AppThemeData({
    required this.primary,
    required this.accent,
    required this.primaryText,
    required this.secondaryText,
    required this.background,
    required this.borderColor,
    required this.success,
    required this.warning,
    required this.error,
    required this.shadowColor,
    required this.buttonText, // Adicionado ao construtor
  });

  static AppThemeData fromJson(Map<String, dynamic> json) {
    return AppThemeData(
      primary: Color(int.parse(json['primary'])),
      accent: Color(int.parse(json['accent'])),
      primaryText: Color(int.parse(json['primaryText'])),
      secondaryText: Color(int.parse(json['secondaryText'])),
      background: Color(int.parse(json['background'])),
      borderColor: Color(int.parse(json['borderColor'])),
      success: Color(int.parse(json['success'])),
      warning: Color(int.parse(json['warning'])),
      error: Color(int.parse(json['error'])),
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
      buttonText: Color(int.parse(json['buttonText'])), // Adicionado ao fromJson
    );
  }
}