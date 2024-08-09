
import 'package:flutter/material.dart';
class CheckInConfirmationScreen extends StatelessWidget {
  final String idNumber;
  final String gender;
  final String name;
  final String timestamp;

  CheckInConfirmationScreen({
    required this.idNumber,
    required this.gender,
    required this.name,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check-In Confirmation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.black87],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Check-In Successful', style: TextStyle(fontSize: 24, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('ID Number: $idNumber', style: TextStyle(fontSize: 18, color: Colors.black87)),
                      Text('Name: $name', style: TextStyle(fontSize: 18, color: Colors.black87)),
                      Text('Gender: $gender', style: TextStyle(fontSize: 18, color: Colors.black87)),
                      Text('Check-In Time: $timestamp', style: TextStyle(fontSize: 18, color: Colors.black87)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
