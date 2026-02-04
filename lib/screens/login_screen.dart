import 'package:flutter/material.dart';
import 'home_screen.dart';

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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.receipt_long_rounded, size: 80, color: Colors.blue.shade800),
              SizedBox(height: 40),
              Text('تطبيق الفواتير الذكي', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 60),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isLoading = true);
                        Future.delayed(Duration(seconds: 1), () {
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        });
                      },
                      icon: Icon(Icons.login),
                      label: Text('دخول سريع'),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
