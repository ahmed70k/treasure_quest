import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;
import '../../models/treasure_model.dart';
import 'treasure_service.dart';

class HomeScreenLogic extends ChangeNotifier {
  final TreasureService _treasureService = TreasureService();
  
  List<TreasureModel> _treasures = [];
  Position? _currentPosition;
  Position? _startPosition;
  Set<Marker> _markers = {};
  double _virtualX = 0;
  double _virtualY = 0;
  double _gpsX = 0;
  double _gpsY = 0;
  double _rotationAngle = 0; // in degrees
  bool _isUsingJoystick = false;

  List<TreasureModel> get treasures => _treasures;
  Position? get currentPosition => _currentPosition;
  Set<Marker> get markers => _markers;
  double get virtualX => _virtualX;
  double get virtualY => _virtualY;
  double get gpsX => _gpsX;
  double get gpsY => _gpsY;
  double get rotationAngle => _rotationAngle;
  bool get isMoving => _isUsingJoystick || (speed > 0.5);
  double get speed => _currentPosition?.speed ?? 0;
  Map<String, Offset> getTreasureOffsets(double screenWidth, double screenHeight) {
    if (_startPosition == null) return {};
    
    Map<String, Offset> offsets = {};
    for (var treasure in _treasures) {
      double dy = (_startPosition!.latitude - treasure.latitude) * 111111 * 5;
      double dx = (treasure.longitude - _startPosition!.longitude) * 111111 * 
                  math.cos(treasure.latitude * math.pi / 180) * 5;
      
      // Center relative to screen center
      offsets[treasure.id] = Offset(
        (screenWidth / 2 - 25) + dx, // 25 is half size of treasure icon
        (screenHeight / 2 - 25) + dy,
      );
    }
    return offsets;
  }

  void updateJoystick(double dx, double dy) {
    if (dx == 0 && dy == 0) {
      _isUsingJoystick = false;
    } else {
      _isUsingJoystick = true;
      // Update virtual position based on joystick input
      _virtualX += dx * 5; // sensitivity
      _virtualY += dy * 5;
      
      // Calculate rotation angle based on joystick direction (dy is inverted in screen coords)
      _rotationAngle = math.atan2(dx, -dy) * 180 / math.pi;
    }
    notifyListeners();
  }

  HomeScreenLogic() {
    _init();
  }

  void _init() {
    // Listen to active treasures
    _treasureService.getActiveTreasures().listen((data) {
      _treasures = data;
      _updateMarkers();
      notifyListeners();
    });

    // Track user location with High Accuracy
    _determinePosition().then((pos) {
      _currentPosition = pos;
      _startPosition = pos;
      
      // Setting high accuracy and 0 distance filter for maximum responsiveness
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, 
      );

      Geolocator.getPositionStream(locationSettings: locationSettings).listen((position) {
        if (_startPosition == null) _startPosition = position;
        _currentPosition = position;
        
        // Calculate displacement in meters
        // Latitude: 1 deg ≈ 111,111 meters
        double deltaY = (_startPosition!.latitude - position.latitude) * 111111;
        // Longitude: 1 deg ≈ 111,111 * cos(lat) meters
        double deltaX = (position.longitude - _startPosition!.longitude) * 111111 * 
                        math.cos(position.latitude * math.pi / 180);

        // Visual scaling (multiplied by 5 to see it on screen)
        _gpsY = deltaY * 5;
        _gpsX = deltaX * 5;

        // Update rotation based on heading if moving
        if (!_isUsingJoystick && position.heading >= 0 && position.speed > 0.2) {
          _rotationAngle = position.heading;
        }

        notifyListeners();
      });
    }).catchError((e) {
      debugPrint('Error determining position: $e');
    });
  }

  void _updateMarkers() {
    _markers = _treasures.map((treasure) {
      return Marker(
        markerId: MarkerId(treasure.id),
        position: LatLng(treasure.latitude, treasure.longitude),
        infoWindow: InfoWindow(
          title: treasure.title,
          snippet: '${treasure.rewardPoints} PTS',
        ),
      );
    }).toSet();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

    return await Geolocator.getCurrentPosition();
  }

  double calculateDistance(double destLat, double destLng) {
    if (_currentPosition == null) return double.infinity;
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      destLat,
      destLng,
    );
  }
  
  bool isWithinRange(double destLat, double destLng, {double range = 20.0}) {
    return calculateDistance(destLat, destLng) <= range;
  }
}
