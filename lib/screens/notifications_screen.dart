// lib/screens/notifications_screen.dart

import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const NotificationsScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Uma cópia das notificações que podemos modificar (marcar como lida)
  late List<Map<String, dynamic>> _notifications;

  @override
  void initState() {
    super.initState();
    // Carrega as notificações do tenantConfig
    _notifications = List<Map<String, dynamic>>.from(
      widget.tenantConfig['notificationsList']?.map((item) => Map<String, dynamic>.from(item)) ?? [],
    );
    // Opcional: Ordenar notificações pela mais recente primeiro
    _notifications.sort((a, b) {
      try {
        DateTime dateA = DateFormat('yyyy-MM-dd HH:mm:ss').parse(a['timestamp']);
        DateTime dateB = DateFormat('yyyy-MM-dd HH:mm:ss').parse(b['timestamp']);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });
  }

  void _markNotificationAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['read'] = true;
      }
    });
    // Em uma aplicação real, aqui você enviaria a atualização para o seu backend.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notificação marcada como lida!'),
        backgroundColor: widget.appColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filtra notificações não lidas para exibição prioritária, se desejar
    final List<Map<String, dynamic>> unreadNotifications = _notifications.where((n) => n['read'] == false).toList();
    final List<Map<String, dynamic>> readNotifications = _notifications.where((n) => n['read'] == true).toList();

    return Scaffold(
      backgroundColor: widget.appColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: CustomHeader(
          title: 'Notificações',
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.appColors.primaryText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          trailing: const SizedBox.shrink(), // Sem ícone de notificação na tela de notificações
          appColors: widget.appColors,
          titleFontSize: 24.0, // Você pode ajustar o tamanho da fonte aqui se quiser um controle mais granular para esta tela
          headerTitleType: 'text', // Força texto para o título desta tela
          logoPath: '',
        ),
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Text(
                'Nenhuma notificação encontrada.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: widget.appColors.secondaryText,
                    ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (unreadNotifications.isNotEmpty) ...[
                    Text(
                      'Novas Notificações',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: widget.appColors.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    ...unreadNotifications.map((notification) => _buildNotificationCard(notification, false)),
                    const SizedBox(height: 24.0),
                  ],
                  if (readNotifications.isNotEmpty) ...[
                    Text(
                      'Notificações Antigas',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: widget.appColors.primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16.0),
                    ...readNotifications.map((notification) => _buildNotificationCard(notification, true)),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, bool isRead) {
    String formattedTime = '';
    try {
      DateTime timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').parse(notification['timestamp']);
      formattedTime = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(timestamp);
    } catch (e) {
      formattedTime = notification['timestamp'] ?? '';
    }

    return Card(
      color: isRead ? widget.appColors.cardBackground : widget.appColors.primary.withOpacity(0.05), // Fundo levemente diferente para não lidas
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notification['title'] ?? 'Sem Título',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: widget.appColors.primaryText,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        ),
                  ),
                ),
                Text(
                  formattedTime,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: widget.appColors.secondaryText,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              notification['message'] ?? 'Sem mensagem.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.appColors.secondaryText,
                  ),
            ),
            if (!isRead)
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => _markNotificationAsRead(notification['id']),
                  child: Text(
                    'Marcar como lida',
                    style: TextStyle(color: widget.appColors.primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
