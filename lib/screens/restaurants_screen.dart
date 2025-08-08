import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import 'menu_screen.dart';

class RestaurantsScreen extends StatefulWidget {
  final Map<String, dynamic> tenantConfig;
  final AppThemeData appColors;

  const RestaurantsScreen({
    super.key,
    required this.tenantConfig,
    required this.appColors,
  });

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  List<Map<String, dynamic>> _restaurants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurantsData();
  }

  Future<void> _loadRestaurantsData() async {
    try {
      final String response = await rootBundle.loadString(
          widget.tenantConfig['restaurantsJsonPath'] ??
              'assets/tenants/konekto_app_default/restaurants_data.json');
      final Map<String, dynamic> data = json.decode(response);
      setState(() {
        _restaurants = List<Map<String, dynamic>>.from(data['restaurants']);
        _isLoading = false;
      });
    } catch (e) {
      print('ERRO ao carregar ou decodificar os dados dos restaurantes: $e');
      setState(() {
        _isLoading = false;
        _restaurants = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.appColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomHeader(
          title: 'Restaurantes',
          appColors: widget.appColors,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.appColors.primaryText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: const SizedBox.shrink(),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: widget.appColors.primary),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Escolha sua experiência gastronômica',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: widget.appColors.primaryText,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = _restaurants[index];
                          return _buildRestaurantCard(context, restaurant);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRestaurantCard(
      BuildContext context, Map<String, dynamic> restaurant) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(
              restaurantTitle: restaurant['title'],
              restaurantDescription: restaurant['description'],
              restaurantImagePath: restaurant['imagePath'],
              menu: List<Map<String, dynamic>>.from(restaurant['menu']),
              appColors: widget.appColors,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                restaurant['imagePath'],
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: widget.appColors.borderColor,
                    child: Icon(Icons.restaurant, color: widget.appColors.secondaryText),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['title'],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: widget.appColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant['description'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: widget.appColors.secondaryText,
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