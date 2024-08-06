import 'package:FlutterCompass/custom_painter.dart';
import 'package:FlutterCompass/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  CompassEvent? _lastRead;
  DateTime? _lastReadAt;

  @override
  void initState() {
    super.initState();
    final provider = context.read<LocationService>().currentDirection;
    debugPrint(" provider ${provider}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Flutter Compass'),
      ),
      body: Consumer<LocationService>(
        builder: (context, provider, _) {
          if (!provider.isLoading) {
            return Column(
              children: <Widget>[
                Card(
                  borderOnForeground: false,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                            "Latitude ${provider.currentLocation!.latitude}\nLongitude ${provider.currentLocation!.longitude}")
                      ],
                    ),
                  ),
                ),
                Expanded(child: _buildCompass()),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }

  Widget _buildManualReader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: const Text('Read Value'),
            onPressed: () async {
              final CompassEvent tmp = await FlutterCompass.events!.first;
              setState(() {
                _lastRead = tmp;
                _lastReadAt = DateTime.now();
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$_lastRead',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '$_lastReadAt',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        double? direction = snapshot.data?.heading;

        if (direction == null) {
          return const Center(
            child: Text("Device does not have sensors!"),
          );
        }

        return Center(
          child: CustomPaint(
            size: const Size(300, 300),
            painter: CompassPainter(direction),
          ),
        );
      },
    );
  }

  // Widget _buildPermissionSheet() {
  //   return Center(
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         const Text('Location Permission Required'),
  //         ElevatedButton(
  //           child: const Text('Request Permissions'),
  //           onPressed: () {
  //             Permission.locationWhenInUse.request().then((ignored) {
  //               _fetchPermissionStatus();
  //             });
  //           },
  //         ),
  //         const SizedBox(height: 16),
  //         ElevatedButton(
  //           child: const Text('Open App Settings'),
  //           onPressed: () {
  //             openAppSettings().then((opened) {
  //               //
  //             });
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}
