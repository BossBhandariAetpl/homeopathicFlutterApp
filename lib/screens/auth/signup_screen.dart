import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool agreeTerms = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Top Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.assignment_ind,
                    size: 48,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 20),

                // Heading
                Text(
                  "Create Account",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Join our homeopathic clinic community",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 26),

                // Form Card
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Patient Registration Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFF0F5FF),
                          border: Border.all(
                            color: const Color(0xFFCCE0FF),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.group, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  "Patient Registration",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Join our homeopathic clinic community as a patient.",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.info,
                                    size: 18, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  "You will be registered as a patient.",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text.rich(
                              TextSpan(
                                text: "Are you a doctor? ",
                                style: GoogleFonts.poppins(fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: "Register here",
                                    style: GoogleFonts.poppins(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Full Name
                      _buildTextField(
                        controller: fullNameController,
                        label: "Full Name",
                        hint: "Enter your full name",
                      ),

                      const SizedBox(height: 16),

                      // Email
                      _buildTextField(
                        controller: emailController,
                        label: "Email Address",
                        hint: "Enter your email",
                        keyboard: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      // Password
                      _buildTextField(
                        controller: passwordController,
                        label: "Password",
                        hint: "Create a password (min. 6 characters)",
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

                      const SizedBox(height: 16),

                      // Confirm Password
                      _buildTextField(
                        controller: confirmPasswordController,
                        label: "Confirm Password",
                        hint: "Confirm your password",
                        obscure: !showConfirmPassword,
                        suffix: IconButton(
                          icon: Icon(
                            showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() =>
                                showConfirmPassword = !showConfirmPassword);
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Terms Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: agreeTerms,
                            onChanged: (val) {
                              setState(() => agreeTerms = val!);
                            },
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "I agree to the ",
                                style: GoogleFonts.poppins(fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: "Terms and Conditions",
                                    style: GoogleFonts.poppins(
                                        color: Colors.blue),
                                  ),
                                  const TextSpan(text: " and "),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: GoogleFonts.poppins(
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Create Account Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Create Account",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Divider with OR
                      Row(
                        children: [
                          Expanded(
                            child: Container(height: 1, color: Colors.black12),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Or sign up with",
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(height: 1, color: Colors.black12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Google Signup Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/google.png",
                            height: 22,
                          ),
                          label: Text(
                            "Sign up with Google",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black26),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Sign in here",
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------
  // Reusable Input Builder
  // ------------------------
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.black45,
              fontSize: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
