import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:reisebuech/add_adventure.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //appBar: AppBar(
      //  title: Text(widget.title),
      //),
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
                            center: LatLng(51.5, -0.09),
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
                                  point: LatLng(51.5, -0.09),
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
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text(
                        'Reis Eis',
                        style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      subtitle: Text(
                        '1.1.20 - 7.1.20',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                    ),
                    Image.network("https://www.auslandsjob.de/wp-content/uploads/england-auslandsjob.jpg"),
                  ],
                ),
              ),
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
