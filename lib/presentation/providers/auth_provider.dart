import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/password_hasher.dart';
import '../../data/datasources/local/daos/users_dao.dart';
import '../../domain/models/user_session.dart';
import 'database_provider.dart';

final authProvider = StateNotifierProvider<AuthNotifier, UserSession?>((ref) {
  final usersDao = ref.watch(usersDaoProvider);
  return AuthNotifier(usersDao);
});

class AuthNotifier extends StateNotifier<UserSession?> {
  final UsersDao _usersDao;

  AuthNotifier(this._usersDao) : super(null);

  /// Validates entered PIN against active users
  Future<bool> loginWithPin(String pin) async {
    final activeUsers = await _usersDao.getAllActiveUsers();

    for (var u in activeUsers) {
      if (PasswordHasher.verifyPin(pin, u.pinHash, u.salt)) {
        state = UserSession(id: u.id, name: u.name, role: u.role);
        return true;
      }
    }
    return false;
  }

  void logout() {
    state = null;
  }

  Future<bool> resetUserPin(int userId, String newPin) async {
    final newSalt = PasswordHasher.generateSalt();
    final newHash = PasswordHasher.hashPin(newPin, newSalt);
    final count = await _usersDao.resetPin(userId, newHash, newSalt);
    return count > 0;
  }
}
