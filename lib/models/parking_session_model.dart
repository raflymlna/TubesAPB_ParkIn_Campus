import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSession {
  final String? id; // Firestore doc ID
  final String userId; // UID dari user yang login
  final String vehicleId; // Firestore doc ID dari vehicles collection
  final String parkingArea; // Nama area parkir (e.g., "TULT Parking Area")
  final String parkingSlot; // Nomor slot (e.g., "A-27")
  final double vehicleLatitude; // Latitude koordinat kendaraan
  final double vehicleLongitude; // Longitude koordinat kendaraan
  final String status; // 'parked' atau 'finished'
  final DateTime parkedAt;
  final DateTime? checkoutAt; // null jika masih parked

  ParkingSession({
    this.id,
    required this.userId,
    required this.vehicleId,
    required this.parkingArea,
    required this.parkingSlot,
    required this.vehicleLatitude,
    required this.vehicleLongitude,
    required this.status,
    required this.parkedAt,
    this.checkoutAt,
  });

  // Convert Firestore document to ParkingSession object
  factory ParkingSession.fromMap(Map<String, dynamic> data, String documentId) {
    return ParkingSession(
      id: documentId,
      userId: data['userId'] ?? '',
      vehicleId: data['vehicleId'] ?? '',
      parkingArea: data['parkingArea'] ?? '',
      parkingSlot: data['parkingSlot'] ?? '',
      vehicleLatitude: (data['vehicleLatitude'] as num?)?.toDouble() ?? 0.0,
      vehicleLongitude: (data['vehicleLongitude'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'parked',
      parkedAt: (data['parkedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      checkoutAt: (data['checkoutAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert ParkingSession object to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'parkingArea': parkingArea,
      'parkingSlot': parkingSlot,
      'vehicleLatitude': vehicleLatitude,
      'vehicleLongitude': vehicleLongitude,
      'status': status,
      'parkedAt': Timestamp.fromDate(parkedAt),
      'checkoutAt': checkoutAt != null ? Timestamp.fromDate(checkoutAt!) : null,
    };
  }

  // Copy with untuk membuat instance baru dengan field tertentu yang berubah
  ParkingSession copyWith({
    String? id,
    String? userId,
    String? vehicleId,
    String? parkingArea,
    String? parkingSlot,
    double? vehicleLatitude,
    double? vehicleLongitude,
    String? status,
    DateTime? parkedAt,
    DateTime? checkoutAt,
  }) {
    return ParkingSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      parkingArea: parkingArea ?? this.parkingArea,
      parkingSlot: parkingSlot ?? this.parkingSlot,
      vehicleLatitude: vehicleLatitude ?? this.vehicleLatitude,
      vehicleLongitude: vehicleLongitude ?? this.vehicleLongitude,
      status: status ?? this.status,
      parkedAt: parkedAt ?? this.parkedAt,
      checkoutAt: checkoutAt ?? this.checkoutAt,
    );
  }
}
