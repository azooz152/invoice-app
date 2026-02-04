import 'dart:io';
import 'dart:ui';
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
      _analyzeText(recognizedText.text);
      await textRecognizer.close();
    } catch (e) {}
    setState(() => _isScanning = false);
  }

  void _analyzeText(String text) {
    List<String> lines = text.split('\n');
    if (lines.isNotEmpty) nameController.text = lines[0].trim();
    RegExp datePattern = RegExp(r'\d{4}[-/]\d{2}[-/]\d{2}|\d{2}[-/]\d{2}[-/]\d{4}');
    for (String line in lines) {
      if (datePattern.hasMatch(line) && dateController.text.isEmpty) {
        dateController.text = datePattern.firstMatch(line)!.group(0)!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("مسح فاتورة", style: TextStyle(fontWeight: FontWeight.bold)), backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF1A2980), Color(0xFF26D0CE)]))),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(ImageSource.gallery), // للمتصفح نستخدم المعرض مبدئياً
                    child: Container(
                      height: 200, width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white30)),
                      child: _image != null ? ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(_image!, fit: BoxFit.cover)) : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, size: 50, color: Colors.white), Text("اضغط هنا", style: TextStyle(color: Colors.white))]),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_isScanning) CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  _glassField(nameController, "المحل", Icons.store),
                  SizedBox(height: 10),
                  _glassField(amountController, "المبلغ", Icons.money, isNum: true),
                  SizedBox(height: 10),
                  _glassField(dateController, "التاريخ", Icons.date_range),
                  SizedBox(height: 30),
                  ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("حفظ الفاتورة"), style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassField(TextEditingController ctrl, String lbl, IconData icon, {bool isNum = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.white.withOpacity(0.15),
          child: TextField(controller: ctrl, keyboardType: isNum ? TextInputType.number : TextInputType.text, style: TextStyle(color: Colors.white), decoration: InputDecoration(labelText: lbl, labelStyle: TextStyle(color: Colors.white70), prefixIcon: Icon(icon, color: Colors.white70), border: InputBorder.none, contentPadding: EdgeInsets.all(15))),
        ),
      ),
    );
  }
}
