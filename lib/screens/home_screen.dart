import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final Map<String, dynamic> tenantConfig;

  const HomeScreen({super.key, required this.tenantConfig});

  @override
  Widget build(BuildContext context) {
    // Obtenha os dados do tenant
    final String hotelName = tenantConfig['name'] ?? 'Nome Padrão';
    final String welcomeText = 'Bem-vindo, Lucas'; // Manter fixo por enquanto
    final Color primaryColor = Color(int.parse('0xFF' + (tenantConfig['primaryColor'] ?? '#1976D2').substring(1)));
    final String logoPath = tenantConfig['logo'] ?? 'assets/logos/default_logo.png';

    return Scaffold(
      // Removendo o AppBar e usando CustomScrollView para maior flexibilidade no cabeçalho
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white, // Fundo branco
            expandedHeight: 260.0, // Altura expandida do cabeçalho
            floating: false, // Não flutua
            pinned: false, // Não fixa quando rola
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true, // Centraliza o conteúdo (logo e nome do hotel)
              titlePadding: EdgeInsets.zero, // Remove padding padrão do título
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
                children: [
                  const SizedBox(height: 120), // Espaço para não ficar colado no topo
                  Image.asset(
                    logoPath,
                    height: 120, // Tamanho grande da logo
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8), // Espaço entre logo e nome
                  Text(
                    hotelName,
                    style: const TextStyle(
                      color: Color(0xFF111416),
                      fontSize: 24, // Nome do hotel grande
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter( // Usar SliverToBoxAdapter para conter o conteúdo padrão rolável
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16), // Padding geral para as laterais
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Alinha os filhos à esquerda
                children: [
                  const SizedBox(height: 20), // Espaço superior após o cabeçalho
                  // Texto de boas-vindas
                  Text(
                    welcomeText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF111416),
                      fontSize: 22,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24), // Espaço entre o texto de boas-vindas e os campos

                  // Campo de E-mail (refatorado)
                  Container(
                    width: double.infinity, // Ocupa toda a largura disponível
                    height: 56,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1), // Cor do tenant com opacidade
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Align( // Alinha o texto dentro do container
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'E-mail',
                        style: TextStyle(
                          color: Color(0xFF5E708C),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16), // Espaço entre os campos

                  // Campo de Senha (refatorado)
                  Container(
                    width: double.infinity, // Ocupa toda a largura disponível
                    height: 56,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1), // Cor do tenant com opacidade
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Align( // Alinha o texto dentro do container
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Senha',
                        style: TextStyle(
                          color: Color(0xFF5E708C),
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Espaço entre os campos e o próximo elemento

                  // Exemplo de um botão para demonstrar a cor primária
                  SizedBox(
                    width: double.infinity, // Ocupa a largura total
                    child: ElevatedButton(
                      onPressed: () {
                        print('Botão Entrar pressionado!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Cor de fundo do botão baseada no tenant
                        foregroundColor: Colors.white, // Cor do texto do botão
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0, // Remove sombra
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
                  const SizedBox(height: 20), // Espaço inferior para rolar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}