import 'package:dio/dio.dart';

class ApiService {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5001/homeo-backend/us-central1/api',
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
  ));

  Future<List<dynamic>> getMedicines() async {
    final response = await dio.get('/');
    return response.data['data']; // match your backend structure
  }
}
