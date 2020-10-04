import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

class Items {
  int _id;
  String _itemName;
  String _itemDescription;
  String _date;
  Items(this._id, this._itemName, this._itemDescription, this._date);

  int get id => _id; // getter method for getting id in class
  String get date // getter method for getting date in class
  {
    return _date;
  }
  void display()
  {
    print(this._id);
    print(this._itemDescription);
    print("it has come here");
  }

  String get itemName // getter method for getting itemName in class
  {
    return _itemName;
  }

  String get itemDescription // getter method for getting item description  in class
  {
    return _itemDescription;
  }

  set itemName(String newName) {
    if (newName.length <= 255) this._itemName = newName;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['itemName'] = _itemName;
    map['itemDescription'] = _itemDescription;
    print("Here is the item decription that you want $itemDescription");
    map['date'] = _date;
    return map;
  }
  Items.fromMapObject(Map<String,dynamic> map)
  {
    this._id=map['id'];
    this._itemDescription=map['itemDescription'];
    this._itemName=map['itemName'];
    this._date=map['date'];

  }
}

// Open the database and store the reference.
