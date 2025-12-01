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
            Text(
              medicine.remedy.isNotEmpty 
                  ? medicine.remedy.toUpperCase() 
                  : "Unknown Remedy",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            if (medicine.commonName.isNotEmpty) ...[
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
            ],

            Container(
              constraints: const BoxConstraints(maxHeight: 120),
              child: SingleChildScrollView(
                child: Text(
                  medicine.general.isNotEmpty 
                      ? medicine.general 
                      : "No description available.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
