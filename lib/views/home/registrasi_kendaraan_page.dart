import 'package:flutter/material.dart';
import '../../widgets/license_plate_input.dart';
import '../../services/vehicle_service.dart';
import '../../models/vehicle_model.dart';
import '../../l10n/app_localizations.dart'; 

class RegistrasiKendaraanPage extends StatefulWidget {
  const RegistrasiKendaraanPage({super.key});

  @override
  State<RegistrasiKendaraanPage> createState() =>
      _RegistrasiKendaraanPageState();
}

class _RegistrasiKendaraanPageState extends State<RegistrasiKendaraanPage> {
  final _vehicleService = VehicleService();
  final _formKey = GlobalKey<FormState>();
  String _vehicleType = 'mobil';
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  bool _isLoading = false;
  Vehicle? _editingVehicle;

  @override
  void dispose() {
    _nomorController.dispose();
    _merkController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  void _clearForm() {
    _nomorController.clear();
    _merkController.clear();
    _modelController.clear();
    _vehicleType = 'mobil';
    _editingVehicle = null;
    _formKey.currentState?.reset();
  }

  void _addOrUpdateVehicle() async {
    // Validate standard form fields
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Validate license plate (expected format: REGION NUMBER SERIES, e.g. B 1234 AMN)
    final plate = _nomorController.text.trim();
    final plateRegex = RegExp(r'^[A-Z]{1,2}\s\d{1,4}\s[A-Z]{1,3}$');
    if (plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.vehicleRequired)),
      );
      return;
    }
    if (!plateRegex.hasMatch(plate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.invalidPlateFormat)),
      );
      return;
    }

    setState(() => _isLoading = true);

    String? error;
    if (_editingVehicle == null) {
      // Add new vehicle
      error = await _vehicleService.addVehicle(
        type: _vehicleType,
        licensePlate: plate,
        brand: _merkController.text.trim(),
        model: _modelController.text.trim(),
      );
    } else {
      // Update existing vehicle
      error = await _vehicleService.updateVehicle(
        vehicleId: _editingVehicle!.id!,
        type: _vehicleType,
        licensePlate: plate,
        brand: _merkController.text.trim(),
        model: _modelController.text.trim(),
      );
    }

    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
      );
      return;
    }

    final message = _editingVehicle == null
    ? AppLocalizations.of(context)!.vehicleAdded
    : AppLocalizations.of(context)!.vehicleUpdated;

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(message),
  ),
);

_clearForm();
  }

  void _editVehicle(Vehicle vehicle) {
    _nomorController.text = vehicle.licensePlate;
    _merkController.text = vehicle.brand;
    _modelController.text = vehicle.model;
    _vehicleType = vehicle.type;
    _editingVehicle = vehicle;
    setState(() {});
    _scrollToForm();
  }

  void _deleteVehicle(Vehicle vehicle) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteVehicle),
       content: Text(AppLocalizations.of(context)!.deleteVehicleConfirm(vehicle.licensePlate),),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.cancel,)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final error = await _vehicleService.deleteVehicle(vehicle.id!);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.vehicleDeleted)),
    );
  }

  void _scrollToForm() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  late final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vehicleRegistration),
        backgroundColor: const Color(0xFF800000),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form tambah/edit kendaraan
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        _editingVehicle == null? AppLocalizations.of(context)!.addNewVehicle: AppLocalizations.of(context)!.editVehicle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        initialValue: _vehicleType,
                        decoration: _inputDecoration(
                          label: AppLocalizations.of(context)!.vehicleType,
                          icon: Icons.directions_car_outlined,
                        ),
                        items: [
                          DropdownMenuItem(value: 'mobil', child: Text(AppLocalizations.of(context)!.car)),
                          DropdownMenuItem(value: 'motor', child: Text(AppLocalizations.of(context)!.motorcycle)),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _vehicleType = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      LicensePlateInput(
                        initial: _nomorController.text,
                        onChanged: (plate) => _nomorController.text = plate,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _merkController,
                        decoration: _inputDecoration(
                          label: AppLocalizations.of(context)!.vehicleBrand,
                          icon: Icons.branding_watermark_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.vehicleBrandRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _modelController,
                        decoration: _inputDecoration(
                          label: AppLocalizations.of(context)!.vehicleModel,
                          icon: Icons.car_rental_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.vehicleModelRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          if (_editingVehicle != null)
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: _isLoading ? null : _clearForm,
                                child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          if (_editingVehicle != null) const SizedBox(width: 12),
                          Expanded(
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
                              onPressed: _isLoading ? null : _addOrUpdateVehicle,
                              child: Text(
                                _isLoading
                                    ? AppLocalizations.of(context)!.saving
                                    : (_editingVehicle == null ? AppLocalizations.of(context)!.addVehicle : AppLocalizations.of(context)!.update),
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // List kendaraan
              Text(
                AppLocalizations.of(context)!.registeredVehicles,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              StreamBuilder<List<Vehicle>>(
                stream: _vehicleService.streamUserVehicles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final vehicles = snapshot.data ?? [];

                  if (vehicles.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.noRegisteredVehicle),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return _buildVehicleCard(vehicle);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(Vehicle vehicle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                vehicle.type == 'mobil' ? Icons.directions_car : Icons.two_wheeler,
                color: const Color(0xFF800000),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.licensePlate,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${vehicle.brand} ${vehicle.model}',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _editVehicle(vehicle),
                icon: const Icon(Icons.edit),
                label: Text(AppLocalizations.of(context)!.edit),
                style: TextButton.styleFrom(foregroundColor: Colors.blue),
              ),
              TextButton.icon(
                onPressed: () => _deleteVehicle(vehicle),
                icon: const Icon(Icons.delete),
                label: Text(AppLocalizations.of(context)!.delete),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
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
}
