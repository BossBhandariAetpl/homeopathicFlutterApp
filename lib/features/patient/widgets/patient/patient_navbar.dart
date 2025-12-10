import 'package:flutter/material.dart';

class PatientNavbar extends StatelessWidget implements PreferredSizeWidget {
  const PatientNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Patient Home'),
      centerTitle: true,
      // Add any patient-specific app bar items here
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            // Navigate to patient profile
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
