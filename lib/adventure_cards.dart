import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
                            builder: (context) => Adventure(adventure)),
                      );
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(a['name'],
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              '1.1.20 - 7.1.20',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Image.network(
                              "https://www.auslandsjob.de/wp-content/uploads/england-auslandsjob.jpg"),
                        ],
                      ),
                    ));
              }).toList(),
            ),
          );
        });
  }
}

//   CollectionReference adventures =
//       FirebaseFirestore.instance.collection('adventures');

//   return FutureBuilder<QuerySnapshot>(
//     future: adventures.get(),
//     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//       if (snapshot.connectionState == ConnectionState.done) {
//         return actual_build(context, snapshot.data);
//       }

//       return Text("loading");
//     },
//   );
// }

// Widget actual_build(BuildContext context, QuerySnapshot<Object> data) {

// }
