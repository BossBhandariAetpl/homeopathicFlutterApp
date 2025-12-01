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
  List<Medicine> filteredMedicines = [];

  String searchTerm = "";
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
    filteredMedicines = medicines; // initialize
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
  void applyFilters() {
  final term = searchTerm.toLowerCase().trim();

  setState(() {
    filteredMedicines = medicines.where((med) {
      final name = med.remedy.toLowerCase();
      final common = med.commonName.toLowerCase();
      final general = med.general.toLowerCase();

      final matchesSearch =
          term.isEmpty ||
          name.contains(term) ||
          common.contains(term) ||
          general.contains(term);

      final matchesCategory =
          selectedCategory == "all" ||
          med.sections.values.join(" ").toLowerCase().contains(
                selectedCategory.toLowerCase(),
              );

      return matchesSearch && matchesCategory;
    }).toList();
  });
}


  Widget _body() {
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [

      // 🔍 Search Bar (scrolls)
      SearchByName(
  onChanged: (value) {
    searchTerm = value;
    applyFilters();
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
        "Showing ${filteredMedicines.length} medicine(s)",
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),

      const SizedBox(height: 12),

      // Medicine cards
      ...filteredMedicines.map(
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