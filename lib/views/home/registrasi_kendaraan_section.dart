import 'package:flutter/material.dart';

enum VehicleType { mobil, motor }

class RegistrasiKendaraanSection extends StatefulWidget {
  const RegistrasiKendaraanSection({super.key});

  @override
  State<RegistrasiKendaraanSection> createState() =>
      _RegistrasiKendaraanSectionState();
}

class _RegistrasiKendaraanSectionState
    extends State<RegistrasiKendaraanSection> {
  final _formKey = GlobalKey<FormState>();
  VehicleType _vehicleType = VehicleType.mobil;
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _tipeController = TextEditingController();
  bool _isRegistered = false;

  @override
  void dispose() {
    _nomorController.dispose();
    _merkController.dispose();
    _modelController.dispose();
    _tipeController.dispose();
    super.dispose();
  }

  void _registerVehicle() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isRegistered = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kendaraan berhasil terdaftar')),
      );
    }
  }

  String get _jenisLabel {
    return _vehicleType == VehicleType.mobil ? 'Mobil' : 'Motor';
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
                : 'Anda belum mendaftarkan kendaraan. Silakan isi data kendaraan di bawah ini.',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 24),
          if (!_isRegistered) _buildForm(context) else _buildRegisteredInfo(),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<VehicleType>(
            value: _vehicleType,
            decoration: _inputDecoration(
              label: 'Jenis Kendaraan',
              icon: Icons.directions_car_outlined,
            ),
            items: const [
              DropdownMenuItem(value: VehicleType.mobil, child: Text('Mobil')),
              DropdownMenuItem(value: VehicleType.motor, child: Text('Motor')),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _vehicleType = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nomorController,
            decoration: _inputDecoration(
              label: 'Nomor Kendaraan',
              icon: Icons.confirmation_num_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nomor kendaraan wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _merkController,
            decoration: _inputDecoration(
              label: 'Merk Kendaraan',
              icon: Icons.branding_watermark_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Merk kendaraan wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _modelController,
            decoration: _inputDecoration(
              label: 'Model Kendaraan',
              icon: Icons.car_rental_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Model kendaraan wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _tipeController,
            decoration: _inputDecoration(
              label: 'Tipe Kendaraan',
              icon: Icons.category_outlined,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Tipe kendaraan wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
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
              onPressed: _registerVehicle,
              child: const Text(
                'Daftar Kendaraan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
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
              Text('Nomor Kendaraan: ${_nomorController.text}'),
              const SizedBox(height: 8),
              Text('Merk Kendaraan: ${_merkController.text}'),
              const SizedBox(height: 8),
              Text('Model Kendaraan: ${_modelController.text}'),
              const SizedBox(height: 8),
              Text('Tipe Kendaraan: ${_tipeController.text}'),
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
