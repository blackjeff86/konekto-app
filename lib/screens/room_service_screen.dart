import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import 'product_detail_screen.dart'; // Importa a nova tela

class RoomServiceScreen extends StatelessWidget {
  final String serviceTitle;
  final String serviceDescription;
  final String serviceImagePath;
  final List<Map<String, dynamic>> menu;
  final AppThemeData appColors;

  const RoomServiceScreen({
    super.key,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.serviceImagePath,
    required this.menu,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(
              title: serviceTitle,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: appColors.primaryText),
                onPressed: () => Navigator.pop(context),
              ),
              trailing: const SizedBox.shrink(),
              appColors: appColors,
            ),
            ImageBanner(
              imagePath: serviceImagePath,
              height: 200,
              appColors: appColors,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                serviceDescription,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: appColors.primaryText,
                    ),
              ),
            ),
            _buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Column(
      children: menu.map((category) {
        return ExpansionTile(
          title: Text(
            category['category'],
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
          ),
          initiallyExpanded: true,
          children: category['items'].map<Widget>((item) {
            return _buildMenuItem(context, item);
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: item,
              appColors: appColors,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColors.background,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: appColors.shadowColor,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                item['imagePath'] ?? 'assets/placeholder.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: appColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: appColors.secondaryText,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${item['price'].toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: appColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}