import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/medicine.dart';
import '../services/medicine_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;
  List<Medicine> medicines = [];

  @override
  void initState() {
    super.initState();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    try {
      medicines = await MedicineService().fetchMedicines();
    } catch (e) {
      print("❌ Failed loading medicines: $e");
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: loading 
        ? const Center(child: CircularProgressIndicator())
        : _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
          ),
        ),
      ),
      title: Text("Homeopathic Clinic", 
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
    );
  }

  Widget _body() {
  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: medicines.length + 2,
    itemBuilder: (context, index) {
      
      // Title
      if (index == 0) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All Medicines",
              style: GoogleFonts.poppins(
                  fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
          ],
        );
      }

      // Count text
      if (index == 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Showing ${medicines.length} medicine(s)",
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
          ],
        );
      }

      // Medicine card
      return _medicineCard(medicines[index - 2]);
    },
  );
}





  Widget _medicineCard(Medicine m) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            m.remedy.isNotEmpty ? m.remedy.toUpperCase() : "Unknown Remedy",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          Text(
            m.commonName.isNotEmpty ? m.commonName : "No Common Name",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.green,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // ❗ IMPORTANT: REMOVE Expanded
          Container(
            constraints: const BoxConstraints(maxHeight: 120),
            child: SingleChildScrollView(
              child: Text(
                m.general.isNotEmpty ? m.general : "No description available.",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("View Details"),
            ),
          ),
        ],
      ),
    ),
  );
}


}
