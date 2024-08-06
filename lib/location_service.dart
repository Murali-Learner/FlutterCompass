import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationService extends ChangeNotifier {
  final Location _location = Location();
  double _currentDirection = 0.0;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  LocationData? _currentLocation;

  LocationData? get currentLocation => _currentLocation;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  double get currentDirection => _currentDirection;

  LocationService() {
    _init();
  }

  Future<void> _init() async {
    setIsLoading(true);
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _location.onLocationChanged.listen((LocationData location) {
      _currentDirection = location.heading ?? 0.0;
      _currentLocation = location;
      debugPrint(
          "Current Direction: $_currentDirection ${_currentLocation!.latitude} ${_currentLocation!.longitude}");
      notifyListeners();
    });
    setIsLoading(false);
  }
}
