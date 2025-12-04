import 'package:flutter/material.dart';
import 'package:flutter_homeopathy_app/widgets/search/category_dropdown.dart';
import 'package:flutter_homeopathy_app/widgets/search/search_by_name.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/medicine.dart';
import '../services/medicine_service.dart';
import '../widgets/app_bar/home_app_bar.dart';
import '../widgets/cards/medicine_card.dart';
import '../widgets/headers/medicines_header.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  int currentPage = 1;
  int itemsPerPage = 12;

  List<Medicine> medicines = [];
  List<Medicine> filteredMedicines = [];

  String searchTerm = "";
  String selectedCategory = "all";

  final user = FirebaseAuth.instance.currentUser;

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

  // PAGINATION — return only X items of current page
  List<Medicine> get paginatedMedicines {
    int start = (currentPage - 1) * itemsPerPage;
    int end = start + itemsPerPage;

    if (start >= filteredMedicines.length) return [];

    return filteredMedicines.sublist(
      start,
      end > filteredMedicines.length ? filteredMedicines.length : end,
    );
  }

  @override
  void initState() {
    super.initState();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    try {
      medicines = await MedicineService().fetchMedicines();
      filteredMedicines = medicines;
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

  // FILTERS
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
            med.sections.values
                .join(" ")
                .toLowerCase()
                .contains(selectedCategory.toLowerCase());

        return matchesSearch && matchesCategory;
      }).toList();

      currentPage = 1; // Reset page after filter
    });
  }

  // MAIN BODY
  Widget _body() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 🔍 Search Bar
        Text(
          "Logged in as: ${user?.email ?? 'User'}",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        SearchByName(
          onChanged: (value) {
            searchTerm = value;
            applyFilters();
          },
        ),

        const SizedBox(height: 16),

        // CATEGORY DROPDOWN
        CategoryDropdown(
          categories: categories,
          selectedCategory: selectedCategory,
          onChanged: (value) {
            selectedCategory = value ?? "all";
            applyFilters();
          },
        ),

        const SizedBox(height: 16),

        // HEADER
        const MedicinesHeader(
          title: 'All Medicines',
          description:
              'Explore our comprehensive collection of homeopathic remedies. '
              'Find detailed information about symptoms, usage, and more.',
        ),

        const SizedBox(height: 12),

        // Showing count
        Text(
          "Showing ${paginatedMedicines.length} of ${filteredMedicines.length} medicines",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 12),

        // SHOW PAGINATED CARDS ONLY
        ...paginatedMedicines.map(
          (med) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MedicineCard(
              key: ValueKey("${med.remedy}_${med.commonName}"),
              medicine: med,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // PAGINATION BAR
        paginationBar(),
      ],
    );
  }

  // PAGINATION BAR EXACT LIKE WEBSITE
  Widget paginationBar() {
    if (filteredMedicines.isEmpty) return const SizedBox();

    int totalPages = ((filteredMedicines.length - 1) / itemsPerPage).ceil();

    int showingFrom = ((currentPage - 1) * itemsPerPage) + 1;
    int showingTo = (currentPage * itemsPerPage > filteredMedicines.length)
        ? filteredMedicines.length
        : currentPage * itemsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffeef1ff),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Showing X–Y of Z
          Text(
            "Showing $showingFrom-$showingTo of ${filteredMedicines.length}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 12),

          // Wrap instead of Row => NO OVERFLOW
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 10,
            children: [
              // PER PAGE DROPDOWN
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Per page: "),
                  const SizedBox(width: 6),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: DropdownButton<int>(
                      value: itemsPerPage,
                      underline: const SizedBox(),
                      items: [12, 24, 48, 96].map((e) {
                        return DropdownMenuItem(value: e, child: Text("$e"));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          itemsPerPage = value!;
                          currentPage = 1;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // PAGINATION BUTTONS
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.first_page),
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage = 1)
                        : null,
                  ),

                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: currentPage > 1
                        ? () => setState(() => currentPage--)
                        : null,
                  ),

                  Text("Page $currentPage of $totalPages"),

                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage++)
                        : null,
                  ),

                  IconButton(
                    icon: const Icon(Icons.last_page),
                    onPressed: currentPage < totalPages
                        ? () => setState(() => currentPage = totalPages)
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
