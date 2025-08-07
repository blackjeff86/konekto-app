import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import 'spa_screen.dart'; // Importação da nova tela do SPA

class ServicesScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;

  const ServicesScreen({super.key, required this.tenantConfig});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pré-carrega as imagens desta tela E as das próximas telas
    _precacheServicesBannerImage();
    _precacheSpaImages();
    _precacheOtherServicesImages();
  }

  void _precacheServicesBannerImage() {
    precacheImage(const AssetImage('assets/images/services_background.png'), context);
  }

  void _precacheSpaImages() {
    const List<String> spaImagePaths = [
      'assets/images/spa_background.png',
      'assets/images/massagem_relaxante.png',
      'assets/images/massagem_terapeutica.png',
      'assets/images/limpeza_de_pele.png',
      'assets/images/tratamento_antiidade.png',
    ];
    for (var path in spaImagePaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  void _precacheOtherServicesImages() {
    // Adicione os caminhos das imagens para os banners dos outros serviços aqui
    // Exemplo:
    const List<String> otherServicesImagePaths = [
      'assets/images/room_service_banner.png',
      'assets/images/restaurantes_banner.png',
      'assets/images/eventos_banner.png',
      'assets/images/passeios_banner.png',
      'assets/images/mapa_hotel_banner.png',
    ];
    for (var path in otherServicesImagePaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(
              title: 'Serviços',
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.primaryText),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: const SizedBox.shrink(),
            ),
            const ImageBanner(
              imagePath: 'assets/images/services_background.png',
              height: 250,
            ),
            _buildServiceList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildServiceItem(
            context,
            'Room Service',
            'Serviço de quarto',
            Icons.room_service,
          ),
          _buildServiceItem(
            context,
            'SPA',
            'Relaxe e rejuvenesça',
            Icons.spa,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SpaScreen()),
              );
            },
          ),
          _buildServiceItem(
            context,
            'Restaurantes',
            'Opções de refeições',
            Icons.restaurant,
          ),
          _buildServiceItem(
            context,
            'Eventos',
            'Eventos especiais',
            Icons.event,
          ),
          _buildServiceItem(
            context,
            'Passeios',
            'Explore a área',
            Icons.directions_walk,
          ),
          _buildServiceItem(
            context,
            'Mapa do Hotel',
            'Mapa do Hotel',
            Icons.map,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, String title, String subtitle, IconData icon, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF2F4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primaryText),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}