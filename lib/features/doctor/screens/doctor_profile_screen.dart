import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/auth_service.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fbUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        titleSpacing: 0,
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fbUser != null ? AuthService().getUserProfile(fbUser.uid) : Future.value(null),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final displayName = (data != null && (data['name'] as String?)?.trim().isNotEmpty == true)
              ? (data['name'] as String)
              : (fbUser?.displayName?.trim().isNotEmpty == true ? fbUser!.displayName! : 'Doctor');
          final email = (data != null && (data['email'] as String?)?.trim().isNotEmpty == true)
              ? (data['email'] as String)
              : (fbUser?.email ?? 'unknown@example.com');
          final role = (() {
            final roles = data?['roles'];
            if (roles is List && roles.isNotEmpty && roles.first is String) return roles.first as String;
            return 'Doctor';
          })();

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text('← Back', style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
                  ),
                ),
                const Text(
                  'My Profile',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manage your account information',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),

                // Main two-column area (responsive)
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: _ProfileCard(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 44,
                                backgroundColor: const Color(0xFF5B86E5),
                                child: Text(
                                  displayName.isNotEmpty ? displayName[0].toUpperCase() : 'D',
                                  style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                displayName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5FF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFFB9E2FF)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified_user, color: Colors.blue, size: 16),
                                    const SizedBox(width: 6),
                                    Text(role, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            _ProfileCard(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Profile Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                        SizedBox(height: 14),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: const Color(0xFF2F6BFF),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      // TODO: Implement edit profile
                                    },
                                    child: const Text('Edit Profile'),
                                  ),
                                ],
                              ),
                            ),
                            _ProfileCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _InfoRow(label: 'Email Address', value: email, trailing: const _VerifiedChip()),
                                  const SizedBox(height: 10),
                                  _InfoRow(label: 'Name', value: displayName),
                                  const SizedBox(height: 10),
                                  _InfoRow(label: 'Account Type', value: role),
                                ],
                              ),
                            ),
                            _ProfileCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Account Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 12),
                                  _ActionRow(
                                    icon: Icons.settings,
                                    label: 'Settings',
                                    onTap: () {
                                      // TODO: Implement settings page
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  _ActionRow(
                                    icon: Icons.logout,
                                    label: 'Sign Out',
                                    danger: true,
                                    onTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      if (context.mounted) {
                                        Navigator.of(context).popUntil((route) => route.isFirst);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 44,
                              backgroundColor: const Color(0xFF5B86E5),
                              child: Text(
                                displayName.isNotEmpty ? displayName[0].toUpperCase() : 'D',
                                style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              displayName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5FF),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFB9E2FF)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.verified_user, color: Colors.blue, size: 16),
                                  const SizedBox(width: 6),
                                  Text(role, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          _ProfileCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Profile Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                      SizedBox(height: 14),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF2F6BFF),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () {
                                    // TODO: Implement edit profile
                                  },
                                  child: const Text('Edit Profile'),
                                ),
                              ],
                            ),
                          ),
                          _ProfileCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _InfoRow(label: 'Email Address', value: email, trailing: const _VerifiedChip()),
                                const SizedBox(height: 10),
                                _InfoRow(label: 'Name', value: displayName),
                                const SizedBox(height: 10),
                                _InfoRow(label: 'Account Type', value: role),
                              ],
                            ),
                          ),
                          _ProfileCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Account Actions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 12),
                                _ActionRow(
                                  icon: Icons.settings,
                                  label: 'Settings',
                                  onTap: () {
                                    // TODO: Implement settings page
                                  },
                                ),
                                const SizedBox(height: 8),
                                _ActionRow(
                                  icon: Icons.logout,
                                  label: 'Sign Out',
                                  danger: true,
                                  onTap: () async {
                                    await FirebaseAuth.instance.signOut();
                                    if (context.mounted) {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          );
        },
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Widget child;
  const _ProfileCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE6E9EF)),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  const _InfoRow({required this.label, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FFF1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBDEFD1)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Colors.green, size: 16),
          SizedBox(width: 4),
          Text('Verified', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;
  const _ActionRow({required this.icon, required this.label, required this.onTap, this.danger = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: danger ? const Color(0xFFFFF1F1) : const Color(0xFFF8FAFF),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: danger ? Colors.red : Colors.black54),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: danger ? Colors.red : Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.arrow_right, color: danger ? Colors.red : Colors.black45),
            ],
          ),
        ),
      ),
    );
  }
}
