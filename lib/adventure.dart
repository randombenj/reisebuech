import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reisebuech/add_text.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
}

Future<List<AssetEntity>> pickImage(BuildContext context) async {
  return AssetPicker.pickAssets(context, textDelegate: EnglishTextDelegate());
}
