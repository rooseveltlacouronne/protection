import 'package:protection/services/storage_service.dart';

class AuthService {
  final StorageService _storageService = StorageService();

  Future<bool> verifyPassword(String inputPassword) async {
    final config = await _storageService.getConfig();
    return config?.password == inputPassword;
  }

  Future<String?> getEmail() async {
    final config = await _storageService.getConfig();
    return config?.email;
  }
}