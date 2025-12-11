import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features/auth/screens/login_screen.dart';
import '../../../features/auth/screens/signup_screen.dart';
import '../app_title_logo.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _showProfileMenu(BuildContext context) async {
    final button = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final selected = await showMenu<String>(
      context: context,
      position: position,
      items: const [
        PopupMenuItem(value: 'signin', child: Text('Sign In')),
        PopupMenuItem(value: 'signup', child: Text('Sign Up')),
      ],
    );

    if (!context.mounted) return;

    switch (selected) {
      case 'signin':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
        break;
      case 'signup':
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SignUpScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: const AppTitleLogo(), // Use the new component
      actions: [_buildProfileButton(context)],
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _showProfileMenu(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
