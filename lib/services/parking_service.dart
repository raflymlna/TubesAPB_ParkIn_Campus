import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_model.dart';

class ParkingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ParkingSlot>> streamParkingSlots() {
    return _firestore.collection('parking_slots').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ParkingSlot.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}
