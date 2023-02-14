import 'order.dart';

class User {
  final String firebaseId;
  final String firstName;
  final String lastName;
  final String address;
  final String landmark;
  final String personalPhoneNumber;
  final String phoneNumber;
  final String restaurantName;
  final String username;
  final String password;
  final List<String> promoCodes;
  User({
    required this.firebaseId,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.landmark,
    required this.personalPhoneNumber,
    required this.phoneNumber,
    required this.restaurantName,
    required this.username,
    required this.password,
    required this.promoCodes
  });
}
