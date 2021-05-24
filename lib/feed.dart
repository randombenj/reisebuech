import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latlong;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';

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

          List<Marker> mapMarker = snapshot.data.docs
            .where((p) => p["type"] == "image")
            .where((p) => p["lat"] >= 0).map((QueryDocumentSnapshot<Object> adventure) {
              Map a = adventure.data();
              return Marker(
                width: 40,
                height: 40,
                point: latlong.LatLng(a["lat"], a["lng"]),
                builder: (ctx) => Container(child: Icon(Icons.place, color: Colors.red))
              );
            }).toList();

          List<Widget> content = [
            Container(
              height: (MediaQuery.of(context).size.height / 2),
              child: Positioned(
                left: 0.0,
                child: Container(
                  height: (MediaQuery.of(context).size.height),
                  width: (MediaQuery.of(context).size.width),
                  child: FlutterMap(
                    options: MapOptions(
                      center: latlong.LatLng(51.5, -0.09),
                      zoom: 2.0,
                    ),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: "http://{s}.tile.stamen.com/toner/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']
                      ),
                      MarkerLayerOptions(
                        markers: mapMarker,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ];

          content.addAll(
            // add all the content after the map
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
            }).toList()
          );

          return Column(
            children: content,
          );
        });
  }
}
