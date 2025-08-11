import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';

class PoiCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final AppThemeData appColors;
  final bool isSelected;
  final VoidCallback onTap;

  const PoiCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.appColors,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? appColors.accent.withOpacity(0.2) : appColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? Border.all(color: appColors.accent, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        // CORREÇÃO: Usamos uma Row para o layout lado a lado
        child: Row(
          children: [
            // Expanded para o texto, que ocupará o espaço disponível
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: appColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: appColors.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Container para a imagem, com tamanho fixo
            Container(
              width: 80,
              height: 80,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: appColors.secondaryText.withOpacity(0.1),
                    child: Center(
                      child: Icon(Icons.broken_image, color: appColors.secondaryText),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}