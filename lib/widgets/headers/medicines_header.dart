import 'package:flutter/material.dart';
import '../../constants/text_styles.dart';

class MedicinesHeader extends StatelessWidget {
  final String title;
  final String description;

  const MedicinesHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.title),
        const SizedBox(height: 4),
        Text(description, style: AppTextStyles.subtitle),
      ],
    );
  }
}
