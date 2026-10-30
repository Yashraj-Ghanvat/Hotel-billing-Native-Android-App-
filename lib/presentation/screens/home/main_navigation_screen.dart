import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../providers/auth_provider.dart';
import '../tokens/token_pos_screen.dart';
import '../tables/table_grid_screen.dart';
import '../menu/menu_item_management_screen.dart';
import '../menu/category_management_screen.dart';
import '../reports/sales_reports_screen.dart';
import '../settings/store_settings_screen.dart';
import '../settings/printer_settings_screen.dart';
import '../settings/user_management_screen.dart';
import '../settings/backup_restore_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    TokenPosScreen(),
    TableGridScreen(),
    MenuItemManagementScreen(),
    CategoryManagementScreen(),
    SalesReportsScreen(),
    StoreSettingsScreen(),
    PrinterSettingsScreen(),
    UserManagementScreen(),
    BackupRestoreScreen(),
  ];

  final List<_NavDestination> _navDestinations = const [
    _NavDestination('Token POS & Display', Icons.confirmation_number),
    _NavDestination('Dining Tables', Icons.table_restaurant),
    _NavDestination('Menu Items', Icons.restaurant_menu),
    _NavDestination('Categories', Icons.category),
    _NavDestination('Reports & Register', Icons.bar_chart),
    _NavDestination('Store Profile', Icons.store),
    _NavDestination('Printer Configuration', Icons.print),
    _NavDestination('Staff Users', Icons.people),
    _NavDestination('Backup & Restore', Icons.backup),
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_navDestinations[_selectedIndex].label),
        ),
        drawer: Drawer(
          backgroundColor: AppColors.surface,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: AppColors.surfaceLight),
                currentAccountPicture: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.restaurant, color: AppColors.primary, size: 32),
                ),
                accountName: Text(
                  user?.name ?? 'Staff User',
                  style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                accountEmail: Text(
                  'ROLE: ${user?.role.toUpperCase() ?? 'STAFF'}',
                  style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _navDestinations.length,
                  itemBuilder: (context, index) {
                    final item = _navDestinations[index];
                    final isSelected = index == _selectedIndex;
                    return ListTile(
                      leading: Icon(
                        item.icon,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                      title: Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      selected: isSelected,
                      selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
                      onTap: () {
                        setState(() => _selectedIndex = index);
                        Navigator.pop(context); // Close drawer
                      },
                    );
                  },
                ),
              ),
              const Divider(color: AppColors.borders),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Logout Staff', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  ref.read(authProvider.notifier).logout();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        body: _screens[_selectedIndex],
      );
    }

    // Tablet & Large Screen View (Side NavigationRail)
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AppColors.surface,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            extended: true,
            selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 24),
            unselectedIconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
            selectedLabelTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelTextStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            indicatorColor: AppColors.primary.withValues(alpha: 0.15),
            leading: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: const Icon(Icons.restaurant, color: AppColors.primary, size: 28),
                ),
                const SizedBox(height: 8),
                Text(user?.name ?? 'Staff', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    user?.role.toUpperCase() ?? 'STAFF',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: IconButton(
                icon: const Icon(Icons.logout, color: AppColors.error),
                tooltip: 'Logout Staff',
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
              ),
            ),
            destinations: _navDestinations.map((d) {
              return NavigationRailDestination(
                icon: Icon(d.icon),
                label: Text(d.label),
              );
            }).toList(),
          ),
          const VerticalDivider(width: 1, color: AppColors.borders),

          // Main View Content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }
}

class _NavDestination {
  final String label;
  final IconData icon;

  const _NavDestination(this.label, this.icon);
}
