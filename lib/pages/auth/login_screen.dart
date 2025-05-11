import 'package:flutter/material.dart';
import 'package:flutter_supabase_project/pages/auth/signup_screen.dart';
import 'package:flutter_supabase_project/pages/screens/onboarding_screen.dart';
import 'package:flutter_supabase_project/service/auth_service.dart';
import 'package:flutter_supabase_project/widgets/widgets.dart';
import 'package:toastification/toastification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isPasswordHidden = true;

  void _logIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (!mounted) return;

    setState(() {
      isLoading = true;
    });
    final result = await _authService.login(email, password);
    if (result == null) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showToastification(
        context,
        "Login failed",
        result,
        ToastificationType.error,
      );
      // Yerine "Toastification" kullanarak hata mesajı gösteriliyor
      //showSnackBar(context, "Login failed: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Image.asset(
                "assets/login.jpg",
                width: double.maxFinite,
                height: 500,
                fit: BoxFit.cover,
              ),
              // email input
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      emailController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordHidden = !isPasswordHidden;
                      });
                    },
                    icon: Icon(isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
                obscureText: isPasswordHidden,
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.blue,
                    )
                  : SizedBox(
                      width: double.maxFinite,
                      child: MyButton(onTap: _logIn, buttonText: "Login"),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Signup here",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
