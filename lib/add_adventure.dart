import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import 'adventure.dart';
import 'main.dart';

class AddAdventure extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddAdventureState();
}

class _AddAdventureState extends State<AddAdventure> {
  DateTimeRange timeRange = DateTimeRange(
      start: DateTime.now(), end: DateTime.now().add(Duration(days: 7)));
  CollectionReference adventures =
      FirebaseFirestore.instance.collection('adventures');
  TextEditingController adventureController = new TextEditingController();
  Color color = Colors.black;
  String dateText = "";
  @override
  Widget build(BuildContext context) {
    setDateTime(timeRange);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Adventure"),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                controller: adventureController,
                decoration: InputDecoration(
                  hintText: 'Adventure Name',
                ),
                style:
                    TextStyle(fontSize: 20.0, height: 2.0, color: Colors.black),
              )),
          Padding(
              child: Row(children: [
                Text("Date of your adventure: "),
                Text(dateText),
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    showDateRangePicker(
                            context: context,
                            currentDate: DateTime.now(),
                            initialDateRange: timeRange,
                            lastDate: DateTime(2100),
                            firstDate: DateTime(2000))
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          setDateTime(value);
                        });
                      }
                    });
                  },
                  child: Text("change"),
                )
              ]),
              padding: EdgeInsets.only(left: 8.0, right: 8.0)),
          Padding(
              child: Row(
                children: [
                  Text("Color: "),
                  TextButton(
                      style: TextButton.styleFrom(
                          primary: color, backgroundColor: color),
                      onPressed: () {
                        ColorPicker(onColorChanged: (value) {
                          setState(() {
                            color = value;
                          });
                        }).showPickerDialog(context);
                      },
                      child: Text("Change the color of your adventure!"))
                ],
              ),
              padding: EdgeInsets.only(left: 8.0, right: 8.0))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          adventures.add({
            'name': adventureController.text,
            'start': timeRange.start.toUtc(),
            'end': timeRange.end.toUtc(),
            'color': color.value
          }).then((adventure) {
            Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Adventure(adventure)),
                  ModalRoute.withName('/')
                );
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Adventure " + adventureController.text + " added!"),
            ));
        },
        tooltip: 'Save a new Adventure',
        child: Icon(Icons.save),
      ),
    );
  }

  void setDateTime(DateTimeRange range) {
    timeRange = range;
    dateText = DateFormat('dd.MM.yyyy').format(timeRange.start);
  }
}
