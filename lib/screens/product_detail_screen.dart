import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';
import '../widgets/custom_dialog.dart';

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
    final String title = widget.product['name'] ?? 'Item sem nome';
    final String description = widget.product['description'] ?? 'Descrição não disponível';
    final double price = widget.product['price']?.toDouble() ?? 0.0;
    final double totalPrice = price * _quantity; // Cálculo do preço total

    return Scaffold(
      backgroundColor: widget.appColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                imagePath.isNotEmpty
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        height: 300,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            width: double.infinity,
                            color: widget.appColors.borderColor,
                            child: Icon(Icons.room_service, color: widget.appColors.secondaryText, size: 50),
                          );
                        },
                      )
                    : Container(
                        height: 300,
                        width: double.infinity,
                        color: widget.appColors.borderColor,
                        child: Icon(Icons.room_service, color: widget.appColors.secondaryText, size: 50),
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
                    'R\$ ${price.toStringAsFixed(2)} por unidade',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.appColors.secondaryText,
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
                      _buildAddToCartButton(context, totalPrice),
                    ],
                  ),
                  // O espaçamento foi aumentado para 24
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total: R\$ ${totalPrice.toStringAsFixed(2)}',
                        // O tamanho da fonte foi ajustado para um valor fixo um pouco menor
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              color: widget.appColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
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
        color: widget.appColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 32,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down, color: widget.appColors.buttonText),
              onPressed: _decrementQuantity,
              padding: EdgeInsets.zero,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _quantity.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: widget.appColors.buttonText,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SizedBox(
            width: 32,
            child: IconButton(
              icon: Icon(Icons.keyboard_arrow_up, color: widget.appColors.buttonText),
              onPressed: _incrementQuantity,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context, double totalPrice) {
    return ElevatedButton.icon(
      onPressed: () {
        showCustomDialog(
          context: context,
          title: 'Pedido para Quarto Confirmado!',
          message: '$_quantity x "${widget.product['name']}" (R\$ ${totalPrice.toStringAsFixed(2)}) será adicionado ao seu carrinho',
          appColors: widget.appColors,
          okButtonText: 'Confirmar Pedido',
          onOkPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.appColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      icon: Icon(Icons.shopping_cart, color: widget.appColors.buttonText),
      label: Text(
        'Adicionar',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: widget.appColors.buttonText,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}