import 'dart:typed_data';
class User {
  int? id;
  String firstName;
  String lastName;
  String email;
  Uint8List? profileImage;
  String? phoneNumber;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.profileImage,
    this.phoneNumber,
  });

  // Convert User to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_image': profileImage,
      'phone_number': phoneNumber,
    };
  }

  // Convert Map to User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      email: map['email'],
      profileImage: map['profile_image'],
      phoneNumber: map['phone_number'],
    );
  }
}
