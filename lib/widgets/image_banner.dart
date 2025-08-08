import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart'; // Importa a classe de cores

class ImageBanner extends StatelessWidget {
  final String imagePath;
  final double height;
  final String? gradientText;
  final AppThemeData appColors; // ADICIONADO: Parâmetro para as cores dinâmicas

  const ImageBanner({
    super.key,
    required this.imagePath,
    this.height = 250.0,
    this.gradientText,
    required this.appColors, // ADICIONADO: ao construtor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: gradientText != null
          ? Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          appColors.shadowColor, // ALTERADO: Usa a cor da sombra
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      gradientText!,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: appColors.background, // ALTERADO: Usa a cor de fundo (geralmente branco para o texto do banner)
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}