import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main_nav/main_page.dart';
import 'login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Loading saat cek session
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Jika user sudah login
        if (snapshot.hasData) {
          return const MainPage();
        }

        // Jika belum login
        return const LoginPage();
      },
    );
  }
}
