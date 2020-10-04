import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'database_structure_and_class_declaration.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;
  String tableName = "items_list";
  String colId = "id";
  String colItemName = "itemName";
  String colDate = "date";
  String colItemDescription = "itemDescription";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'app_storage.db';

    var itemsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return itemsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colItemName TEXT,$colItemDescription TEXT,$colDate TEXT)');
  print('CREATE TABLE $tableName($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colItemName TEXT,$colItemDescription TEXT,$colDate TEXT)');
  }

  Future<List<Map<String, dynamic>>> getItemMapList() async {
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $tableName');
    return result;
  }

  Future<int> insertItem(Items item) async {
    print("call came here");
    Database db = await this.database;
    String idnew =item.itemName;
    String idDesc=item.itemDescription;
    String date=item.date;
    print("<__>$idnew<__>$date><__>$idDesc<__>");
    var result = await db.rawInsert("INSERT INTO $tableName($colItemName,$colItemDescription,$colDate) VALUES('$idnew','$idDesc','$date')");
//    var result = await db.insert(tableName, item.toMap());
    print("the heck man");
    print("result:$result");
    return result;
  }

  Future<int> updateItem(Items item) async {
    var db = await this.database;
    var result = await db.update(tableName, item.toMap(),
        where: '$colId=?', whereArgs: [item.id]);
    return result;
  }

  Future<int> deleteItem(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) FROM $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Items>> getItemsList() async {
    // ignore: non_constant_identifier_names
    var ItemsMapList = await getItemMapList();
    int count = ItemsMapList.length;
    // ignore: non_constant_identifier_names
    List<Items> ItemsList = List<Items>();
    for (int i = 0; i < count; i++) {
      ItemsList.add(Items.fromMapObject(ItemsMapList[i]));
    }
    return ItemsList;
  }
}
