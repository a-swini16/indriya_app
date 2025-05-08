// lib/widgets/section_title.dart
import 'package:flutter/material.dart';
import 'package:indriya_academy/config/theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isLight;
  
  const SectionTitle({
    Key? key, 
    required this.title, 
    this.subtitle,
    this.isLight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: isLight ? Colors.white : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 16),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 16,
              color: isLight ? Colors.white.withOpacity(0.9) : Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
