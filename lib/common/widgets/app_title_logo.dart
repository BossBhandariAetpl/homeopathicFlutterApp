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
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            'Homeopathic Clinic',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'MANAGEMENT SYSTEM',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}