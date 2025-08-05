import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Importe para carregar assets
import 'dart:convert'; // Importe para decodificar JSON

// Importe sua HomeScreen
import 'package:konekto_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _tenantConfig = {}; // Estado para armazenar a configuração do tenant
  bool _isLoading = true; // Estado para controlar o carregamento

  @override
  void initState() {
    super.initState();
    _loadTenantConfig(); // Carrega a configuração quando o app inicia
  }

 Future<void> _loadTenantConfig() async {
    try {
      // Carrega o arquivo JSON do tenant dos assets
      final String response = await rootBundle.loadString('lib/tenants/hotel_default.json');
      // --- Adicione esta linha para ver o conteúdo do JSON que está sendo lido ---
      print('Conteúdo JSON lido: $response');
      // --------------------------------------------------------------------------
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _tenantConfig = data;
        _isLoading = false;
      });
    } catch (e) {
      // --- Mude esta linha para imprimir o erro exato ---
      print('ERRO ao carregar ou decodificar a configuração do tenant: $e');
      // --------------------------------------------------
      setState(() {
        _isLoading = false;
        // Opcional: Definir uma configuração padrão de fallback em caso de erro
        _tenantConfig = {
          'name': 'Konekto App - Erro', // Mantemos isso para saber que é o fallback
          'primaryColor': '#CCCCCC',
          'logo': 'assets/logos/default_logo.png',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Enquanto estiver carregando, mostra um indicador
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Quando a configuração estiver carregada, constrói o aplicativo
    return MaterialApp(
      title: 'Konekto App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Você pode ajustar isso com base na primaryColor do tenant se quiser
      ),
      home: HomeScreen(tenantConfig: _tenantConfig), // Renderiza a HomeScreen passando a configuração
    );
  }
}