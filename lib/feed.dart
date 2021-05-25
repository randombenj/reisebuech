import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:latlong/latlong.dart' as latlong;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class Feed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FeedState();
  DocumentReference<Object> adventure;
  Color color;
  Feed(this.adventure, this.color);
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
      stream: widget.adventure.collection('posts').orderBy("time", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.error != null) {
          return Text("Ooooops something went wrong");
        }

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
              height: 200.0,
              width: (MediaQuery.of(context).size.width),
              child: FlutterMap(
                options: MapOptions(
                  center: center,
                  zoom: 9.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "http://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']
                  ),
                  MarkerLayerOptions(
                    markers: mapMarker,
                  ),
                ],
              ),
            ),
          );
        }

        int count = 0;
        List<String> images = [];
        content.addAll(
          // add all the content after the map
        snapshot.data.docs.map((QueryDocumentSnapshot<Object> adventure) {
          count++;
          Map a = adventure.data();
          Widget content = null;


          switch (a['type']) {
            case 'text':
              if (a['title'] != "") {
                content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a['title'],
                      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: widget.color)
                    ),
                    Text(
                      a['text'],
                      style: TextStyle(fontSize: 20.0)
                    )
                  ]
                );
              } else {
                content = Text(
                  a['text'],
                  style: TextStyle(fontSize: 20.0)
                );
              }
              break;
            case 'image':
              images.add(a['file']);
              break;
          }


          if (images.length > 0 && (count + 1 == snapshot.data.docs.length || (count + 1 < snapshot.data.docs.length && snapshot.data.docs[count]['type'] == 'text'))) {
            debugPrint("Gridview with  length ${images.length}, cnt: $count snapshot.data.docs.length: ${snapshot.data.docs.length}");


            List<Widget> imageList = [];
            if (images.length % 2 == 1) {
              var imgUrl = images.removeAt(0);
              imageList.add(
                CachedNetworkImage(
                  imageUrl: imgUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              );
            }

            if (images.length > 0) {
              imageList.add(GridView.count(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: images.map((img) => FittedBox(
                  child: CachedNetworkImage(
                    imageUrl: img,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                )).toList()
              ));
            }

            content = Column(children: imageList);
            images = [];
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
