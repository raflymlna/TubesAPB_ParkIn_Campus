import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/parking_history_service.dart';
import '../../l10n/app_localizations.dart';
import '../services/vehicle_service.dart';
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
  final VehicleService vehicleService = VehicleService();

  Future<void> handleScan(String? code) async {
    if (code == null || isScanned) return;

    setState(() => isScanned = true);

    try {
      final cleaned = code.trim();

      if (!cleaned.contains("|")) {
        showResult(AppLocalizations.of(context)!.invalidQr);
        return;
      }

      final parts = cleaned.split("|");

      if (parts.length != 2) {
        showResult(AppLocalizations.of(context)!.invalidQrFormat);
        return;
      }

      final action = parts[0].trim().toLowerCase();
      final building = parts[1].trim();

      final firestore = FirebaseFirestore.instance;
      final auth = FirebaseAuth.instance;

      //  PARK IN
      if (action == "park in") {
        final activeParking = await firestore
            .collection('parking_history')
            .where('userId', isEqualTo: auth.currentUser?.uid)
            .where('status', isEqualTo: 'Park')
            .limit(1)
            .get();

        if (activeParking.docs.isNotEmpty) {
          final currentParkLocation = activeParking.docs.first
              .data()['location'];

          throw Exception("Anda sedang parkir di $currentParkLocation");
        }
        await validateParkingAccess(building);

        String userVehicleType = 'Motor';
        final vehicleQuery = await firestore
            .collection('vehicles')
            .where('userId', isEqualTo: auth.currentUser?.uid)
            .limit(1)
            .get();

        if (vehicleQuery.docs.isNotEmpty) {
          String rawType = vehicleQuery.docs.first.data()['type'] ?? 'Motor';
          if (rawType.toLowerCase().contains('motor')) {
            userVehicleType = 'Motor';
          } else if (rawType.toLowerCase().contains('mobil')) {
            userVehicleType = 'Mobil';
          }
        }

        final slotKosong = await firestore
            .collection('parking_slots')
            .where('locationName', isEqualTo: building)
            .where('vehicleType', isEqualTo: userVehicleType)
            .where('isAvailable', isEqualTo: true)
            .orderBy('slotName')
            .limit(1)
            .get();

        if (slotKosong.docs.isEmpty) {
          throw Exception("Parkiran $userVehicleType di $building penuh!");
        }

        final slotDoc = slotKosong.docs.first;
        final slotName = slotDoc.data()['slotName'];

        await slotDoc.reference.update({'isAvailable': false});

        await historyService.parkIn(building, slotName);

        showResult(AppLocalizations.of(context)!.parkInSuccess(building));
      }
      // PARK OUT
      else if (action == "park out") {
        await validateParkingAccess(building);

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

        if (parkedSlotName != null) {
          await firestore
              .collection('parking_slots')
              .doc(parkedSlotName)
              .update({'isAvailable': true});
        }

        await historyService.parkOut(building);

        showResult(AppLocalizations.of(context)!.parkOutSuccess(building));
      } else {
        showResult("QR tidak dikenali");
      }
    } catch (e) {
      String error = e.toString();

      if (error.contains("active_parking")) {
        showResult(AppLocalizations.of(context)!.activeParking);
      } else if (error.contains("not_parked")) {
        showResult(AppLocalizations.of(context)!.notParked);
      } else if (error.contains("wrong_location:")) {
        final location = error.split(":").last;

        showResult(AppLocalizations.of(context)!.wrongLocation(location));
      } else {
        showResult(error);
      }
    }
  }

  Future<void> validateParkingAccess(String location) async {
    final vehicleTypes = await vehicleService.getUserVehicleTypes();

    if (vehicleTypes.isEmpty) {
      throw Exception("Silakan registrasikan kendaraan terlebih dahulu");
    }

    const motorAreas = ['Gate 4', 'GKU', 'TULT', 'FIT-FIK', 'FKS-FEB'];

    const carAreas = ['Gate 2', 'Gate 3'];

    final hasMotor = vehicleTypes.contains('motor');

    final hasCar = vehicleTypes.contains('mobil');

    if (hasMotor && hasCar) {
      return;
    }

    if (hasMotor && carAreas.contains(location)) {
      throw Exception("Area parkir ini hanya untuk mobil");
    }

    if (hasCar && motorAreas.contains(location)) {
      throw Exception("Area parkir ini hanya untuk motor");
    }
  }

  void showResult(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.info),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isScanned = false);
            },
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.scanQrParking)),
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

          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.scanInstruction,
                style: const TextStyle(color: Colors.white),
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
