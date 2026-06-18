import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParkingHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future<void> parkIn(String location) async {
    final activeParking = await _firestore
        .collection('parking_history')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'Park')
        .limit(1)
        .get();

    if (activeParking.docs.isNotEmpty) {
      throw Exception('Masih ada parkir aktif');
    }

    await _firestore.collection('parking_history').add({
      'userId': uid,
      'location': location,
      'checkInTime': Timestamp.now(),
      'checkOutTime': null,
      'status': 'Park',
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> parkOut(String location) async {
    final query = await _firestore
        .collection('parking_history')
        .where('userId', isEqualTo: uid)
        .where('location', isEqualTo: location)
        .where('status', isEqualTo: 'Park')
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      await query.docs.first.reference.update({
        'status': 'Done',
        'checkOutTime': Timestamp.now(),
      });
    }
  }

  Stream<QuerySnapshot> getHistory() {
    return _firestore
        .collection('parking_history')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
