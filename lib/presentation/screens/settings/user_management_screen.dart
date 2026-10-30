import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/password_hasher.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../providers/database_provider.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersDao = ref.watch(usersDaoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Staff & User Management')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Add Staff Account', style: TextStyle(color: Colors.white)),
        onPressed: () => _showAddUserDialog(context, ref),
      ),
      body: StreamBuilder<List<User>>(
        stream: usersDao.watchAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final users = snapshot.data ?? [];

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final user = users[index];
              Color roleColor = AppColors.secondary;
              if (user.role == AppConstants.roleAdmin) roleColor = AppColors.error;
              if (user.role == AppConstants.roleCashier) roleColor = AppColors.primary;

              return Card(
                color: AppColors.surface,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: roleColor.withValues(alpha: 0.15),
                    child: Icon(Icons.person, color: roleColor),
                  ),
                  title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('Role: ${user.role.toUpperCase()}'),
                  trailing: OutlinedButton(
                    onPressed: () => _showResetPinDialog(context, ref, user),
                    child: const Text('Reset PIN'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final pinController = TextEditingController();
    String role = AppConstants.roleWaiter;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Staff Account'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Staff Name'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: role,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(value: AppConstants.roleWaiter, child: Text('Waiter')),
                        DropdownMenuItem(value: AppConstants.roleCashier, child: Text('Cashier')),
                        DropdownMenuItem(value: AppConstants.roleAdmin, child: Text('Admin')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => role = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pinController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Login PIN (4 digits)'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final pin = pinController.text.trim();
                    if (name.isEmpty || pin.length < 4) return;

                    final salt = PasswordHasher.generateSalt();
                    final hash = PasswordHasher.hashPin(pin, salt);

                    final usersDao = ref.read(usersDaoProvider);
                    await usersDao.createUser(UsersCompanion.insert(
                      name: name,
                      role: role,
                      pinHash: hash,
                      salt: salt,
                    ));

                    if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                  },
                  child: const Text('Create User'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResetPinDialog(BuildContext context, WidgetRef ref, User user) {
    final pinController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text('Reset PIN for ${user.name}'),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'New 4-digit PIN'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final pin = pinController.text.trim();
                if (pin.length < 4) return;

                final salt = PasswordHasher.generateSalt();
                final hash = PasswordHasher.hashPin(pin, salt);

                final usersDao = ref.read(usersDaoProvider);
                await usersDao.resetPin(user.id, hash, salt);

                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('PIN updated for ${user.name}!')),
                  );
                }
              },
              child: const Text('Save New PIN'),
            ),
          ],
        );
      },
    );
  }
}
