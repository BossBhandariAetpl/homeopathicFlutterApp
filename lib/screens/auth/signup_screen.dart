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
  final TextEditingController confirmPasswordController = TextEditingController();

  bool agreeTerms = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
                _buildTopIcon(context),
                const SizedBox(height: 20),
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
                _buildFormCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopIcon(BuildContext context) {
    return Container(
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
      child: Icon(
        Icons.assignment_ind,
        size: 48,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
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
          _buildPatientInfoBox(context),
          const SizedBox(height: 25),
          _buildFormFields(),
          const SizedBox(height: 18),
          _buildTermsCheckbox(),
          const SizedBox(height: 12),
          _buildCreateAccountButton(),
          const SizedBox(height: 25),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildGoogleButton(),
          const SizedBox(height: 20),
          _buildSignInLink(context),
        ],
      ),
    );
  }

  Widget _buildPatientInfoBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFFF0F5FF),
        border: Border.all(color: const Color(0xFFCCE0FF)),
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
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Join our homeopathic clinic community as a patient.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info, size: 18, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                "You will be registered as a patient.",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
              ),
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(
          controller: fullNameController,
          label: "Full Name",
          hint: "Enter your full name",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: emailController,
          label: "Email Address",
          hint: "Enter your email",
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: passwordController,
          label: "Password",
          hint: "Create a password (min. 6 characters)",
          obscure: !showPassword,
          suffix: _buildPasswordToggle(
            showPassword,
            () => setState(() => showPassword = !showPassword),
          ),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: confirmPasswordController,
          label: "Confirm Password",
          hint: "Confirm your password",
          obscure: !showConfirmPassword,
          suffix: _buildPasswordToggle(
            showConfirmPassword,
            () => setState(() => showConfirmPassword = !showConfirmPassword),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordToggle(bool isVisible, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
      onPressed: onPressed,
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: agreeTerms,
          onChanged: (val) => setState(() => agreeTerms = val ?? false),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: "I agree to the ",
              style: GoogleFonts.poppins(fontSize: 13),
              children: [
                TextSpan(
                  text: "Terms and Conditions",
                  style: GoogleFonts.poppins(color: Colors.blue),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: GoogleFonts.poppins(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSignUp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.black12)),
        const SizedBox(width: 10),
        Text(
          "Or sign up with",
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: Colors.black12)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Google signup coming soon!")),
          );
        },
        icon: Image.asset("assets/google.png", height: 22),
        label: Text(
          "Sign up with Google",
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black26),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            "Sign in here",
            style: GoogleFonts.poppins(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSignUp() {
    if (_validateForm()) {
      setState(() => isLoading = true);
      
      // Simulate signup process
      Future.delayed(const Duration(seconds: 2), () {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully!")),
        );
        Navigator.pop(context);
      });
    }
  }

  bool _validateForm() {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
      _showError("Please enter your full name");
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showError("Please enter a valid email address");
      return false;
    }

    if (password.length < 6) {
      _showError("Password must be at least 6 characters");
      return false;
    }

    if (password != confirmPassword) {
      _showError("Passwords do not match");
      return false;
    }

    if (!agreeTerms) {
      _showError("Please agree to the terms and conditions");
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

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
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black45, fontSize: 14),
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
