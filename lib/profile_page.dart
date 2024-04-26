import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper.dart'; // Import the land page
import 'profiledisplay.dart';
import 'profile_data.dart';


class ProfilePage extends StatefulWidget {
 @override
 _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 final _formKey = GlobalKey<FormState>();
 final _nameController = TextEditingController();
 final _roleController = TextEditingController();
 final _addressController = TextEditingController();

 @override
 void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _addressController.dispose();
    super.dispose();
 }

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                 }
                 return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Please enter your role';
                 }
                 return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                 if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                 }
                 return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                 onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String name = _nameController.text;
                      String role = _roleController.text;
                      String address = _addressController.text;

                      // Insert the data into the database
                      _insertProfile(context, name, role, address);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')),
                      );
                    }
                 },
                 child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
 }

Future<void> _insertProfile(BuildContext context, String name, String role, String address) async {
  try {
    // Access the database
    final db = await DatabaseHelper.database;

    Map<String, dynamic> profile = {
      'name': name,
      'role': role,
      'address': address,
    };

    // Insert the data into the database
    await db.insert(DatabaseHelper.profileTable, profile);
    print('Data inserted successfully');

    // Navigate to the new page after data insertion
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileDisplayPage()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data Saved Successfully')),
    );
  } catch (error) {
    print('Error inserting data: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving data: $error')),
    );
  }
}
}