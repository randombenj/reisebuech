import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdventureCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference adventures =
        FirebaseFirestore.instance.collection('adventures');

    return FutureBuilder<QuerySnapshot>(
      future: adventures.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return actual_build(context, snapshot.data);
        }

        return Text("loading");
      },
    );
  }

  Widget actual_build(BuildContext context, QuerySnapshot<Object> data) {
    return new Container(
      child: Column(
      children: data.docs.map((QueryDocumentSnapshot<Object> adventure) {
        Map a = adventure.data();
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(a['name'],
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  '1.1.20 - 7.1.20',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Image.network(
                  "https://www.auslandsjob.de/wp-content/uploads/england-auslandsjob.jpg"),
            ],
          ),
        );
      }).toList(),
      ),
    );
  }
}
