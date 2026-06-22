import 'package:flutter/material.dart';
import '../../services/vehicle_service.dart';
import '../../services/parking_session_service.dart';
import '../../models/vehicle_model.dart';
import '../../models/parking_session_model.dart';
import 'package:url_launcher/url_launcher.dart';

class FindMyRidePage extends StatefulWidget {
  const FindMyRidePage({super.key});

  @override
  State<FindMyRidePage> createState() => _FindMyRidePageState();
}

class _FindMyRidePageState extends State<FindMyRidePage> {
  // Instance service (Sesuaikan dengan inisialisasi pada project Anda)
  final ParkingSessionService _parkingSessionService = ParkingSessionService();
  final VehicleService _vehicleService = VehicleService();

  /// Fungsi untuk mendapatkan link Google Maps berdasarkan nama lokasi secara akurat
  String _getGoogleMapsLink(String location) {
    // Normalisasi teks: hapus spasi di awal/akhir dan ubah ke huruf kecil semua
    final loc = location.trim().toLowerCase();

    // Pengecekan berbasis kata kunci spesifik menggunakan Regular Expression 
    // untuk menghindari ambiguitas antar Gate.
    if (loc.contains(RegExp(r'gate\s*3'))) {
      return 'https://maps.app.goo.gl/twJ3Gi8HSd4tvBCJ9';
    }
    if (loc.contains(RegExp(r'gate\s*2'))) {
      return 'https://maps.app.goo.gl/JP63eQkhiwkLEHfh7';
    }
    if (loc.contains('gku')) {
      return 'https://maps.app.goo.gl/edtzKAnebVh5QGw9A';
    }
    if (loc.contains('tult')) {
      return 'https://maps.app.goo.gl/eLLcZ66LoLGtjpcT6';
    }
    if (loc.contains(RegExp(r'gate\s*4'))) {
      return 'https://maps.app.goo.gl/q6pHMpcRXQJPtER56';
    }
    if (loc.contains('fik') || loc.contains('fit')) {
      return 'https://maps.app.goo.gl/ALtH8kG33er5mLxZ6';
    }

    // Fallback/Default jika lokasi tidak dikenali (bisa diarahkan ke link default)
    return 'https://maps.google.com';
  }

  /// Fungsi untuk mengeksekusi URL eksternal ke Google Maps
  Future<void> _openGoogleMaps(String location) async {
    final url = _getGoogleMapsLink(location);
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka peta rute ke $location')),
        );
      }
    }
  }

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
          // Menampilkan indikator loading saat memuat sesi parkir
          if (sessionSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF800000)),
              ),
            );
          }

          // Jika data kosong atau tidak ada sesi parkir aktif
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

          // Memuat data kendaraan berdasarkan ID kendaraan dari sesi parkir
          return FutureBuilder<Vehicle?>(
            future: _vehicleService.getVehicle(parkingSession.vehicleId),
            builder: (context, vehicleSnapshot) {
              if (vehicleSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF800000)),
                  ),
                );
              }

              // Jika data kendaraan tidak ditemukan di database
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

              return _buildContent(
                vehicle,
                parkingSession,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(Vehicle vehicle, ParkingSession parkingSession) {
    // Menentukan ikon berdasarkan jenis kendaraan
    IconData vehicleIcon = vehicle.type == 'motor'
        ? Icons.motorcycle
        : Icons.directions_car;

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

          // Kartu Informasi Kendaraan
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

          // Tampilan Grid Slot Parkir
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFF800000).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildParkingMapDisplay(parkingSession),
          ),

          const SizedBox(height: 35),

          // Tombol Utama Navigasi Eksternal ke Google Maps
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openGoogleMaps(parkingSession.parkingArea),
              icon: const Icon(Icons.map),
              label: const Text(
                'Open in Google Maps',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Tap the button to navigate directly to ${parkingSession.parkingArea}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF800000)),
          const SizedBox(width: 15),
          Text(
            "$title : ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildParkingMapDisplay(ParkingSession parkingSession) {
    final location = parkingSession.parkingArea.toLowerCase();
    final slotName = parkingSession.parkingSlot;

    if (location.contains('tult') || location.isEmpty) {
      return Column(
        children: [
          _parkingRow(["A21", "A22", "A23", "A24", "A25"], slotName),
          const SizedBox(height: 15),
          _parkingRow(["A26", "A27", "A28", "A29", "A30"], slotName),
          const SizedBox(height: 15),
          _parkingRow(["A31", "A32", "A33", "A34", "A35"], slotName),
        ],
      );
    }

    return _buildSlotDisplayCard(location, slotName);
  }

  Widget _buildSlotDisplayCard(String location, String slotName) {
    final displayLocation = _formatLocationName(location);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Parking Location",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF800000), width: 2),
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.location_on, color: Color(0xFF800000), size: 32),
            ],
          ),
        ),
      ],
    );
  }

  Widget _parkingRow(List<String> slots, String currentSlot) {
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
              color: isMyVehicle ? const Color(0xFF800000) : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: isMyVehicle
                ? const Icon(Icons.motorcycle, color: Colors.white)
                : Text(
                    slot,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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

  String _extractSlotDisplay(String slotName) {
    final normalized = slotName.trim().toUpperCase();
    if (normalized.contains('-') || normalized.contains('_')) {
      final parts = normalized.split(RegExp(r'[-_]'));
      return parts.last;
    }
    return normalized;
  }

  String _formatLocationName(String location) {
    final normalized = location.trim();
    if (normalized.isEmpty) return 'Unknown Location';

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
    return normalized[0].toUpperCase() + normalized.substring(1).toLowerCase();
  }
}