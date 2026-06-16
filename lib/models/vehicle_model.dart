import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String? id; // Firestore doc ID
  final String userId; // UID dari user yang login
  final String type; // 'mobil' atau 'motor'
  final String licensePlate; // format: "B 1234 AMN"
  final String brand;
  final String model;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Vehicle({
    this.id,
    required this.userId,
    required this.type,
    required this.licensePlate,
    required this.brand,
    required this.model,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert Firestore document to Vehicle object
  factory Vehicle.fromMap(Map<String, dynamic> data, String documentId) {
    return Vehicle(
      id: documentId,
      userId: data['userId'] ?? '',
      type: data['type'] ?? 'mobil',
      licensePlate: data['licensePlate'] ?? '',
      brand: data['brand'] ?? '',
      model: data['model'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert Vehicle object to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'licensePlate': licensePlate,
      'brand': brand,
      'model': model,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt ?? DateTime.now()),
    };
  }

  // Copy with untuk membuat instance baru dengan field tertentu yang berubah
  Vehicle copyWith({
    String? id,
    String? userId,
    String? type,
    String? licensePlate,
    String? brand,
    String? model,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      licensePlate: licensePlate ?? this.licensePlate,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
