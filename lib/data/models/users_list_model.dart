class UsersList {
  final List<UserData> usersList;

  UsersList({required this.usersList});
}

class UserData {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
      );
}