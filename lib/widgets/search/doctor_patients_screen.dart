import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorPatientsScreen extends StatelessWidget {
  const DoctorPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xfff5f7ff), // very light pastel background
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🔹 Top Header Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xff00796b), // teal
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Patient Management",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Manage patient records and information",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // 🔹 Cards Grid (Stacked vertically for mobile)
          _buildCard(
            icon: Icons.person_add_alt_1,
            title: "Add New Patient",
            description:
                "Register a new patient and create their profile.",
            iconBg: const Color(0xffe8f0fe),
          ),

          const SizedBox(height: 14),

          _buildAllPatientsCard(),

          const SizedBox(height: 14),

          _buildCard(
            icon: Icons.medical_services_rounded,
            title: "Create Prescription",
            description: "Start a new prescription for a patient.",
            iconBg: const Color(0xffe8fef0),
          ),
        ],
      ),
    );
  }

  // 🔹 Standard Card UI (for Add & Create Prescription)
  Widget _buildCard({
    required IconData icon,
    required String title,
    required String description,
    required Color iconBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Circle
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.black87),
          ),

          const SizedBox(width: 20),

          // Title + Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 🔹 Special Card for "All Patients"
  Widget _buildAllPatientsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xfff3e8ff),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.groups_rounded,
                    size: 28, color: Colors.black87),
              ),
              const SizedBox(width: 20),
              Text(
                "All Patients",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "View and search all patients by name, contact, or email.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          // Stats Row (Total, Male, Female)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildStat("Total", 0, Colors.black),
              const SizedBox(width: 18),
              _buildStat("Male", 0, Colors.blue),
              const SizedBox(width: 18),
              _buildStat("Female", 0, Colors.pink),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
          Text(
            "$count",
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
