import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/app_title_logo.dart';

class PatientNavbar extends StatelessWidget implements PreferredSizeWidget {
  const PatientNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error signing out')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      title: const AppTitleLogo(), // Using the common AppTitleLogo
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.black87),
          tooltip: 'Profile',
          onPressed: () {
            // Navigate to patient profile
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.red),
          tooltip: 'Logout',
          onPressed: () => _handleSignOut(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}