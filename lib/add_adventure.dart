import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAdventure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference adventures =
        FirebaseFirestore.instance.collection('adventures');
    TextEditingController adventureController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Adventure"),
      ),
      body: Column(children: [
        Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
              controller: adventureController,
              decoration: InputDecoration(
                hintText: 'Adventure Name',
              ),
              style:
                  TextStyle(fontSize: 20.0, height: 2.0, color: Colors.black),
            ))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          adventures.add({'name': adventureController.text});
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Adventure " + adventureController.text + " added!"),
          ));
          Navigator.pop(context);
        },
        tooltip: 'Save a new Adventure',
        child: Icon(Icons.save),
      ), // This trailing comma,
    );
  }
}
