import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/parking_history_service.dart';
import '../services/vehicle_service.dart';

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

      //  PARK IN
      if (action == "park in") {
        await validateParkingAccess(building);
        await historyService.parkIn(building);

        showResult("Berhasil masuk parkir di $building");
      } else if (action == "park out") {
        await validateParkingAccess(building);
        await historyService.parkOut(building);

        showResult("Berhasil keluar parkir di $building");
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
