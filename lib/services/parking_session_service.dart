import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/parking_session_model.dart';

class ParkingSessionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _currentUserId => _auth.currentUser?.uid ?? '';

  /// Get active parking session dari collection parking_history dengan status 'Park'
  Future<ParkingSession?> getActiveParkingSession() async {
    try {
      final userId = _currentUserId;
      if (userId.isEmpty) return null;

      final querySnapshot = await _firestore
          .collection('parking_history')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'Park')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final data = querySnapshot.docs.first.data();

      // Map parking_history fields to ParkingSession model
      return ParkingSession(
        id: querySnapshot.docs.first.id,
        userId: data['userId'] ?? '',
        vehicleId: data['vehicleId'] ?? '',
        parkingArea: data['location'] ?? '', // location -> parkingArea
        parkingSlot: data['slotName'] ?? '', // slotName -> parkingSlot
        vehicleLatitude: 0.0, // parking_history tidak menyimpan koordinat
        vehicleLongitude: 0.0,
        status: 'parked', // Convert 'Park' -> 'parked'
        parkedAt: (data['checkInTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
        checkoutAt: (data['checkOutTime'] as Timestamp?)?.toDate(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Stream active parking session dari collection parking_history dengan status 'Park'
  /// Real-time updates untuk Find My Ride
  Stream<ParkingSession?> streamActiveParkingSession() {
    final userId = _currentUserId;
    if (userId.isEmpty) return Stream.value(null);

    return _firestore
        .collection('parking_history')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Park')
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;

          final data = snapshot.docs.first.data();

          // Map parking_history fields to ParkingSession model
          return ParkingSession(
            id: snapshot.docs.first.id,
            userId: data['userId'] ?? '',
            vehicleId: data['vehicleId'] ?? '',
            parkingArea: data['location'] ?? '', // location -> parkingArea
            parkingSlot: data['slotName'] ?? '', // slotName -> parkingSlot
            vehicleLatitude: 0.0, // parking_history tidak menyimpan koordinat
            vehicleLongitude: 0.0,
            status: 'parked', // Convert 'Park' -> 'parked'
            parkedAt: (data['checkInTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
            checkoutAt: (data['checkOutTime'] as Timestamp?)?.toDate(),
          );
        });
  }

  /// Create new parking session
  Future<String?> createParkingSession({
    required String vehicleId,
    required String parkingArea,
    required String parkingSlot,
    required double vehicleLatitude,
    required double vehicleLongitude,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId.isEmpty) return 'User tidak login';

      // Check jika sudah ada active parking session
      final existingSession = await getActiveParkingSession();
      if (existingSession != null) {
        return 'Sudah ada sesi parkir aktif. Selesaikan terlebih dahulu.';
      }

      final parkingSession = ParkingSession(
        userId: userId,
        vehicleId: vehicleId,
        parkingArea: parkingArea,
        parkingSlot: parkingSlot,
        vehicleLatitude: vehicleLatitude,
        vehicleLongitude: vehicleLongitude,
        status: 'parked',
        parkedAt: DateTime.now(),
      );

      await _firestore
          .collection('parking_sessions')
          .add(parkingSession.toMap());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Finish parking session (update status to 'finished' dan set checkoutAt)
  Future<String?> finishParkingSession(String sessionId) async {
    try {
      final userId = _currentUserId;
      if (userId.isEmpty) return 'User tidak login';

      // Verify ownership sebelum finish
      final docSnapshot = await _firestore
          .collection('parking_sessions')
          .doc(sessionId)
          .get();

      if (!docSnapshot.exists || docSnapshot['userId'] != userId) {
        return 'Sesi parkir tidak ditemukan atau bukan milik Anda';
      }

      await _firestore.collection('parking_sessions').doc(sessionId).update({
        'status': 'finished',
        'checkoutAt': Timestamp.now(),
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Get single parking session by id
  Future<ParkingSession?> getParkingSession(String sessionId) async {
    try {
      final docSnapshot = await _firestore
          .collection('parking_sessions')
          .doc(sessionId)
          .get();

      if (!docSnapshot.exists) return null;

      return ParkingSession.fromMap(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      return null;
    }
  }

  /// Get parking history untuk current user (all finished sessions)
  Stream<List<ParkingSession>> streamParkingHistory() {
    final userId = _currentUserId;
    if (userId.isEmpty) return Stream.value([]);

    return _firestore
        .collection('parking_sessions')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'finished')
        .orderBy('checkoutAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ParkingSession.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  /// Update vehicle location pada parking session yang aktif
  Future<String?> updateVehicleLocation({
    required String sessionId,
    required double vehicleLatitude,
    required double vehicleLongitude,
  }) async {
    try {
      final userId = _currentUserId;
      if (userId.isEmpty) return 'User tidak login';

      // Verify ownership sebelum update
      final docSnapshot = await _firestore
          .collection('parking_sessions')
          .doc(sessionId)
          .get();

      if (!docSnapshot.exists || docSnapshot['userId'] != userId) {
        return 'Sesi parkir tidak ditemukan atau bukan milik Anda';
      }

      await _firestore
          .collection('parking_sessions')
          .doc(sessionId)
          .update({
        'vehicleLatitude': vehicleLatitude,
        'vehicleLongitude': vehicleLongitude,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
