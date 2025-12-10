import 'package:flutter/material.dart';

class ReceptionistNavbar extends StatelessWidget implements PreferredSizeWidget {
  const ReceptionistNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Receptionist Dashboard'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline),
          onPressed: () {
            // Navigate to receptionist profile
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
