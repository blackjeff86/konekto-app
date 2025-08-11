// lib/screens/check_in_status_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'welcome_screen.dart';
import '../utils/app_theme_data.dart';
import 'dart:math';

class CheckInStatusScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const CheckInStatusScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<CheckInStatusScreen> createState() => _CheckInStatusScreenState();
}

class _CheckInStatusScreenState extends State<CheckInStatusScreen> {
  final TextEditingController _hotelIdController = TextEditingController();
  String _currentScreenStatus = 'input';
  String _statusMessage = '';

  Map<String, dynamic> _loadedTenantConfig = {};
  late AppThemeData _loadedAppColors;

  @override
  void initState() {
    super.initState();
    _statusMessage = "Por favor, insira o Código de Identificação do Hotel.";
    _loadedAppColors = widget.appColors;
  }

  @override
  void dispose() {
    _hotelIdController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _loadTenantConfig(String tenantIdentifier) async {
    try {
      final String hotelConfigPath = 'assets/tenants/$tenantIdentifier/hotel_default.json';
      final String hotelConfigString = await rootBundle.loadString(hotelConfigPath);
      final Map<String, dynamic> loadedTenantConfig = json.decode(hotelConfigString);

      final Map<String, dynamic> combinedConfig = {};
      combinedConfig.addAll(loadedTenantConfig);

      final String uiConfigString = await rootBundle.loadString(loadedTenantConfig['uiConfigJsonPath']);
      combinedConfig['uiConfig'] = json.decode(uiConfigString);

      final String themeConfigString = await rootBundle.loadString(loadedTenantConfig['themeConfigJsonPath']);
      combinedConfig['themeConfig'] = json.decode(themeConfigString);
      
      setState(() {
        _loadedAppColors = AppThemeData.fromJson(combinedConfig['themeConfig']);
      });

      final String servicesListString = await rootBundle.loadString(loadedTenantConfig['servicesJsonPath']);
      combinedConfig['servicesList'] = json.decode(servicesListString);

      final Map<String, dynamic>? roomServiceConfigFromHotel = loadedTenantConfig['roomServiceConfig'];
      if (roomServiceConfigFromHotel != null && roomServiceConfigFromHotel['jsonPath'] != null) {
        final String roomServiceConfigString = await rootBundle.loadString(roomServiceConfigFromHotel['jsonPath']);
        roomServiceConfigFromHotel['menu'] = json.decode(roomServiceConfigString);
        combinedConfig['roomServiceConfig'] = roomServiceConfigFromHotel;
      } else {
        combinedConfig['roomServiceConfig'] = {'menu': []};
      }

      final String spaConfigString = await rootBundle.loadString(loadedTenantConfig['spaJsonPath']);
      final Map<String, dynamic> spaConfigMap = json.decode(spaConfigString);
      combinedConfig['spaServicesList'] = spaConfigMap['spa_services'];

      final String restaurantsConfigString = await rootBundle.loadString(loadedTenantConfig['restaurantsJsonPath']);
      combinedConfig['restaurantsConfig'] = json.decode(restaurantsConfigString);

      final String notificationsConfigString = await rootBundle.loadString(loadedTenantConfig['notificationsJsonPath']);
      final Map<String, dynamic> notificationsConfigMap = json.decode(notificationsConfigString);
      combinedConfig['notificationsList'] = notificationsConfigMap['notifications'];

      if (loadedTenantConfig['checkInConfig'] == null) {
          throw Exception('checkInConfig não encontrado no hotel_default.json do tenant $tenantIdentifier');
      }
      combinedConfig['checkInConfig'] = loadedTenantConfig['checkInConfig'];

      return combinedConfig;

    } catch (e) {
      throw Exception('Falha ao carregar configurações para o tenant "$tenantIdentifier": $e');
    }
  }

  Future<void> _processHotelIdAndCheckIn() async {
    final String hotelId = _hotelIdController.text.trim().toLowerCase();

    if (hotelId.isEmpty) {
      setState(() {
        _currentScreenStatus = 'input';
        _statusMessage = "Por favor, insira o Código de Identificação do Hotel.";
      });
      return;
    }

    if (_currentScreenStatus == 'loading') return;

    setState(() {
      _currentScreenStatus = 'loading';
      _statusMessage = 'Carregando informações do hotel...';
      _currentScreenStatus = 'loading';
    });

    try {
      _loadedTenantConfig = await _loadTenantConfig(hotelId);

      String simulatedCheckInStatus;
      String simulatedStatusMessage;

      // ATUALIZADO: Lógica de simulação de check-in para 'konekto_app'
      if (hotelId == 'beach_park') {
        simulatedCheckInStatus = 'success';
        simulatedStatusMessage = 'Check-in realizado com sucesso no Beach Park!';
      } else if (hotelId == 'copacabana_palace') {
        simulatedCheckInStatus = 'awaiting';
        simulatedStatusMessage = 'Seu check-in no Copacabana Palace está aguardando aprovação. Por favor, entre em contato com a recepção.';
      } else if (hotelId == 'konekto_app') { // ADICIONADO: Simulação para konekto_app
        simulatedCheckInStatus = 'success';
        simulatedStatusMessage = 'Check-in realizado com sucesso no Konekto Hotel!';
      }
      else {
        simulatedCheckInStatus = 'pending';
        simulatedStatusMessage = 'Nenhum check-in encontrado para este código no ${_loadedTenantConfig['name'] ?? 'Hotel'}. Verifique com a recepção.';
      }

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(
              tenantConfig: _loadedTenantConfig,
              appColors: _loadedAppColors,
              checkInStatus: simulatedCheckInStatus,
              statusMessage: simulatedStatusMessage,
            ),
          ),
        );
      }

    } catch (e) {
      print('Erro ao carregar ou verificar check-in para o hotel "$hotelId": $e');
      setState(() {
        _currentScreenStatus = 'error';
        _statusMessage = 'Erro ao carregar dados ou verificar check-in para o hotel "$hotelId". Detalhes: $e';
      });
    } finally {
      setState(() {
        _currentScreenStatus = 'input';
      });
    }
  }

  Future<void> _scanQrCode() async {
    setState(() {
      _currentScreenStatus = 'loading';
      _statusMessage = 'Escaneando QR Code...';
    });

    await Future.delayed(const Duration(seconds: 3));

    final bool qrScanSuccess = Random().nextBool();
    if (qrScanSuccess) {
      // Simula que o QR Code leria um tenantId
      final List<String> testTenantIds = ['beach_park', 'copacabana_palace', 'konekto_app']; // ATUALIZADO
      final String scannedHotelId = testTenantIds[Random().nextInt(testTenantIds.length)];
      _hotelIdController.text = scannedHotelId;
      await _processHotelIdAndCheckIn();
    } else {
      setState(() {
        _currentScreenStatus = 'input';
        _statusMessage = 'Falha ao escanear o QR Code. Tente novamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.appColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60.0),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.appColors.cardBackground,
                  boxShadow: [
                    BoxShadow(
                      color: widget.appColors.shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/konekto_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.apps, size: 80, color: widget.appColors.secondaryText);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              'Bem-vindo ao Konekto!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: widget.appColors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24.0),
            _currentScreenStatus == 'loading' || _currentScreenStatus == 'error'
                ? Card(
                    color: _currentScreenStatus == 'loading' ? widget.appColors.warning.withOpacity(0.8) : widget.appColors.error.withOpacity(0.8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            _currentScreenStatus == 'loading' ? Icons.info_outline : Icons.error_outline,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            _statusMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 24.0),

            if (_currentScreenStatus == 'input')
              _buildHotelIdentificationInputs(),
            
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelIdentificationInputs() {
    return Column(
      children: [
        TextField(
          controller: _hotelIdController,
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.none,
          decoration: InputDecoration(
            labelText: 'Código de Identificação do Hotel',
            hintText: 'Ex: beach_park, copacabana_palace ou konekto_app', // ATUALIZADO AQUI
            labelStyle: TextStyle(color: widget.appColors.onPrimary.withOpacity(0.8)),
            hintStyle: TextStyle(color: widget.appColors.onPrimary.withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: widget.appColors.onPrimary.withOpacity(0.5), width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: widget.appColors.onPrimary, width: 2.0),
            ),
            filled: true,
            fillColor: widget.appColors.accent.withOpacity(0.3),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          ),
          style: TextStyle(color: widget.appColors.onPrimary, fontSize: 18.0),
          cursorColor: widget.appColors.onPrimary,
        ),
        const SizedBox(height: 24.0),
        ElevatedButton(
          onPressed: _currentScreenStatus == 'loading' ? null : () => _processHotelIdAndCheckIn(),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.appColors.onPrimary,
            foregroundColor: widget.appColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 5,
          ),
          child: _currentScreenStatus == 'loading'
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: widget.appColors.primary,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Verificar Hotel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: widget.appColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
        ),
        const SizedBox(height: 24.0),
        Text(
          'OU',
          style: TextStyle(color: widget.appColors.onPrimary.withOpacity(0.8), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24.0),
        OutlinedButton.icon(
          onPressed: _currentScreenStatus == 'loading' ? null : _scanQrCode,
          icon: Icon(Icons.qr_code_scanner, color: widget.appColors.onPrimary, size: 28),
          label: Text(
            'Escanear QR Code',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: widget.appColors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: BorderSide(color: widget.appColors.onPrimary, width: 2),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}