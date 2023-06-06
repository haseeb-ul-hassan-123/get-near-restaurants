import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  final String rId;
  final String rAddress;
  final String rImage;
  final String rName;
  final String rNumber;
  final String rOwner;
  final String rEmail;
  final String rPassword;
  final bool rApproved;
  double distanceInMiles = 0.0;
  final Map location;
  final Map<String, List<Map<String, int>>> hours;

  Restaurant({
    required this.rId,
    required this.rAddress,
    required this.rImage,
    required this.rName,
    required this.rNumber,
    required this.rOwner,
    required this.rEmail,
    required this.rPassword,
    required this.rApproved,
    required this.location,
    required this.hours,
  });

  factory Restaurant.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final location = data['location'] as GeoPoint;
    final hours = data['hours'] as Map<String, dynamic>;

    return Restaurant(
      rId: doc.id,
      rAddress: data['address'] as String,
      rImage: data['image'] as String,
      rName: data['name'] as String,
      rNumber: data['number'] as String,
      rOwner: data['owner'] as String,
      rEmail: data['email'] as String,
      rPassword: data['password'] as String,
      rApproved: data['approved'] as bool,
      location: data['location'] ?? [],
      hours: hours.map((key, value) {
        final slots = value as List<dynamic>?;
        if (slots == null) {
          return MapEntry(key, []);
        }
        final parsedSlots = slots.map((slot) {
          final slotData = slot as Map<String, dynamic>;
          return {
            'open': slotData['open'] as int,
            'close': slotData['close'] as int,
          };
        }).toList();
        return MapEntry(key, parsedSlots);
      }),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'address': rAddress,
      'image': rImage,
      'name': rName,
      'number': rNumber,
      'owner': rOwner,
      'email': rEmail,
      'password': rPassword,
      'approved': rApproved,
      'location': location,
      'hours': hours.map((key, value) {
        if (value.isEmpty) {
          return MapEntry(key, null);
        }
        final parsedSlots = value.map((slot) {
          return {
            'open': slot['open'],
            'close': slot['close'],
          };
        }).toList();
        return MapEntry(key, parsedSlots);
      }),
    };
  }
}
