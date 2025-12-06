import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api-f7x6ruhiiq-uc.a.run.app',
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
  ));

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return credential.user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<String?> getUserRole(String uid) async {
    try {
      final response = await dio.get("/users/$uid");
      final data = response.data["data"];

      if (data != null && data["roles"] != null) {
        return data["roles"][0];
      }
      return null;
    } catch (e) {
      throw "Failed to get user role: $e";
    }
  }

  /// Helper to get current logged-in Firebase user
  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
