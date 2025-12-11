import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_homeopathy_app/features/patient/widgets/patient/patient_navbar.dart';
import '../../../../core/services/auth_service.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fbUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: PatientNavbar(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fbUser != null ? AuthService().getUserProfile(fbUser.uid) : Future.value(null),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final displayName = (data != null && (data['name'] as String?)?.trim().isNotEmpty == true)
              ? (data['name'] as String)
              : (fbUser?.displayName?.trim().isNotEmpty == true ? fbUser!.displayName! : 'User');
          final email = (data != null && (data['email'] as String?)?.trim().isNotEmpty == true)
              ? (data['email'] as String)
              : (fbUser?.email ?? 'unknown@example.com');
          
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Text('← Back', style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
                ),
                const SizedBox(height: 16),
                const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Manage your account information',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                
                // Main content
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;
                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side - Profile card
                          Expanded(
                            flex: 1,
                            child: _buildProfileCard(context, displayName, email, fbUser?.emailVerified ?? false),
                          ),
                          const SizedBox(width: 20),
                          // Right side - Info and actions
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildInfoCard(context, displayName, email),
                                const SizedBox(height: 20),
                                _buildActionsCard(context),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          _buildProfileCard(context, displayName, email, fbUser?.emailVerified ?? false),
                          const SizedBox(height: 20),
                          _buildInfoCard(context, displayName, email),
                          const SizedBox(height: 20),
                          _buildActionsCard(context),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String displayName, String email, bool isEmailVerified) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              child: Center(
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 40, color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Patient',
                style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            if (!isEmailVerified) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email not verified',
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Implement resend verification email
                            },
                            child: const Text(
                              'Resend verification email',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String displayName, String email) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const Divider(height: 24),
            _buildInfoRow('Email Address', email),
            const SizedBox(height: 16),
            _buildInfoRow('Name', displayName),
            const SizedBox(height: 16),
            _buildInfoRow('Account Type', 'Patient'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement edit profile
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Edit Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            const Divider(height: 24),
            _buildActionRow(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                // TODO: Navigate to settings
              },
            ),
            const Divider(thickness: 1, height: 40),
            _buildActionRow(
              context,
              icon: Icons.logout,
              title: 'Sign Out',
              isSignOut: true,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context, 
                    '/welcome', 
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
        const Text(':', style: TextStyle(color: Colors.grey)),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool isSignOut = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: isSignOut ? Colors.red : Colors.grey, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: isSignOut ? Colors.red : Colors.black87,
                fontWeight: isSignOut ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (!isSignOut)
              const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
