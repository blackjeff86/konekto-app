import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  final AppThemeData appColors;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.appColors,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = widget.product['imagePath'] ?? 'assets/placeholder.jpg';
    final String title = widget.product['title'];
    final String description = widget.product['description'];
    final double price = widget.product['price']?.toDouble() ?? 0.0;

    return Scaffold(
      backgroundColor: widget.appColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: widget.appColors.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R\$ ${price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: widget.appColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.appColors.secondaryText,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuantitySelector(),
                      _buildAddToCartButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.appColors.accent, // CORRIGIDO: Usando 'accent'
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _decrementQuantity,
            child: Icon(Icons.remove, color: widget.appColors.primaryText),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              _quantity.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: widget.appColors.primaryText,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          GestureDetector(
            onTap: _incrementQuantity,
            child: Icon(Icons.add, color: widget.appColors.primaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Implementar a lógica para adicionar ao carrinho
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_quantity x "${widget.product['title']}" adicionado(s) ao carrinho.'),
            backgroundColor: widget.appColors.primary,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.appColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        'Adicionar ao Carrinho',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: widget.appColors.buttonText, // CORRIGIDO: Usando 'buttonText'
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}