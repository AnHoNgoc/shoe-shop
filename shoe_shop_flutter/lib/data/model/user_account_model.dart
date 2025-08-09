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
    return UserAccount(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      group: map['group'] ?? '',
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