import 'package:flutter/material.dart';
import '../../constants/text_styles.dart';

class CategoryDropdown extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final void Function(String?)? onChanged;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      items: categories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: "Category",
        labelStyle: AppTextStyles.label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
