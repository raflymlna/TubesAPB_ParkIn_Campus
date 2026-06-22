import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/parking_history_service.dart';
import '../../l10n/app_localizations.dart';
import '../services/vehicle_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../views/main_nav/main_page.dart';

class QRPage extends StatefulWidget {
   final int previousTab;

   const QRPage({
    super.key,
    required this.previousTab,
  });

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  bool isScanned = false;
  bool vehicleReady = false;

  final MobileScannerController cameraController =
      MobileScannerController();

  QueryDocumentSnapshot? selectedVehicle;
  bool vehicleSelected = false;

  final ParkingHistoryService historyService = ParkingHistoryService();
  final VehicleService vehicleService = VehicleService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final active = await hasActiveParking();

      print("Active parking = $active");

      if (!active) {
        await chooseVehicleOnOpen();
      } else {
        setState(() {
          vehicleReady = true;
        });
      }
    });
  }

   @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<QueryDocumentSnapshot?> selectVehicleDialog() async {
    final vehicles = await FirebaseFirestore.instance
        .collection('vehicles')
        .where(
          'userId',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .get();

    print("Jumlah kendaraan = ${vehicles.docs.length}");

    for (var doc in vehicles.docs) {
      print(doc.data());
    }

    if (vehicles.docs.isEmpty) return null;

     if (vehicles.docs.length == 1) {
      return vehicles.docs.first;
    }

   final result = await showDialog<QueryDocumentSnapshot>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectVehicle,),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: vehicles.docs.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles.docs[index].data();

                return ListTile(
                  leading: Icon(
                    vehicle['type']
                            .toString()
                            .toLowerCase()
                            .contains('motor')
                        ? Icons.motorcycle
                        : Icons.directions_car,
                  ),
                  title: Text(
                    vehicle['licensePlate'] ?? '-',
                  ),
                  subtitle: Text(
                    '${vehicle['brand']} ${vehicle['model']}',
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      vehicles.docs[index],
                    );
                  },
                );
              },
            ),
          ),

           actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainPage(
                      initialIndex: MainPage.lastTab,
                    ),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.cancel,),
            ),
          ],
        );
      },
    );
    return result;
  }

  Future<void> chooseVehicleOnOpen() async {
    final vehicle = await selectVehicleDialog();

    if (!mounted) return;

   if (vehicle == null) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const MainPage(),
      ),
    );
    return;
  }

    setState(() {
      selectedVehicle = vehicle;
      vehicleSelected = true;
      vehicleReady = true;
    });
  }

  Future<bool> hasActiveParking() async {
    final activeParking = await FirebaseFirestore.instance
        .collection('parking_history')
        .where(
          'userId',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid,
        )
        .where('status', isEqualTo: 'Park')
        .limit(1)
        .get();

    return activeParking.docs.isNotEmpty;
  }
  
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

          throw Exception(AppLocalizations.of(context)!.alreadyParkedAt(currentParkLocation),);
        }

        String userVehicleType = 'Motor';
        String? vehicleId;
        String? vehicleLicensePlate;
        String? vehicleBrand;
        String? vehicleModel;
        String? vehicleRawType;

        if (selectedVehicle == null) {
          throw Exception("registerVehicleFirst");
        }
          final vDoc = selectedVehicle!;
          final vData = vDoc.data() as Map<String, dynamic>;
          vehicleId = vDoc.id;
          vehicleRawType = (vData['type'] ?? 'Motor').toString();
          vehicleLicensePlate = vData['licensePlate']?.toString();
          await validateParkingAccess(building,vehicleRawType,);
          vehicleBrand = vData['brand']?.toString();
          vehicleModel = vData['model']?.toString();

          if (vehicleRawType.toLowerCase().contains('motor')) {
            userVehicleType = 'Motor';
          } else if (vehicleRawType.toLowerCase().contains('mobil')) {
            userVehicleType = 'Mobil';
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
          throw Exception(AppLocalizations.of(context)!.parkingFull(userVehicleType,building,),);
        }

        final slotDoc = slotKosong.docs.first;
        final slotName = slotDoc.data()['slotName'];

        await slotDoc.reference.update({'isAvailable': false});

        await historyService.parkIn(
          building,
          slotName,
          vehicleId: vehicleId,
          licensePlate: vehicleLicensePlate,
          brand: vehicleBrand,
          model: vehicleModel,
          type: vehicleRawType,
        );

        showResult(AppLocalizations.of(context)!.parkInSuccess(building));
      }
      // PARK OUT
      else if (action == "park out") {

        final activeParking = await firestore
            .collection('parking_history')
            .where('userId', isEqualTo: historyService.uid)
            .where('status', isEqualTo: 'Park')
            .limit(1)
            .get();

        if (activeParking.docs.isEmpty) {
          throw Exception("not_parked");
        }

        final historyData = activeParking.docs.first.data();
        final parkedSlotName = historyData['slotName'];
        final parkedLocation = historyData['location'];

        if (parkedLocation != building) {
          throw Exception("wrong_location:$parkedLocation");
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
        showResult(AppLocalizations.of(context)!.unknownQr,);
      }
    } catch (e) {
      String error = e.toString();

      if (error.contains("active_parking")) {
        showResult(AppLocalizations.of(context)!.activeParking,);
      } else if (error.contains("not_parked")) {
        showResult(AppLocalizations.of(context)!.notParked,);
      } else if (error.contains("wrong_location:")) {
        final location = error.split(":").last;
        showResult(AppLocalizations.of(context)!.wrongLocation(location),);
      } else if (error.contains("registerVehicleFirst")) {
        showResult(AppLocalizations.of(context)!.registerVehicleFirst,);
      } else if (error.contains("carOnlyArea")) {
        showResult(AppLocalizations.of(context)!.carOnlyArea,);
      } else if (error.contains("motorcycleOnlyArea")) {
        showResult(AppLocalizations.of(context)!.motorcycleOnlyArea,);
      } else {
         showResult(error.replaceFirst("Exception: ", ""),);
      }
    }
  }

    Future<void> validateParkingAccess(
    String location,
    String vehicleType,
  ) async {
    const motorAreas = [
      'Gate 4',
      'GKU',
      'TULT',
      'FIT-FIK',
      'FKS-FEB'
    ];

    const carAreas = [
      'Gate 2',
      'Gate 3'
    ];

    final isMotor =
        vehicleType.toLowerCase().contains('motor');

    final isCar =
        vehicleType.toLowerCase().contains('mobil');

    if (isMotor && carAreas.contains(location)) {
      throw Exception("carOnlyArea");
    }

    if (isCar && motorAreas.contains(location)) {
      throw Exception("motorcycleOnlyArea");
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
      body: !vehicleReady ? const Center(child: CircularProgressIndicator(),
      )
      : Stack(
        children: [
          MobileScanner(
            controller: cameraController,
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
