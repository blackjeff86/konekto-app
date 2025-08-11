// lib/screens/reservations_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../utils/app_theme_data.dart';
import '../widgets/image_banner.dart';
import 'package:intl/intl.dart';

class ReservationsScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const ReservationsScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  List<dynamic> _pendingReservations = [];
  List<dynamic> _completedReservations = [];
  List<dynamic> _cancelledReservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final String response = await rootBundle.loadString(
          widget.tenantConfig['reservationsJsonPath'] ??
              'assets/tenants/konekto_app_default/reservations_config.json');
      final Map<String, dynamic> data = json.decode(response);

      final List<dynamic> allReservations = data['reservations'];
      _sortAndCategorizeReservations(allReservations);
    } catch (e) {
      print('ERRO FATAL: Falha ao carregar ou decodificar os dados das reservas.');
      print('Detalhes do erro: $e');
      setState(() {
        _isLoading = false;
        _pendingReservations = [];
        _completedReservations = [];
        _cancelledReservations = [];
      });
    }
  }

  void _sortAndCategorizeReservations(List<dynamic> reservations) {
    // Lista para as reservas já processadas com o novo status
    final List<dynamic> processedReservations = [];
    final DateTime now = DateTime.now();

    for (var reservation in reservations) {
      // Cria uma cópia da reserva para evitar modificar a original
      final Map<String, dynamic> updatedReservation = Map.from(reservation);
      
      try {
        final DateTime reservationDateTime = DateFormat('yyyy-MM-dd HH:mm')
            .parse('${reservation['date']} ${reservation['time']}');

        // Calcula o tempo de "graça" de 25 minutos após o agendamento
        final DateTime completionTime = reservationDateTime.add(const Duration(minutes: 25));

        // Verifica se a reserva deve ser concluída automaticamente
        if (now.isAfter(completionTime) && updatedReservation['status'].toString().trim().toLowerCase() == 'em andamento') {
          updatedReservation['status'] = 'Concluído';
        }

      } catch (e) {
        print('Erro ao processar data/hora da reserva: $e');
      }
      processedReservations.add(updatedReservation);
    }
    
    // Ordena as reservas por data, da mais recente para a mais antiga
    processedReservations.sort((a, b) {
      try {
        final DateTime dateA = DateFormat('yyyy-MM-dd HH:mm').parse('${a['date']} ${a['time']}');
        final DateTime dateB = DateFormat('yyyy-MM-dd HH:mm').parse('${b['date']} ${b['time']}');
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    setState(() {
      _pendingReservations = processedReservations
          .where((r) => r['status'] != null && r['status'].toString().trim().toLowerCase() == 'em andamento')
          .toList();
      _completedReservations = processedReservations
          .where((r) => r['status'] != null && r['status'].toString().trim().toLowerCase() == 'concluído')
          .toList();
      _cancelledReservations = processedReservations
          .where((r) => r['status'] != null && r['status'].toString().trim().toLowerCase() == 'cancelado')
          .toList();
      _isLoading = false;
    });
  }

  void _showCancellationDialog(Map<String, dynamic> reservation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: widget.appColors.cardBackground,
          title: Text(
            'Confirmar Cancelamento',
            style: TextStyle(color: widget.appColors.primaryText),
          ),
          content: Text(
            'Tem certeza de que deseja cancelar esta reserva?',
            style: TextStyle(color: widget.appColors.secondaryText),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Não',
                style: TextStyle(color: widget.appColors.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                _cancelReservation(reservation);
                Navigator.of(context).pop();
              },
              child: Text(
                'Sim',
                style: TextStyle(color: widget.appColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _cancelReservation(Map<String, dynamic> reservation) {
    setState(() {
      final index = _pendingReservations
          .indexWhere((r) => r['id'] == reservation['id']);
      if (index != -1) {
        final cancelledReservation = _pendingReservations.removeAt(index);
        cancelledReservation['status'] = 'Cancelado';
        _cancelledReservations.add(cancelledReservation);
        _sortAndCategorizeReservations([
          ..._pendingReservations,
          ..._completedReservations,
          ..._cancelledReservations
        ]);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reserva cancelada com sucesso!'),
        backgroundColor: widget.appColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> reservationsConfig =
        widget.tenantConfig['uiConfig']?['reservationsScreen'] ?? {};
    final String bannerPath = reservationsConfig['bannerPath'] ??
        'assets/tenants/konekto_app_default/images/banners/reservas_banner.jpg';
    final String bannerText =
        reservationsConfig['bannerText'] ?? 'Minhas Reservas';

    return Scaffold(
      backgroundColor: widget.appColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageBanner(
              imagePath: bannerPath,
              height: 250,
              gradientText: bannerText,
              appColors: widget.appColors,
            ),
            _isLoading
                ? Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: widget.appColors.primary),
                    ),
                  )
                : _buildReservationsContent(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationsContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildReservationList(
            'Reservas Agendadas',
            _pendingReservations,
            'Você não possui nenhuma reserva agendada.',
            isCollapsible: false,
          ),
          _buildReservationList(
            'Reservas Concluídas',
            _completedReservations,
            'Nenhuma reserva concluída encontrada.',
            isCollapsible: true,
          ),
          _buildReservationList(
            'Reservas Canceladas',
            _cancelledReservations,
            'Nenhuma reserva cancelada encontrada.',
            isCollapsible: true,
          ),
        ],
      ),
    );
  }

  Widget _buildReservationList(
      String title, List<dynamic> reservations, String emptyMessage, {required bool isCollapsible}) {
    final Widget content = reservations.isEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.appColors.secondaryText,
                  ),
            ),
          )
        : Column(
            children: reservations
                .map((r) => _buildReservationItem(context, r, r['status']))
                .toList(),
          );

    if (isCollapsible) {
      return Card(
        color: widget.appColors.cardBackground,
        margin: const EdgeInsets.only(top: 16),
        child: ExpansionTile(
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: widget.appColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
          ),
          children: [content],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: widget.appColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          if (reservations.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                emptyMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: widget.appColors.secondaryText,
                    ),
              ),
            ),
          if (reservations.isNotEmpty)
            ...reservations.map((r) => _buildReservationItem(context, r, r['status'])),
        ],
      );
    }
  }

  Widget _buildReservationItem(
      BuildContext context, Map<String, dynamic> reservation, String status) {
    final bool canCancel = status.toString().trim().toLowerCase() == 'em andamento';
    
    String formattedDate = '';
    try {
      final date = DateFormat('yyyy-MM-dd').parse(reservation['date']);
      formattedDate = DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      formattedDate = reservation['date'];
    }

    return Container(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              reservation['imagePath'] ?? 'assets/images/placeholder.png',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: widget.appColors.borderColor,
                  child: Icon(Icons.error_outline,
                      color: widget.appColors.secondaryText),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation['name'],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: widget.appColors.primaryText,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tipo: ${reservation['service_type']}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: widget.appColors.secondaryText,
                      ),
                ),
                Text(
                  'Data: $formattedDate às ${reservation['time']}h',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: widget.appColors.secondaryText,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Status: ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: widget.appColors.primaryText,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    _buildStatusChip(status),
                  ],
                ),
                if (canCancel) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 200,
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancellationDialog(reservation),
                      icon: const Icon(Icons.cancel, size: 20),
                      label: const Text('Cancelar Reserva'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: widget.appColors.error,
                        side: BorderSide(color: widget.appColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText = status;

    switch (status.toString().trim().toLowerCase()) {
      case 'em andamento':
        chipColor = widget.appColors.warning;
        break;
      case 'concluído':
        chipColor = widget.appColors.success;
        break;
      case 'cancelado':
        chipColor = widget.appColors.error;
        break;
      default:
        chipColor = widget.appColors.secondaryText;
        statusText = 'Desconhecido';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: chipColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}