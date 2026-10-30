import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/menu_provider.dart';

class MenuItemManagementScreen extends ConsumerStatefulWidget {
  const MenuItemManagementScreen({super.key});

  @override
  ConsumerState<MenuItemManagementScreen> createState() => _MenuItemManagementScreenState();
}

class _MenuItemManagementScreenState extends ConsumerState<MenuItemManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuItemsAsync = ref.watch(allMenuItemsManagementStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Menu Items Management')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Menu Item', style: TextStyle(color: Colors.white)),
        onPressed: () {
          final cats = categoriesAsync.value ?? [];
          if (cats.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please add at least one category first.')),
            );
            return;
          }
          _showAddEditMenuItemDialog(context, ref, categories: cats);
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                ref.read(menuSearchQueryProvider.notifier).state = val;
              },
            ),
          ),
          Expanded(
            child: menuItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('No menu items found.', style: TextStyle(color: AppColors.textSecondary)));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: AppColors.surface,
                      child: ListTile(
                        leading: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: item.isVeg ? AppColors.veg : AppColors.nonVeg,
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text('Price: ${CurrencyFormatter.format(item.price)} | GST: ${item.taxRate}% | HSN: ${item.hsnCode ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.primary),
                          onPressed: () {
                            final cats = categoriesAsync.value ?? [];
                            _showAddEditMenuItemDialog(context, ref, categories: cats, menuItem: item);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEditMenuItemDialog(
    BuildContext context,
    WidgetRef ref, {
    required List<Category> categories,
    MenuItem? menuItem,
  }) {
    final nameController = TextEditingController(text: menuItem?.name ?? '');
    final priceController = TextEditingController(text: menuItem?.price.toString() ?? '');
    final taxRateController = TextEditingController(text: (menuItem?.taxRate ?? 5.0).toString());
    final hsnController = TextEditingController(text: menuItem?.hsnCode ?? '2106');

    int selectedCatId = menuItem?.categoryId ?? categories.first.id;
    bool isVeg = menuItem?.isVeg ?? true;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(menuItem == null ? 'Add Menu Item' : 'Edit Menu Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Item Name (e.g. Paneer Butter Masala)'),
                    ),
                    const SizedBox(height: 12),

                    // Category Selector Dropdown
                    DropdownButtonFormField<int>(
                      initialValue: selectedCatId,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: categories.map((c) {
                        return DropdownMenuItem<int>(
                          value: c.id,
                          child: Text(c.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedCatId = val);
                      },
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price (₹)'),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: taxRateController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'GST Tax Rate % (e.g. 5.0)'),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: hsnController,
                      decoration: const InputDecoration(labelText: 'HSN / SAC Code'),
                    ),
                    const SizedBox(height: 14),

                    // Veg / Non-Veg Switch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(color: isVeg ? AppColors.veg : AppColors.nonVeg, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  isVeg ? 'Vegetarian (Veg)' : 'Non-Vegetarian (Non-Veg)',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isVeg,
                          activeThumbColor: AppColors.veg,
                          inactiveTrackColor: AppColors.nonVeg.withValues(alpha: 0.3),
                          onChanged: (val) => setDialogState(() => isVeg = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
                    final tax = double.tryParse(taxRateController.text.trim()) ?? 5.0;
                    final hsn = hsnController.text.trim();

                    if (name.isEmpty || price <= 0) return;

                    final menuDao = ref.read(menuDaoProvider);

                    if (menuItem == null) {
                      await menuDao.createMenuItem(MenuItemsCompanion.insert(
                        categoryId: selectedCatId,
                        name: name,
                        price: price,
                        taxRate: drift.Value(tax),
                        hsnCode: drift.Value(hsn),
                        isVeg: drift.Value(isVeg),
                      ));
                    } else {
                      await menuDao.updateMenuItem(MenuItem(
                        id: menuItem.id,
                        categoryId: selectedCatId,
                        name: name,
                        price: price,
                        taxRate: tax,
                        hsnCode: hsn,
                        isVeg: isVeg,
                        isActive: menuItem.isActive,
                      ));
                    }

                    if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                  },
                  child: const Text('Save Item'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
