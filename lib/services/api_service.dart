import 'package:dio/dio.dart';

class ApiService {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api-f7x6ruhiiq-uc.a.run.app',
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
  ));

  Future<List<dynamic>> getMedicines() async {
    final response = await dio.get('/');
    return response.data['data']; // match your backend structure
  }
}
