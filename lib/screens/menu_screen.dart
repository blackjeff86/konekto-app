import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import '../widgets/bottom_buttons.dart';
import 'schedule_screen.dart';

class MenuScreen extends StatelessWidget {
  final String restaurantTitle;
  final String restaurantDescription;
  final String restaurantImagePath;
  final List<Map<String, dynamic>> menu;
  final AppThemeData appColors;
  // NOVO: Adicionados os parâmetros necessários para a ScheduleScreen
  final Map<String, dynamic> tenantConfig;
  final List<Map<String, dynamic>> roomServiceMenu;

  const MenuScreen({
    super.key,
    required this.restaurantTitle,
    required this.restaurantDescription,
    required this.restaurantImagePath,
    required this.menu,
    required this.appColors,
    // NOVO: Adicionados os parâmetros no construtor
    required this.tenantConfig,
    required this.roomServiceMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomHeader(
          title: 'Cardápio',
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: appColors.primaryText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: const SizedBox.shrink(),
          appColors: appColors,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ImageBanner(
              imagePath: restaurantImagePath,
              height: 250,
              gradientText: restaurantTitle,
              appColors: appColors,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: appColors.secondaryText,
                        ),
                  ),
                  const SizedBox(height: 24),
                  if (menu.isNotEmpty)
                    ...menu.map((section) => _buildMenuSection(context, section)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButtons(
        text: 'Reservar Mesa',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleScreen(
                serviceTitle: restaurantTitle,
                serviceDescription: restaurantDescription,
                imagePath: restaurantImagePath,
                appColors: appColors,
                tenantConfig: tenantConfig,
                roomServiceMenu: roomServiceMenu,
              ),
            ),
          );
        },
        appColors: appColors,
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, Map<String, dynamic> section) {
    final String sectionTitle = section['title'] ?? 'Seção sem Título';
    final List<dynamic> items = section['items'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sectionTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: appColors.primaryText,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        ...items.map<Widget>((item) => _buildMenuItem(context, item)),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    final String itemName = item['name'] ?? 'Item sem nome';
    final String itemDescription = item['description'] ?? 'Descrição não disponível';
    final double itemPrice = item['price']?.toDouble() ?? 0.0;
    final String imagePath = item['imagePath'] ?? 'assets/placeholder.jpg';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: appColors.borderColor,
                    child: Icon(Icons.restaurant_menu, color: appColors.secondaryText),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        itemName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appColors.primaryText,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${itemPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  itemDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: appColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}