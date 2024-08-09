import 'package:flutter/material.dart';
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
                // Check-out logic
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
