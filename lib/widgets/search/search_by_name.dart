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
          decoration: InputDecoration(
            hintText: "Search medicines by name...",
            hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
