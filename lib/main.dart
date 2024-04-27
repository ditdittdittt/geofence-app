import 'package:flutter/material.dart';
import 'profile_page.dart'; // Import the profile page
import 'land_page.dart'; // Import the land page
// Import the land page
import 'land_records_page.dart';
// Import your DatabaseHelper

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: const FlutterLogo(
            size: 20,
          ),
          backgroundColor: const Color(0xFF4287f5),
          title: const Text("Geofence App"),
          centerTitle: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandRecordsPage(landRecords: [],)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text("Profile Kebun"),
                  );
                },
              ),
              const SizedBox(height: 10),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LandPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text("Tambah Kebun"),
                  );
                },
              ),
              const SizedBox(height: 10),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text("Profile"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}