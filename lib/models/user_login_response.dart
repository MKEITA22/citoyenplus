class UserLoginResponse {
  final String token;
  final String refreshToken;

  UserLoginResponse({required this.token, required this.refreshToken});

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      token: json['token'],
      refreshToken: json['refresh_token'],
    );
  }
}
