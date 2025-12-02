import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchByName extends StatelessWidget {
  final void Function(String)? onChanged;

  const SearchByName({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 10),

        TextField(
          style: GoogleFonts.inter(color: const Color(0xFF1E293B)),
          decoration: InputDecoration(
            hintText: "Search medicines by name or description...",
            hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0x1A000000)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0x1A000000)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
