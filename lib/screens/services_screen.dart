// lib/screens/services_screen.dart

import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';
import '../widgets/service_grid_item.dart';
import 'spa_screen.dart';
import 'room_service_screen.dart';
import 'restaurants_screen.dart';
import 'events_screen.dart';
import 'tours_screen.dart';
import 'map_screen.dart'; // NOVO: Importa a tela de mapa
import '../widgets/image_banner.dart';

class ServicesScreen extends StatelessWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;
  final String bannerTitle;
  final String bannerImagePath;

  const ServicesScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
    required this.bannerTitle,
    required this.bannerImagePath,
  });

  void _handleServiceTap(BuildContext context, String action) {
    final List<dynamic> services = tenantConfig['servicesList'] ?? [];
    final service = services.firstWhere((s) => s['action'] == action, orElse: () => null);

    if (service == null) return;

    if (action == 'spa') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SpaScreen(
            tenantConfig: tenantConfig,
            appColors: appColors,
          ),
        ),
      );
    } else if (action == 'room_service') {
      final Map<String, dynamic> roomServiceConfig = tenantConfig['roomServiceConfig'] ?? {};

      final List<dynamic> menuList = roomServiceConfig['menu'] ?? [];
      final List<Map<String, dynamic>> roomServiceMenu = menuList.map<Map<String, dynamic>>((item) {
        if (item is Map<String, dynamic>) {
          return item;
        } else {
          return {};
        }
      }).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomServiceScreen(
            serviceTitle: service['title'] ?? 'Room Service',
            serviceDescription: roomServiceConfig['description'] ?? '',
            serviceImagePath: roomServiceConfig['bannerPath'] ?? '',
            menu: roomServiceMenu,
            appColors: appColors,
          ),
        ),
      );
    } else if (action == 'restaurants') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RestaurantsScreen(
            tenantConfig: tenantConfig,
            appColors: appColors,
          ),
        ),
      );
    } else if (action == 'events') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventsScreen(
            tenantConfig: tenantConfig,
            appColors: appColors,
          ),
        ),
      );
    } else if (action == 'tours') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ToursScreen(
            tenantConfig: tenantConfig,
            appColors: appColors,
          ),
        ),
      );
    } else if (action == 'map') { // NOVO: Adiciona a navegação para a tela de mapa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            tenantConfig: tenantConfig,
            appColors: appColors,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> services = tenantConfig['servicesList'] ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageBanner(
            imagePath: bannerImagePath,
            height: 250,
            gradientText: bannerTitle,
            appColors: appColors,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final imagePath = service['bannerPath'] ?? '';
                return ServiceGridItem(
                  title: service['title'],
                  imagePath: imagePath,
                  onTap: () => _handleServiceTap(context, service['action']),
                  appColors: appColors,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}