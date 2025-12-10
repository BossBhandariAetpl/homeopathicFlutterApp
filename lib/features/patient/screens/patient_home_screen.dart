import 'package:flutter/material.dart';

import '../../auth/screens/home_screen.dart';
import '../widgets/patient/patient_navbar.dart';

class PatientHomeScreen extends BaseHomeScreen<PatientHomeScreen> {
  const PatientHomeScreen({super.key});

  @override
  BaseHomeScreenState<BaseHomeScreen<PatientHomeScreen>, PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends BaseHomeScreenState<BaseHomeScreen<PatientHomeScreen>, PatientHomeScreen> {
  @override
  PreferredSizeWidget buildAppBar() {
    return const PatientNavbar();
  }

  @override
  Widget buildContent() {
    return super.buildContent(); // Use the medicine list from BaseHomeScreen
  }
}
