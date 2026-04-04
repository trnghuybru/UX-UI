class ShelterModel {
  final int id;
  final String name;
  final String address;
  final int capacity;
  final int currentPeople;
  final double lat;
  final double lng;
  final String status;
  final DateTime createdAt;

  ShelterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.capacity,
    required this.currentPeople,
    required this.lat,
    required this.lng,
    required this.status,
    required this.createdAt,
  });

  factory ShelterModel.fromJson(Map<String, dynamic> json) {
    return ShelterModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      capacity: json['capacity'],
      currentPeople: json['current_people'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'capacity': capacity,
      'current_people': currentPeople,
      'lat': lat,
      'lng': lng,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
