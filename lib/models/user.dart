class UserModel {
  final int id;
  final String fullname;
  final String email;
  final String phone;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
