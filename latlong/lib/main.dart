import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_elevation/map_elevation.dart';

import 'data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ElevationPoint? hoverPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Stack(children: [
        FlutterMap(
          options: new MapOptions(
            center: LatLng(45.10, 5.48),
            zoom: 11.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayerOptions(
              // Will only render visible polylines, increasing performance
              polylines: [
                Polyline(
                  // An optional tag to distinguish polylines in callback
                  points: getPoints(),
                  color: Colors.red,
                  strokeWidth: 3.0,
                ),
              ],
            ),
            MarkerLayerOptions(markers: [
              if (hoverPoint is LatLng)
                Marker(
                    point: hoverPoint!,
                    width: 8,
                    height: 8,
                    builder: (BuildContext context) => Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8)),
                        ))
            ]),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            color: Colors.white.withOpacity(0.6),
            child: NotificationListener<ElevationHoverNotification>(
                onNotification: (ElevationHoverNotification notification) {
                  setState(() {
                    hoverPoint = notification.position;
                  });

                  return true;
                },
                child: Elevation(
                  getPoints(),
                  color: Colors.grey,
                  elevationGradientColors: ElevationGradientColors(
                      gt10: Colors.green,
                      gt20: Colors.orangeAccent,
                      gt30: Colors.redAccent),
                )),
          ),
        )
      ]),
    );
  }
}