# 📍 Flutter Location Tracking App (MVVM + Riverpod)

A real-time location tracking module built using **Flutter**, **MVVM architecture**, and **Riverpod** for state management.  
The app fetches the user’s current location, converts coordinates into human-readable addresses (city, state, pincode), updates continuously when the user moves, and maintains an in-memory history of all locations.



## 🚀 Features
- **Location Permission Handling**
    - Requests Fine & Coarse location permissions
    - Handles denied / deniedForever states
    - Shows permission status in the UI

- **Current Location Display**
    - Latitude & Longitude
    - City, State, Pincode (via Google Geocoding API)
    - Last updated timestamp

- **Real-time Location Updates**
    - Uses `Geolocator.getPositionStream()`
    - Automatically updates UI
    - Adds new locations to history

- **Location History**
    - Shows previous coordinates with addresses
    - Includes timestamp for each location

### ⭐ Bonus Features
- **Google Map View**
    - Marker for current location
    - Optional polyline to show path/movement

- **Dark/Light Theme Toggle**



## 🛠️ Tech Stack

| Component | Library |
|----------|----------|
| State Management | Riverpod |
| Location Access | Geolocator |
| Permissions | Permission Handler |
| Reverse Geocoding | Google Geocoding API |
| Map View | google_maps_flutter |
| Architecture | MVVM |



 📂 Project Structure (MVVM)

lib/
├── core/
│ └── services/
│ └── location_service.dart
├── models/
│ └── location_model.dart
├── viewmodels/
│ └── location_viewmodel.dart
├── views/
│ ├── home_screen.dart
│ ├── map_screen.dart
│ └── components/
└── main.dart


🔑 Setup & Google API

1. Enable Google APIs:
    - Maps SDK for Android
    - Geocoding API

2. Add API key in `AndroidManifest.xml`:

xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY_HERE" />


