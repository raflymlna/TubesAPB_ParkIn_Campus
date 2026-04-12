import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  bool isScanned = false;

  void handleScan(String? code) {
    if (code == null || isScanned) return;

    setState(() => isScanned = true);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Berhasil Scan"),
        content: Text("Kamu parkir di: $code"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isScanned = false);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Parkir')),
      body: MobileScanner(
        onDetect: (BarcodeCapture) {
          final List<Barcode> barcodes = BarcodeCapture.barcodes;
          
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            handleScan(code);
          }
        },
      ),
    );
  }
}