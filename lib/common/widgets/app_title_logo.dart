// lib/common/widgets/app_title_logo.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTitleLogo extends StatelessWidget {
  const AppTitleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAppLogo(),
        const SizedBox(width: 12),
        _buildAppTitle(),
      ],
    );
  }

  Widget _buildAppLogo() {
    return Image.asset(
      'assets/icons/logo/Logo.png',
      height: 30,
      width: 30,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.medical_services, size: 30),
    );
  }

  Widget _buildAppTitle() {
    return Column(
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
    );
  }
}