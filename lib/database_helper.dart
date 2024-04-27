import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
 static const _databaseName = "app_database.db";
 static const _databaseVersion = 1;

 static const profileTable = 'profile';
 static const landTable = 'land';

 static const profileColumnId = '_id';
 static const profileColumnName = 'name';
 static const profileColumnRole = 'role';
 static const profileColumnAddress = 'address';

 static const landColumnId = '_id';
 static const landColumnLandName = 'name';
 static const landColumnAddress = 'address';
 static const landColumnAreaSize = 'area_size';
 static const landColumnOwnershipCertificate = 'ownership_certificate';
 static const landColumnIspoCertificate = 'ispo_certificate';

 // Singleton class
 DatabaseHelper._privateConstructor();
 static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

 // Database reference
 static Database? _database;

 // Getter for the database instance
 static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
 }

  static Future<List<Map<String, dynamic>>> getProfiles() async {
    // Use DatabaseHelper.database getter
    final db = await DatabaseHelper.database;
    return await db.query(profileTable);
  }

  static Future<void> insertProfile(BuildContext context, String name, String role, String address) async {
    // Wait for the database to be initialized
    await DatabaseHelper.database;

    Map<String, dynamic> profile = {
      'name': name,
      'role': role,
      'address': address,
    };

    // Ensure database is initialized
    final db = await DatabaseHelper.database;
    await db.insert(DatabaseHelper.profileTable, profile);
  }

  static Future<void> deleteProfile(int id) async {
    // Use DatabaseHelper.database getter
    final db = await DatabaseHelper.database;
    await db.delete(
      profileTable,
      where: '$profileColumnId = ?',
      whereArgs: [id],
    );
  }

  static Future<void> updateProfile(int id, String name, String role, String address) async {
    // Use DatabaseHelper.database getter
    final db = await DatabaseHelper.database;
    await db.update(
      profileTable,
      {
        profileColumnName: name,
        profileColumnRole: role,
        profileColumnAddress: address,
      },
      where: '$profileColumnId = ?',
      whereArgs: [id],
    );
  }

  // Initialize the database
  static Future<Database> _initDatabase() async {
    
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $profileTable ($profileColumnId INTEGER PRIMARY KEY, $profileColumnName TEXT NOT NULL, $profileColumnRole TEXT NOT NULL, $profileColumnAddress TEXT NOT NULL);
          CREATE TABLE $landTable ($landColumnId INTEGER PRIMARY KEY, $landColumnLandName TEXT NOT NULL, $landColumnAddress TEXT NOT NULL, $landColumnAreaSize TEXT NOT NULL, $landColumnOwnershipCertificate TEXT NOT NULL, $landColumnIspoCertificate TEXT NOT NULL);
          ''',
        );
      },
    );
 }
}
