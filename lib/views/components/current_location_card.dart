import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_location_app/models/location_model.dart';
import 'package:flutter_location_app/viewmodels/location_viewmodel.dart';

class CurrentLocationCard extends ConsumerWidget {
  const CurrentLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationViewModelProvider);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Location',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            locationState.currentLocation.when(
              data: (location) {
                if (location == null) {
                  return const Text('Location data not available.');
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Latitude: ${location.latitude}'),
                    Text('Longitude: ${location.longitude}'),
                    Text('City: ${location.city}'),
                    Text('State: ${location.state}'),
                    Text('Pincode: ${location.pincode}'),
                    Text('Last Updated: ${location.formattedTimestamp}'),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: ${e.toString()}'),
            ),
          ],
        ),
      ),
    );
  }
}


