import 'package:flutter/material.dart';

class AddAdventure extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Adventure"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextField(
                decoration: InputDecoration(
                  hintText: 'Adventure Name',
                ),
                style: TextStyle(
                  fontSize: 20.0,
                  height: 2.0,
                  color: Colors.black
                )
            )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: save
        },
        tooltip: 'Save a new Adventure',
        child: Icon(Icons.save),
      ), // This trailing comma,
    );
  }
}