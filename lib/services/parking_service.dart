import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_model.dart';

class ParkingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Fungsi stream diubah biar nerima parameter kategori
  Stream<List<ParkingSlot>> streamParkingSlots({
    String category = 'Semua',
    String location = 'Semua',
  }) {
    Query query = _firestore.collection('parking_slots');

    // Filter tipe kendaraan (Motor/Mobil)
    if (category != 'Semua') {
      query = query.where('vehicleType', isEqualTo: category);
    }

    // Filter nama lokasi gedung/gate
    if (location != 'Semua') {
      query = query.where('locationName', isEqualTo: location);
    }

    return query.orderBy('slotName').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ParkingSlot.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // --- Tambahan Fungsi untuk Seeding Database ---
  Future<void> seedParkingDatabase() async {
    final batch = _firestore.batch();

    // Variabel selectedCategory yang nyasar di sini udah gua hapus ya!

    // Setup lokasi, kode slot, kapasitas, dan tipe kendaraan
    final List<Map<String, dynamic>> locations = [
      {'name': 'TULT', 'prefix': 'TULT', 'count': 75, 'type': 'Motor'},
      {'name': 'FIT-FIK', 'prefix': 'FIT-FIK', 'count': 150, 'type': 'Motor'},
      {'name': 'GKU', 'prefix': 'GKU', 'count': 300, 'type': 'Motor'},
      {'name': 'Gate4', 'prefix': 'GATE-4', 'count': 100, 'type': 'Motor'},
      {'name': 'Gate 2', 'prefix': 'GATE-2', 'count': 50, 'type': 'Mobil'},
      {'name': 'Gate 3', 'prefix': 'GATE-3', 'count': 100, 'type': 'Mobil'},
    ];

    for (var loc in locations) {
      for (int i = 1; i <= loc['count']; i++) {
        // Format nomor jadi 2 digit (contoh: 01, 02)
        String slotNumber = i.toString().padLeft(3, '0');
        String slotName = '${loc['prefix']}-$slotNumber';

        // Buat referensi dokumen baru
        DocumentReference docRef = _firestore
            .collection('parking_slots')
            .doc(slotName);

        // Masukkan data sesuai model
        batch.set(docRef, {
          'slotName': slotName,
          'isAvailable': true, // Semua slot kosong saat inisialisasi
          'locationName': loc['name'],
          'vehicleType':
              loc['type'], // KUNCI: Ini yang dipake buat nge-filter nanti
        });
      }
    }

    await batch.commit();
  }
}
