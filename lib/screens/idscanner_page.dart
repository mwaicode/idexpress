import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class IDScannerScreen extends StatefulWidget {
  final String? qrData;

  IDScannerScreen({this.qrData});

  @override
  _IDScannerScreenState createState() => _IDScannerScreenState();
}

class _IDScannerScreenState extends State<IDScannerScreen> with SingleTickerProviderStateMixin {
  File? _image;
  String _idNumber = '';
  String _gender = '';
  String _name = '';
  bool _isScanning = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.qrData != null) {
      _processQRData(widget.qrData!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processQRData(String data) {
    // Process the QR data to extract ID information
    setState(() {
      _idNumber = _parseIDNumber(data) ?? '';
      _gender = _parseGender(data) ?? '';
      _name = _parseName(data) ?? '';
      _isScanning = false;
    });

    // Proceed with sending OTP
    _sendOtp();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _scanID();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _scanID() async {
    if (_image == null) return;

    setState(() {
      _isScanning = true;
    });

    _controller.forward();

    final inputImage = InputImage.fromFilePath(_image!.path);

    // For OCR
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    String idNumber = '';
    String gender = '';
    String name = '';

    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        if (line.text.contains('ID Number:')) {
          idNumber = line.text.split(':')[1].trim();
        } else if (line.text.contains('Gender:')) {
          gender = line.text.split(':')[1].trim();
        } else if (line.text.contains('Name:')) {
          name = line.text.split(':')[1].trim();
        }
      }
    }

    // For Barcode Scanning
    final barcodeScanner = BarcodeScanner();
    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      if (barcode.format == BarcodeFormat.pdf417 || barcode.format == BarcodeFormat.code128) {
        final String rawValue = barcode.rawValue ?? '';
        idNumber = _parseIDNumber(rawValue) ?? idNumber;
        gender = _parseGender(rawValue) ?? gender;
        name = _parseName(rawValue) ?? name;
      }
    }

    textRecognizer.close();
    barcodeScanner.close();

    setState(() {
      _idNumber = idNumber;
      _gender = gender;
      _name = name;
      _isScanning = false;
    });

    // Proceed with sending OTP
    _sendOtp();
  }

  String? _parseIDNumber(String rawValue) {
    return rawValue.contains('ID') ? rawValue.split('ID')[1].trim() : null;
  }

  String? _parseGender(String rawValue) {
    return rawValue.contains('Gender') ? rawValue.split('Gender')[1].trim() : null;
  }

  String? _parseName(String rawValue) {
    return rawValue.contains('Name') ? rawValue.split('Name')[1].trim() : null;
  }

  Future<void> _sendOtp() async {
    // Implement OTP sending logic using Twilio or any other SMS service
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('ID Scanner'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text(
              'No image selected.',
              style: TextStyle(color: Colors.white),
            )
                : FadeTransition(
              opacity: _animation,
              child: Image.file(_image!),
            ),
            SizedBox(height: 20),
            _isScanning
                ? CircularProgressIndicator()
                : Column(
              children: [
                Text('ID Number: $_idNumber', style: TextStyle(color: Colors.white)),
                Text('Gender: $_gender', style: TextStyle(color: Colors.white)),
                Text('Name: $_name', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
        backgroundColor: Colors.white,
      ),
    );
  }
}
