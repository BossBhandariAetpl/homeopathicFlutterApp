import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const _borderRadius = 8.0;
  static const _menuMaxHeight = 300.0;
  static const _itemHeight = 48.0;
  static const _dropdownHeight = 50.0;
  static const _padding = 12.0;
  static const _verticalPadding = 8.0;
  
  static const _textStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF1E293B),
  );
  
  static const _activeTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF4F46E5),
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const SizedBox(height: 8),
        _buildDropdown(),
      ],
    );
  }
  
  Widget _buildTitle() {
    return Text(
      "Filter by Category",
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF334155),
      ),
    );
  }
  
  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: _padding),
      height: _dropdownHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: const Color(0x1A000000)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF64748B),
          ),
          style: _textStyle,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(_borderRadius),
          elevation: 4,
          menuMaxHeight: _menuMaxHeight,
          isDense: false,
          itemHeight: _itemHeight,
          items: _buildDropdownItems(),
          onChanged: onChanged,
        ),
      ),
    );
  }
  
  List<DropdownMenuItem<String>> _buildDropdownItems() {
    return categories.map((category) {
      final isSelected = selectedCategory == category;
      return DropdownMenuItem(
        value: category,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: _verticalPadding),
          child: Text(
            category.isNotEmpty 
                ? '${category[0].toUpperCase()}${category.substring(1)}'
                : category,
            style: isSelected ? _activeTextStyle : _textStyle,
          ),
        ),
      );
    }).toList();
  }
}
