import 'package:flutter/material.dart';
import 'registrasi_kendaraan_page.dart';

enum VehicleType { mobil, motor }

class RegistrasiKendaraanSection extends StatefulWidget {
  const RegistrasiKendaraanSection({super.key});

  @override
  State<RegistrasiKendaraanSection> createState() =>
      _RegistrasiKendaraanSectionState();
}

class _RegistrasiKendaraanSectionState
    extends State<RegistrasiKendaraanSection> {
  VehicleData? _registeredVehicle;
  bool _isRegistered = false;

  @override
  void dispose() {
    super.dispose();
  }

  String get _jenisLabel {
    return _registeredVehicle?.type == VehicleType.mobil ? 'Mobil' : 'Motor';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registrasi Kendaraan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _isRegistered
                ? 'Kendaraan Anda sudah terdaftar. Jika sudah lengkap, Anda dapat melanjutkan penggunaan aplikasi.'
                : 'Anda belum mendaftarkan kendaraan. Silakan registrasi kendaraan terlebih dahulu.',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          if (!_isRegistered)
            _buildRegistrationButton(context)
          else
            _buildRegisteredInfo(),
        ],
      ),
    );
  }

  Widget _buildRegistrationButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF800000),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () => _showRegistrationDialog(context),
        child: const Text(
          'Registrasi Kendaraan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registrasi Kendaraan'),
          content: const Text(
            'Anda akan diarahkan ke halaman registrasi kendaraan. Pastikan data yang Anda masukkan benar.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF800000),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final result = await Navigator.of(context).push<VehicleData>(
                  MaterialPageRoute(
                    builder: (context) => const RegistrasiKendaraanPage(),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _registeredVehicle = result;
                    _isRegistered = true;
                  });
                }
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF800000), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  Widget _buildRegisteredInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF800000).withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jenis Kendaraan: $_jenisLabel',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text('Nomor Kendaraan: ${_registeredVehicle?.nomor ?? ''}'),
              const SizedBox(height: 8),
              Text('Merk Kendaraan: ${_registeredVehicle?.merk ?? ''}'),
              const SizedBox(height: 8),
              Text('Model Kendaraan: ${_registeredVehicle?.model ?? ''}'),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Jika sudah terdaftar, Anda dapat langsung melanjutkan ke bagian lainnya.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }
}
