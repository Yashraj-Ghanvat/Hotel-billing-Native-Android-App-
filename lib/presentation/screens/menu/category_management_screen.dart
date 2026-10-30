import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/menu_provider.dart';

class CategoryManagementScreen extends ConsumerWidget {
  const CategoryManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Category Management')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Category', style: TextStyle(color: Colors.white)),
        onPressed: () => _showAddEditCategoryDialog(context, ref),
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
        data: (categories) {
          if (categories.isEmpty) {
            return const Center(child: Text('No categories added.', style: TextStyle(color: AppColors.textSecondary)));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Card(
                color: AppColors.surface,
                child: ListTile(
                  title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  subtitle: Text('Display Order: ${cat.displayOrder}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    onPressed: () => _showAddEditCategoryDialog(context, ref, category: cat),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddEditCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final orderController = TextEditingController(text: (category?.displayOrder ?? 1).toString());

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Edit Category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Category Name (e.g. Starters)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Display Order'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final order = int.tryParse(orderController.text.trim()) ?? 1;

                if (name.isEmpty) return;

                final menuDao = ref.read(menuDaoProvider);

                if (category == null) {
                  await menuDao.createCategory(CategoriesCompanion.insert(
                    name: name,
                    displayOrder: drift.Value(order),
                  ));
                } else {
                  await menuDao.updateCategory(Category(
                    id: category.id,
                    name: name,
                    displayOrder: order,
                    isActive: category.isActive,
                  ));
                }

                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
