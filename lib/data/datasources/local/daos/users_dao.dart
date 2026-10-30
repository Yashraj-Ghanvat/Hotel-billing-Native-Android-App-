import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/users_table.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(AppDatabase db) : super(db);

  Stream<List<User>> watchAllUsers() {
    return (select(users)..where((tbl) => tbl.isActive.equals(true))).watch();
  }

  Future<List<User>> getAllActiveUsers() {
    return (select(users)..where((tbl) => tbl.isActive.equals(true))).get();
  }

  Future<User?> getUserById(int id) {
    return (select(users)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<User?> getUserByRole(String role) {
    return (select(users)..where((tbl) => tbl.role.equals(role) & tbl.isActive.equals(true))).getSingleOrNull();
  }

  Future<int> createUser(UsersCompanion user) => into(users).insert(user);

  Future<bool> updateUser(User user) => update(users).replace(user);

  Future<int> resetPin(int userId, String newPinHash, String salt) {
    return (update(users)..where((tbl) => tbl.id.equals(userId))).write(
      UsersCompanion(
        pinHash: Value(newPinHash),
        salt: Value(salt),
      ),
    );
  }

  Future<int> deactivateUser(int userId) {
    return (update(users)..where((tbl) => tbl.id.equals(userId))).write(
      const UsersCompanion(isActive: Value(false)),
    );
  }
}
