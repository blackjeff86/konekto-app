// lib/screens/events_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import 'schedule_screen.dart';

class EventsScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const EventsScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<dynamic> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final String response = await rootBundle.loadString(
          widget.tenantConfig['eventsJsonPath'] ??
              'assets/tenants/konekto_app_default/events.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _events = data['events'];
        _isLoading = false;
      });
    } catch (e) {
      print('ERRO FATAL: Falha ao carregar ou decodificar os dados de eventos.');
      print('Detalhes do erro: $e');
      setState(() {
        _isLoading = false;
        _events = [];
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
              title: 'Eventos',
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
              imagePath: widget.tenantConfig['eventsBannerPath'] ??
                  'assets/tenants/konekto_app_default/images/banners/events_banner.jpg',
              height: 250,
              gradientText: 'Eventos',
              appColors: widget.appColors,
            ),
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: CircularProgressIndicator(color: widget.appColors.primary),
                    ),
                  )
                : _buildEventsContent(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsContent(BuildContext context) {
    if (_events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            'Nenhum evento disponível no momento.',
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
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return _buildEventItem(context, event);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, Map<String, dynamic> event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScheduleScreen(
              serviceTitle: event['title'],
              serviceDescription: event['description'],
              imagePath: event['imagePath'],
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
                    event['type'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: widget.appColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.appColors.primaryText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event['description'],
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
                event['imagePath'],
                width: 130,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 130,
                    height: 112,
                    color: widget.appColors.borderColor,
                    child: Icon(Icons.event, color: widget.appColors.secondaryText),
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