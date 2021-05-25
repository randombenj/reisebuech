import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddText extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTextState();
  DocumentReference<Object> adventure;
  AddText(this.adventure);
}

class _AddTextState extends State<AddText> {
  TextEditingController titleController = new TextEditingController();
  TextEditingController textController = new TextEditingController();
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adventure Title"),
      ),
      body: Container(
        child: Padding(child: Column(
          children: [
            Text("test"),
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: "Title (optional)"),
            ),
            TextField(
              controller: textController,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              maxLines: null,
              decoration: InputDecoration(
                  labelText: "Tell something about your adventure!",
                  hintText: "Today I, ..."),
              // style: TextStyle(height: 10.0),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.green),
              onPressed: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now()).then((value) {
                      setState(() {
                        date = value;
                      });
                    });
              },
              child: Text("Date"),
            )
          ],
        ),
       padding: EdgeInsets.only(left: 8.0, right: 8.0))),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          widget.adventure.collection('posts').add({
            'type': 'text',
            'title': titleController.text,
            'text': textController.text,
            'time': date.toUtc()
          });
          Navigator.pop(context);
        },
      ),
    );
  }
}

void pickDate(BuildContext context) {}
