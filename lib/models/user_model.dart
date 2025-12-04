class UserRegisterModel {
  final String email;
  final String password;
  final String fullname;
  final String phone;

  UserRegisterModel({
    required this.email,
    required this.password,
    required this.fullname,
    required this.phone,

  });

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      email: json['email'],
      password: json['password'],
      fullname: json['fullname'],
      phone: json['phone'],

    );
  }

}
