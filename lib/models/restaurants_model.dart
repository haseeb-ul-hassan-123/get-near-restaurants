import 'package:geoflutterfire/geoflutterfire.dart';

class RestaurantsModel {
  final String rId;
  final String rAddress;
  final String rImage;
  final String rName;
  final String rNumber;
  final String rOwner;
  final String rEmail;
  final String rPassword;
  final int rApproved;
  final bool isOpen;
  final List<dynamic> rLikes;
  double distanceInMiles = 0.0;
  final Map location;
  GeoFirePoint? geoPoint;
  final Map<String, List<Map<String, int>>> hours;
  List<String> categories;
  final String? imageName;
  final bool isblocked;
  RestaurantsModel(
      {required this.rId,
      required this.rAddress,
      required this.rImage,
      required this.rName,
      required this.rNumber,
      required this.isOpen,
      required this.rLikes,
      required this.rOwner,
      required this.rEmail,
      required this.rPassword,
      required this.rApproved,
      required this.location,
      required this.hours,
      required this.isblocked,
      required this.imageName,
      required this.categories});

  factory RestaurantsModel.fromFirestore(doc) {
    final data = doc.data();
    final location = data['location'] as Map;
    final hours = data['hours'] as Map<String, dynamic>;

    return RestaurantsModel(
      rId: doc.id,
      rLikes: data['rLikes'] ?? [],
      rAddress: data['address'] as String,
      rImage: data['image'] as String,
      rName: data['name'] as String,
      isOpen: data['isOpen'] as bool,
      isblocked: data['isblocked'] ?? false,
      rNumber: data['number'] as String,
      rOwner: data['owner'] as String,
      rEmail: data['email'] as String,
      rPassword: data['password'] as String,
      rApproved: data['status'] as int,
      imageName: data['imageName'] as String,
      location: location,
      categories: List<String>.from(data['categories'] ?? []),
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
      'status': rApproved,
      'location': location,
      'imageName': imageName,
      'isblocked': isblocked,
      'isOpen': isOpen,
      'rLikes': rLikes,
      'categories': categories,
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
