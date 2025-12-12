import 'package:flutter/material.dart';

import '../../auth/screens/home_screen.dart';
import '../widgets/receptionist/receptionist_navbar.dart';

class ReceptionistHomeScreen extends BaseHomeScreen<ReceptionistHomeScreen> {
  const ReceptionistHomeScreen({super.key});

  @override
  BaseHomeScreenState<BaseHomeScreen<ReceptionistHomeScreen>, ReceptionistHomeScreen> 
    createState() => _ReceptionistHomeScreenState();
}

class _ReceptionistHomeScreenState 
    extends BaseHomeScreenState<BaseHomeScreen<ReceptionistHomeScreen>, ReceptionistHomeScreen> {
  
  @override
  PreferredSizeWidget buildAppBar() {
    return ReceptionistNavbar();
  }

  @override
  Widget buildContent() {
    return super.buildContent();
  }
}
