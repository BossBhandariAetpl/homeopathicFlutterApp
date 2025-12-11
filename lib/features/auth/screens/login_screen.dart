import 'package:flutter/material.dart';
import 'package:flutter_homeopathy_app/features/doctor/screens/doctor_home_screen.dart';
import 'package:flutter_homeopathy_app/features/patient/screens/patient_home_screen.dart';
import 'package:flutter_homeopathy_app/features/receptionist/screens/receptionist_home_screen.dart';
import '../../../core/services/auth_service.dart';

// Shared imports
import '../../../constants/text_styles.dart';
import '../../../common/widgets/common/custom_text_field.dart';

// Fallback home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to Home Screen'),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool showPassword = false;
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (emailController.text.trim().isEmpty || 
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      // Sign in with email and password
      final user = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        // Get user profile to determine role
        final profile = await _authService.getUserProfile(user.uid);
        
        if (profile == null) {
          throw Exception('User profile not found');
        }

        final roles = profile['roles'] as List<dynamic>?;
        
        if (roles == null || roles.isEmpty) {
          throw Exception('User has no assigned role');
        }

        // Navigate based on user role
        Future.microtask(() {
          if (roles.contains('doctor')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DoctorHomeScreen()),
            );
          } else if (roles.contains('patient')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
            );
          } else if (roles.contains('receptionist')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ReceptionistHomeScreen()),
            );
          } else {
            // Default fallback for other roles
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        });
      }
    } catch (e) {
      // Handle specific error cases
      String errorMessage = 'Login failed';
      
      if (e.toString().contains('user-not-found') || 
          e.toString().contains('wrong-password')) {
        errorMessage = 'Invalid email or password';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Network error. Please check your connection';
      } else {
        errorMessage = e.toString();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text("Welcome Back", style: AppTextStyles.title),

                const SizedBox(height: 8),

                Text("Log in to continue", style: AppTextStyles.subtitle),

                const SizedBox(height: 32),

                // ----------------------------
                // Email Field (Refactored)
                // ----------------------------
                CustomTextField(
                  controller: emailController,
                  label: "Email",
                  keyboard: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // ----------------------------
                // Password Field (Refactored)
                // ----------------------------
                CustomTextField(
                  controller: passwordController,
                  label: "Password",
                  obscure: !showPassword,
                  suffix: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => showPassword = !showPassword);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password reset coming soon!")),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ----------------------------
                // Login Button
                // ----------------------------
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: loading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Sign In",
                            style: AppTextStyles.label.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // ----------------------------
                // Create Account
                // ----------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: AppTextStyles.body),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Sign up coming soon!")),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: AppTextStyles.body.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
