import 'package:shoe_shop_flutter/data/model/group_model.dart';

class UserAccount {
  final int id;
  final String username;
  final String group;

  UserAccount({
    required this.id,
    required this.username,
    required this.group,
  });

  factory UserAccount.fromJson(Map<String, dynamic> map) {
    final data = map['DT'] ?? {}; // Lấy data trong key DT

    return UserAccount(
      id: data['id'] ?? 0,
      username: data['username'] ?? '',
      group: data['group'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DT': {
        'id': id,
        'username': username,
        'group': group,
      },
    };
  }

  @override
  String toString() {
    return 'UserAccount(id: $id, username: $username, group: $group)';
  }
}