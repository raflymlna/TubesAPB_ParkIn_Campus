import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/parking_history_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  bool isScanned = false;

  final ParkingHistoryService historyService = ParkingHistoryService();

  Future<void> handleScan(String? code) async {
    if (code == null || isScanned) return;

    setState(() => isScanned = true);

    try {
      final cleaned = code.trim();

      if (!cleaned.contains("|")) {
        showResult("QR tidak valid!");
        return;
      }

      final parts = cleaned.split("|");

      if (parts.length != 2) {
        showResult("Format QR salah!");
        return;
      }

      final action = parts[0].trim().toLowerCase();
      final building = parts[1].trim();

      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      //  PARK IN
      if (action == "park in") {
        // 1. Cek tipe kendaraan user (ambil kendaraan pertama, default 'Motor')
        String userVehicleType = 'Motor';
        final vehicleQuery = await firestore
            .collection('vehicles')
            .where('userId', isEqualTo: auth.currentUser?.uid)
            .limit(1)
            .get();

        if (vehicleQuery.docs.isNotEmpty) {
          // Ambil data asli dari profil user
          String rawType = vehicleQuery.docs.first.data()['type'] ?? 'Motor';

          // Sanitasi: Paksa jadi huruf kapital di awal (Motor / Mobil) biar sinkron sama database
          if (rawType.toLowerCase().contains('motor')) {
            userVehicleType = 'Motor';
          } else if (rawType.toLowerCase().contains('mobil')) {
            userVehicleType = 'Mobil';
          }
        }

        // 2. Cari slot parkir berurutan (dari 01, 02, dst)
        final slotKosong = await firestore
            .collection('parking_slots')
            .where('locationName', isEqualTo: building)
            .where('vehicleType', isEqualTo: userVehicleType)
            .where('isAvailable', isEqualTo: true) // Cari yang masih hijau
            .orderBy('slotName') // Urutkan biar ngisinya rapi
            .limit(1)
            .get();

        if (slotKosong.docs.isEmpty) {
          throw Exception("Parkiran $userVehicleType di $building penuh!");
        }

        final slotDoc = slotKosong.docs.first;
        final slotName = slotDoc.data()['slotName']; // dapet misal: TULT-MT-01

        // 3. Merahkan slot parkir
        await slotDoc.reference.update({'isAvailable': false});

        // 4. Catat di history
        await historyService.parkIn(building, slotName);

        showResult("Berhasil masuk! Silakan parkir di slot: $slotName");
      }
      // PARK OUT
      else if (action == "park out") {
        // 1. Cari data parkir aktif buat ngecek dia parkir di kotak mana
        final activeParking = await firestore
            .collection('parking_history')
            .where('userId', isEqualTo: historyService.uid)
            .where('status', isEqualTo: 'Park')
            .limit(1)
            .get();

        if (activeParking.docs.isEmpty) {
          throw Exception("Anda belum parkir!");
        }

        final historyData = activeParking.docs.first.data();
        final parkedSlotName = historyData['slotName'];
        final parkedLocation = historyData['location'];

        if (parkedLocation != building) {
          throw Exception("Anda parkir di $parkedLocation, bukan di sini!");
        }

        // 2. Hijaukan kotak parkir yang ditinggalkan
        if (parkedSlotName != null) {
          await firestore
              .collection('parking_slots')
              .doc(parkedSlotName)
              .update({'isAvailable': true});
        }

        // 3. Update history jadi 'Done'
        await historyService.parkOut(building);

        showResult("Selesai parkir. Slot $parkedSlotName sudah dikosongkan.");
      } else {
        showResult("QR tidak dikenali");
      }
    } catch (e) {
      String message = e.toString();
      if (message.startsWith("Exception: ")) {
        message = message.replaceFirst("Exception: ", "");
      }
      showResult(message);
    }
  }

  void showResult(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Info"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isScanned = false);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Parkir')),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (barcodeCapture) {
              final List<Barcode> barcodes = barcodeCapture.barcodes;

              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                handleScan(code);
              }
            },
          ),

          CustomPaint(size: Size.infinite, painter: ScannerOverlay()),

          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),

          Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                children: [
                  buildCorner(Alignment.topLeft),
                  buildCorner(Alignment.topRight, isRight: true),
                  buildCorner(Alignment.bottomLeft, isBottom: true),
                  buildCorner(
                    Alignment.bottomRight,
                    isRight: true,
                    isBottom: true,
                  ),
                ],
              ),
            ),
          ),

          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Scan QR Park In / Park Out",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCorner(
    Alignment alignment, {
    bool isRight = false,
    bool isBottom = false,
  }) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: isBottom
                ? BorderSide.none
                : const BorderSide(color: Colors.red, width: 4),
            bottom: isBottom
                ? const BorderSide(color: Colors.red, width: 4)
                : BorderSide.none,
            left: isRight
                ? BorderSide.none
                : const BorderSide(color: Colors.red, width: 4),
            right: isRight
                ? const BorderSide(color: Colors.red, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}

//  Overlay
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    const double boxSize = 250;
    final left = (size.width - boxSize) / 2;
    final top = (size.height - boxSize) / 2;

    final cutoutRect = Rect.fromLTWH(left, top, boxSize, boxSize);

    final path = Path()
      ..addRect(rect)
      ..addRect(cutoutRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
