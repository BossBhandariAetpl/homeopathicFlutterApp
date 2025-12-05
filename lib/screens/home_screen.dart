import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/medicine.dart';
import '../services/medicine_service.dart';
import '../widgets/app_bar/home_app_bar.dart';
import '../widgets/cards/medicine_card.dart';
import '../widgets/headers/medicines_header.dart';
import '../widgets/search/category_dropdown.dart';
import '../widgets/search/search_by_name.dart';
import '../constants/app_strings.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  
  int _currentPage = 1;
  int _itemsPerPage = 12;
  String _searchTerm = "";
  String _selectedCategory = "all";
  
  final List<Medicine> _medicines = [];
  final List<Medicine> _filteredMedicines = [];
  
  static const List<String> _categories = AppStrings.categories;

  List<Medicine> get _paginatedMedicines {
    final start = (_currentPage - 1) * _itemsPerPage;
    if (start >= _filteredMedicines.length) return [];
    
    final end = start + _itemsPerPage > _filteredMedicines.length
        ? _filteredMedicines.length
        : start + _itemsPerPage;
        
    return _filteredMedicines.sublist(start, end);
  }

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    try {
      final fetchedMedicines = await MedicineService().fetchMedicines();
      setState(() {
        _medicines.addAll(fetchedMedicines);
        _filteredMedicines.addAll(fetchedMedicines);
        _loading = false;
      });
    } catch (e) {
      debugPrint("❌ Failed to load medicines: $e");
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HomeAppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  void _applyFilters() {
    final term = _searchTerm.toLowerCase().trim();
    
    setState(() {
      _filteredMedicines.clear();
      _filteredMedicines.addAll(_medicines.where((med) {
        final matchesSearch = term.isEmpty ||
            med.remedy.toLowerCase().contains(term) ||
            med.commonName.toLowerCase().contains(term) ||
            med.general.toLowerCase().contains(term);
            
        final matchesCategory = _selectedCategory == "all" ||
            med.sections.values
                .join(" ")
                .toLowerCase()
                .contains(_selectedCategory.toLowerCase());
                
        return matchesSearch && matchesCategory;
      }));
      
      _currentPage = 1; // Reset to first page after filtering
    });
  }

  Widget _buildBody() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Logged in as: ${_user?.email ?? 'User'}",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        SearchByName(
          onChanged: (value) {
            _searchTerm = value;
            _applyFilters();
          },
        ),
        
        const SizedBox(height: 16),
        
        CategoryDropdown(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onChanged: (value) {
            _selectedCategory = value ?? "all";
            _applyFilters();
          },
        ),
        
        const SizedBox(height: 16),
        const MedicinesHeader(
          title: 'All Medicines',
          description: 'Explore our comprehensive collection of homeopathic remedies. '
              'Find detailed information about symptoms, usage, and more.',
        ),
        
        const SizedBox(height: 12),
        Text(
          "Showing ${_paginatedMedicines.length} of ${_filteredMedicines.length} medicines",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        const SizedBox(height: 12),
        ..._paginatedMedicines.map((med) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: MedicineCard(
            key: ValueKey("${med.remedy}_${med.commonName}"),
            medicine: med,
          ),
        )),
        
        const SizedBox(height: 20),
        _buildPaginationBar(),
      ],
    );
  }

  Widget _buildPaginationBar() {
    if (_filteredMedicines.isEmpty) return const SizedBox();

    final totalPages = ((_filteredMedicines.length - 1) / _itemsPerPage).ceil();
    final showingFrom = ((_currentPage - 1) * _itemsPerPage) + 1;
    final showingTo = _currentPage * _itemsPerPage > _filteredMedicines.length
        ? _filteredMedicines.length
        : _currentPage * _itemsPerPage;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffeef1ff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Showing $showingFrom-$showingTo of ${_filteredMedicines.length}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 10,
            children: [
              _buildItemsPerPageDropdown(),
              _buildPageNavigation(totalPages),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildItemsPerPageDropdown() {
    return Row(
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
            value: _itemsPerPage,
            underline: const SizedBox(),
            items: [12, 24, 48, 96]
                .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _itemsPerPage = value;
                  _currentPage = 1;
                });
              }
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildPageNavigation(int totalPages) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage = 1) : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
        ),
        Text("Page $_currentPage of $totalPages"),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: _currentPage < totalPages ? () => setState(() => _currentPage = totalPages) : null,
        ),
      ],
    );
  }
}
