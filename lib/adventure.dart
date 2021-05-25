import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:reisebuech/add_text.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

import 'feed.dart';

class Adventure extends StatefulWidget {
  @override
  _AdventureState createState() => _AdventureState();
  DocumentReference<Object> adventure;
  Adventure(this.adventure);
}

class _AdventureState extends State<Adventure> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('adventures')
          .doc(widget.adventure.id)
          .snapshots(),
        builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
              break;
              default:
                  // Completed with error
                  if (snapshot.hasError) {
                    return Text("soawii, somethin wned wong :(");
                  }

                  return Scaffold(
                    body: SingleChildScrollView(
                      child: Container(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            child: Text(
                              snapshot.data['name'],
                              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)
                            ),
                            padding: EdgeInsets.all(8.0).add(EdgeInsets.only(top: 48.0)),
                          ),
                          Padding(
                            child: Divider(
                              color: Color(snapshot.data['color']),
                              thickness: 5.0,
                            ),
                            padding: EdgeInsets.only(right: 300, left: 10, bottom: 24),
                          ),
                          Feed(widget.adventure)
                        ],
                      )
                    )),
                    floatingActionButton: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        FloatingActionButton(
                          heroTag: "camera",
                          child: Icon(Icons.camera),
                          onPressed: () {
                            pickImage(context);
                          },
                        ),
                        FloatingActionButton(
                          heroTag: "text",
                          child: Icon(Icons.text_fields),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddText(widget.adventure)),
                            );
                          },
                        )
                      ],
                    ),
                  );
            }
        });
  }

  Future pickImage(BuildContext context) async {
    try {
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
    } catch (_) {}
  }

  Future addImageToDb(
    Future<TaskSnapshot> image, AssetEntity originalFile) async {
    String url = await (await image).ref.getDownloadURL();
    LatLng ll = await originalFile.latlngAsync();
    widget.adventure.collection('posts').add({
      'type': 'image',
      'file': url,
      'original-name': originalFile.title,
      'lat': ll.latitude,
      'lng': ll.longitude,
    });
  }
}
