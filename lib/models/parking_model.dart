class ParkingSlot {
  final String id;
  final String slotName; // Contoh: "A-01"
  final bool isAvailable; // Status ketersediaan
  final String locationName; // Contoh: "Gedung TULT", "Fakultas Informatika"
  final String vehicleType; // Contoh: "Motor" atau "Mobil"

  ParkingSlot({
    required this.id,
    required this.slotName,
    required this.isAvailable,
    required this.locationName,
    required this.vehicleType,
  });

  factory ParkingSlot.fromMap(Map<String, dynamic> data, String documentId) {
    return ParkingSlot(
      id: documentId,
      slotName: data['slotName'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
      locationName: data['locationName'] ?? 'Area Parkir Utama',
      vehicleType: data['vehicleType'] ?? 'Motor',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slotName': slotName,
      'isAvailable': isAvailable,
      'locationName': locationName,
      'vehicleType': vehicleType,
    };
  }
}
