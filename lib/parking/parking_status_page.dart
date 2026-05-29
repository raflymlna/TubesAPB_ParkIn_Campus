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
      // StreamBuilder ini yang bikin tampilan otomatis update kalau ada data masuk/keluar
      body: StreamBuilder<List<ParkingSlot>>(
        stream: _parkingService.streamParkingSlots(),
        builder: (context, snapshot) {
          // Kalau koneksi error
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          // Kalau lagi loading narik data
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

          // Nampilin denah parkir pakai Grid
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              return Container(
                decoration: BoxDecoration(
                  // Logika warna: Hijau kalau kosong, Merah kalau terisi
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
                    slot.slotName, // Nampilin nama slot (misal: "A1")
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
