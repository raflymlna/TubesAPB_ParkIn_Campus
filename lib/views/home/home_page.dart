import 'package:flutter/material.dart';
import 'registrasi_kendaraan_section.dart';
import '../../parking/parking_status_page.dart'; // <-- Tambahan Import Halaman Status Parkir
import '../../parking/history_page.dart'; // <-- Tambahin ini buat History
import 'registrasi_kendaraan_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../parking/find_my_ride.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users') // Pastiin nama collection-nya 'users'
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Default kalau data belum ada
                  String displayName = "User";

                  if (snapshot.hasData && snapshot.data!.exists) {
                    var data = snapshot.data!.data() as Map<String, dynamic>;
                    displayName =
                        data['full_name'] ?? "User"; // Ambil field 'full_name'
                  }

                  return Text(
                    "Halo, $displayName",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('vehicles')
                    .where(
                      'userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                    )
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  // Mencegah layar kedip pas lagi loading ngecek database
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 60);
                  }

                  // JIKA KOSONG (Belum daftar kendaraan): Tampilkan bannernya
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Column(
                      children: [
                        // <-- Nggak pakai const di sini
                        const SizedBox(height: 24), // SizedBox aman pakai const
                        RegistrasiKendaraanSection(), // <-- Bener-bener polos tanpa const
                        const SizedBox(height: 40), // SizedBox aman pakai const
                      ],
                    );
                  }

                  // JIKA SUDAH ADA KENDARAAN: Banner hilang, sisa jarak kosong aja ke menu
                  return const SizedBox(height: 60);
                },
              ),
              // Section 2: Barisan Card (Horizontal Scroll)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2, // Tetap 2 kolom buat HP
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent:
                      260, // <-- KUNCI: Kasih tinggi tetap yang cukup buat teks biar gak overflow
                  children: [
                    _buildMenuCard(
                      icon: Icons.local_parking_rounded,
                      title: "Parking",
                      description: "Slot info.",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParkingStatusPage(),
                        ),
                      ),
                      isMobile: isMobile,
                    ),
                    _buildMenuCard(
                      icon: Icons.history_rounded,
                      title: "History",
                      description: "Past data.",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryPage()),
                      ),
                      isMobile: isMobile,
                    ),
                    _buildMenuCard(
                      icon: Icons.directions_car_filled_rounded,
                      title: "Vehicle",
                      description: "Car info.",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrasiKendaraanPage(),
                        ),
                      ),
                      isMobile: isMobile,
                    ),
                    _buildMenuCard(
                      icon: Icons.location_on_rounded,
                      title:
                          "Find Ride", // Judul disingkat biar gak kepanjangan
                      description: "Locate.",
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FindMyRidePage(),
                        ),
                      ),
                      isMobile: isMobile,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),

              const SizedBox(height: 100),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 30 : 100,
                  vertical: 60,
                ),
                child: isMobile
                    ? Column(children: _buildMapContent(isMobile))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildMapContent(isMobile),
                      ),
              ),

              const SizedBox(height: 100),

              Container(
                width: double.infinity,
                color: const Color(0xFF800000).withOpacity(0.05),
                padding: EdgeInsets.symmetric(
                  vertical: 100,
                  horizontal: isMobile ? 30 : 100,
                ),
                child: Column(
                  children: [
                    Text(
                      "ParkInCampus is simple to use",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 32 : 40,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 60),
                    isMobile
                        ? Column(children: _buildFeatureItems(isMobile))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildFeatureItems(isMobile),
                          ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureItems(bool isMobile) {
    return [
      _buildFeatureCard(
        icon: Icons.check_circle_rounded,
        title: "Easy to register",
        description:
            "Unlock added benefits when you register on our app. Registering is simple and straightforward. It takes less than 30 seconds.",
        isMobile: isMobile,
      ),
      if (!isMobile) const SizedBox(width: 40),
      if (isMobile) const SizedBox(height: 40),

      _buildFeatureCard(
        icon: Icons.ads_click_rounded,
        title: "Easy to use",
        description:
            "Get access to parking spots instantly with our seamless interface. No complicated forms or long queues—just open the app, find your spot, and start your journey within seconds.",
        isMobile: isMobile,
      ),
      if (!isMobile) const SizedBox(width: 40),
      if (isMobile) const SizedBox(height: 40),

      _buildFeatureCard(
        icon: Icons.local_parking_rounded,
        title: "Smart Slot Finder",
        description:
            "No more circling around the block. View live parking occupancy through our app and navigate directly to an empty slot, ensuring a stress-free parking experience.",
        isMobile: isMobile,
      ),
    ];
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isMobile,
  }) {
    final cardWidth = isMobile ? double.infinity : 350.0;
    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF800000).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: const Color(0xFF800000)),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: isMobile ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMapContent(bool isMobile) {
    return [
      Container(
        width: 450,
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.black, Color(0xFF800000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.black.withOpacity(0.05), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "assets/images/1689081414373-scaled.jpg",
            fit: BoxFit.cover,
            color: const Color(0xFF800000).withOpacity(0.2),
            colorBlendMode: BlendMode.darken,
          ),
        ),
      ),
      isMobile ? const SizedBox(height: 60) : const SizedBox(width: 80),
      SizedBox(
        width: isMobile ? double.infinity : 500,
        child: Column(
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  height: 1.1,
                ),
                children: [
                  TextSpan(text: "We're "),
                  TextSpan(
                    text: "everywhere",
                    style: TextStyle(color: Color(0xFF800000)),
                  ),
                  TextSpan(text: " you need us to be"),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Work. Gym. Class. Hang Out. ParkInCampus is with you on your journey each day. We are available in over 1,000 Parking Slot on Telkom University. You can choose us to simplify their journey.",
              textAlign: isMobile ? TextAlign.center : TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Our locations",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  // <-- Tambahan parameter onPrimaryTap di sini
  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required bool isMobile,
  }) {
    // Disesuaikan biar kalau di web, kotaknya cukup besar dan pas di tengah
    final cardWidth = isMobile ? double.infinity : 400.0;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              onTap, // <-- Biar kotaknya ada efek klik (ripple) dan bisa navigasi
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF800000), // Warna background merah solid
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // <-- Modifikasi: Bungkus Container dengan Material & InkWell agar bisa diklik
  Widget _customButton(
    String label,
    Color bg,
    Color fg, {
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: fg, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
