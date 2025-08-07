import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart'; // A linha que havia sumido

// Importe suas telas
import 'package:konekto_app/screens/home_screen.dart';

void main() async { // A função main precisa ser assíncrona
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null); // Inicializa os dados de localização
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> _tenantConfig = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTenantConfig();
  }

  Future<void> _loadTenantConfig() async {
    try {
      final String response = await rootBundle.loadString('assets/tenants/hotel_default.json');
      print('Conteúdo JSON lido: $response');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _tenantConfig = data;
        _isLoading = false;
      });
    } catch (e) {
      print('ERRO ao carregar ou decodificar a configuração do tenant: $e');
      setState(() {
        _isLoading = false;
        _tenantConfig = {
          'name': 'Konekto App - Erro',
          'primaryColor': '#CCCCCC',
          'logo': 'assets/logos/default_logo.png',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Konekto App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(tenantConfig: _tenantConfig),
    );
  }
}