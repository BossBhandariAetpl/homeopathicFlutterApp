import 'package:flutter/material.dart';
import '../widgets/doctor/doctor_navbar.dart';

class PatientManagementScreen extends StatelessWidget {
  const PatientManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FF),
      appBar: DoctorNavbar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0E7A6D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient Management',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Manage patient records and information',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Cards grid
            LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;
                final crossAxisCount = maxW >= 1100 ? 3 : (maxW >= 740 ? 3 : 1);
                final cardWidth = (maxW - (crossAxisCount - 1) * 16) / crossAxisCount;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ActionCard(
                      width: cardWidth,
                      icon: Icons.add_box_outlined,
                      iconBg: const Color(0xFFE6F0FF),
                      title: 'Add New Patient',
                      subtitle: 'Register a new patient and create their profile.',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const _AddPatientPlaceholder()),
                        );
                      },
                    ),
                    _ActionCard(
                      width: cardWidth,
                      icon: Icons.people_outline,
                      iconBg: const Color(0xFFFFF1E6),
                      title: 'All Patients',
                      subtitle: 'View and search all patients by name, contact, or email.',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const _AllPatientsPlaceholder()),
                        );
                      },
                    ),
                    _ActionCard(
                      width: cardWidth,
                      icon: Icons.medical_services_outlined,
                      iconBg: const Color(0xFFE8FFF1),
                      title: 'Create Prescription',
                      subtitle: 'Start a new prescription for a patient.',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const _CreatePrescriptionPlaceholder()),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _ActionCard({
    required this.width,
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6E9EF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AddPatientPlaceholder extends StatelessWidget {
  const _AddPatientPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Patient')),
      body: const Center(child: Text('Add Patient screen - TODO')),
    );
  }
}

class _CreatePrescriptionPlaceholder extends StatelessWidget {
  const _CreatePrescriptionPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Prescription')),
      body: const Center(child: Text('Create Prescription screen - TODO')),
    );
  }
}

class _AllPatientsPlaceholder extends StatelessWidget {
  const _AllPatientsPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Patients')),
      body: const Center(child: Text('All Patients screen - TODO')),
    );
  }
}
