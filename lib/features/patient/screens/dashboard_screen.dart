import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/auth_service.dart';
import '../widgets/patient/patient_navbar.dart';

class DashboardScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildActionCards(),
            const SizedBox(height: 32),
            _buildAboutAccount(),
            const SizedBox(height: 32),
            _buildGettingStarted(),
            const SizedBox(height: 16),
            _buildEmailVerificationBanner(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final user = _auth.currentUser;
    
    return FutureBuilder<Map<String, dynamic>?>(
      future: user != null ? _authService.getUserProfile(user.uid) : Future.value(null),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final displayName = (data != null && (data['name'] as String?)?.trim().isNotEmpty == true)
            ? (data['name'] as String)
            : (user?.displayName?.trim().isNotEmpty == true ? user!.displayName! : 'User');
            
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, $displayName!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your health journey starts here',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        );
      },
    );
  }

  

  Widget _buildActionCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 600;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isWide ? 3 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isWide ? 1 : 1.5,
          children: [
            _buildActionCard(
              icon: FontAwesomeIcons.pills,
              title: 'Browse Medicines',
              description: 'Explore our wide range of homeopathic medicines',
              color: Colors.blue,
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.person_outline,
              title: 'My Profile',
              description: 'View and update your personal information',
              color: Colors.purple,
              onTap: () {},
            ),
            _buildActionCard(
              icon: Icons.support_agent_outlined,
              title: 'Contact Support',
              description: 'Get help from our support team',
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 32, color: color),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View Details',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 16, color: color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutAccount() {
    final user = _auth.currentUser;
    
    return FutureBuilder<Map<String, dynamic>?>(
      future: user != null ? _authService.getUserProfile(user.uid) : Future.value(null),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final email = (data != null && (data['email'] as String?)?.trim().isNotEmpty == true)
            ? (data['email'] as String)
            : (user?.email ?? 'Not available');
            
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Your Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const Divider(height: 24),
                _buildInfoRow(Icons.person_outline, 'Patient Account'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.email_outlined, 'Email: $email'),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.lock_outline, 'Secure & Private'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildGettingStarted() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Getting Started',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            _buildStep(1, 'Complete Your Profile'),
            _buildStep(2, 'Browse Medicines'),
            _buildStep(3, 'Contact Support'),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.teal,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailVerificationBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Please Verify Your Email',
              style: TextStyle(
                color: Colors.orange[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement email verification resend
            },
            child: const Text('Resend Email'),
          ),
        ],
      ),
    );
  }
}
