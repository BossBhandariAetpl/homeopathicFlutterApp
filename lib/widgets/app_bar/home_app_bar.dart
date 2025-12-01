import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final TextEditingController? searchController;

  @override
  final Size preferredSize;

  const HomeAppBar({
    super.key,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchController,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  bool _isSearching = false;
  final FocusNode _searchFocusNode = FocusNode();
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        widget.onSearchChanged?.call('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search medicines...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[400],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                isDense: true,
              ),
              onChanged: widget.onSearchChanged,
              onSubmitted: (_) {
                widget.onSearchSubmitted?.call();
                _searchFocusNode.unfocus();
              },
              textInputAction: TextInputAction.search,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icons/logo/Logo.png',
                  height: 30,
                  width: 30,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.medical_services, size: 30),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                      ).createShader(bounds),
                      child: Text(
                        "Homeopathic Clinic",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'MANAGEMENT SYSTEM',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _toggleSearch,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => (context.findAncestorStateOfType<_HomeAppBarState>()?.widget as HomeAppBar).preferredSize;
}
