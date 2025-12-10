// home_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../doctor/models/medicine.dart';
import '../../../core/services/medicine_service.dart';

// Widgets
import '../../../common/widgets/app_bar/home_app_bar.dart';
import '../../../common/widgets/cards/medicine_card.dart';
import '../../../common/widgets/headers/medicines_header.dart';
import '../../../common/widgets/search/category_dropdown.dart';
import '../../../common/widgets/search/search_by_name.dart';

// Constants
import '../../../constants/app_strings.dart';

// Base class with common functionality
abstract class BaseHomeScreen<T extends StatefulWidget> extends StatefulWidget {
  const BaseHomeScreen({super.key});

  @override
  BaseHomeScreenState<BaseHomeScreen<T>, T> createState();
}

abstract class BaseHomeScreenState<T extends BaseHomeScreen<W>, W extends StatefulWidget> extends State<W> {
  bool _loading = true;
  int _currentPage = 1;
  int _itemsPerPage = 12;
  String _searchTerm = "";
  String _selectedCategory = "all";
  final List<Medicine> _medicines = [];
  final List<Medicine> _filteredMedicines = [];
  static const List<String> _categories = AppStrings.categories;

  // Abstract method to be implemented by subclasses
  PreferredSizeWidget buildAppBar();

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  // Data Loading
  Future<void> _loadMedicines() async {
    try {
      final fetched = await MedicineService().fetchMedicines();
      if (mounted) {
        setState(() {
          _medicines.addAll(fetched);
          _filteredMedicines.addAll(fetched);
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint("❌ Failed to load medicines: $e");
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // Filtering Logic
  void _applyFilters() {
    final term = _searchTerm.toLowerCase().trim();

    setState(() {
      _filteredMedicines
        ..clear()
        ..addAll(
          _medicines.where((med) {
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
          }),
        );

      _currentPage = 1;
    });
  }

  // Pagination Getter
  List<Medicine> get _paginatedMedicines {
    final start = (_currentPage - 1) * _itemsPerPage;
    if (start >= _filteredMedicines.length) return [];

    final end = (_currentPage * _itemsPerPage).clamp(
      0,
      _filteredMedicines.length,
    );

    return _filteredMedicines.sublist(start, end);
  }

  // Build the main content (can be overridden by subclasses)
  Widget buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),

        // Search Input
        SearchByName(
          onChanged: (value) {
            _searchTerm = value;
            _applyFilters();
          },
        ),

        const SizedBox(height: 16),

        // Category Dropdown
        CategoryDropdown(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onChanged: (value) {
            _selectedCategory = value ?? "all";
            _applyFilters();
          },
        ),

        const SizedBox(height: 16),

        // Header
        const MedicinesHeader(
          title: 'All Medicines',
          description:
              'Explore our comprehensive collection of homeopathic remedies. Find detailed information about symptoms, usage, and more.',
        ),

        const SizedBox(height: 12),

        // Count Summary
        Text(
          "Showing ${_paginatedMedicines.length} of ${_filteredMedicines.length} medicines",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        // Medicine Cards List
        ..._paginatedMedicines.map(
          (med) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MedicineCard(
              key: ValueKey("${med.remedy}_${med.commonName}"),
              medicine: med,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Pagination Bar
        _buildPaginationBar(),
      ],
    );
  }

  // Pagination Bar
  Widget _buildPaginationBar() {
    if (_filteredMedicines.isEmpty) return const SizedBox();

    final totalPages = ((_filteredMedicines.length - 1) / _itemsPerPage).ceil();

    final showingFrom = ((_currentPage - 1) * _itemsPerPage) + 1;
    final showingTo = (_currentPage * _itemsPerPage).clamp(
      showingFrom,
      _filteredMedicines.length,
    );

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
            items: const [12, 24, 48, 96]
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
        _pageButton(
          icon: Icons.first_page,
          enabled: _currentPage > 1,
          action: () => _setPage(1),
        ),
        _pageButton(
          icon: Icons.chevron_left,
          enabled: _currentPage > 1,
          action: () => _setPage(_currentPage - 1),
        ),

        Text("Page $_currentPage of $totalPages"),

        _pageButton(
          icon: Icons.chevron_right,
          enabled: _currentPage < totalPages,
          action: () => _setPage(_currentPage + 1),
        ),
        _pageButton(
          icon: Icons.last_page,
          enabled: _currentPage < totalPages,
          action: () => _setPage(totalPages),
        ),
      ],
    );
  }

  // Helpers
  void _setPage(int page) {
    setState(() => _currentPage = page);
  }

  Widget _pageButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback action,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: enabled ? action : null,
      color: enabled ? Colors.blue : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : buildContent(),
    );
  }
}

// Regular HomeScreen implementation
class HomeScreen extends BaseHomeScreen<HomeScreen> {
  const HomeScreen({super.key});

  @override
  BaseHomeScreenState<BaseHomeScreen<HomeScreen>, HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseHomeScreenState<BaseHomeScreen<HomeScreen>, HomeScreen> {
  @override
  PreferredSizeWidget buildAppBar() {
    return const HomeAppBar();
  }
}