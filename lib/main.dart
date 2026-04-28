import 'package:flutter/material.dart';
import 'views/auth/login_page.dart';
import '/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkIn Campus',
      theme: AppTheme.lightTheme,
      home: LoginPage(),
    );
  }
}
