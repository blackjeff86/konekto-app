import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart'; // ALTERADO: Usa a nova classe de cores
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import '../widgets/bottom_buttons.dart';
import 'schedule_screen.dart';

class MenuScreen extends StatelessWidget {
  final String restaurantTitle;
  final String restaurantDescription;
  final String restaurantImagePath;
  final List<Map<String, dynamic>> menu;
  final AppThemeData appColors; // ADICIONADO: Parâmetro para as cores dinâmicas

  const MenuScreen({
    super.key,
    required this.restaurantTitle,
    required this.restaurantDescription,
    required this.restaurantImagePath,
    required this.menu,
    required this.appColors, // ADICIONADO: ao construtor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background, // ALTERADO: Usa cor dinâmica
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomHeader(
          title: 'Cardápio',
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: appColors.primaryText), // ALTERADO: Usa cor dinâmica
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
              appColors: appColors, // CORRIGIDO: O argumento 'appColors' agora está sendo passado.
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: appColors.secondaryText, // ALTERADO: Usa cor dinâmica
                        ),
                  ),
                  const SizedBox(height: 24),
                  ...menu.map((section) => _buildMenuSection(context, section)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomButtons(
        text: 'Agendar agora',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleScreen(
                serviceTitle: restaurantTitle,
                serviceDescription: restaurantDescription,
                imagePath: restaurantImagePath,
                appColors: appColors, // ADICIONADO: Passa a paleta de cores para a próxima tela
              ),
            ),
          );
        },
        appColors: appColors,
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, Map<String, dynamic> section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section['title'],
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: appColors.primaryText, // ALTERADO: Usa cor dinâmica
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        ...section['items'].map<Widget>((item) => _buildMenuItem(context, item)).toList(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
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
                item['imagePath'],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: appColors.borderColor, // ALTERADO: Usa cor dinâmica
                    child: Icon(Icons.restaurant_menu, color: appColors.secondaryText), // ALTERADO: Usa cor dinâmica
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
                        item['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: appColors.primaryText, // ALTERADO: Usa cor dinâmica
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ${item['price'].toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appColors.primary, // ALTERADO: Usa cor dinâmica
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: appColors.secondaryText, // ALTERADO: Usa cor dinâmica
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