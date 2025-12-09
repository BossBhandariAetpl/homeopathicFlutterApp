import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
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

class _AddPatientPlaceholder extends StatefulWidget {
  const _AddPatientPlaceholder();

  @override
  _AddPatientPlaceholderState createState() => _AddPatientPlaceholderState();
}

class _AddPatientPlaceholderState extends State<_AddPatientPlaceholder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();
  
  String? _selectedGender;
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final _authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorName();
  }

  Future<void> _fetchDoctorName() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final profile = await _authService.getUserProfile(user.uid);
        final name = profile?['name'] ?? user.displayName ?? 'Doctor';
        setState(() {
          _doctorNameController.text = '$name (Self)';
          _isLoading = false;
        });
      } else {
        setState(() {
          _doctorNameController.text = 'Doctor (Self)';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _doctorNameController.text = 'Doctor (Self)';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _medicalHistoryController.dispose();
    _doctorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Add New Patient'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Full Name',
                hint: 'Enter patient name',
                controller: _nameController,
                isRequired: true,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Contact Number',
                      hint: '10-digit number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Email',
                      hint: 'email@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Age',
                      hint: 'Age in years',
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            hintText: 'Select gender',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          items: _genders.map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select gender';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _isLoading 
                ? const CircularProgressIndicator()
                : _buildTextField(
                    label: 'Assigned Doctor',
                    hint: 'Loading...',
                    enabled: false,
                    controller: _doctorNameController,
                  ),
              const SizedBox(height: 16),
              const Text(
                'Address',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Medical History',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),
              const SizedBox(height: 4),
              TextFormField(
                controller: _medicalHistoryController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter medical history, allergies, previous conditions, etc.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Handle form submission
                          print('Form submitted');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E9B95),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Add Patient'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  if (keyboardType == TextInputType.phone && value.length != 10) {
                    return 'Please enter a valid 10-digit number';
                  }
                  if (keyboardType == TextInputType.emailAddress &&
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}

class _Medicine {
  final String id;
  final TextEditingController nameController;
  final TextEditingController dosageController;
  final TextEditingController frequencyController;
  final TextEditingController durationController;
  final TextEditingController instructionsController;

  _Medicine()
      : id = DateTime.now().millisecondsSinceEpoch.toString(),
        nameController = TextEditingController(),
        dosageController = TextEditingController(),
        frequencyController = TextEditingController(),
        durationController = TextEditingController(),
        instructionsController = TextEditingController();

  void dispose() {
    nameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}

class _CreatePrescriptionPlaceholder extends StatefulWidget {
  const _CreatePrescriptionPlaceholder();

  @override
  _CreatePrescriptionPlaceholderState createState() => _CreatePrescriptionPlaceholderState();
}

class _CreatePrescriptionPlaceholderState extends State<_CreatePrescriptionPlaceholder> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final List<_Medicine> _medicines = [];
  String? _selectedPatient;
  final List<Map<String, String>> _patients = [];
  final _authService = AuthService();
  String _doctorName = 'Loading...';
  String _doctorEmail = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctorInfo();
    _fetchPatients();
    // Add first medicine by default
    _addMedicine();
  }

  Future<void> _fetchDoctorInfo() async {
    try {
      final user = _authService.currentUser;
      if (user != null) {
        final profile = await _authService.getUserProfile(user.uid);
        setState(() {
          _doctorName = profile?['name'] ?? user.displayName ?? 'Doctor';
          _doctorEmail = user.email ?? 'No email';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _doctorName = 'Doctor';
        _doctorEmail = 'Error loading email';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchPatients() async {
    // TODO: Replace with actual patient fetching logic
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _patients.addAll([
          {'id': '1', 'name': 'John Doe'},
          {'id': '2', 'name': 'Jane Smith'},
          {'id': '3', 'name': 'Robert Johnson'},
        ]);
      });
    }
  }

  void _addMedicine() {
    setState(() {
      _medicines.add(_Medicine());
    });
  }

  void _removeMedicine(String id) {
    if (_medicines.length <= 1) return; // Keep at least one medicine
    
    setState(() {
      final index = _medicines.indexWhere((m) => m.id == id);
      if (index != -1) {
        _medicines[index].dispose();
        _medicines.removeAt(index);
      }
    });
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _notesController.dispose();
    for (var medicine in _medicines) {
      medicine.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Create Prescription'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Information
                    _buildSectionHeader('Doctor Information'),
                    _buildInfoBox([
                      'Name: $_doctorName',
                      'Email: $_doctorEmail',
                    ]),
                    const SizedBox(height: 24),

                    // Patient Information
                    _buildSectionHeader('Patient Information'),
                    _buildPatientDropdown(),
                    const SizedBox(height: 16),

                    // Diagnosis
                    _buildSectionHeader('Diagnosis'),
                    TextFormField(
                      controller: _diagnosisController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter diagnosis...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes / Advice
                    _buildSectionHeader('Notes / Advice'),
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Additional instructions...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Medicines
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('Medicines'),
                        TextButton.icon(
                          onPressed: _addMedicine,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Medicine'),
                        ),
                      ],
                    ),
                    ..._buildMedicineForms(),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // TODO: Handle form submission
                                print('Prescription submitted');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0E9B95),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Save Prescription'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoBox(List<String> infoLines) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: infoLines
            .map((line) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(line),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPatientDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPatient,
      decoration: InputDecoration(
        labelText: 'Select Patient',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      hint: const Text('-- Choose patient --'),
      items: _patients.map((patient) {
        return DropdownMenuItem(
          value: patient['id'],
          child: Text(patient['name'] ?? ''),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedPatient = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a patient';
        }
        return null;
      },
    );
  }

  List<Widget> _buildMedicineForms() {
    return _medicines.map((medicine) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Medicine ${_medicines.indexOf(medicine) + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (_medicines.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _removeMedicine(medicine.id),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: medicine.nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Medicine name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter medicine name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: medicine.dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage',
                        hintText: 'e.g., 30C',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: medicine.frequencyController,
                      decoration: const InputDecoration(
                        labelText: 'Frequency',
                        hintText: 'e.g., 3x daily',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: medicine.durationController,
                      decoration: const InputDecoration(
                        labelText: 'Duration',
                        hintText: 'e.g., 7 days',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: medicine.instructionsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Instructions',
                  hintText: 'Special instructions (e.g., before meals)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _AllPatientsPlaceholder extends StatefulWidget {
  const _AllPatientsPlaceholder();

  @override
  _AllPatientsPlaceholderState createState() => _AllPatientsPlaceholderState();
}

class _AllPatientsPlaceholderState extends State<_AllPatientsPlaceholder> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedGender;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Patients'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Filter Row
            Row(
              children: [
                // Search Card
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: TextFormField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search patients by name, contact, or email...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onChanged: (value) {
                        // TODO: Implement search functionality
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Gender Filter Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        hint: const Text('Filter by Gender:'),
                        items: <String>['Male', 'Female', 'Other']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                            // TODO: Implement gender filter
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // No Patients Found Message
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Patients Found',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try adjusting your search or add a new patient',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
