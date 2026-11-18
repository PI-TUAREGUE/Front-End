import 'package:flutter/material.dart';
import 'data/repositories/auth_repository.dart';
import 'views/pages/login_page.dart';
import 'views/pages/main_navigation_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authRepository = AuthRepository();
  final isLoggedIn = await authRepository.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agendamento Automotivo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: isLoggedIn ? const MainNavigationPage() : const LoginPage(),
    );
  }
}
