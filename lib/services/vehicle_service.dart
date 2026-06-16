import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  /// Add new vehicle untuk current user
  Future<String?> addVehicle({
    required String type,
    required String licensePlate,
    required String brand,
    required String model,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId.isEmpty) return 'User tidak login';

      final vehicle = Vehicle(
        userId: userId,
        type: type,
        licensePlate: licensePlate,
        brand: brand,
        model: model,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('vehicles').add(vehicle.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Get all vehicles untuk current user
  Stream<List<Vehicle>> streamUserVehicles() {
    final userId = _currentUserId;
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Vehicle.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Update vehicle by id
  Future<String?> updateVehicle({
    required String vehicleId,
    required String type,
    required String licensePlate,
    required String brand,
    required String model,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId.isEmpty) return 'User tidak login';

      // Verify ownership sebelum update
      final docSnapshot =
          await _firestore.collection('vehicles').doc(vehicleId).get();
      if (!docSnapshot.exists || docSnapshot['userId'] != userId) {
        return 'Vehicle tidak ditemukan atau bukan milik Anda';
      }

      await _firestore.collection('vehicles').doc(vehicleId).update({
        'type': type,
        'licensePlate': licensePlate,
        'brand': brand,
        'model': model,
        'updatedAt': Timestamp.now(),
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Delete vehicle by id
  Future<String?> deleteVehicle(String vehicleId) async {
    try {
      final userId = _currentUserId;
      if (userId.isEmpty) return 'User tidak login';

      // Verify ownership sebelum delete
      final docSnapshot =
          await _firestore.collection('vehicles').doc(vehicleId).get();
      if (!docSnapshot.exists || docSnapshot['userId'] != userId) {
        return 'Vehicle tidak ditemukan atau bukan milik Anda';
      }

      await _firestore.collection('vehicles').doc(vehicleId).delete();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Get single vehicle by id
  Future<Vehicle?> getVehicle(String vehicleId) async {
    try {
      final docSnapshot =
          await _firestore.collection('vehicles').doc(vehicleId).get();
      if (!docSnapshot.exists) return null;

      return Vehicle.fromMap(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      return null;
    }
  }
}
