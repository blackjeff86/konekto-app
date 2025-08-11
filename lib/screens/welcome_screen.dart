// lib/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart'; // Para navegar para a tela principal
import '../utils/app_theme_data.dart'; // Para as cores do tema
import 'restaurants_screen.dart'; // Para navegar para restaurantes
import 'spa_screen.dart'; // Para navegar para spa
import 'events_screen.dart'; // Para navegar para eventos
import 'tours_screen.dart'; // Para navegar para tours

class WelcomeScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;
  final String checkInStatus; // O status do check-in do hóspede (success/awaiting)
  final String statusMessage; // A mensagem de status a ser exibida

  const WelcomeScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
    required this.checkInStatus,
    required this.statusMessage,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Se o check-in for bem-sucedido, navega automaticamente para a HomeScreen
    if (widget.checkInStatus == 'success') {
      Future.delayed(const Duration(seconds: 3), () { // Pequeno atraso para o hóspede ler
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                tenantConfig: widget.tenantConfig,
                appColors: widget.appColors,
              ),
            ),
          );
        }
      });
    }
  }

  void _navigateToService(String serviceAction) {
    // Obtenha a lista de serviços do tenantConfig
    final List<dynamic> services = widget.tenantConfig['servicesList'] ?? [];
    final Map<String, dynamic>? serviceConfig = services.firstWhere(
      (s) => s['action'] == serviceAction,
      orElse: () => null,
    );

    if (serviceConfig == null) {
      print('Serviço "$serviceAction" não encontrado na configuração do hotel.');
      // Opcional: mostrar um SnackBar ou diálogo de erro ao usuário
      return;
    }

    Widget screenToNavigate;
    switch (serviceAction) {
      case 'restaurants':
        screenToNavigate = RestaurantsScreen(tenantConfig: widget.tenantConfig, appColors: widget.appColors);
        break;
      case 'spa':
        screenToNavigate = SpaScreen(tenantConfig: widget.tenantConfig, appColors: widget.appColors);
        break;
      case 'events':
        screenToNavigate = EventsScreen(tenantConfig: widget.tenantConfig, appColors: widget.appColors);
        break;
      case 'tours':
        screenToNavigate = ToursScreen(tenantConfig: widget.tenantConfig, appColors: widget.appColors);
        break;
      default:
        print('Ação de serviço desconhecida para navegação: $serviceAction');
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screenToNavigate),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pega a logo do hotel carregado, com fallback
    final String hotelLogoPath = widget.tenantConfig['logoPath'] ?? 'assets/images/placeholder.png';
    final String hotelName = widget.tenantConfig['name'] ?? 'Seu Hotel';

    Color statusCardColor;
    Color statusIconTextColor;
    IconData statusIcon;

    switch (widget.checkInStatus) {
      case 'success':
        statusCardColor = widget.appColors.success;
        statusIconTextColor = Colors.white;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'awaiting':
        statusCardColor = widget.appColors.warning;
        statusIconTextColor = Colors.white;
        statusIcon = Icons.access_time;
        break;
      default: // Para 'pending' ou qualquer outro status inesperado
        statusCardColor = widget.appColors.error;
        statusIconTextColor = Colors.white;
        statusIcon = Icons.info_outline;
        break;
    }

    return Scaffold(
      backgroundColor: widget.appColors.primary, // Fundo com a cor primária do hotel carregado
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60.0), // Espaçamento superior
            Center(
              child: Container(
                width: 150, // Tamanho maior para a logo do hotel
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.appColors.cardBackground, // Fundo do círculo da logo
                  boxShadow: [
                    BoxShadow(
                      color: widget.appColors.shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    hotelLogoPath,
                    fit: BoxFit.contain, // Ajusta a imagem dentro do círculo
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.hotel, size: 100, color: widget.appColors.secondaryText); // Fallback
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              'Bem-vindo ao $hotelName!', // Nome do hotel carregado
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: widget.appColors.onPrimary, // Texto branco no fundo do hotel
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24.0),
            // Card de Status do Check-in
            Card(
              color: statusCardColor.withOpacity(0.9), // Cor baseada no status
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      statusIcon,
                      color: statusIconTextColor,
                      size: 60,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      widget.statusMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: statusIconTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            // Mostra os serviços SOMENTE se o status for 'awaiting'
            if (widget.checkInStatus == 'awaiting')
              _buildPreCheckInServices(),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildPreCheckInServices() {
    final List<dynamic> servicesList = widget.tenantConfig['servicesList'] ?? [];

    final List<Map<String, dynamic>> servicesWithBanners = servicesList
        .where((service) => service['bannerPath'] != null && service['bannerPath'].isNotEmpty)
        .map<Map<String, dynamic>>((service) => Map<String, dynamic>.from(service))
        .toList();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: widget.appColors.onPrimary.withOpacity(0.5), height: 40),
        Text(
          'Enquanto aguarda, explore os serviços do ${widget.tenantConfig['name'] ?? 'Hotel'}!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: widget.appColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16.0),
        Column(
          children: servicesWithBanners.map((service) {
            return _buildServiceListItem(
              context,
              service['title']!,
              service['bannerPath']!,
              () => _navigateToService(service['action']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServiceListItem(BuildContext context, String title, String imagePath, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: widget.appColors.cardBackground, // Usa a cor do tema do hotel
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 60,
                      color: widget.appColors.borderColor,
                      child: Icon(Icons.broken_image, color: widget.appColors.secondaryText),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: widget.appColors.primaryText,
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 20, color: widget.appColors.secondaryText),
            ],
          ),
        ),
      ),
    );
  }
}
