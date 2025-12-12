import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_homeopathy_app/features/auth/screens/login_screen.dart';
import '../../../../core/services/auth_service.dart';
import '../widgets/receptionist/receptionist_navbar.dart';

class ReceptionistProfileScreen extends StatelessWidget {
  const ReceptionistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fbUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: ReceptionistNavbar(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fbUser != null ? AuthService().getUserProfile(fbUser.uid) : Future.value(null),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final displayName = (data != null && (data['name'] as String?)?.trim().isNotEmpty == true)
              ? (data['name'] as String)
              : (fbUser?.displayName?.trim().isNotEmpty == true ? fbUser!.displayName! : 'Receptionist');
          final email = (data != null && (data['email'] as String?)?.trim().isNotEmpty == true)
              ? (data['email'] as String)
              : (fbUser?.email ?? 'unknown@example.com');
          final role = 'Receptionist';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Text(
                    '← Back',
                    style: TextStyle(color: Colors.blueAccent, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
                    if (constraints.maxWidth >= 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side - Profile card
                          Expanded(
                            flex: 1,
                            child: _buildProfileCard(
                              context,
                              displayName,
                              email,
                              role,
                              fbUser?.emailVerified ?? false,
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right side - Info and actions
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                _buildInfoCard(context, displayName, email, role),
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
                          _buildProfileCard(
                            context,
                            displayName,
                            email,
                            role,
                            fbUser?.emailVerified ?? false,
                          ),
                          const SizedBox(height: 20),
                          _buildInfoCard(context, displayName, email, role),
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

  Widget _buildProfileCard(
    BuildContext context,
    String displayName,
    String email,
    String role,
    bool isEmailVerified,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'R',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                role,
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email not verified',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              // TODO: Implement email verification
                            },
                            child: const Text(
                              'Tap to resend verification email',
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

  Widget _buildInfoCard(
    BuildContext context,
    String displayName,
    String email,
    String role,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow('Email Address', email, isVerified: true),
            const SizedBox(height: 16),
            _buildInfoRow('Name', displayName),
            const SizedBox(height: 16),
            _buildInfoRow('Role', role),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
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
            const Divider(height: 24),
            _buildActionRow(
              context,
              icon: Icons.logout,
              title: 'Sign Out',
              isSignOut: true,
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
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
                        content: Text('Error signing out: ${e.toString()}'),
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
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isVerified = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isVerified) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: const Text(
                    'Verified',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSignOut ? Colors.red : Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSignOut ? Colors.red : Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}