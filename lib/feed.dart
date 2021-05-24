import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Feed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedState();
  DocumentReference<Object> adventure;
  Feed(this.adventure);
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: widget.adventure.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Column(children:
              snapshot.data.docs.map((QueryDocumentSnapshot<Object> adventure) {
            Map a = adventure.data();
            switch (a['type']){
              case 'text':
                return Text(a['text']);
              case 'image':
                return  Image.network(a['file']);
              break;
            }
            return Row(children: [Text(a['type'])]);
          }).toList());
        });
  }
}
