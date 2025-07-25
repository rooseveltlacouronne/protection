import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Map<String, double>?> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    final position = await Geolocator.getCurrentPosition();
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
  }
}