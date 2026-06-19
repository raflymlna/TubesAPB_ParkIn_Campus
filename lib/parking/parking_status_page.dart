import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../models/parking_model.dart';
import '../services/parking_service.dart';

class ParkingStatusPage extends StatelessWidget {
  final ParkingService _parkingService = ParkingService();

  ParkingStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ketersediaan Parkir',
          style: TextStyle(color: AppColors.textWhite),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      ),
      body: StreamBuilder<List<ParkingSlot>>(
        stream: _parkingService.streamParkingSlots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final slots = snapshot.data ?? [];

          if (slots.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data slot parkir di Firebase.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // --- LOGIKA PENGELOMPOKKAN DATA (GROUPING) ---
          // Memisahkan data berdasarkan locationName dan vehicleType
          Map<String, List<ParkingSlot>> groupedSlots = {};

          for (var slot in slots) {
            // Bikin judul grupnya, misal: "Gedung TULT - Motor"
            String groupKey = '${slot.locationName} - ${slot.vehicleType}';

            if (!groupedSlots.containsKey(groupKey)) {
              groupedSlots[groupKey] = [];
            }
            groupedSlots[groupKey]!.add(slot);
          }

          // Urutkan nama grupnya biar tampilannya selalu konsisten (A-Z)
          var sortedKeys = groupedSlots.keys.toList()..sort();

          // Gunakan ListView untuk menampung barisan Grup
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              String key = sortedKeys[index];
              List<ParkingSlot> groupData = groupedSlots[key]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- KOTAK JUDUL LOKASI & TIPE KENDARAAN ---
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          key.toLowerCase().contains('motor')
                              ? Icons.motorcycle
                              : Icons.directions_car,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          key,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- GRID KOTAK HIJAU/MERAH KHUSUS GRUP INI ---
                  GridView.builder(
                    shrinkWrap:
                        true, // WAJIB: Biar Grid bisa masuk di dalam ListView tanpa error
                    physics:
                        const NeverScrollableScrollPhysics(), // WAJIB: Biar gak ada scroll ganda (scroll ikut ListView)
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1, // Bikin kotaknya persegi
                        ),
                    itemCount: groupData.length,
                    itemBuilder: (context, gridIndex) {
                      final slot = groupData[gridIndex];
                      return Container(
                        decoration: BoxDecoration(
                          color: slot.isAvailable
                              ? AppColors.slotAvailable
                              : AppColors.slotOccupied,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            slot.slotName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  15, // Dikecilin dikit biar teks panjang kayak FIT/FIK-45 nggak kepotong
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40), // Jarak pembatas antar gedung
                ],
              );
            },
          );
        },
      ),
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          await _parkingService.seedParkingDatabase();

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Database parkir berhasil di-generate ulang!'),
              ),
            );
          }
        },
        child: const Icon(Icons.dataset, color: AppColors.textWhite),
      ), */
    );
  }
}
