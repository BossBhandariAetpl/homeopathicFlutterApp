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

abstract class BaseHomeScreen<T extends StatefulWidget> extends StatefulWidget {
  const BaseHomeScreen({super.key});
  @override
  BaseHomeScreenState<BaseHomeScreen<T>, T> createState();
}

abstract class BaseHomeScreenState<T extends BaseHomeScreen<W>, W extends StatefulWidget>
    extends State<W> {
  final ScrollController _scrollController = ScrollController();

  bool _loading = true;
  bool _isFetchingMore = false;
  bool _hasMore = true;

  int _currentPage = 1;
  final int _itemsPerPage = 12;

  String _searchTerm = "";
  String _selectedCategory = "all";

  final List<Medicine> _medicines = [];
  final List<Medicine> _filteredMedicines = [];

  static const List<String> _categories = AppStrings.categories;

  PreferredSizeWidget buildAppBar();

  @override
  void initState() {
    super.initState();
    _fetchNextPage();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isFetchingMore &&
          _hasMore) {
        _fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------- DATA LOADING ----------------
  Future<void> _fetchNextPage() async {
    _isFetchingMore = true;

    try {
      final fetched = await MedicineService().fetchMedicines(
        page: _currentPage,
        limit: _itemsPerPage,
      );

      if (!mounted) return;

      setState(() {
        _medicines.addAll(fetched);
        _applyFiltersInternal();

        _loading = false;
        _currentPage++;
        _isFetchingMore = false;

        if (fetched.length < _itemsPerPage) {
          _hasMore = false;
        }
      });
    } catch (e) {
      debugPrint("❌ Failed to load medicines: $e");
      _isFetchingMore = false;
    }
  }

  // ---------------- FILTERING ----------------
  void _applyFilters() {
    _currentPage = 1;
    _applyFiltersInternal();
  }

  void _applyFiltersInternal() {
    final term = _searchTerm.toLowerCase().trim();

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
  }

  // ---------------- UI ----------------
  Widget buildContent() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 16),

        SearchByName(
          onChanged: (value) {
            _searchTerm = value;
            setState(_applyFilters);
          },
        ),

        const SizedBox(height: 16),

        CategoryDropdown(
          categories: _categories,
          selectedCategory: _selectedCategory,
          onChanged: (value) {
            _selectedCategory = value ?? "all";
            setState(_applyFilters);
          },
        ),

        const SizedBox(height: 16),

        const MedicinesHeader(
          title: 'All Medicines',
          description:
              'Explore our comprehensive collection of homeopathic remedies. Find detailed information about symptoms, usage, and more.',
        ),

        const SizedBox(height: 12),

        Text(
          "Showing ${_filteredMedicines.length} medicines",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 12),

        ..._filteredMedicines.map(
          (med) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MedicineCard(
              key: ValueKey("${med.remedy}_${med.commonName}"),
              medicine: med,
            ),
          ),
        ),

        if (_isFetchingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: buildContent(),
    );
  }
}

// Concrete HomeScreen
class HomeScreen extends BaseHomeScreen<HomeScreen> {
  const HomeScreen({super.key});

  @override
  BaseHomeScreenState<BaseHomeScreen<HomeScreen>, HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends BaseHomeScreenState<BaseHomeScreen<HomeScreen>, HomeScreen> {
  @override
  PreferredSizeWidget buildAppBar() => const HomeAppBar();
}
