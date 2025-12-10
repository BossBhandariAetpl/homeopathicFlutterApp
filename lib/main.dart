import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'features/auth/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart' as auth_screens;
import 'features/doctor/screens/doctor_home_screen.dart';
import 'features/patient/screens/patient_home_screen.dart';
import 'features/receptionist/screens/receptionist_home_screen.dart';
import 'core/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Homeopathy App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const StartupWrapper(),
    );
  }
}

class StartupWrapper extends StatelessWidget {
  const StartupWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          // Show login screen when not authenticated
          return const auth_screens.LoginScreen();
        }

        // 🔥 Logged in → load correct role screen
        return FutureBuilder<String?>(
          future: AuthService().getUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (!roleSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data?.toLowerCase();

            switch (role) {
              case 'doctor':
                return const DoctorHomeScreen();
              case 'patient':
                return const PatientHomeScreen();
              case 'receptionist':
                return const ReceptionistHomeScreen();
              default:
                // Fallback to generic home screen if role is not recognized
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}
