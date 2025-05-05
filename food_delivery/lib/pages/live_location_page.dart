import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LiveLocationPage extends StatefulWidget {
  @override
  _LiveLocationPageState createState() => _LiveLocationPageState();
}

class _LiveLocationPageState extends State<LiveLocationPage> {
  Stream<Position>? positionStream;
  Position? currentPosition;
  String? locality, sublocality;

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return;
      }
    }

    // Start listening to location updates
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 10, // meters
      ),
    );

    positionStream!.listen((Position position) async {
      setState(() {
        currentPosition = position;
      });
      await getAddressFromLatLng(position);
    });
  }

Future<void> getAddressFromLatLng(Position position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );

  Placemark place = placemarks[0];
  setState(() {
    locality= place.locality;
    sublocality= place.subLocality;
  });
  // print('ADDRESS FROM LT ** ${place.street}, ${place.locality}, ${place.country} ${place.administrativeArea}');
  // print("${place.isoCountryCode} ${place.postalCode} ${place.subLocality}");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Location')),
      body: Center(
        child: currentPosition == null
            ? Text('Getting location...')
            : Text(
                'Lat: ${currentPosition!.latitude}, '
                'Lng: ${currentPosition!.longitude}'
                '\n $sublocality, $locality',
              ),
      ),
    );
  }
}
