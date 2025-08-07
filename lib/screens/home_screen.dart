import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import 'services_screen.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;

  const HomeScreen({super.key, required this.tenantConfig});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pré-carrega as imagens da tela de Serviços e do SPA
    _precacheServicesImages();
  }

  void _precacheServicesImages() {
    // IMPORTANTE: Substitua os caminhos abaixo pelos caminhos reais das suas imagens
    const List<String> servicesImagePaths = [
      'assets/images/services_banner.jpg', // Exemplo
      'assets/images/servico_1.jpg',      // Exemplo
      'assets/images/servico_2.jpg',      // Exemplo
      'assets/images/servico_3.jpg',      // Exemplo
    ];

    for (var path in servicesImagePaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(
              title: widget.tenantConfig['name'] ?? 'Konekto App',
              leading: const SizedBox(width: 48),
              trailing: IconButton(
                icon: const Icon(Icons.settings, color: AppColors.primaryText),
                onPressed: () {
                  // Ação para o botão de configurações
                },
              ),
            ),
            const ImageBanner(
              imagePath: 'assets/images/pool_background.png',
              height: 250,
            ),
            _buildWelcomeInfo(context),
            _buildAccessInfo(context),
            _buildNavigationGrid(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildWelcomeInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bem-vindo, Lucas!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check-in realizado com sucesso! Seu quarto é o 305.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryText,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados de acesso',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(context, 'Wi-fi', 'Beach Park Wi-Fi'),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Login', 'lucas.silva@email.com'),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Senha', '123456'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 8),
        const Text(
          '|',
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primaryText,
              ),
        ),
      ],
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildNavigationButton(context, 'Serviços', Icons.room_service),
              const SizedBox(width: 12),
              _buildNavigationButton(context, 'Loja', Icons.store),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildNavigationButton(context, 'Perfil', Icons.person),
              const SizedBox(width: 12),
              _buildNavigationButton(context, 'Histórico', Icons.history),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(
      BuildContext context, String title, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (title == 'Serviços') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServicesScreen(tenantConfig: widget.tenantConfig),
              ),
            );
          }
        },
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: AppColors.primaryText),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryText,
      unselectedItemColor: AppColors.secondaryText,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark_border),
          label: 'Bookmarks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        // TODO: Implementar a navegação entre as telas aqui
      },
    );
  }
}