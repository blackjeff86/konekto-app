import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'services_screen.dart';
import 'room_service_screen.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import '../utils/app_theme_data.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const HomeScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _roomServiceMenu = [];
  bool _isLoading = true;
  bool _isPrecaching = false;

  @override
  void initState() {
    super.initState();
    _loadRoomServiceData();
  }

  Future<void> _loadRoomServiceData() async {
    try {
      final String response = await rootBundle.loadString(
          widget.tenantConfig['roomServiceConfig']['jsonPath'] ??
              'assets/tenants/konekto_app_default/room_service.json');
      final List<dynamic> data = json.decode(response);

      if (!mounted) return;

      setState(() {
        _roomServiceMenu = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
      // ignore: avoid_print
      print('Dados do Room Service carregados com sucesso. Itens: ${_roomServiceMenu.length}');
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao carregar dados do Room Service: $e");
      // ignore: avoid_print
      print('Verifique se o arquivo JSON está no caminho correto e sem erros de sintaxe.');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _roomServiceMenu = [];
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheAllImagesFromJsons();
  }

  // ignore: use_build_context_synchronously
  Future<void> _precacheAllImagesFromJsons() async {
    if (_isPrecaching) return;
    _isPrecaching = true;
    
    List<String> allImagePaths = [];

    try {
      final spaPaths = await _getImagePathsFromSpaJson();
      final restaurantPaths = await _getImagePathsFromRestaurantsJson();
      final roomServicePaths = await _getImagePathsFromRoomServiceJson();

      allImagePaths = [
        ...spaPaths,
        ...restaurantPaths,
        ...roomServicePaths,
        widget.tenantConfig['bannerImages']['homeBanner'],
        widget.tenantConfig['bannerImages']['servicesBanner'],
        widget.tenantConfig['roomServiceConfig']['bannerPath'],
      ];
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
      print('Imagens pré-carregadas com sucesso.');
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

  Future<List<String>> _getImagePathsFromRoomServiceJson() async {
    try {
      final String response = await rootBundle.loadString(
          'assets/tenants/konekto_app_default/room_service.json');
      final List<dynamic> data = json.decode(response);
      List<String> paths = [];
      for (var section in data) {
        for (var item in section['items']) {
          if (item.containsKey('imagePath')) {
            paths.add(item['imagePath']);
          }
        }
      }
      return paths;
    } catch (e) {
      // ignore: avoid_print
      print("Erro ao carregar imagens do Room Service: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: widget.appColors.background,
        body: Center(
          child: CircularProgressIndicator(
            color: widget.appColors.primary,
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: widget.appColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(
              title: widget.tenantConfig['name'] ?? 'Konekto App',
              leading: const SizedBox(width: 48),
              trailing: IconButton(
                icon: Icon(Icons.settings, color: widget.appColors.primaryText),
                onPressed: () {
                  // Ação para o botão de configurações
                },
              ),
              appColors: widget.appColors,
            ),
            ImageBanner(
              imagePath: widget.tenantConfig['bannerImages']['homeBanner'],
              height: 250,
              appColors: widget.appColors,
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
                  color: widget.appColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check-in realizado com sucesso! Seu quarto é o 305.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: widget.appColors.primaryText,
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
                  color: widget.appColors.primaryText,
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
                color: widget.appColors.primaryText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 8),
        Text(
          '|',
          style: TextStyle(
            color: widget.appColors.secondaryText,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: widget.appColors.primaryText,
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
              _buildNavigationButton(
                context,
                'Serviços',
                Icons.room_service,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServicesScreen(
                        tenantConfig: widget.tenantConfig,
                        appColors: widget.appColors,
                        roomServiceMenu: _roomServiceMenu, // CORREÇÃO: Passando o menu
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildNavigationButton(
                context,
                'Room Service',
                Icons.restaurant_menu,
                onTap: () {
                  if (_roomServiceMenu.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoomServiceScreen(
                          serviceTitle: 'Room Service',
                          serviceDescription: widget.tenantConfig['roomServiceConfig']['description'],
                          serviceImagePath: widget.tenantConfig['roomServiceConfig']['bannerPath'],
                          menu: _roomServiceMenu,
                          appColors: widget.appColors,
                        ),
                      ),
                    );
                  }
                },
              ),
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
      BuildContext context, String title, IconData icon,
      {VoidCallback? onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.appColors.background,
            border: Border.all(color: widget.appColors.borderColor),
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
              Icon(icon, size: 24, color: widget.appColors.primaryText),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.appColors.primaryText,
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
      backgroundColor: widget.appColors.background,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: widget.appColors.primary,
      unselectedItemColor: widget.appColors.secondaryText,
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