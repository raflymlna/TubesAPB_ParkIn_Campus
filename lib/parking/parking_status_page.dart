import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import '../models/parking_model.dart';
import '../services/parking_service.dart';

// 1. UBAH JADI STATEFUL WIDGET
class ParkingStatusPage extends StatefulWidget {
  const ParkingStatusPage({super.key});

  @override
  State<ParkingStatusPage> createState() => _ParkingStatusPageState();
}

class _ParkingStatusPageState extends State<ParkingStatusPage> {
  final ParkingService _parkingService = ParkingService();

  // 2. VARIABEL STATE BUAT NYIMPEN KATEGORI
  String selectedCategory = 'Semua';
  String selectedLocation = 'Semua';

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
      // 3. PAKE COLUMN BIAR TOMBOL BISA DI ATAS
      body: Column(
        children: [
          // --- BARISAN TOMBOL FILTER KATEGORI ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Semua'),
                  const SizedBox(width: 10),
                  _buildCategoryChip('Motor'),
                  const SizedBox(width: 10),
                  _buildCategoryChip('Mobil'),
                ],
              ),
            ),
          ),

          // --- BARISAN TOMBOL FILTER LOKASI (BARU) ---
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildLocationChip('Semua'),
                  const SizedBox(width: 8),
                  _buildLocationChip('TULT'),
                  const SizedBox(width: 8),
                  _buildLocationChip('FIT-FIK'),
                  const SizedBox(width: 8),
                  _buildLocationChip('GKU'),
                  const SizedBox(width: 8),
                  _buildLocationChip('Gate4'),
                  const SizedBox(width: 8),
                  _buildLocationChip('Gate 2'),
                  const SizedBox(width: 8),
                  _buildLocationChip('Gate 3'),
                ],
              ),
            ),
          ),

          // --- STREAM BUILDER (DIBUNGKUS EXPANDED) ---
          Expanded(
            child: StreamBuilder<List<ParkingSlot>>(
              // 4. PASING PARAMETER KATEGORI KE DALAM STREAM
              stream: _parkingService.streamParkingSlots(
                category: selectedCategory,
                location: selectedLocation,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final slots = snapshot.data ?? [];

                if (slots.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada slot parkir untuk kendaraan ini.',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // --- LOGIKA PENGELOMPOKKAN DATA (GROUPING) ---
                Map<String, List<ParkingSlot>> groupedSlots = {};

                for (var slot in slots) {
                  String groupKey =
                      '${slot.locationName} - ${slot.vehicleType}';

                  if (!groupedSlots.containsKey(groupKey)) {
                    groupedSlots[groupKey] = [];
                  }
                  groupedSlots[groupKey]!.add(slot);
                }

                var sortedKeys = groupedSlots.keys.toList()..sort();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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

                        // --- GRID KOTAK HIJAU/MERAH ---
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
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
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 5. FUNGSI UNTUK MERENDER TOMBOL CHIP
  Widget _buildCategoryChip(String category) {
    final isSelected = selectedCategory == category;

    return ChoiceChip(
      label: Text(
        category,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary, // Nyesuaiin warna merah tema lu
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
      ),
      showCheckmark: false, // Dibikin false biar bentuk tombolnya lebih clean
      onSelected: (bool selected) {
        // Logika biar tombol berubah warna pas dipencet
        setState(() {
          selectedCategory = category;
        });
      },
    );
  }

  Widget _buildLocationChip(String location) {
    final isSelected = selectedLocation == location;

    return ChoiceChip(
      label: Text(
        location,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12, // Dikecilin dikit biar muat banyak
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          8,
        ), // Dibikin agak kotak biar beda sama filter kendaraan
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
        ),
      ),
      showCheckmark: false,
      onSelected: (bool selected) {
        setState(() {
          selectedLocation = location;
        });
      },
    );
  }
}
