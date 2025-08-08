import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import 'spa_screen.dart';
import 'restaurants_screen.dart';
import 'room_service_screen.dart'; // IMPORTANTE: Importe a tela de Room Service

class ServicesScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;
  // NOVO: Adicionado o menu do Room Service como parâmetro
  final List<Map<String, dynamic>> roomServiceMenu;

  const ServicesScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
    required this.roomServiceMenu,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _isPrecaching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheAllImagesFromJsons();
  }

  // CORREÇÃO: Adicionado o ignore para o aviso de BuildContext
  // ignore: use_build_context_synchronously
  Future<void> _precacheAllImagesFromJsons() async {
    if (_isPrecaching) return;
    _isPrecaching = true;

    final List<String> allImagePaths = [
      widget.tenantConfig['bannerImages']['servicesBanner'],
    ];

    try {
      final spaPaths = await _getImagePathsFromSpaJson();
      final restaurantPaths = await _getImagePathsFromRestaurantsJson();
      allImagePaths.addAll(spaPaths);
      allImagePaths.addAll(restaurantPaths);
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao coletar caminhos de imagens para pré-carregamento: $e");
    }

    if (mounted) {
      for (var path in allImagePaths) {
        if (path.isNotEmpty) {
          precacheImage(AssetImage(path), context);
        }
      }
      // ignore: avoid_print
      print('Imagens pré-carregadas para a ServicesScreen com sucesso.');
    }
    _isPrecaching = false;
  }

  Future<List<String>> _getImagePathsFromSpaJson() async {
    try {
      final String response = await rootBundle.loadString(
          'assets/tenants/konekto_app_default/spa.json');
      // CORREÇÃO: O JSON do spa é uma lista, não um mapa.
      final List<dynamic> data = json.decode(response);
      List<String> paths = [];
      for (var item in data) {
          if (item.containsKey('imagePath')) {
              paths.add(item['imagePath']);
          }
      }
      return paths;
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao carregar imagens do SPA: $e");
      return [];
    }
  }

  Future<List<String>> _getImagePathsFromRestaurantsJson() async {
    try {
      final String response = await rootBundle.loadString(
          'assets/tenants/konekto_app_default/restaurants_data.json');
      final Map<String, dynamic> data = json.decode(response);
      List<String> paths = [];
      for (var restaurant in data['restaurants']) {
        paths.add(restaurant['imagePath']);
        for (var section in restaurant['menu']) {
          for (var item in section['items']) {
            if (item.containsKey('imagePath')) {
              paths.add(item['imagePath']);
            }
          }
        }
      }
      return paths;
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao carregar imagens de Restaurantes: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.appColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(
              title: 'Serviços',
              leading: IconButton(
                icon: Icon(Icons.close, color: widget.appColors.primaryText),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: const SizedBox.shrink(),
              appColors: widget.appColors,
            ),
            ImageBanner(
              imagePath: widget.tenantConfig['bannerImages']['servicesBanner'],
              height: 250,
              appColors: widget.appColors,
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
          // Botão Room Service com navegação
          _buildServiceItem(
            context,
            'Room Service',
            'Serviço de quarto',
            Icons.room_service,
            onTap: () {
              if (widget.roomServiceMenu.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoomServiceScreen(
                      serviceTitle: 'Room Service',
                      serviceDescription: widget.tenantConfig['roomServiceConfig']['description'],
                      serviceImagePath: widget.tenantConfig['roomServiceConfig']['bannerPath'],
                      menu: widget.roomServiceMenu,
                      appColors: widget.appColors,
                    ),
                  ),
                );
              }
            },
          ),
          _buildServiceItem(
            context,
            'SPA',
            'Relaxe e rejuvenesça',
            Icons.spa,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpaScreen(
                    tenantConfig: widget.tenantConfig,
                    appColors: widget.appColors,
                  ),
                ),
              );
            },
          ),
          _buildServiceItem(
            context,
            'Restaurantes',
            'Opções de refeições',
            Icons.restaurant,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantsScreen(
                    tenantConfig: widget.tenantConfig,
                    appColors: widget.appColors,
                  ),
                ),
              );
            },
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

  Widget _buildServiceItem(BuildContext context, String title, String subtitle,
      IconData icon, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.appColors.background,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: widget.appColors.shadowColor,
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
                  color: widget.appColors.borderColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: widget.appColors.primaryText),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: widget.appColors.primaryText,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.appColors.secondaryText,
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