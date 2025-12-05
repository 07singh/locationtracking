import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_location_app/models/location_model.dart';
import 'package:flutter_location_app/viewmodels/location_viewmodel.dart';

class HistoryListWidget extends ConsumerWidget {
  const HistoryListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationViewModelProvider);
    final history = locationState.history.reversed.toList(); // Show newest first

    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (history.isEmpty)
                const Text('No location history available.')
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final location = history[index];
                      return ListTile(
                        title: Text(
                            '${location.city}, ${location.state} (${location.pincode})'),
                        subtitle: Text(
                            'Lat: ${location.latitude}, Lng: ${location.longitude} - ${location.formattedTimestamp}'),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}


