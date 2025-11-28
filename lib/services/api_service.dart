import 'package:dio/dio.dart';

class ApiService {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://10.0.2.2:5001/homeo-backend/us-central1/api',
  ));
}
