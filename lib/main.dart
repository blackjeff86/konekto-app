// lib/main.dart
import 'package:flutter/material.dart';
// Para rootBundle
import 'package:intl/date_symbol_data_local.dart'; 

import 'utils/app_theme_data.dart'; // Certifique-se de que esta linha está correta
import 'screens/check_in_status_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Definimos algumas cores básicas aqui para que a tela inicial tenha um tema
    // antes mesmo do tenantConfig ser carregado.
    // ESTA INICIALIZAÇÃO AGORA CORRESPONDE EXATAMENTE À SUA CLASSE APPTHEMEDATA
    final AppThemeData defaultAppColors = AppThemeData(
      primary: const Color(0xFF0F172A), // Azul escuro da Konekto (cor do fundo da tela de check-in)
      onPrimary: Colors.white,           // Texto/ícones sobre a cor primary (azul escuro)
      accent: const Color(0xFF3B82F6),   // Um azul mais vibrante para destaque (campo de texto)
      primaryText: Colors.white,         // Texto principal branco
      secondaryText: Colors.grey[400]!,  // Texto secundário cinza claro
      background: Colors.grey[50]!,      // Cor de fundo geral do app (quando o tenantConfig for carregado)
      cardBackground: Colors.white,      // Fundo de cards branco
      buttonBackground: const Color(0xFF3B82F6), // Exemplo de cor para botões
      borderColor: Colors.grey[700]!,     // Cor de borda para inputs, etc.
      success: Colors.green,             // Cor para mensagens de sucesso
      warning: Colors.orange,            // Cor para mensagens de alerta/aguardando
      error: Colors.red,                 // Cor para mensagens de erro
      onError: Colors.white,             // Texto/ícones sobre a cor de erro
      shadowColor: Colors.black.withOpacity(0.2), // Sombra padrão
      buttonText: Colors.white,          // Texto em botões
      splashScreenIconPath: 'assets/images/icons/default_icon.png', // Caminho padrão para ícone da splash (você pode ajustar)
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Konekto App', 
      theme: ThemeData(
        primaryColor: defaultAppColors.primary,
        scaffoldBackgroundColor: defaultAppColors.background, 
        // Definir um TextTheme básico para a tela inicial
        textTheme: TextTheme(
          headlineMedium: TextStyle(color: defaultAppColors.primaryText),
          titleLarge: TextStyle(color: defaultAppColors.primaryText),
          titleMedium: TextStyle(color: defaultAppColors.primaryText),
          bodyLarge: TextStyle(color: defaultAppColors.primaryText),
          bodyMedium: TextStyle(color: defaultAppColors.primaryText),
        ),
        // Embora 'extensions' seja bom para temas mais complexos,
        // para sua AppThemeData, você pode acessá-lo diretamente
        // como `widget.appColors.primary` ou via `Theme.of(context).primaryColor`
        // se você mapear as cores para as propriedades padrão do ThemeData.
        // No entanto, para usar todas as suas cores personalizadas facilmente,
        // passá-las diretamente para os widgets é o ideal.
      ),
      home: CheckInStatusScreen(
        tenantConfig: const {}, 
        appColors: defaultAppColors,
      ),
    );
  }
}