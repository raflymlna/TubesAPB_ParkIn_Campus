import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Parking History"),
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
            const Text(
              "Your Parking Activity",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: ListView(
                children: [
                  _buildHistoryCard(
                    location: "TULT - Telkom University",
                    date: "12 April 2026",
                    time: "08:00 - 10:00",
                    status: "Done",
                  ),
                  _buildHistoryCard(
                    location: "GKU - Telkom University",
                    date: "10 April 2026",
                    time: "13:00 - 15:00",
                    status: "Done",
                  ),
                  _buildHistoryCard(
                    location: "CACUK - Telkom University",
                    date: "8 April 2026",
                    time: "09:00 - 11:30",
                    status: "Done",
                  ),

                  _buildHistoryCard(
                    location: "TULT - Telkom University",
                    date: "12 April 2026",
                    time: "14:00 - Now",
                    status: "Park",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String location,
    required String date,
    required String time,
    required String status,
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

    return Container(
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
          // Icon kiri
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

          // Info
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
                  "$date • $time",
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // 🔥 Status (Dynamic)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}