import 'package:flutter/material.dart';
import 'add_invoice_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("فواتيري"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginScreen())),
          )
        ],
      ),
      body: Center(child: Text("لا توجد فواتير حالياً")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoiceScreen()));
        },
        label: Text("إضافة فاتورة"),
        icon: Icon(Icons.camera_alt),
      ),
    );
  }
}
