import 'package:flutter/material.dart';

class FindMyRidePage extends StatelessWidget {
  const FindMyRidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Find My Ride"),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vehicle Found",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF800000).withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.motorcycle,
                    size: 70,
                    color: Color(0xFF800000),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Honda Vario 160",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Currently Parked",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  _infoTile(
                    Icons.location_on,
                    "Location",
                    "TULT Parking Area",
                  ),

                  _infoTile(
                    Icons.local_parking,
                    "Slot",
                    "A-27",
                  ),

                  _infoTile(
                    Icons.access_time,
                    "Parked Since",
                    "14:00 WIB",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Parking Map",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFF800000).withOpacity(0.05),
              ),
              child: Column(
                children: [
                  _parkingRow([
                    "A21",
                    "A22",
                    "A23",
                    "A24",
                    "A25",
                  ]),

                  const SizedBox(height: 15),

                  _parkingRow([
                    "A26",
                    "A27",
                    "A28",
                    "A29",
                    "A30",
                  ]),

                  const SizedBox(height: 15),

                  _parkingRow([
                    "A31",
                    "A32",
                    "A33",
                    "A34",
                    "A35",
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.navigation),
                label: const Text("Navigate To Slot"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Navigating to Slot A-27",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF800000),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF800000),
          ),
          const SizedBox(width: 15),
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _parkingRow(List<String> slots) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: slots.map((slot) {
        final bool isMyVehicle = slot == "A27";

        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isMyVehicle
                ? const Color(0xFF800000)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMyVehicle
                  ? const Color(0xFF800000)
                  : Colors.grey.shade300,
            ),
          ),
          child: Center(
            child: isMyVehicle
                ? const Icon(
                    Icons.motorcycle,
                    color: Colors.white,
                  )
                : Text(
                    slot,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }
}