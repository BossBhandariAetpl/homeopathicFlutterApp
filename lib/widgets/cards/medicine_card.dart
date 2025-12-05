import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/medicine.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onTap;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRemedyName(),
            if (medicine.commonName.isNotEmpty) ..._buildCommonName(),
            _buildDescription(),
            const SizedBox(height: 12),
            _buildViewDetailsButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRemedyName() {
    return Text(
      medicine.remedy.isEmpty ? "Unknown Remedy" : medicine.remedy.toUpperCase(),
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<Widget> _buildCommonName() {
    return [
      const SizedBox(height: 6),
      Text(
        medicine.commonName,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.green,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(height: 12),
    ];
  }

  Widget _buildDescription() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 120),
      child: SingleChildScrollView(
        child: Text(
          medicine.general.isEmpty ? "No description available." : medicine.general,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildViewDetailsButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        child: const Text("View Details"),
      ),
    );
  }
}
