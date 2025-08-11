import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/poi_card.dart';

class MapScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const MapScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<dynamic> _pointsOfInterest = [];
  int? _selectedPoiIndex;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPointsOfInterest();
  }

  Future<void> _loadPointsOfInterest() async {
    try {
      final String response = await rootBundle.loadString(
          widget.tenantConfig['mapJsonPath'] ??
              'assets/tenants/konekto_app_default/map.json');
      final Map<String, dynamic> data = json.decode(response);

      setState(() {
        _pointsOfInterest = data['pointsOfInterest'];
        _isLoading = false;
      });
    } catch (e) {
      print('ERRO FATAL: Falha ao carregar ou decodificar os dados do mapa.');
      print('Detalhes do erro: $e');
      setState(() {
        _isLoading = false;
        _pointsOfInterest = [];
      });
    }
  }

  void _onPoiTapped(int index) {
    setState(() {
      _selectedPoiIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.appColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomHeader(
          title: 'Mapa do Hotel',
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.appColors.primaryText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: const SizedBox.shrink(),
          appColors: widget.appColors,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: widget.appColors.primary),
            )
          : Column(
              children: [
                _buildPoiList(),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.asset(
                              'assets/tenants/konekto_app_default/images/mapa/mapa_do_hotel.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                          ),
                          ..._buildMarkers(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  Widget _buildPoiList() {
    if (_pointsOfInterest.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Nenhum ponto de interesse encontrado.',
            style: TextStyle(color: widget.appColors.primaryText),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 16.0),
      itemCount: _pointsOfInterest.length,
      itemBuilder: (context, index) {
        final poi = _pointsOfInterest[index];
        return PoiCard(
          title: poi['title'],
          description: poi['description'],
          imagePath: poi['imagePath'],
          appColors: widget.appColors,
          isSelected: _selectedPoiIndex == index,
          onTap: () => _onPoiTapped(index),
        );
      },
    );
  }

  List<Widget> _buildMarkers() {
    if (_selectedPoiIndex != null) {
      final poi = _pointsOfInterest[_selectedPoiIndex!];
      return [
        Positioned(
          left: poi['x'].toDouble(),
          top: poi['y'].toDouble(),
          child: InkWell(
            onTap: () => _onPoiTapped(_selectedPoiIndex!),
            child: const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      ];
    }
    return [];
  }
}