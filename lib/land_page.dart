import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'addlandpage.dart'; // Import the land page
import 'livetrackpolygon.dart'; // Import the land page
import 'database_helper.dart'; // Import the land page
import 'package:sqflite/sqflite.dart';
import 'land_record.dart';
import 'land_records_page.dart';
import 'map_selection.dart';

class LandPage extends StatefulWidget {
  const LandPage({super.key});

 @override
 _LandPageState createState() => _LandPageState();
}

class _LandPageState extends State<LandPage> {
   List<LandRecord> landRecords = [];
 final _formKey = GlobalKey<FormState>();
 late GoogleMapController mapController;
 Set<Marker> markers = {};
 final _landNameController = TextEditingController();
 final _addressController = TextEditingController();
 final _areaSizeController = TextEditingController();
 final _ownershipCertificateController = TextEditingController();
 final _ispoCertificateController = TextEditingController();

 // Example of _createLandRecord method
void _createLandRecord(String landName, String address, String areaSize, String ownershipCertificate, String ispoCertificate) {
 setState(() {
    landRecords.add(LandRecord(
      landName: landName,
      address: address,
      areaSize: areaSize,
      ownershipCertificate: ownershipCertificate,
      ispoCertificate: ispoCertificate,
    ));
 });
}

 @override
 void initState() {
   super.initState();
   _addMarkers(); // Initialize markers
 }
 
 @override
 void dispose() {
    // Dispose of the TextEditingController instances
    _landNameController.dispose();
    _addressController.dispose();
    _areaSizeController.dispose();
    _ownershipCertificateController.dispose();
    _ispoCertificateController.dispose();
    super.dispose();
 }

 // Define the _insertLand method here
Future<void> _insertLand(String landName, String address, String areaSize, String ownershipCertificate, String ispoCertificate) async {
  // Use DatabaseHelper.database getter
  final db = await DatabaseHelper.database;
  await db.insert(
    DatabaseHelper.landTable,

     {
       DatabaseHelper.landColumnLandName: landName,
       DatabaseHelper.landColumnAddress: address,
       DatabaseHelper.landColumnAreaSize: areaSize,
       DatabaseHelper.landColumnOwnershipCertificate: ownershipCertificate,
       DatabaseHelper.landColumnIspoCertificate: ispoCertificate,
     },
     conflictAlgorithm: ConflictAlgorithm.replace,
   );
 }

 void _addMarkers() {
   // Example markers
   Marker marker1 = const Marker(
     markerId: MarkerId('marker_1'),
     position: LatLng(-6.967660903930664, 107.6590805053711),
     infoWindow: InfoWindow(title: 'Marker 1'),
     draggable: true,
   );

   Marker marker2 = const Marker(
     markerId: MarkerId('marker_2'),
     position: LatLng(-6.967, 107.66),
     infoWindow: InfoWindow(title: 'Marker 2'),
   );

   markers.add(marker1);
   markers.add(marker2);
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Land Page'),
     ),
     body: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         children: <Widget>[
           Expanded(
             child: GoogleMap(
               onMapCreated: (GoogleMapController controller) {
                 mapController = controller;
                 _getCurrentLocation();
               },
               initialCameraPosition: const CameraPosition(
                 target: LatLng(0, 0), // Default location, will be updated with user's location
                 zoom: 11.0,
               ),
               markers: markers,
             ),
           ),
           Form(
             key: _formKey,
             child: Column(
               children: <Widget>[
                 // Use a Row widget to place buttons side by side
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusts the spacing between buttons
                   children: <Widget>[
                 // Moved the button here to appear above the TextFormField for the land address
                 Builder(
                   builder: (BuildContext context) {
                     return ElevatedButton(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const UkurKebun()), // Changed to MapsPage
                         );
                       }, // Changed text to "Ukur Lahan"
                       style: ElevatedButton.styleFrom(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(0),
                         ),
                         fixedSize: const Size(200, 50),
                       ),
                       child: const Text("Ukur Lahan Manual"),
                     );
                   },
                 ),
                 // New "Ukur Lahan Tracking" button
                 Builder(
                   builder: (BuildContext context) {
                     return ElevatedButton(
                       onPressed: () {
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const PolygonLiveTracking()), // Changed to MapsPage
                         );
                       },
                       style: ElevatedButton.styleFrom(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(0),
                       ),
                       fixedSize: const Size(200, 50),
                       ),
                       child: const Text("Ukur Lahan Tracking"),
                      );
                     },
                    ),
                   ],
                 ),
                 TextFormField(
                   controller: _landNameController,
                   decoration: const InputDecoration(labelText: 'Nama Lahan*'),
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return 'Please enter the land address';
                     }
                     return null;
                    },
                   ),
                   // Replace TextFormField with a button
TextFormField(
  controller: _addressController,
  readOnly: true, // Make the field read-only
  decoration: InputDecoration(
    labelText: 'Alamat Lahan*',
    suffixIcon: IconButton(
      icon: const Icon(Icons.map),
      onPressed: () async {
        // Navigate to the map selection screen
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MapSelectionPage()),
        );

        if (result != null) {
          // Update the address field with the selected location data
          _addressController.text = result['address'];
          // Add a marker to the map at the selected location
          markers.add(Marker(
            markerId: const MarkerId('selectedLocation'),
            position: LatLng(result['latitude'], result['longitude']),
            infoWindow: const InfoWindow(title: 'Selected Location'),
          ));
          setState(() {});
        }
      },
    ),
  ),
),


                TextFormField(
                  controller: _areaSizeController,
                  decoration: const InputDecoration(labelText: 'Luas Area Lahan*'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the land area size';
                    }
                    return null;
                    },
                  ),
                TextFormField(
                  controller: _ownershipCertificateController,
                  decoration: const InputDecoration(labelText: 'Nomor Sertifikat Hak Milik*'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ownership certificate number';
                    }
                    return null;
                    },
                  ),
                TextFormField(
                  controller: _ispoCertificateController,
                  decoration: const InputDecoration(labelText: 'Nomor Sertifikat ISPO*'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ISPO certificate number';
                    }
                    return null;
                    },
                  ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 16.0),
                   child: ElevatedButton(
                     onPressed: () {
                       if (_formKey.currentState!.validate()) {
                        // Get the form data
                        String landName = _landNameController.text;
                        String address = _addressController.text;
                        String areaSize = _areaSizeController.text;
                        String ownershipCertificate = _ownershipCertificateController.text;
                        String ispoCertificate = _ispoCertificateController.text;
                        // Insert the data into the database
                         _createLandRecord(landName, address, areaSize, ownershipCertificate, ispoCertificate);

                         ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Land record added')),
                         );
                            // Navigate to the LandRecordsPage
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                               builder: (context) => LandRecordsPage(landRecords: landRecords),
                             ),
                           );
                       }
                     },
                     child: const Text('Submit'),
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     ),
   );
 }

 Future<void> _getCurrentLocation() async {
   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
   setState(() {
     markers.add(Marker(
       markerId: const MarkerId('userLocation'),
       position: LatLng(position.latitude, position.longitude),
     ));
     // Update camera position to focus on the user's current location
     mapController.animateCamera(
       CameraUpdate.newCameraPosition(
         CameraPosition(
           target: LatLng(position.latitude, position.longitude),
           zoom: 18.0,
         ),
       ),
     );
   });
 }
}
