import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';

// Shared imports
import '../../constants/text_styles.dart';
import '../../widgets/common/custom_text_field.dart';

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

  void login() async {
    setState(() => loading = true);

    try {
      final user = await _authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: $e")),
        );
      }
    }

    if (mounted) {
      setState(() => loading = false);
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
                      showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
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
                    onPressed: () {},
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
                      onPressed: () {},
                      child: Text(
                        "Sign Up",
                        style: AppTextStyles.body.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
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
