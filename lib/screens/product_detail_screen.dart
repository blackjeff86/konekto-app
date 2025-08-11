// lib/screens/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
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
  late final TextEditingController _customizationController;

  @override
  void initState() {
    super.initState();
    _customizationController = TextEditingController();
  }

  @override
  void dispose() {
    _customizationController.dispose();
    super.dispose();
  }

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
    final double totalPrice = price * _quantity;

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
                    // Usa a cor buttonText, que agora é branca
                    icon: Icon(Icons.arrow_back, color: widget.appColors.buttonText, size: 30),
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
                  Text(
                    'Observações do pedido:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: widget.appColors.primaryText,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  DottedBorder(
                    color: widget.appColors.secondaryText,
                    strokeWidth: 1,
                    dashPattern: const [4, 4],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    child: TextField(
                      controller: _customizationController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      style: TextStyle(color: widget.appColors.primaryText),
                      decoration: InputDecoration(
                        hintText: 'Ex: Sem cebola, com mais molho, etc.',
                        hintStyle: TextStyle(color: widget.appColors.secondaryText),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 50,
                        child: _buildQuantitySelector(),
                      ),
                      SizedBox(
                        width: 170,
                        height: 50,
                        child: _buildAddToCartButton(context, totalPrice),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Total: R\$ ${totalPrice.toStringAsFixed(2)}',
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: widget.appColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.keyboard_arrow_down, color: widget.appColors.buttonText),
            onPressed: _decrementQuantity,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              _quantity.toString(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.appColors.buttonText, // Usa a cor do tema
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.keyboard_arrow_up, color: widget.appColors.buttonText),
            onPressed: _incrementQuantity,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context, double totalPrice) {
    String customizationText = _customizationController.text;

    final String deliveryEstimate = 'A entrega está estimada para 30-45 minutos.';

    String dialogMessage = '$_quantity x "${widget.product['name']}" (R\$ ${totalPrice.toStringAsFixed(2)}) será adicionado ao seu carrinho.';
    if (customizationText.isNotEmpty) {
      dialogMessage += '\n\nObservações:\n$customizationText';
    }
    dialogMessage += '\n\n$deliveryEstimate';

    return ElevatedButton.icon(
      onPressed: () {
        showCustomDialog(
          context: context,
          title: 'Pedido para Quarto Confirmado!',
          message: dialogMessage,
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
        padding: EdgeInsets.zero,
      ),
      icon: Icon(Icons.shopping_cart, color: widget.appColors.buttonText),
      label: Text(
        'Adicionar',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: widget.appColors.buttonText, // Usa a cor do tema
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}