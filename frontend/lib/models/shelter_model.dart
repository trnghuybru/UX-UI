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

  final bool hasCleanWater;
  final bool hasFirstAid;
  final bool hasFood;
  final bool hasPower;
  final bool hasWifi;

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
    this.hasCleanWater = false,
    this.hasFirstAid = false,
    this.hasFood = false,
    this.hasPower = false,
    this.hasWifi = false,
  });

  factory ShelterModel.fromJson(Map<String, dynamic> json) {
    return ShelterModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      capacity: json['capacity'],
      currentPeople: json['current_people'],
      lat: (json['lat'] ?? json['latitude'] as num).toDouble(),
      lng: (json['lng'] ?? json['longitude'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      hasCleanWater: json['has_clean_water'] ?? false,
      hasFirstAid: json['has_first_aid'] ?? false,
      hasFood: json['has_food'] ?? false,
      hasPower: json['has_power'] ?? false,
      hasWifi: json['has_wifi'] ?? false,
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
      'has_clean_water': hasCleanWater,
      'has_first_aid': hasFirstAid,
      'has_food': hasFood,
      'has_power': hasPower,
      'has_wifi': hasWifi,
    };
  }
}
