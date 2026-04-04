import '../models/user_model.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  User? _currentUser;
  String? _accessToken;

  User? get currentUser => _currentUser;
  String? get accessToken => _accessToken;

  void saveSession(AuthResponse response) {
    _currentUser = response.user;
    _accessToken = response.accessToken;
  }

  void clearSession() {
    _currentUser = null;
    _accessToken = null;
  }

  bool get isLoggedIn => _currentUser != null;
}
