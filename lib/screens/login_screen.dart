import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. اللوقو
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  size: 80,
                  color: Colors.blue.shade800,
                ),
              ),
              SizedBox(height: 40),

              // 2. الترحيب
              Text(
                'مرحباً بك!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'سجل فواتيرك، وريح بالك.\nكل مشترياتك في مكان واحد آمن.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                  fontFamily: 'Cairo',
                ),
              ),
              SizedBox(height: 60),

              // 3. زر الدخول
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        // محاكاة عملية الدخول
                        Future.delayed(Duration(seconds: 2), () {
                           setState(() => _isLoading = false);
                           // الانتقال للصفحة التالية
                        });
                      },
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text(
                        'تسجيل الدخول عبر Google',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
