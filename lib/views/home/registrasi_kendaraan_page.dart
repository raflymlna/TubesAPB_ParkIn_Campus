import 'package:flutter/material.dart';

enum VehicleType { mobil, motor }

class VehicleData {
  final VehicleType type;
  final String nomor;
  final String merk;
  final String model;

  VehicleData({
    required this.type,
    required this.nomor,
    required this.merk,
    required this.model,
  });
}

class RegistrasiKendaraanPage extends StatefulWidget {
  const RegistrasiKendaraanPage({super.key});

  @override
  State<RegistrasiKendaraanPage> createState() =>
      _RegistrasiKendaraanPageState();
}

class _RegistrasiKendaraanPageState extends State<RegistrasiKendaraanPage> {
  final _formKey = GlobalKey<FormState>();
  VehicleType _vehicleType = VehicleType.mobil;
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();

  @override
  void dispose() {
    _nomorController.dispose();
    _merkController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  void _registerVehicle() {
    if (_formKey.currentState?.validate() ?? false) {
      // Simulasi registrasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kendaraan berhasil terdaftar')),
      );
      // Kembali ke homepage dengan data kendaraan
      final vehicleData = VehicleData(
        type: _vehicleType,
        nomor: _nomorController.text,
        merk: _merkController.text,
        model: _modelController.text,
      );
      Navigator.of(context).pop(vehicleData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Registrasi Kendaraan'),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
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
                    children: [
                      const Text(
                        'Data Kendaraan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<VehicleType>(
                        value: _vehicleType,
                        decoration: _inputDecoration(
                          label: 'Jenis Kendaraan',
                          icon: Icons.directions_car_outlined,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: VehicleType.mobil,
                            child: Text('Mobil'),
                          ),
                          DropdownMenuItem(
                            value: VehicleType.motor,
                            child: Text('Motor'),
                          ),
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
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
}
