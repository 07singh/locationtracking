import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/services/location_service.dart';
import '../core/services/geocoding_service.dart';
import '../core/utils/mapper.dart';
import '../models/location_model.dart';

final locationServiceProvider = Provider((ref) => LocationService());
final geocodingServiceProvider = Provider((ref) => GeocodingService());

final locationViewModelProvider =
    StateNotifierProvider<LocationViewModel, LocationState>((ref) {
  return LocationViewModel(
    ref.watch(locationServiceProvider),
    ref.watch(geocodingServiceProvider),
  );
});

class LocationState {
  final AsyncValue<LocationDataModel?> currentLocation;
  final List<LocationDataModel> history;
  final bool permissionGranted;
  final bool isLoading;
  final LocationPermission permissionStatus;

  LocationState({
    required this.currentLocation,
    required this.history,
    required this.permissionGranted,
    required this.isLoading,
    required this.permissionStatus,
  });

  LocationState copyWith({
    AsyncValue<LocationDataModel?>? currentLocation,
    List<LocationDataModel>? history,
    bool? permissionGranted,
    bool? isLoading,
    LocationPermission? permissionStatus,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      history: history ?? this.history,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      isLoading: isLoading ?? this.isLoading,
      permissionStatus: permissionStatus ?? this.permissionStatus,
    );
  }
}

class LocationViewModel extends StateNotifier<LocationState> {
  final LocationService _locationService;
  final GeocodingService _geocodingService;

  LocationViewModel(this._locationService, this._geocodingService)
      : super(LocationState(
          currentLocation: const AsyncValue.loading(),
          history: [],
          permissionGranted: false,
          isLoading: true,
          permissionStatus: LocationPermission.denied,
        )) {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await checkAndRequestPermission();
    if (state.permissionGranted) {
      await _getCurrentLocation();
      _startLocationStream();
    }
  }

  Future<void> checkAndRequestPermission() async {
    state = state.copyWith(isLoading: true);
    final permissionStatus = await _locationService.checkPermission();
    bool granted = permissionStatus == LocationPermission.whileInUse ||
        permissionStatus == LocationPermission.always;

    if (!granted) {
      granted = await _locationService.requestPermission();
    }

    state = state.copyWith(
      permissionGranted: granted,
      permissionStatus: permissionStatus,
      isLoading: false,
    );
  }

  Future<void> _getCurrentLocation() async {
    if (!state.permissionGranted) return;
    try {
      state = state.copyWith(isLoading: true);
      final position = await _locationService.getCurrentPosition();
      final address = await _geocodingService.getAddressFromLatLng(
          position.latitude, position.longitude);
      final locationData =
          LocationMapper.fromPositionAndAddress(position, address);
      state = state.copyWith(
        currentLocation: AsyncValue.data(locationData),
        history: [...state.history, locationData],
        isLoading: false,
      );
    } catch (e, st) {
      state = state.copyWith(
          currentLocation: AsyncValue.error(e, st), isLoading: false);
    }
  }

  void _startLocationStream() {
    if (!state.permissionGranted) return;
    _locationService.getPositionStream().listen((position) async {
      final address = await _geocodingService.getAddressFromLatLng(
          position.latitude, position.longitude);
      final locationData =
          LocationMapper.fromPositionAndAddress(position, address);
      state = state.copyWith(
        currentLocation: AsyncValue.data(locationData),
        history: [...state.history, locationData],
      );
    }).onError((e, st) {
      state = state.copyWith(currentLocation: AsyncValue.error(e, st));
    });
  }

  void openAppSettings() {
    openAppSettings();
  }
}


