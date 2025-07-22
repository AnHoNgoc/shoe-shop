class Group {
  final int id;
  final String name;
  final List<dynamic> roles;

  Group({
    required this.id,
    required this.name,
    required this.roles,
  });

  factory Group.fromJson(Map<String, dynamic> map) {
    return Group(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      roles: map['Roles'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'Roles': roles,
    };
  }
}