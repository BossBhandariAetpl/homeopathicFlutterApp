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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Filter by Category",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF334155),
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 50,  // Fixed height for the dropdown container
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0x1A000000)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF1E293B),
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              elevation: 4,
              menuMaxHeight: 300,
              isDense: false,  // Changed to false to allow full height
              itemHeight: 48,  // Height of each dropdown item
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      category[0].toUpperCase() + category.substring(1),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: selectedCategory == category 
                            ? const Color(0xFF4F46E5) 
                            : const Color(0xFF1E293B),
                        fontWeight: selectedCategory == category 
                            ? FontWeight.w600 
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
