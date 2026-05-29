class ParkingSlot {
  final String id;
  final String slotName;
  final bool isAvailable;

  ParkingSlot({
    required this.id,
    required this.slotName,
    required this.isAvailable,
  });

  factory ParkingSlot.fromMap(Map<String, dynamic> data, String documentId) {
    return ParkingSlot(
      id: documentId,
      slotName: data['slotName'] ?? '',
      isAvailable: data['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'slotName': slotName, 'isAvailable': isAvailable};
  }
}
