import 'package:flutter/material.dart';
import 'package:visit_management_app/screens/idscanner_page.dart';
import 'package:visit_management_app/screens/qr_scanner_screen.dart';

import 'package:visit_management_app/screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: WelcomeScreen(),
      routes: {

        '/home': (context) => HomeScreen(),
        '/qrscanner': (context) => QRScannerScreen(),
        '/idscanner': (context) => IDScannerScreen(),
      },
    );
  }
}

// class SplashScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/id.png', width: 100, height: 100),
//             SizedBox(height: 20),
//             Text('Visit Management App', style: TextStyle(fontSize: 24)),
//           ],
//         ),
//       ),
//     );
//   }
// }





class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black87, // Dark color for the AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey[900]!], // Dark gradient from black to near-black
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/qrscanner');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[400], // Teal color for the button
              // onPrimary: Colors.white, // Text color for the button
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Scan ID',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
