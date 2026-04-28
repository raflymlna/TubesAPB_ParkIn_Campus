import 'package:flutter/material.dart';
import 'registrasi_kendaraan_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cek lebar layar untuk menentukan layout (Web vs Mobile)
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Section 1: Tagline
              const Text(
                "Simplifying your journey",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              const RegistrasiKendaraanSection(),
              const SizedBox(height: 40),

              // Section 2: Barisan Card (Horizontal Scroll)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildWebStyleCard(
                      "Parking Slot",
                      "Available Parking Slot",
                      "https://images.unsplash.com/photo-1506521781263-d8422e82f27a?q=80&w=600",
                    ),
                    const SizedBox(width: 20),
                    _buildWebStyleCard(
                      "Parking History",
                      "See History",
                      "https://images.unsplash.com/photo-1648823161626-0e839927401b?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),

              // Section 3: Hero Description (Responsive Layout)
              Container(
                width: double
                    .infinity, // Supaya background merahnya full selebar layar
                color: const Color(
                  0xFF800000,
                ).withOpacity(0.05), // Merah Maroon Transparan
                padding: EdgeInsets.symmetric(
                  vertical: 80,
                  horizontal: isMobile ? 30 : 100,
                ),
                child: isMobile
                    ? Column(children: _buildHeroContent(isMobile))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildHeroContent(isMobile),
                      ),
              ),

              const SizedBox(height: 100),

              // Section 4: Section Peta Everywhere (Responsive)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 30 : 100,
                  vertical: 60,
                ),
                child: isMobile
                    ? Column(
                        children: _buildMapContent(isMobile),
                      ) // Tumpuk bawah (HP)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildMapContent(
                          isMobile,
                        ), // Jajar samping (Web)
                      ),
              ),

              const SizedBox(height: 100),

              // Section 5: Section "Simple to use" (Responsive)
              Container(
                width: double
                    .infinity, // Supaya background merahnya full selebar layar
                color: const Color(
                  0xFF800000,
                ).withOpacity(0.05), // Merah Maroon Transparan
                padding: EdgeInsets.symmetric(
                  vertical: 100, // Tambahin padding vertikal biar lega
                  horizontal: isMobile ? 30 : 100,
                ),
                child: Column(
                  children: [
                    // Judul Utama
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

                    // Barisan Fitur (Responsive)
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
      if (!isMobile) const SizedBox(width: 40), // Jarak antar card di web
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
        icon:
            Icons.local_parking_rounded, // Atau use history_toggle_off_outlined
        title: "Smart Slot Finder",
        description:
            "No more circling around the block. View live parking occupancy through our app and navigate directly to an empty slot, ensuring a stress-free parking experience.",
        isMobile: isMobile,
      ),
    ];
  }

  // Widget buat satu item fitur
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isMobile,
  }) {
    // Kita patok lebarnya di web biar rapi, di mobile full
    final cardWidth = isMobile ? double.infinity : 350.0;

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          // Icon Container (Maroon Transparan)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF800000).withOpacity(0.1), // Maroon muda
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFF800000), // Warna Maroon utama
            ),
          ),
          const SizedBox(height: 24),

          // Judul
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

          // Deskripsi
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
      // Sisi Gambar Peta (Gradasi Maroon-Hitam)
      Container(
        width: 450,
        height: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Colors.black,
              Color(0xFF800000),
            ], // Gradasi Hitam ke Maroon
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

      // Jarak
      isMobile ? const SizedBox(height: 60) : const SizedBox(width: 80),

      // Sisi Teks
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
                    style: TextStyle(color: Color(0xFF800000)), // Warna Maroon
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
                backgroundColor: const Color(0xFF800000), // Tombol Maroon
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

  // Fungsi buat bikin isi konten Hero (Teks & Gambar HP)
  List<Widget> _buildHeroContent(bool isMobile) {
    return [
      // Sisi Teks
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
                  TextSpan(text: "We're here to "),
                  TextSpan(
                    text: "simplify your journey",
                    style: TextStyle(color: Color(0xFF800000)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "We know you have better things to worry about than paying for your parking. That's why our smart, intuitive technology delivers a world-class digital payment experience for millions of drivers.",
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
                "How it works",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),

      // Jarak
      isMobile ? const SizedBox(height: 60) : const SizedBox(width: 80),

      // Sisi Gambar (Ilustrasi HP)
      Container(
        width: 320,
        height: 600,
        decoration: BoxDecoration(
          color: const Color(0xFF800000).withOpacity(0.05),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black.withOpacity(0.05), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?q=80&w=600",
            fit: BoxFit.cover,
          ),
        ),
      ),
    ];
  }

  // Widget Card yang sudah kamu punya
  Widget _buildWebStyleCard(String title, String buttonLabel, String imageUrl) {
    return Container(
      width: 300,
      height: 450,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            const Color(0xFF800000).withOpacity(0.3),
            BlendMode.darken,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _customButton(
                  buttonLabel,
                  const Color(0xFF800000),
                  Colors.white,
                ),
                const SizedBox(height: 10),
                _customButton("Learn more", Colors.white, Colors.black),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _customButton(String label, Color bg, Color fg) {
    return Container(
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
    );
  }
}
