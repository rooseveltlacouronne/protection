import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class UserConfig {
  final String password;
  final String email;

  UserConfig({required this.password, required this.email});

  Map<String, dynamic> toJson() => {'password': password, 'email': email};

  factory UserConfig.fromJson(Map<String, dynamic> json) =>
      UserConfig(password: json['password'], email: json['email']);
}

class StorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveConfig(UserConfig config) async {
    await _storage.write(
      key: 'user_config',
      value: jsonEncode(config.toJson()),
    );
  }

  Future<UserConfig?> getConfig() async {
    final jsonString = await _storage.read(key: 'user_config');
    if (jsonString != null) {
      return UserConfig.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  Future<bool> isConfigured() async {
    final config = await getConfig();
    return config != null && config.password.isNotEmpty && config.email.isNotEmpty;
  }
}