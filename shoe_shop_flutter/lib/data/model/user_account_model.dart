import 'package:shoe_shop_flutter/data/model/group_model.dart';

class UserAccount {
  final int id;
  final String username;
  final Group group;
  final String accessToken;
  final String profileImage;

  UserAccount({
    required this.id,
    required this.username,
    required this.group,
    required this.accessToken,
    required this.profileImage,
  });

  factory UserAccount.fromJson(Map<String, dynamic> map) {
    return UserAccount(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      group: Group.fromJson(map['group'] ?? {}),
      accessToken: map['access_token'] ?? '',
      profileImage: map['profile_image'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'group': group,
      'access_token': accessToken,
      "profileImage": profileImage
    };
  }

  @override
  String toString() {
    return 'UserAccount('
        'id: $id, '
        'username: $username, '
        'group: $group, '
        'accessToken: $accessToken, '
        'profileImage: $profileImage'
        ')';
  }
}