import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../services/vehicle_service.dart';
import '../../services/parking_session_service.dart';
import '../../models/vehicle_model.dart';
import '../../models/parking_session_model.dart';

class FindMyRidePage extends StatefulWidget {
  const FindMyRidePage({super.key});

  @override
  State<FindMyRidePage> createState() => _FindMyRidePageState();
}

class _FindMyRidePageState extends State<FindMyRidePage> {
  bool showNavigation = false;
  final ParkingSessionService _parkingSessionService =
      ParkingSessionService();
  final VehicleService _vehicleService = VehicleService();

  // Default user location (universitas area)
  final LatLng userLocation = const LatLng(-6.9735, 107.6298);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Find My Ride"),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<ParkingSession?>(
        stream: _parkingSessionService.streamActiveParkingSession(),
        builder: (context, sessionSnapshot) {
          // Show loading indicator saat fetching data
          if (sessionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF800000)),
              ),
            );
          }

          // Jika tidak ada active parking session
          if (!sessionSnapshot.hasData || sessionSnapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 80,
                      color: const Color(0xFF800000).withOpacity(0.5),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "No active parking session",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Start a parking session to track your vehicle",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final parkingSession = sessionSnapshot.data!;

          // Fetch vehicle data berdasarkan vehicleId dari parking session
          return FutureBuilder<Vehicle?>(
            future: _vehicleService.getVehicle(parkingSession.vehicleId),
            builder: (context, vehicleSnapshot) {
              // Show loading indicator
              if (vehicleSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF800000)),
                  ),
                );
              }

              // Jika vehicle tidak ditemukan
              if (!vehicleSnapshot.hasData || vehicleSnapshot.data == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: const Color(0xFF800000).withOpacity(0.5),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Vehicle not found",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final vehicle = vehicleSnapshot.data!;
              
              // Get vehicle location from parking area (location mapping)
              // This ensures marker appears at correct area: Gate 3, TULT, GKU, etc.
              final vehicleLocation = _getLocationCoordinates(parkingSession.parkingArea);

              return _buildContent(
                vehicle,
                parkingSession,
                vehicleLocation,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(
    Vehicle vehicle,
    ParkingSession parkingSession,
    LatLng vehicleLocation,
  ) {
    // Determine icon berdasarkan vehicle type
    IconData vehicleIcon = vehicle.type == 'motor'
        ? Icons.motorcycle
        : Icons.directions_car;

    // Format parked time
    final parkedTime = _formatTime(parkingSession.parkedAt);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Vehicle Found",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 25),

          // Vehicle Info Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF800000).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  vehicleIcon,
                  size: 70,
                  color: const Color(0xFF800000),
                ),
                const SizedBox(height: 15),
                Text(
                  "${vehicle.brand} ${vehicle.model}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Currently Parked",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                _infoTile(
                  Icons.location_on,
                  "Location",
                  parkingSession.parkingArea,
                ),
                _infoTile(
                  Icons.local_parking,
                  "Slot",
                  parkingSession.parkingSlot,
                ),
                _infoTile(
                  Icons.directions_car,
                  "License Plate",
                  vehicle.licensePlate,
                ),
                _infoTile(
                  Icons.access_time,
                  "Parked Since",
                  parkedTime,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            "Parking Map",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Parking Slots Display - Dynamic based on location
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF800000).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildParkingMapDisplay(parkingSession),
          ),

          const SizedBox(height: 30),

          // Navigate Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.navigation),
              label: Text(
                showNavigation ? "Navigation Active" : "Navigate To Slot",
              ),
              onPressed: () {
                setState(() {
                  showNavigation = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Navigation Route Map
          if (showNavigation)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Navigation Route",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 450,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: vehicleLocation,
                      initialZoom: 18,
                    ),
                    children: [
                      TileLayer(
  urlTemplate:
      'https://a.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png',
),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [
                              userLocation,
                              vehicleLocation,
                            ],
                            strokeWidth: 5,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: userLocation,
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.person_pin_circle,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                          Marker(
                            point: vehicleLocation,
                            width: 80,
                            height: 80,
                            child: Icon(
                              vehicleIcon,
                              color: const Color(0xFF800000),
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Directions",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "1. Walk straight for 20 meters to ${parkingSession.parkingArea}",
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "2. Turn right to find your parking slot",
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "3. Your vehicle is located at Slot ${parkingSession.parkingSlot}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF800000),
          ),
          const SizedBox(width: 15),
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Build parking map display - dynamically shows slots based on parking location
  /// For TULT area: shows A21-A35 grid
  /// For other areas: shows actual slot name from backend
  Widget _buildParkingMapDisplay(ParkingSession parkingSession) {
    final location = parkingSession.parkingArea.toLowerCase();
    final slotName = parkingSession.parkingSlot;

    // For TULT area, show the A-series grid
    if (location.contains('tult') || location.isEmpty) {
      return Column(
        children: [
          _parkingRow(
            ["A21", "A22", "A23", "A24", "A25"],
            slotName,
          ),
          const SizedBox(height: 15),
          _parkingRow(
            ["A26", "A27", "A28", "A29", "A30"],
            slotName,
          ),
          const SizedBox(height: 15),
          _parkingRow(
            ["A31", "A32", "A33", "A34", "A35"],
            slotName,
          ),
        ],
      );
    }

    // For other areas (Gate 2, Gate 3, Gate 4, FIT-FIK, GKU), show actual backend slot
    return _buildSlotDisplayCard(location, slotName);
  }

  /// Build slot display card for non-TULT parking areas
  Widget _buildSlotDisplayCard(String location, String slotName) {
    // Capitalize location name properly
    final displayLocation = _formatLocationName(location);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Parking Location",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF800000),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                displayLocation,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF800000),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Slot: $slotName",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Icon(
                Icons.location_on,
                color: Color(0xFF800000),
                size: 32,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _parkingRow(List<String> slots, String currentSlot) {
    // Extract slot code from backend format
    // "TULT-MT-A27" -> "A27", "GATE-3-001" -> last part if numeric
    // For A-series, just take the format as is
    final extractedSlotCode = _extractSlotDisplay(currentSlot);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: slots.map((slot) {
        final bool isMyVehicle = slot == extractedSlotCode;

        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isMyVehicle ? const Color(0xFF800000) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMyVehicle
                  ? const Color(0xFF800000)
                  : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: isMyVehicle
                ? const Icon(
                    Icons.motorcycle,
                    color: Colors.white,
                  )
                : Text(
                    slot,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute WIB";
  }

  /// Extract slot display code for A-series slots
  /// Examples:
  ///   "TULT-MT-A27" -> "A27"
  ///   "A27" -> "A27"
  /// Returns last alphanumeric part after delimiter
  String _extractSlotDisplay(String slotName) {
    final normalized = slotName.trim().toUpperCase();
    
    // If contains delimiter, take the last part
    if (normalized.contains('-') || normalized.contains('_')) {
      final parts = normalized.split(RegExp(r'[-_]'));
      return parts.last;
    }
    
    return normalized;
  }

  /// Map parking location name to geographic coordinates
  /// Supports all parking areas on campus:
  /// MOTOR: FIT-FIK, TULT, GKU, GATE 4
  /// MOBIL: GATE 2, GATE 3
  LatLng _getLocationCoordinates(String location) {
  final normalizedLocation =
      location.toLowerCase().trim();

  if (normalizedLocation.contains('gate 2')) {
    return const LatLng(
      -6.9742,
      107.6310,
    );
  }

  if (normalizedLocation.contains('gate 3')) {
    return const LatLng(
      -6.9750,
      107.6320,
    );
  }

  if (normalizedLocation.contains('gate 4')) {
    return const LatLng(
      -6.9755,
      107.6330,
    );
  }

  if (normalizedLocation.contains('fit')) {
    return const LatLng(
      -6.9728,
      107.6290,
    );
  }

  if (normalizedLocation.contains('gku')) {
    return const LatLng(
      -6.9720,
      107.6280,
    );
  }

  return const LatLng(
    -6.9735,
    107.6298,
  );
}

  /// Format location name for display
  /// Converts lowercase/mixed case to proper capitalization
  String _formatLocationName(String location) {
    final normalized = location.trim();

    if (normalized.isEmpty) return 'Unknown Location';

    // Handle special cases
    if (normalized.toLowerCase().contains('gate')) {
      return 'Gate ${normalized.replaceAll(RegExp(r'[^0-9]'), '')}';
    }
    if (normalized.toLowerCase().contains('fit')) {
      return 'FIT-FIK';
    }
    if (normalized.toLowerCase().contains('tult')) {
      return 'TULT';
    }
    if (normalized.toLowerCase().contains('gku')) {
      return 'GKU';
    }

    // Default: capitalize first letter
    return normalized[0].toUpperCase() + normalized.substring(1).toLowerCase();
  }
}