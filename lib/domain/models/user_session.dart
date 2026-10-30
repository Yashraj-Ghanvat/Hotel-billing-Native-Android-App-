import '../../core/constants/app_constants.dart';

class UserSession {
  final int id;
  final String name;
  final String role; // 'admin', 'cashier', 'waiter'

  UserSession({
    required this.id,
    required this.name,
    required this.role,
  });

  bool get isAdmin => role == AppConstants.roleAdmin;
  bool get isCashier => role == AppConstants.roleCashier || isAdmin;
  bool get isWaiter => role == AppConstants.roleWaiter || isCashier;
}
