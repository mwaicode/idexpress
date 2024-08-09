import 'package:flutter/material.dart';
class DisplayDataScreen extends StatelessWidget {
  final String name;
  final String gender;
  final String idNumber;
  final String serialNumber;

  DisplayDataScreen({
    required this.name,
    required this.gender,
    required this.idNumber,
    required this.serialNumber,
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
                Navigator.pop(context);
              },
              child: Text('Back'),
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

