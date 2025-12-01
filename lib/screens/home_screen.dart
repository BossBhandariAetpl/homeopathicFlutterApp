import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/medicine.dart';
import '../services/medicine_service.dart';
import '../widgets/app_bar/home_app_bar.dart';
import '../widgets/cards/medicine_card.dart';
import '../widgets/headers/medicines_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  List<Medicine> medicines = [];

  @override
  void initState() {
    super.initState();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    try {
      medicines = await MedicineService().fetchMedicines();
    } catch (e) {
      print("❌ Failed loading medicines: $e");
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: loading 
          ? const Center(child: CircularProgressIndicator())
          : _body(),
    );
  }

  Widget _body() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: medicines.length + 2,
      itemBuilder: (context, index) {
        // Header Section
        if (index == 0) {
          return const MedicinesHeader(
            title: 'All Medicines',
            description: 'Explore our comprehensive collection of homeopathic remedies. '
                'Find detailed information about symptoms, usage, and more.',
          );
        }

        // Count text
        if (index == 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Showing ${medicines.length} medicine(s)",
                style: GoogleFonts.poppins(
                  fontSize: 16, 
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }

        // Medicine card
        return MedicineCard(
          key: ValueKey('${medicines[index - 2].remedy}_${medicines[index - 2].commonName}'),
          medicine: medicines[index - 2],
          onTap: () {
            // TODO: Handle medicine card tap
          },
        );
      },
    );
  }
}