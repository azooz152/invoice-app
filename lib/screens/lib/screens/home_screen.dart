import 'package:flutter/material.dart';
import 'login_screen.dart'; 
// import 'add_invoice_screen.dart'; // سننشئها في الخطوة القادمة

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // 1. الشريط العلوي
      appBar: AppBar(
        title: Text("فواتيري 🧾", style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // كود تسجيل الخروج والعودة لصفحة الدخول
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),

      // 2. جسم الصفحة (قائمة الفواتير)
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // بطاقة ملخص المصروفات (اختياري جمالي)
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue.shade800, Colors.blue.shade500]),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("إجمالي الشهر", style: TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
                      Text("1,250 ر.س", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.pie_chart, color: Colors.white.withOpacity(0.8), size: 40),
                ],
              ),
            ),
            SizedBox(height: 20),
            
            // عنوان القائمة
            Align(
              alignment: Alignment.centerRight,
              child: Text("آخر العمليات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
            ),
            SizedBox(height: 10),

            // قائمة الفواتير (وهمية حالياً للعرض)
            Expanded(
              child: ListView.builder(
                itemCount: 5, // عدد وهمي
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange.shade100,
                        child: Icon(Icons.shopping_bag, color: Colors.orange.shade800),
                      ),
                      title: Text("سوبر ماركت الدانوب", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      subtitle: Text("2026-02-04 • مقاضي"),
                      trailing: Text("- 350 ر.س", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 3. الزر العائم لإضافة فاتورة
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // الانتقال لصفحة إضافة فاتورة
          // Navigator.push(context, MaterialPageRoute(builder: (context) => AddInvoiceScreen()));
        },
        label: Text("إضافة فاتورة", style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        icon: Icon(Icons.camera_alt),
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }
}
