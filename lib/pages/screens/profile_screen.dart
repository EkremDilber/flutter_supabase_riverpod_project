import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_supabase_project/core/provider/cart_provider.dart';
import 'package:flutter_supabase_project/core/provider/favorite_provider.dart';
import 'package:flutter_supabase_project/service/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

AuthService authService = AuthService();

class ProfileScreen extends ConsumerWidget {
  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) ...[
              Text(
                'Hoş geldiniz, ${user.email}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
            ],
            ElevatedButton(
              onPressed: () {
                authService.logout(context);
                ref.invalidate(favoriteProvider);
                ref.invalidate(cartProvider);
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
