class UserModel {
  String? firstName;
  String? userId;
  int? accountType;
  String? lastName;
  String? phoneNumber;
  String? password;
  double? latitude;
  double? longitude;
  String? address;
  UserModel(
      {this.firstName,
      this.lastName,
      this.userId,
      this.accountType,
      this.phoneNumber,
      this.password,
      this.latitude,
      this.address,
      this.longitude});

  factory UserModel.fromJson(json) => UserModel(
      userId: json['userId'],
      accountType: json['accountType'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      latitude: json['latitude'],
      address: json['address'],
      longitude: json['longitude']);

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "password": password,
        "userId": userId,
        "accountType": accountType,
        "latitude": latitude,
        "longitude": longitude,
        "address": address
      };
}
