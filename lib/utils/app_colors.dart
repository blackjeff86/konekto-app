import 'package:flutter/material.dart';

class AppColors {
  // Cor base, um azul muito escuro
  static const Color primary = Color(0xFF0F172A);

  // Cor de destaque, um azul mais claro para botões ou ícones
  static const Color accent = Color(0xFF1E293B);

  // Cor principal para textos, um cinza escuro para melhor legibilidade
  static const Color primaryText = Color(0xFF111416);

  // Cor secundária para textos, um cinza claro para legendas ou informações adicionais
  static const Color secondaryText = Color(0xFF637287);
  
  // Cor de fundo, um branco levemente acinzentado para não cansar a vista
  static const Color background = Color(0xFFF8FAFC);

  // Cor de bordas e divisores
  static const Color borderColor = Color(0xFFE5E8EA);

  // Cores de feedback (sucesso, aviso, erro)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Nova cor para a sombra, usando preto com 10% de opacidade
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.1);

  // Nova cor para o texto secundário com opacidade reduzida (50%)
  static const Color secondaryTextLowOpacity = Color.fromRGBO(99, 114, 135, 0.5);
}