class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String username;
  final int id;
  final int? group;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.id,
    required this.group,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      username: json['username'],
      id: json['id'],
      group: json['group'] is int ? json['group'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'username': username,
    'id': id,
    'group': group,
  };
}