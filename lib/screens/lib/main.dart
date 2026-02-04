import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'تطبيق الفواتير الذكي',
      theme: ThemeData(
        fontFamily: 'Cairo', // إذا الخط مو مضاف بيستخدم الخط العادي
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(), // ابدأ بصفحة الدخول
    );
  }
}
