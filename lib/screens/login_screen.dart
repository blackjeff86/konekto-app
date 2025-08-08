import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart'; // Importa a classe AppThemeData
import 'home_screen.dart'; // Para navegar após o login (se aplicável)

class LoginScreen extends StatelessWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors; // NOVO: Adiciona o parâmetro para as cores do tema

  const LoginScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors, // NOVO: Requerido no construtor
  });

  @override
  Widget build(BuildContext context) {
    // Obtenha os dados do tenant
    final String hotelName = tenantConfig['name'] ?? 'Nome Padrão';
    final String welcomeText = 'Bem-vindo, Lucas';
    // CORRIGIDO: Usa appColors para acessar as cores do tema
    final String logoPath = tenantConfig['logoPath'] ?? 'assets/tenants/konekto_app_default/logos/default_logo.png'; // CORRIGIDO: Caminho do logo do tenantConfig

    return Scaffold(
      backgroundColor: appColors.background, // Usa a cor de fundo do tema
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: appColors.background, // Usa a cor de fundo do tema
            expandedHeight: 260.0,
            floating: false,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.zero,
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 120),
                  Image.asset(
                    logoPath,
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // fallback para o logo padrão ou um ícone
                      return Icon(Icons.hotel, size: 80, color: appColors.primary);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotelName,
                    style: TextStyle(
                      color: appColors.primaryText, // Usa a cor do texto primário do tema
                      fontSize: 24,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    welcomeText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appColors.primaryText, // Usa a cor do texto primário do tema
                      fontSize: 22,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // CAMPO DE E-MAIL
                  Container(
                    width: double.infinity,
                    height: 56,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: appColors.accent.withOpacity(0.1), // Usa a cor accent do tema
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                          color: appColors.secondaryText, // Usa a cor do texto secundário do tema
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // CAMPO DE SENHA
                  Container(
                    width: double.infinity,
                    height: 56,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: appColors.accent.withOpacity(0.1), // Usa a cor accent do tema
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Senha',
                        style: TextStyle(
                          color: appColors.secondaryText, // Usa a cor do texto secundário do tema
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // ignore: avoid_print
                        print('Botão Entrar pressionado!');
                        // Ação de navegação para a HomeScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                              tenantConfig: tenantConfig,
                              appColors: appColors,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appColors.primary, // Usa a cor primária do tema
                        foregroundColor: appColors.buttonText, // Usa a cor do texto do botão do tema
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}