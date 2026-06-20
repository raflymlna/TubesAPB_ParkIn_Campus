import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/parking_history_service.dart';
import '../parking/find_my_ride.dart';
import '../../l10n/app_localizations.dart';

String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return "-";

  return DateFormat('dd MMM yyyy • HH:mm').format(timestamp.toDate());
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.parkingHistory,),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 100,
          vertical: 30,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.yourParkingActivity,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions_car),
                label: Text(AppLocalizations.of(context)!.findMyRide,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FindMyRidePage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF800000),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ParkingHistoryService().getHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.noParkingHistory,
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;

                      final licensePlate = data['licensePlate']?.toString();
                      final vehicleBrand = data['vehicleBrand']?.toString();
                      final vehicleModel = data['vehicleModel']?.toString();
                      final vehicleType = data['vehicleType']?.toString();

                      return _buildHistoryCard(
                        context: context,
                        location: data['location'],
                        checkIn: data['checkInTime'],
                        checkOut: data['checkOutTime'],
                        status: data['status'],
                        licensePlate: licensePlate,
                        vehicleBrand: vehicleBrand,
                        vehicleModel: vehicleModel,
                        vehicleType: vehicleType,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required String location,
    required Timestamp? checkIn,
    required Timestamp? checkOut,
    required String status,
    String? licensePlate,
    String? vehicleBrand,
    String? vehicleModel,
    String? vehicleType,
  }) {
    Color bgColor;
    Color textColor;

    if (status == "Done") {
      bgColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
    } else if (status == "Park") {
      bgColor = Colors.blue.withOpacity(0.1);
      textColor = Colors.blue;
    } else {
      bgColor = Colors.grey.withOpacity(0.1);
      textColor = Colors.grey;
    }

    String displayStatus;

    if (status == "Park") {
      displayStatus = AppLocalizations.of(context)!.parking;
    } else if (status == "Done") {
      displayStatus = AppLocalizations.of(context)!.out;
    } else {
      displayStatus = status;
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            final bool isDone = status == "Done";

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF800000).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.local_parking,
                        color: Color(0xFF800000),
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      AppLocalizations.of(context)!.parkingDetail,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildDetailRow(
                      Icons.location_on,
                      AppLocalizations.of(context)!.location,
                      location,
                    ),

                    if (licensePlate != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.confirmation_number,
                        'Plat',
                        licensePlate,
                      ),
                    ],

                    if ((vehicleBrand != null && vehicleBrand.isNotEmpty) ||
                        (vehicleModel != null && vehicleModel.isNotEmpty)) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.directions_car,
                        'Kendaraan',
                        '${vehicleBrand ?? '-'} ${vehicleModel ?? ''}',
                      ),
                    ],

                    if (vehicleType != null) ...[
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.category,
                        AppLocalizations.of(context)!.vehicleType,
                        vehicleType,
                      ),
                    ],

                    const SizedBox(height: 12),

                    _buildDetailRow(
                      Icons.login,
                      AppLocalizations.of(context)!.parkIn,
                      formatTimestamp(checkIn),
                    ),

                    const SizedBox(height: 12),

                    _buildDetailRow(
                      Icons.logout,
                      AppLocalizations.of(context)!.parkOut,
                      formatTimestamp(checkOut),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDone
                            ? Colors.green.withOpacity(0.1)
                            : Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        displayStatus,
                        style: TextStyle(
                          color: isDone ? Colors.green : Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF800000),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          AppLocalizations.of(context)!.close,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF800000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.local_parking,
                color: Color(0xFF800000),
                size: 30,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${formatTimestamp(checkIn)} - ${checkOut == null ? AppLocalizations.of(context)!.now : formatTimestamp(checkOut)}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: status == "Done"
                    ? Colors.green.withOpacity(0.1)
                    : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                displayStatus,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: status == "Done" ? Colors.green : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: const Color(0xFF800000)),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
