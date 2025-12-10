// doctor_home_screen.dart
import 'package:flutter/material.dart';

import '../../auth/screens/home_screen.dart';
import '../widgets/doctor/doctor_navbar.dart';

class DoctorHomeScreen extends BaseHomeScreen<DoctorHomeScreen> {
  const DoctorHomeScreen({super.key});

  @override
  BaseHomeScreenState<BaseHomeScreen<DoctorHomeScreen>, DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends BaseHomeScreenState<BaseHomeScreen<DoctorHomeScreen>, DoctorHomeScreen> {
  @override
  PreferredSizeWidget buildAppBar() {
    return DoctorNavbar();
  }

  // You can override buildContent() here if you need custom content for doctor's home screen
  // Otherwise, it will use the default implementation from BaseHomeScreen
}