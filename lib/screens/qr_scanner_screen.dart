import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: QRScannerScreen(),
  ));
}

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String detectedText = "";
  List<Map<String, String>> checkedInPersons = [];

  Future<void> _requestPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan my ID'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Instructions'),
                  content: Text(
                    'Align the ID card within the frame to scan. Ensure the code is clear and visible.',
                    style: TextStyle(color: Colors.black87),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK', style: TextStyle(color: Colors.deepPurpleAccent)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.list, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckedInScreen(checkedInPersons: checkedInPersons),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (result != null)
                        Card(
                          color: Colors.white.withOpacity(0.8),
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Scan Result',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Barcode Type: ${describeEnum(result!.format)}',
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Data: ${result!.code}',
                                  style: TextStyle(fontSize: 16, color: Colors.black87),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Text(
                          'Scan a code',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return Text(
                                    'Flash: ${snapshot.data ?? 'Off'}',
                                    style: TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.flipCamera();
                                setState(() {});
                              },
                              child: Text(
                                'Flip Camera',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.pauseCamera();
                              },
                              child: const Text(
                                'Pause',
                                style: TextStyle(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () async {
                                await controller?.resumeCamera();
                              },
                              child: const Text(
                                'Resume',
                                style: TextStyle(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: _captureAndProcessImage,
                        child: Text(
                          'Capture Image',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 300.0 // Increase the size for smaller devices
        : 500.0; // Larger size for larger devices

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        _processIDData(scanData.code!);
      });
    });
  }

  Future<void> _processIDData(String idData) async {
    // Process the ID data as needed
    // Decrypt the ID number, gender, and other information from the code
    // For simplicity, let's assume the ID data is formatted as 'Name,Gender,ID,Serial'
    List<String> parts = idData.split(',');

    if (parts.length == 4) {
      String name = parts[0];
      String gender = parts[1];
      String idNumber = parts[2];
      String serialNumber = parts[3];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DisplayDataScreen(
            name: name,
            gender: gender,
            idNumber: idNumber,
            serialNumber: serialNumber,
            onCheckIn: (person) {
              setState(() {
                checkedInPersons.add(person);
              });
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      // Handle error in data format
      log('Error: ID data format is incorrect.');
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  Future<void> _captureAndProcessImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final InputImage inputImage = InputImage.fromFile(File(image.path));
      final TextRecognizer textRecognizer = TextRecognizer();
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        detectedText = recognizedText.text;
      });

      // Process the detected text and extract required fields
      List<String> lines = detectedText.split('\n');
      if (lines.length >= 4) {
        String name = lines[0];
        String gender = lines[1];
        String idNumber = lines[2];
        String serialNumber = lines[3];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayDataScreen(
              name: name,
              gender: gender,
              idNumber: idNumber,
              serialNumber: serialNumber,
              onCheckIn: (person) {
                setState(() {
                  checkedInPersons.add(person);
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      } else {
        // Handle error in detected text format
        log('Error: Detected text format is incorrect.');
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class DisplayDataScreen extends StatelessWidget {
  final String name;
  final String gender;
  final String idNumber;
  final String serialNumber;
  final Function(Map<String, String>) onCheckIn;

  DisplayDataScreen({
    required this.name,
    required this.gender,
    required this.idNumber,
    required this.serialNumber,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-In Details'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: $name', style: TextStyle(fontSize: 18)),
            Text('Gender: $gender', style: TextStyle(fontSize: 18)),
            Text('ID Number: $idNumber', style: TextStyle(fontSize: 18)),
            Text('Serial Number: $serialNumber', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Map<String, String> person = {
                  'Name': name,
                  'Gender': gender,
                  'ID Number': idNumber,
                  'Serial Number': serialNumber,
                  'Check-In Time': DateTime.now().toString(),
                };
                onCheckIn(person);
              },
              child: Text('Check In'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckedInScreen extends StatelessWidget {
  final List<Map<String, String>> checkedInPersons;

  CheckedInScreen({required this.checkedInPersons});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checked-In Persons'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView.builder(
        itemCount: checkedInPersons.length,
        itemBuilder: (context, index) {
          final person = checkedInPersons[index];
          return ListTile(
            title: Text(person['Name'] ?? 'Unknown'),
            subtitle: Text('ID: ${person['ID Number']}, Gender: ${person['Gender']}'),
            trailing: TextButton(
              onPressed: () {
                String checkOutTime = DateTime.now().toString();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${person['Name']} checked out at $checkOutTime')),
                );

                // Remove the person from the checked-in list
                checkedInPersons.removeAt(index);

                // Update the state to reflect the changes
                (context as Element).markNeedsBuild();
              },
              child: Text('Check Out', style: TextStyle(color: Colors.red)),
            ),
          );
        },
      ),
    );
  }
}
