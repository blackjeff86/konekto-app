// lib/widgets/service_grid_item.dart

import 'package:flutter/material.dart';
import '../utils/app_theme_data.dart';

class ServiceGridItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;
  final AppThemeData appColors;

  const ServiceGridItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    required this.appColors,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: appColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: appColors.shadowColor,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imagePath.isNotEmpty
                    ? Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: appColors.borderColor,
                            child: const Icon(Icons.error, color: Colors.red),
                          );
                        },
                      )
                    : Container(
                        // Se o caminho da imagem for vazio, exibe um ícone de placeholder.
                        color: appColors.borderColor,
                        child: const Icon(Icons.help_outline, color: Colors.grey, size: 48),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  color: appColors.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}