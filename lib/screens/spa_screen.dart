import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import 'schedule_screen.dart';

class SpaScreen extends StatefulWidget {
  const SpaScreen({super.key});

  @override
  State<SpaScreen> createState() => _SpaScreenState();
}

class _SpaScreenState extends State<SpaScreen> {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pré-carrega todas as imagens da tela do SPA
    _precacheSpaImages();
  }

  void _precacheSpaImages() {
    const List<String> spaImagePaths = [
      'assets/images/spa_background.png',
      'assets/images/massagem_relaxante.png',
      'assets/images/massagem_terapeutica.png',
      'assets/images/limpeza_de_pele.png',
      'assets/images/tratamento_antiidade.png',
    ];

    for (var path in spaImagePaths) {
      precacheImage(AssetImage(path), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomHeader(
              title: 'SPA',
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.primaryText),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: const SizedBox.shrink(),
            ),
            const ImageBanner(
              imagePath: 'assets/images/spa_background.png',
              height: 250,
            ),
            _buildSpaContent(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Massagens',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildServiceItem(
            context,
            'Massagem Relaxante',
            'Alivia o estresse e a tensão muscular com movimentos suaves e óleos essenciais.',
            '60 min',
            'assets/images/massagem_relaxante.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduleScreen(
                    serviceTitle: 'Massagem Relaxante',
                    serviceDescription: 'Alivia o estresse e a tensão muscular com movimentos suaves e óleos essenciais.',
                    imagePath: 'assets/images/massagem_relaxante.png',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildServiceItem(
            context,
            'Massagem Terapêutica',
            'Tratamento profundo para dores musculares e articulares, com técnicas avançadas.',
            '90 min',
            'assets/images/massagem_terapeutica.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduleScreen(
                    serviceTitle: 'Massagem Terapêutica',
                    serviceDescription: 'Tratamento profundo para dores musculares e articulares, com técnicas avançadas.',
                    imagePath: 'assets/images/massagem_terapeutica.png',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Tratamentos Faciais',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildServiceItem(
            context,
            'Limpeza de Pele Profunda',
            'Remove impurezas e cravos, deixando a pele limpa e revitalizada.',
            '45 min',
            'assets/images/limpeza_de_pele.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduleScreen(
                    serviceTitle: 'Limpeza de Pele Profunda',
                    serviceDescription: 'Remove impurezas e cravos, deixando a pele limpa e revitalizada.',
                    imagePath: 'assets/images/limpeza_de_pele.png',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildServiceItem(
            context,
            'Tratamento Anti-idade',
            'Reduz rugas e linhas de expressão, promovendo uma pele mais jovem e firme.',
            '60 min',
            'assets/images/tratamento_antiidade.png',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduleScreen(
                    serviceTitle: 'Tratamento Anti-idade',
                    serviceDescription: 'Reduz rugas e linhas de expressão, promovendo uma pele mais jovem e firme.',
                    imagePath: 'assets/images/tratamento_antiidade.png',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(
      BuildContext context, String title, String subtitle, String duration, String imagePath, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    duration,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryText,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 130,
                height: 112,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}