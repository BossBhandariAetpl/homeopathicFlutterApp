import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common/widgets/app_title_logo.dart';
import '../../screens/doctor_home_screen.dart';
import '../../screens/doctor_profile_screen.dart';
import '../../../receptionist/screens/patient_management_screen.dart';
// import '../../screens/doctor_appointments_screen.dart';  // create later

class DoctorNavbar extends StatelessWidget implements PreferredSizeWidget {
  DoctorNavbar({super.key});

  final _auth = FirebaseAuth.instance;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      // -----------------------------
      //   LEFT SIDE: LOGO + TITLE 
      // -----------------------------
      title: const AppTitleLogo(),

      // -----------------------------
      //   RIGHT SIDE: 3-LINE MENU
      // -----------------------------
      actions: [
        PopupMenuButton<int>(
          icon: const Icon(Icons.menu, color: Colors.black87, size: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onSelected: (value) async {
            switch (value) {

              // -----------------
              // Navigation items
              // -----------------
              case 1: // Medicines
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
                );
                break;

              case 2: // Patients
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PatientManagementScreen()),
                );
                break;

              case 3: // Appointments (create later)
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (_) => const DoctorAppointmentsScreen()),
                // );
                break;

              // -----------------
              // User menu
              // -----------------
              case 10: // Profile
                // open profile later
                break;

              case 11: // Logout
                await _auth.signOut();
                break;
            }
          },

          itemBuilder: (context) => [

            // --------------------------
            //  NAVIGATION GROUP
            // --------------------------
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
                leading: Icon(Icons.medication, color: Colors.teal),
                title: Text("Medicines"),
                horizontalTitleGap: 0,
              ),
            ),

            const PopupMenuItem(
              value: 2,
              child: ListTile(
                leading: Icon(Icons.people, color: Colors.indigo),
                title: Text("Patients"),
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

            // --------------------------
            //  USER PROFILE GROUP
            // --------------------------
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
                    "Doctor",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                  children: [
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(radius: 14, child: Text("👨‍⚕️")),
                      title: Text("Signed in as: Doctor"),
                      horizontalTitleGap: 0,
                      enabled: false,
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.person, color: Colors.black87),
                      title: const Text("My Profile"),
                      onTap: () {
                        Navigator.pop(context); // close popup menu
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DoctorProfileScreen()),
                        );
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.logout, color: Colors.red.shade700),
                      title: const Text("Sign Out"),
                      onTap: () async {
                        Navigator.pop(context); // close popup menu
                        await _auth.signOut();
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
