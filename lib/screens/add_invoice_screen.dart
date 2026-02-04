import 'dart:io';
import 'dart:ui'; // لتأثير الزجاج
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit_text_recognition/google_ml_kit_text_recognition.dart';

class AddInvoiceScreen extends StatefulWidget {
  @override
  _AddInvoiceScreenState createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isScanning = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // --- 1. دوال الذكاء الاصطناعي (المخ) ---
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      _scanImage();
    }
  }

  Future<void> _scanImage() async {
    if (_image == null) return;
    setState(() => _isScanning = true);

    try {
      final inputImage = InputImage.fromFile(_image!);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      _analyzeText(recognizedText.text); // تحليل البيانات
      await textRecognizer.close();
    } catch (e) {
      print("Error scanning: $e");
    }
    setState(() => _isScanning = false);
  }

  // خوارزمية البحث الذكية
  void _analyzeText(String text) {
    List<String> lines = text.split('\n');
    
    // أ. اسم المحل (أول سطر)
    if (lines.isNotEmpty) {
      nameController.text = lines[0].trim();
    }

    // ب. التاريخ والمبلغ
    RegExp datePattern = RegExp(r'\d{4}[-/]\d{2}[-/]\d{2}|\d{2}[-/]\d{2}[-/]\d{4}');
    // يبحث عن أرقام فيها فواصل عشرية (مثل 50.00 أو 100,50)
    RegExp moneyPattern = RegExp(r'\d+[.,]\d{2}'); 

    double maxAmount = 0.0;

    for (String line in lines) {
      // 1. صيد التاريخ
      if (datePattern.hasMatch(line) && dateController.text.isEmpty) {
        dateController.text = datePattern.firstMatch(line)!.group(0)!;
      }

      // 2. صيد المبلغ (نأخذ أكبر رقم في الفاتورة لأنه غالباً الإجمالي)
      Iterable<Match> moneyMatches = moneyPattern.allMatches(line);
      for (var match in moneyMatches) {
        String numStr = match.group(0)!.replaceAll(',', '.'); // توحيد الفاصلة
        try {
          double val = double.parse(numStr);
          // تجاهل الأرقام الطويلة جداً (عشان ما يلخبط مع الرقم الضريبي)
          if (val > maxAmount && val < 100000) { 
            maxAmount = val;
          }
        } catch (e) {}
      }
    }

    // تعبئة خانة المبلغ تلقائياً
    if (maxAmount > 0) {
      amountController.text = maxAmount.toStringAsFixed(2);
    }
  }

  // --- 2. التصميم المستقبلي 2027 (الشكل) ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("مسح فاتورة 📸", style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // الخلفية الفضائية
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A2980), Color(0xFF26D0CE)],
              ),
            ),
          ),
          
          // دوائر جمالية
          Positioned(top: -50, left: -50, child: _glowCircle()),
          Positioned(bottom: 100, right: -50, child: _glowCircle()),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // شاشة السكانر
                  GestureDetector(
                    onTap: () => _showPickerOption(),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 5)],
                      ),
                      child: _image != null
                          ? ClipRRect(borderRadius: BorderRadius.circular(25), child: Image.file(_image!, fit: BoxFit.cover))
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code_scanner, size: 70, color: Colors.white70),
                                SizedBox(height: 10),
                                Text("اضغط لتصوير الفاتورة", style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                              ],
                            ),
                    ),
                  ),
                  
                  SizedBox(height: 30),

                  if (_isScanning)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(width: 10),
                          Text("جاري استخراج البيانات...", style: TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
                        ],
                      ),
                    ),

                  // الحقول الشفافة (معبأة تلقائياً)
                  _glassTextField(controller: nameController, label: "اسم المحل", icon: Icons.store),
                  SizedBox(height: 15),
                  
                  _glassTextField(
                    controller: amountController, 
                    label: "المبلغ", 
                    icon: Icons.attach_money, 
                    isNumber: true,
                    isBig: true
                  ),
                  SizedBox(height: 15),
                  
                  _glassTextField(controller: dateController, label: "التاريخ", icon: Icons.calendar_today),
                  
                  SizedBox(height: 40),

                  // زر الحفظ
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.deepOrange]),
                      boxShadow: [BoxShadow(color: Colors.orange.withOpacity(0.4), blurRadius: 15, offset: Offset(0, 5))],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pop(context);
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم الحفظ بنجاح ✨")));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text("حفظ الفاتورة", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- أدوات التصميم (Widgets) ---
  Widget _glassTextField({required TextEditingController controller, required String label, required IconData icon, bool isNumber = false, bool isBig = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: TextStyle(color: Colors.white, fontSize: isBig ? 24 : 16, fontWeight: isBig ? FontWeight.bold : FontWeight.normal),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle: TextStyle(color: Colors.white70, fontFamily: 'Cairo'),
              prefixIcon: Icon(icon, color: Colors.white70),
              suffixText: isNumber ? "ر.س" : null,
              suffixStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glowCircle() {
    return Container(
      width: 200, height: 200,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  void _showPickerOption() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(color: Color(0xFF1A2980), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          padding: EdgeInsets.all(20),
          child: Wrap(children: [
              ListTile(leading: Icon(Icons.camera_alt, color: Colors.white), title: Text('الكاميرا', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
              Divider(color: Colors.white24),
              ListTile(leading: Icon(Icons.image, color: Colors.white), title: Text('الاستديو', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
          ]),
        );
      },
    );
  }
}
