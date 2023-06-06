import 'dart:math';

double radians(double degrees) {
  return degrees * (pi / 180);
}

double distanceBetween(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; // in kilometers

  double dLat = radians(lat2 - lat1);
  double dLon = radians(lon2 - lon1);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;

  /// this method return distance in miles
  return distance * 0.62137119;
}
