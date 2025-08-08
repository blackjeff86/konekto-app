import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import 'schedule_screen.dart';

class SpaScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const SpaScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<SpaScreen> createState() => _SpaScreenState();
}

class _SpaScreenState extends State<SpaScreen> {
  List<dynamic> _spaServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpaServices();
  }

  Future<void> _loadSpaServices() async {
    try {
      final String response = await rootBundle.loadString(
          widget.tenantConfig['spaJsonPath'] ??
              'assets/tenants/konekto_app_default/spa.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _spaServices = data['spa_services'];
        _isLoading = false;
      });
    } catch (e) {
      print('ERRO FATAL: Falha ao carregar ou decodificar os dados do spa.');
      print('Detalhes do erro: $e');
      setState(() {
        _isLoading = false;
        _spaServices = [];
      });
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
              title: 'SPA',
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: widget.appColors.primaryText),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: const SizedBox.shrink(),
              appColors: widget.appColors,
            ),
            ImageBanner(
              imagePath: widget.tenantConfig['spaBannerPath'] ??
                  'assets/tenants/konekto_app_default/images/spa/spa_background.png',
              height: 250,
              gradientText: 'Spa e Bem-Estar',
              appColors: widget.appColors,
            ),
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: CircularProgressIndicator(color: widget.appColors.primary),
                    ),
                  )
                : _buildSpaContent(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // REMOVIDO: A parte com o título "Nossos Serviços" foi removida.
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _spaServices.length,
            itemBuilder: (context, index) {
              final service = _spaServices[index];
              return _buildServiceItem(context, service);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, Map<String, dynamic> service) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleScreen(
              serviceTitle: service['title'],
              serviceDescription: service['description'],
              imagePath: service['imagePath'],
              appColors: widget.appColors,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.appColors.background,
          borderRadius: BorderRadius.circular(12),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: widget.appColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.appColors.secondaryText,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${service['price'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: widget.appColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                service['imagePath'],
                width: 130,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 130,
                    height: 112,
                    color: widget.appColors.borderColor,
                    child: Icon(Icons.spa, color: widget.appColors.secondaryText),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}