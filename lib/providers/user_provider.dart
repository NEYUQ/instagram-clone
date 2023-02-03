import 'package:flutter/material.dart';
import 'package:instagram_flutter/Models/user.dart';
import 'package:instagram_flutter/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  final AuthMethod _authMethod = AuthMethod();
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
