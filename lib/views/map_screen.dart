import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter_location_app/viewmodels/location_viewmodel.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationViewModelProvider);

    Set<Marker> markers = {};
    Set<Polyline> polylines = {};

    LatLng? currentLocationLatLng;

    locationState.currentLocation.whenData((location) {
      if (location != null) {
        currentLocationLatLng = LatLng(location.latitude, location.longitude);
        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: currentLocationLatLng!,
            infoWindow: InfoWindow(
              title: 'Current Location',
              snippet: 'Lat: \${location.latitude}, Lng: \${location.longitude}',
            ),
          ),
        );
      }
    });

    if (locationState.history.isNotEmpty) {
      final historyLatLngs = locationState.history
          .map((loc) => LatLng(loc.latitude, loc.longitude))
          .toList();

      polylines.add(
        Polyline(
          polylineId: const PolylineId('locationHistory'),
          points: historyLatLngs,
          color: Colors.blue,
          width: 5,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: currentLocationLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLocationLatLng!,
                zoom: 15,
              ),
              markers: markers,
              polylines: polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}


