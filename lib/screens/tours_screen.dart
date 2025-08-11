// lib/screens/tours_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import 'schedule_screen.dart';

class ToursScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const ToursScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  List<dynamic> _tours = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTours();
  }

  Future<void> _loadTours() async {
    try {
      final String response = await rootBundle.loadString(
          widget.tenantConfig['toursJsonPath'] ??
              'assets/tenants/konekto_app_default/tours.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _tours = data['tours'];
        _isLoading = false;
      });
    } catch (e) {
      print('ERRO FATAL: Falha ao carregar ou decodificar os dados de passeios.');
      print('Detalhes do erro: $e');
      setState(() {
        _isLoading = false;
        _tours = [];
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
              title: 'Passeios',
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
              imagePath: widget.tenantConfig['toursBannerPath'] ??
                  'assets/tenants/konekto_app_default/images/banners/tours_banner.jpg',
              height: 250,
              gradientText: 'Passeios',
              appColors: widget.appColors,
            ),
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: CircularProgressIndicator(color: widget.appColors.primary),
                    ),
                  )
                : _buildToursContent(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildToursContent(BuildContext context) {
    if (_tours.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'Nenhum passeio disponível no momento.',
            style: TextStyle(
              color: widget.appColors.secondaryText,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _tours.length,
            itemBuilder: (context, index) {
              final tour = _tours[index];
              return _buildTourItem(context, tour);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTourItem(BuildContext context, Map<String, dynamic> tour) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleScreen(
              serviceTitle: tour['title'],
              serviceDescription: tour['description'],
              imagePath: tour['imagePath'],
              appColors: widget.appColors,
              tenantConfig: widget.tenantConfig,
              roomServiceMenu: [],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.appColors.cardBackground,
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
                    tour['type'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.appColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tour['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.appColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tour['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.appColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                tour['imagePath'],
                width: 130,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 130,
                    height: 112,
                    color: widget.appColors.borderColor,
                    child: Icon(Icons.tour, color: widget.appColors.secondaryText),
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