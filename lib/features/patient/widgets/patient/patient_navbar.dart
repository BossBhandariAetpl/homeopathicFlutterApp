import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_homeopathy_app/features/auth/screens/login_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/app_title_logo.dart';
import '../../screens/patient_home_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/patient_profile_screen.dart';

class PatientNavbar extends StatelessWidget implements PreferredSizeWidget {
  PatientNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      title: const AppTitleLogo(),
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) async {
            switch (value) {
              // Navigation items
              case 1: // Medicines
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
                  );
                }
                break;
              case 2: // Dashboard
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                }
                break;
              case 3: // Medicines
                // Add navigation to medicines screen later
                break;
              case 4: // Appointments
                // Add navigation to appointments screen later
                break;
              
              // User menu
              case 10: // Profile
                // Open profile later
                break;

              case 11: // Logout
                await _auth.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
                break;
            }
          },
          itemBuilder: (context) => [
            // Navigation Group
            const PopupMenuItem(
              value: 999,
              enabled: false,
              child: Text(
                "Navigation",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const PopupMenuItem(
              value: 1,
              child: ListTile(
                leading: Icon(Icons.dashboard, color: Colors.blue),
                title: Text("Medicines"),
                horizontalTitleGap: 0,
              ),
            ),

            const PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: Icon(Icons.medication, color: Colors.teal),
                title: Text("Dashboard"),
                horizontalTitleGap: 0,
              ),
            ),

            const PopupMenuItem(
              value: 3,
              child: ListTile(
                leading: Icon(Icons.calendar_month, color: Colors.purple),
                title: Text("Appointments"),
                horizontalTitleGap: 0,
              ),
            ),

            const PopupMenuDivider(),

            // User Profile Group
            PopupMenuItem(
              enabled: false,
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: const Text(
                    "Patient",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                  children: [
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(radius: 14, child: Text("👤")),
                      title: Text("Signed in as: Patient"),
                      horizontalTitleGap: 0,
                      enabled: false,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person, color: Colors.black87),
                      title: const Text("My Profile"),
                      onTap: () {
                        Navigator.pop(context); // close popup menu
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PatientProfileScreen(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.logout, color: Colors.red.shade700),
                      title: const Text("Sign Out"),
                      onTap: () async {
                        Navigator.pop(context); // close popup menu
                        try {
                          await _auth.signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error signing out: ${e.toString()}',
                                ),
                                duration: const Duration(seconds: 5),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 6),
      ],
    );
  }
}