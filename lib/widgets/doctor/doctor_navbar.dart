import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_homeopathy_app/widgets/search/doctor_patients_screen.dart';

import '../../screens/doctor_home_screen.dart';
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
      titleSpacing: 0,

      // -----------------------------
      //   LEFT SIDE: LOGO + TITLE 
      // -----------------------------
      title: Row(
        children: [
          const SizedBox(width: 12),

          // App Logo
          Image.asset("assets/icons/logo/Logo.png", height: 45),

          const SizedBox(width: 10),

          // Title text column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Homeopathic Clinic",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.teal,
                ),
              ),
              Text(
                "MANAGEMENT SYSTEM",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),

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
                  MaterialPageRoute(builder: (_) => const DoctorPatientsScreen()),
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
            const PopupMenuItem(
              value: 998,
              enabled: false,
              child: Text(
                "User",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const PopupMenuItem(
              value: 997,
              enabled: false,
              child: ListTile(
                leading: CircleAvatar(radius: 14, child: Text("👨‍⚕️")),
                title: Text("Current User: Doctor"),
                horizontalTitleGap: 0,
              ),
            ),

            const PopupMenuItem(
              value: 10,
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.black87),
                title: Text("My Profile"),
              ),
            ),

            PopupMenuItem(
              value: 11,
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red.shade700),
                title: const Text("Sign Out"),
              ),
            ),
          ],
        ),

        const SizedBox(width: 6),
      ],
    );
  }
}
