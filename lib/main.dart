import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_project/pages/auth/login_screen.dart';
import 'package:flutter_supabase_project/pages/screens/app_main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    //Oluşturduğunuz Supabase veri tabanının API Key bilgilerini buraya yapıştırın
    //Assets klasörünün cvs-files klasöründeki CSV dosyalarını Supabase veri tabanınıza yüklemeyi unutmayın
    url: "URL BURAYA",
    anonKey: "ANON KEY BURAYA",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ToastificationWrapper(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: AuthCheck(),
        ),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  final supabase = Supabase.instance.client;
  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = supabase.auth.currentSession;
        if (session != null) {
          return const AppMainScreen(); // User is logged in go to home screen
        } else {
          return const LoginScreen(); // User is not logged in
        }
      },
    );
  }
}
