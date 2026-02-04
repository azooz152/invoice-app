import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit_text_recognition/google_ml_kit_text_recognition.dart';
import 'home_screen.dart';

class AddInvoiceScreen extends StatefulWidget {
  @override
  _AddInvoiceScreenState createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;

  // حقول النص (Controllers) عشان نعبيها تلقائياً
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // 1. دالة اختيار الصورة
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // بمجرد اختيار الصورة، ابدأ التحليل فوراً
      _scanImage();
    }
  }

  // 2. دالة الذكاء الاصطناعي (المخ) 🧠
  Future<void> _scanImage() async {
    if (_image == null) return;

    setState(() => _isScanning = true);

    try {
      final inputImage = InputImage.fromFile(_image!);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String extractedText = recognizedText.text;
      
      // تحليل النص لاستخراج البيانات
      _analyzeText(extractedText);

      await textRecognizer.close();
    } catch (e) {
      print("خطأ في القراءة: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("لم نتمكن من قراءة الفاتورة بوضوح")));
    }

    setState(() => _isScanning = false);
  }

  // 3. خوارزمية البحث عن البيانات (الفلترة)
  void _analyzeText(String text) {
    List<String> lines = text.split('\n');

    // أ. اسم المحل: غالباً يكون في أول سطر
    if (lines.isNotEmpty) {
      nameController.text = lines[0].trim(); 
    }

    // ب. البحث عن التاريخ والمبلغ
    // تعبيرات نمطية (Regex) للبحث عن الأشكال
    RegExp datePattern = RegExp(r'\d{4}[-/]\d{2}[-/]\d{2}|\d{2}[-/]\d{2}[-/]\d{4}');
    RegExp moneyPattern = RegExp(r'\d+[.,]\d{2}'); // يبحث عن أرقام فيها فواصل مثل 50.00

    double maxAmount = 0.0;

    for (String line in lines) {
      // البحث عن التاريخ
      if (datePattern.hasMatch(line) && dateController.text.isEmpty) {
        dateController.text = datePattern.firstMatch(line)!.group(0)!;
      }

      // البحث عن المبالغ (نأخذ أكبر رقم لأنه غالباً المجموع)
      Iterable<Match> moneyMatches = moneyPattern.allMatches(line);
      for (var match in moneyMatches) {
        String numStr = match.group(0)!.replaceAll(',', '.'); // توحيد الفاصلة
        try {
          double val = double.parse(numStr);
          if (val > maxAmount) {
            maxAmount = val;
          }
        } catch (e) {}
      }
    }

    // وضع أكبر رقم في خانة المبلغ
    if (maxAmount > 0) {
      amountController.text = maxAmount.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مسح فاتورة 📸", style: TextStyle(fontFamily: 'Cairo')),
        backgroundColor: Colors.blue.shade800,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // مساحة الصورة
            GestureDetector(
              onTap: () => _showPickerOption(),
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_image!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_enhance, size: 60, color: Colors.grey),
                          Text("اضغط هنا لتصوير الفاتورة", style: TextStyle(fontFamily: 'Cairo')),
                        ],
                      ),
              ),
            ),
            SizedBox(height: 20),

            // مؤشر التحميل أثناء الذكاء الاصطناعي
            if (_isScanning) 
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("جاري تحليل البيانات بالذكاء الاصطناعي... 🤖", style: TextStyle(color: Colors.blue)),
                  SizedBox(height: 20),
                ],
              ),

            // الحقول (تتعبأ تلقائياً)
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "اسم المحل",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.store),
              ),
            ),
            SizedBox(height: 15),
            
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "المبلغ الإجمالي",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money),
                suffixText: "ر.س",
              ),
            ),
            SizedBox(height: 15),

            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: "التاريخ",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            SizedBox(height: 30),

            // زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // هنا كود الحفظ في قاعدة البيانات (لاحقاً)
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم حفظ الفاتورة بنجاح! ✅")));
                  Navigator.pop(context);
                },
                child: Text("حفظ الفاتورة", style: TextStyle(fontSize: 18, fontFamily: 'Cairo')),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // نافذة اختيار (كاميرا أو استديو)
  void _showPickerOption() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('الكاميرا'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('الاستديو'),
              onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); },
            ),
          ],
        );
      },
    );
  }
}
