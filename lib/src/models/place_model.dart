class Place {
  final String id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;

  const Place({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromMap(Map<String, dynamic> map) {
    final coordinate = Map<String, dynamic>.from(map['coordinate'] as Map);
    
    return Place(
      id: map['id'] as String,
      name: map['name'] as String,
      address: map['address'] as String?,
      latitude: coordinate['latitude'] as double,
      longitude: coordinate['longitude'] as double,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'address': address,
    'coordinate': {
      'latitude': latitude,
      'longitude': longitude,
    },
  };

  @override
  String toString() => 'Place(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude)';
}