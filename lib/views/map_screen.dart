import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_location_app/viewmodels/location_viewmodel.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _currentLatLng;

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationViewModelProvider);

    // Schedule update after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (locationState.currentLocation.value != null) {
        final location = locationState.currentLocation.value!;
        final newLatLng = LatLng(location.latitude, location.longitude);

        setState(() {
          _currentLatLng = newLatLng;

          _markers = {
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: newLatLng,
              infoWindow: InfoWindow(
                title: 'Current Location',
                snippet:
                'Lat: ${location.latitude}, Lng: ${location.longitude}',
              ),
            ),
          };

          if (locationState.history.isNotEmpty) {
            final historyLatLngs = locationState.history
                .map((loc) => LatLng(loc.latitude, loc.longitude))
                .toList();

            _polylines = {
              Polyline(
                polylineId: const PolylineId('locationHistory'),
                points: historyLatLngs,
                color: Colors.blue,
                width: 5,
              ),
            };
          }

          // Move camera
          _mapController?.animateCamera(CameraUpdate.newLatLng(newLatLng));
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Map View')),
      body: _currentLatLng == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition:
        CameraPosition(target: _currentLatLng!, zoom: 15),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
