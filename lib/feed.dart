import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latlong;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Feed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedState();
  DocumentReference<Object> adventure;
  Feed(this.adventure);
}

class _FeedState extends State<Feed> {

  latlong.LatLng computeCentroid(List<latlong.LatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    points.forEach((point) {
      latitude += point.latitude;
      longitude += point.longitude;
    });

    return latlong.LatLng(latitude/n, longitude/n);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.adventure.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        List<latlong.LatLng> locations = snapshot.data.docs
          .where((p) => p["type"] == "image")
          .where((p) => p["lat"] > 0).map((QueryDocumentSnapshot<Object> adventure) {
            Map a = adventure.data();
            return latlong.LatLng(a["lat"], a["lng"]);
          }).toList();

        List<Marker> mapMarker = locations.map((latlong.LatLng loc) {
          return Marker(
            width: 40,
            height: 40,
            point: loc,
            builder: (ctx) => Container(child: Icon(Icons.place, color: Colors.red))
          );
        }).toList();

        List<Widget> content = [];

        latlong.LatLng center;
        if (locations.length > 1) {
          center = computeCentroid(locations);
        } else if (locations.length == 1) {
          center = locations.first;
        }

        if (locations.length > 0) {
          content.add(
            Container(
              height: (MediaQuery.of(context).size.height / 2),
              child: Positioned(
                left: 0.0,
                child: Container(
                  height: (MediaQuery.of(context).size.height),
                  width: (MediaQuery.of(context).size.width),
                  child: FlutterMap(
                    options: MapOptions(
                      center: center,
                      zoom: 8.0,
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
          );
        }

        content.addAll(
          // add all the content after the map
          snapshot.data.docs.map((QueryDocumentSnapshot<Object> adventure) {
            Map a = adventure.data();
            Widget content = Text("");
            switch (a['type']) {
              case 'text':
                if (a['title'] != "") {
                  content = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['title'],
                        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)
                      ),
                      Text(
                        a['text'],
                        style: TextStyle(fontSize: 24.0)
                      )
                    ]
                  );
                } else {
                  content = Text(
                    a['text'],
                    style: TextStyle(fontSize: 24.0)
                  );
                }
                break;
              case 'image':
                content = Image.network(a['file']);
                break;
              break;
            }
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: content// Text(a['type'])
            );
          }).toList()
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: content,
        );
      });
  }
}
