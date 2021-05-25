import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reisebuech/adventure.dart';

class AdventureCards extends StatefulWidget {
  @override
  _AdventureCardsState createState() => _AdventureCardsState();
}

class _AdventureCardsState extends State<AdventureCards> {
  final Stream<QuerySnapshot> _adventuresStream =
      FirebaseFirestore.instance.collection('adventures').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _adventuresStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return new Container(
            child: Column(
              children: snapshot.data.docs
                  .map((QueryDocumentSnapshot<Object> adventure) {
                Map a = adventure.data();
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Adventure(adventure.reference)),
                      );
                    },
                    child: Padding(padding: EdgeInsets.all(8.0), child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0), textAlign: TextAlign.right),
                                Padding(
                                  child: Divider(
                                    color: Color(a['color']),
                                    thickness: 3.0,
                                  ),
                                  padding: EdgeInsets.only(right: 300),
                                )
                              ],
                            ),
                            subtitle: Text(
                              DateFormat('dd.MM.yyyy').format((a['start']as Timestamp).toDate()) + " - " +DateFormat('dd.MM.yyyy').format((a['end']as Timestamp).toDate()),
                              style: TextStyle(
                              color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Image.network("https://www.auslandsjob.de/wp-content/uploads/england-auslandsjob.jpg"),
                        ],
                      ),
                    )));
              }).toList(),
            ),
          );
        });
  }
}
