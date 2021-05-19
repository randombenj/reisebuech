import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:reisebuech/add_text.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class Adventure extends StatelessWidget {
  QueryDocumentSnapshot<Object> adventure;
  Adventure(this.adventure);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text(adventure['name']),
      ),
      floatingActionButton: Row(
        textDirection: TextDirection.rtl,
        children: [
          FloatingActionButton(
            child: Icon(Icons.camera),
            onPressed: () {
              pickImage(context);
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.text_fields),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddText()),
              );
            },
          )
        ],
      ),
    );
  }

  Future pickImage(BuildContext context) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
    List<AssetEntity> images = await AssetPicker.pickAssets(context,
        textDelegate: EnglishTextDelegate());
    return Future.wait(images.map((image) async {
      File file = await image.file;
      String name = Uuid().v1() + image.title;
      Future<TaskSnapshot> taskSnapshot = storage.ref(name).putFile(file);
      return addImageToDb(taskSnapshot, image);
    }));
  }

  Future addImageToDb(
      Future<TaskSnapshot> image, AssetEntity originalFile) async {
    String url = await (await image).ref.getDownloadURL();
    LatLng ll = await originalFile.latlngAsync();
    adventure.reference.collection('images').add({
      'file': url,
      'original-name': originalFile.title,
      'lat': ll.latitude,
      'lng': ll.longitude,
    });
  }
}
