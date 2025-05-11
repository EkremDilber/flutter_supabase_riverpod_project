import 'package:flutter/material.dart';
import 'package:flutter_supabase_project/pages/auth/login_screen.dart';
import 'package:flutter_supabase_project/service/auth_service.dart';
import 'package:flutter_supabase_project/widgets/widgets.dart';
import 'package:toastification/toastification.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  bool isPasswordHidden = true;

  void _signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    //validate email format
    if (!email.contains(".com")) {
      showToastification(
        context,
        "Invalid email",
        "Invalid email address",
        ToastificationType.error,
      );
      // Yerine "Toastification" kullanarak hata mesajı gösteriliyor
      //showSnackBar(context, 'Invalid email');
    }
    setState(() {
      isLoading = true;
    });
    final result = await _authService.signUp(email, password);
    if (result == null) {
      setState(() {
        isLoading = false;
      });
      showToastification(
        context,
        "Sign up successful",
        "User created successfully",
        ToastificationType.success,
      );
      // Yerine "Toastification" kullanarak hata mesajı gösteriliyor
      //showSnackBar(context, "Sign up successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      showToastification(
        context,
        "Signup failed",
        result,
        ToastificationType.error,
      );
      // Yerine "Toastification" kullanarak hata mesajı gösteriliyor
      //showSnackBar(context, "Signup failed: $result");
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
                "assets/6343825.jpg",
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
                      child: MyButton(onTap: _signUp, buttonText: "Sign Up"),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Login here",
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
