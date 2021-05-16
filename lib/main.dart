import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:flutter_map/flutter_map.dart';
import 'package:reisebuech/add_adventure.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'adventure_cars.dart';
void main() {
  runApp(MyApp());
}

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReiseBuech',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: MyHomePage(title: 'Saletti Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  AnimationController _controller;

  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Text("soawii, somethin wned wong :(");
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return buildActualApp(context);
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return Text("loading");
          },
        );
  }

  Widget buildActualApp(BuildContext context)
  {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 24.0),
        child:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  height: (MediaQuery.of(context).size.height),
                  child: new Stack(
                  children: <Widget>[
                    Positioned(
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
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: latlong.LatLng(51.5, -0.09),
                                  builder: (ctx) =>
                                  Container(
                                    child: FlutterLogo(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      width: (MediaQuery.of(context).size.width),
                      bottom: 36.0,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _controller,
                          child: Icon(Icons.arrow_downward, size: 36.0, color: Colors.white),
                          builder: (BuildContext context, Widget child) {
                            return Transform.translate(
                              offset: Offset(0.0, _controller.value * 10),
                              child: child
                            );
                          }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AdventureCards(),
              
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAdventure()),
          );
        },
        tooltip: 'Add a new Adventure',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<List<AssetEntity>> pickImage(BuildContext context) async {
  return AssetPicker.pickAssets(context, textDelegate: EnglishTextDelegate());
}
