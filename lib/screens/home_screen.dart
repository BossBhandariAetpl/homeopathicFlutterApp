import 'package:flutter/material.dart';
import 'package:flutter_homeopathy_app/widgets/search/category_dropdown.dart';
import 'package:flutter_homeopathy_app/widgets/search/search_by_name.dart';
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

  String selectedCategory = "all";

  List<String> categories = [
    "all",
    "Pain Relief",
    "Fever",
    "Digestive",
    "Respiratory",
    "Urinary",
    "Sleep",
    "Skin",
    "Female",
    "Male",
    "General",
  ];

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
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [

      // 🔍 Search Bar (scrolls)
      SearchByName(
        onChanged: (value) {
          // TODO search logic
        },
      ),

      const SizedBox(height: 16),

      // NEW: CATEGORY DROPDOWN (scrolls)
      CategoryDropdown(
        categories: categories,
        selectedCategory: selectedCategory,
        onChanged: (value) {
          setState(() {
            selectedCategory = value ?? "all";
          });

          // TODO: filtering logic
        },
      ),

      const SizedBox(height: 16),

      // 🌟 Header
      const MedicinesHeader(
        title: 'All Medicines',
        description:
            'Explore our comprehensive collection of homeopathic remedies. '
            'Find detailed information about symptoms, usage, and more.',
      ),

      const SizedBox(height: 12),

      // Showing count
      Text(
        "Showing ${medicines.length} medicine(s)",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 12),

      // Medicine cards
      ...medicines.map(
        (med) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MedicineCard(
            key: ValueKey("${med.remedy}_${med.commonName}"),
            medicine: med,
          ),
        ),
      ),
    ],
  );
}




}