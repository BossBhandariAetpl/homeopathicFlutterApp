import '../../features/doctor/models/medicine.dart';
import 'api_service.dart';

class MedicineService {
  Future<List<Medicine>> fetchMedicines({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await ApiService().dio.get(
        '/medicines',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> rawList = response.data["data"];
      return rawList.map((item) => Medicine.fromJson(item)).toList();
    } catch (e) {
      print("❌ Error in fetchMedicines: $e");
      rethrow;
    }
  }
}
