import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_location_app/viewmodels/location_viewmodel.dart';
import 'package:flutter_location_app/views/components/current_location_card.dart';
import 'package:flutter_location_app/views/components/history_list_widget.dart';
import 'package:flutter_location_app/views/map_screen.dart';
import 'package:flutter_location_app/main.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationViewModelProvider);
    final locationViewModel = ref.read(locationViewModelProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);
    final themeModeNotifier = ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
        actions: [
          Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeModeNotifier.state = value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeModeNotifier.state = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Permission Status Box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location Permission Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  locationState.permissionStatus == LocationPermission.whileInUse ||
                          locationState.permissionStatus ==
                              LocationPermission.always
                      ? 'Granted'
                      : 'Denied',
                  style: TextStyle(
                    color: locationState.permissionGranted ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!locationState.permissionGranted && !locationState.isLoading)
                  ElevatedButton(
                    onPressed: () {
                      locationViewModel.checkAndRequestPermission();
                    },
                    child: const Text('Request Permission Again'),
                  ),
              ],
            ),
          ),

          // Current Location Card
          const CurrentLocationCard(),

          // Open Map View Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
              child: const Text('Open Map View'),
            ),
          ),

          // History List
          const HistoryListWidget(),
        ],
      ),
    );
  }
}
