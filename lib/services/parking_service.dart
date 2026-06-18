import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_model.dart';

class ParkingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ParkingSlot>> streamParkingSlots() {
    return _firestore
        .collection('parking_slots')
        .orderBy('slotName')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return ParkingSlot.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // --- Tambahan Fungsi untuk Seeding Database ---
  Future<void> seedParkingDatabase() async {
    final batch = _firestore.batch();

    // Setup lokasi, kode slot, kapasitas, dan tipe kendaraan
    final List<Map<String, dynamic>> locations = [
      {'name': 'TULT', 'prefix': 'TULT-A', 'count': 20, 'type': 'Mobil'},
      {'name': 'TULT', 'prefix': 'TULT-B', 'count': 20, 'type': 'Mobil'},
      {'name': 'TULT', 'prefix': 'TULT-C', 'count': 20, 'type': 'Mobil'},
      {'name': 'FKS', 'prefix': 'FKS', 'count': 20, 'type': 'Mobil'},
      {'name': 'FEB', 'prefix': 'FEB', 'count': 20, 'type': 'Mobil'},
      {'name': 'FIT', 'prefix': 'FIT', 'count': 20, 'type': 'Mobil'},
      {'name': 'FIK', 'prefix': 'FIK', 'count': 20, 'type': 'Mobil'},
      {'name': 'GKU', 'prefix': 'GKU-A', 'count': 50, 'type': 'Mobil'},
      {'name': 'GKU', 'prefix': 'GKU-B', 'count': 50, 'type': 'Mobil'},
      {'name': 'GKU', 'prefix': 'GKU-C', 'count': 50, 'type': 'Mobil'},
      {'name': 'CACUK', 'prefix': 'CACUK-A', 'count': 20, 'type': 'Mobil'},
      {'name': 'CACUK', 'prefix': 'CACUK-B', 'count': 20, 'type': 'Mobil'},
      {'name': 'CACUK', 'prefix': 'CACUK-C', 'count': 20, 'type': 'Mobil'},
      {'name': 'CACUK', 'prefix': 'CACUK-D', 'count': 20, 'type': 'Mobil'},
      {'name': 'CACUK', 'prefix': 'CACUK-E', 'count': 20, 'type': 'Mobil'},
      {'name': 'CACUK', 'prefix': 'CACUK-F', 'count': 20, 'type': 'Mobil'},
      {'name': 'GATE-4', 'prefix': 'GATE-4', 'count': 100, 'type': 'Motor'},
      {'name': 'GKU', 'prefix': 'GKU', 'count': 300, 'type': 'Motor'},
      {'name': 'TULT', 'prefix': 'TULT', 'count': 100, 'type': 'Motor'},
      {'name': 'FIT/FIK', 'prefix': 'FIT/FIK', 'count': 150, 'type': 'Motor'},
      {'name': 'FKS/FEB', 'prefix': 'FKS/FEB', 'count': 50, 'type': 'Motor'},
    ];

    for (var loc in locations) {
      for (int i = 1; i <= loc['count']; i++) {
        // Format nomor jadi 2 digit (contoh: 01, 02)
        String slotNumber = i.toString().padLeft(2, '0');
        String slotName = '${loc['prefix']}-$slotNumber';

        // Buat referensi dokumen baru
        DocumentReference docRef = _firestore.collection('parking_slots').doc();

        // Masukkan data sesuai model
        batch.set(docRef, {
          'slotName': slotName,
          'isAvailable': true, // Semua slot kosong saat inisialisasi
          'locationName': loc['name'],
          'vehicleType': loc['type'],
        });
      }
    }

    await batch.commit();
  }
}
