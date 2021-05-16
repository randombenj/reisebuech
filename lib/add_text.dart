import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adventure Title"),
      ),
      body: Container(
        child: Column(
          children: [
            Text("test"),
            TextField(
              decoration: InputDecoration(labelText: "Title (optional)"),
            ),
            TextField(
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.bottom,
              maxLines: null,
              decoration: InputDecoration(labelText: "Tell something about your adventure!", hintText: "Today I, ..."),
              // style: TextStyle(height: 10.0),
            ),
            TextButton(
              style: TextButton.styleFrom(primary: Colors.green),
              onPressed: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now());
              },
              child: Text("Date"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {},
      ),
    );
  }
}

void pickDate(BuildContext context) {}
