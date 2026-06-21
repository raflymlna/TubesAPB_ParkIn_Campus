import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParkingHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  // Tambahin parameter slotName di sini
  Future<void> parkIn(String location, String slotName,
      {String? vehicleId,
      String? licensePlate,
      String? brand,
      String? model,
      String? type}) async {
    final activeParking = await _firestore
        .collection('parking_history')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'Park')
        .limit(1)
        .get();

    if (activeParking.docs.isNotEmpty) {
      throw Exception('active_parking');
    }

    final data = {
      'userId': uid,
      'location': location,
      'slotName': slotName, // <--- Catat nama slot (misal: TULT-MT-01)
      'checkInTime': Timestamp.now(),
      'checkOutTime': null,
      'status': 'Park',
      'createdAt': Timestamp.now(),
    };

    // Jika tersedia, sertakan informasi kendaraan
    if (vehicleId != null) data['vehicleId'] = vehicleId;
    if (licensePlate != null) data['licensePlate'] = licensePlate;
    if (brand != null) data['vehicleBrand'] = brand;
    if (model != null) data['vehicleModel'] = model;
    if (type != null) data['vehicleType'] = type;

    await _firestore.collection('parking_history').add(data);
  }

  Future<void> parkOut(String location) async {
    final activeParking = await _firestore
        .collection('parking_history')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'Park')
        .limit(1)
        .get();

    if (activeParking.docs.isEmpty) {
      throw Exception("not_parked");
    }

    final data = activeParking.docs.first.data();

    final currentLocation = data['location'];

    if (currentLocation != location) {
      throw Exception("wrong_location:$currentLocation");
    }

    await activeParking.docs.first.reference.update({
      'status': 'Done',
      'checkOutTime': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getHistory() {
    return _firestore
        .collection('parking_history')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
