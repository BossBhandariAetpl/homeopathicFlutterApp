import '../../features/doctor/models/medicine.dart';
import 'api_service.dart';

class MedicineService {
  Future<List<Medicine>> fetchMedicines() async {
    try {
      final response = await ApiService().dio.get('/medicines');

      // Extract the real list
      final List<dynamic> rawList = response.data["data"];

      // Convert to Model
      return rawList.map((item) => Medicine.fromJson(item)).toList();
    } catch (e) {
      print("❌ Error in fetchMedicines: $e");
      rethrow;
    }
  }
}
