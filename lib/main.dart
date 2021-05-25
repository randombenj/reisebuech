import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' as latlong;
import 'package:flutter_map/flutter_map.dart';
import 'package:reisebuech/add_adventure.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'adventure_cards.dart';
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
         buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
            accentColor: Colors.black,
            primaryColor: Colors.black
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
            return CircularProgressIndicator();
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
              Image.asset("assets/adventure.png"),
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


