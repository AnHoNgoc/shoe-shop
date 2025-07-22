import 'group_model.dart';

class User {
  final int id;
  final String username;
  final String profileImage;
  final Group group;

  User({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.group,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        id: map['id'] ?? 0,
        username: map['username'] ?? '',
        profileImage: map['profile_image'] ?? '',
        group: Group.fromJson(map['group'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      "profile_image": profileImage,
      'group': group,
    };
  }

  @override
  String toString() {
    return 'UserAccount('
        'id: $id, '
        'username: $username, '
        'group: $group, '
        'profileImage: $profileImage'
        ')';
  }
}