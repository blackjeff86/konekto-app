import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;

  const CustomHeader({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 48,
            child: leading ?? const SizedBox.shrink(),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
            ),
          ),
          SizedBox(
            width: 48,
            child: trailing ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}