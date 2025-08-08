import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';

// Importe suas telas
import 'package:konekto_app/screens/home_screen.dart';
// Importe a classe que criamos para gerenciar as cores
import 'package:konekto_app/utils/app_theme_data.dart';

// Variáveis globais para armazenar os dados carregados
late Map<String, dynamic> tenantConfig;
late AppThemeData appColors;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  // Carrega o arquivo de configuração do inquilino (hotel_default.json)
  try {
    final String response = await rootBundle.loadString('assets/tenants/konekto_app_default/hotel_default.json');
    tenantConfig = json.decode(response);

    // Constrói a paleta de cores a partir da seção 'colors' do JSON
    // Certifique-se de que seu hotel_default.json tenha uma chave 'colors'
    final Map<String, dynamic> colorsData = tenantConfig['colors'];
    appColors = AppThemeData.fromJson(colorsData);
  } catch (e) {
    print('ERRO ao carregar ou decodificar a configuração do tenant: $e');
    // Em caso de erro, usa a configuração e as cores padrão (fallback)
    tenantConfig = {
      'name': 'Konekto App - Erro',
      'logoPath': 'assets/logos/default_logo.png',
      'bannerImages': {
        'homeBanner': 'assets/images/default_banner.png',
        'servicesBanner': 'assets/images/default_banner.png',
      },
      // Cores padrão em caso de falha ao carregar o JSON
      'colors': {
        "primary": "0xFF0F172A",
        "accent": "0xFF1E293B",
        "primaryText": "0xFF111416",
        "secondaryText": "0xFF637287",
        "background": "0xFFF8FAFC",
        "borderColor": "0xFFE5E8EA",
        "success": "0xFF10B981",
        "warning": "0xFFF59E0B",
        "error": "0xFFEF4444",
        "shadowColor": "0x1A000000" // Cor da sombra com 10% de opacidade (0x1A é 10% de 0xFF)
      }
    };
    // Inicializa appColors com os valores de fallback
    appColors = AppThemeData.fromJson(tenantConfig['colors']);
  }

  // Executa o aplicativo após o carregamento das configurações
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tenantConfig['name'] ?? 'Konekto App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: appColors.background,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Necessário para a construtora
          backgroundColor: appColors.background,
        ).copyWith(
          primary: appColors.primary,
          secondary: appColors.accent,
          surface: appColors.background,
          onPrimary: appColors.primaryText,
          onSecondary: appColors.secondaryText,
        ),
        textTheme: const TextTheme(
          // Estilos de texto padrão aqui, se necessário
        ),
      ),
      home: HomeScreen(
        tenantConfig: tenantConfig,
        appColors: appColors,
      ),
    );
  }
}