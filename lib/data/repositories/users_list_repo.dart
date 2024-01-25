import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:interview_test_app/data/models/users_list_model.dart';

class UsersListRepository {
  Future<List<UserData>> fetchUsersList() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users'));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> usersData = jsonData['data'];

      List<UserData> usersList =
          usersData.map((user) => UserData.fromJson(user)).toList();
      return usersList;
    } else {
      throw Exception('Failed to fetch users list');
    }
  }
}
