import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/table_provider.dart';
import '../../providers/order_provider.dart';
import '../orders/order_taking_screen.dart';

class TableGridScreen extends ConsumerStatefulWidget {
  const TableGridScreen({super.key});

  @override
  ConsumerState<TableGridScreen> createState() => _TableGridScreenState();
}

class _TableGridScreenState extends ConsumerState<TableGridScreen> {
  String _selectedStatusFilter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final tablesAsync = ref.watch(tablesStreamProvider);
    final isMobile = Responsive.isMobile(context);
    final columns = Responsive.gridColumnCount(context, itemWidth: 160.0, minColumns: 2, maxColumns: 6);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Table Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_rounded),
            tooltip: 'Add Table',
            onPressed: () => _showAddEditTableDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Tables',
            onPressed: () => ref.invalidate(tablesStreamProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New Table', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        onPressed: () => _showAddEditTableDialog(context, ref),
      ),
      body: tablesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error loading tables: $err', style: const TextStyle(color: AppColors.error))),
        data: (tables) {
          final totalSeats = tables.fold<int>(0, (sum, t) => sum + t.capacity);
          final occupiedSeats = tables.where((t) => t.status == AppConstants.tableOccupied || t.status == AppConstants.tableBilled).fold<int>(0, (sum, t) => sum + t.capacity);

          final filteredTables = tables.where((t) {
            if (_selectedStatusFilter == 'ALL') return true;
            return t.status == _selectedStatusFilter;
          }).toList();

          return Column(
            children: [
              // Overall Capacity Banner & Status Filter Bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(bottom: BorderSide(color: AppColors.borders)),
                ),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_seat_rounded, color: AppColors.primary, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '${tables.length} Tables | Total: $totalSeats Seats ($occupiedSeats Occupied)',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Filter Status:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                              DropdownButton<String>(
                                value: _selectedStatusFilter,
                                underline: const SizedBox(),
                                isDense: true,
                                icon: const Icon(Icons.filter_list, size: 16, color: AppColors.primary),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                items: const [
                                  DropdownMenuItem(value: 'ALL', child: Text('All Tables')),
                                  DropdownMenuItem(value: AppConstants.tableAvailable, child: Text('Available')),
                                  DropdownMenuItem(value: AppConstants.tableOccupied, child: Text('Occupied')),
                                  DropdownMenuItem(value: AppConstants.tableBilled, child: Text('Billed')),
                                  DropdownMenuItem(value: AppConstants.tableReserved, child: Text('Reserved')),
                                ],
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedStatusFilter = val);
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.event_seat_rounded, color: AppColors.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                '${tables.length} Tables | Total Capacity: $totalSeats Seats ($occupiedSeats Occupied)',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          DropdownButton<String>(
                            value: _selectedStatusFilter,
                            underline: const SizedBox(),
                            icon: const Icon(Icons.filter_list, size: 18, color: AppColors.primary),
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            items: const [
                              DropdownMenuItem(value: 'ALL', child: Text('All Tables')),
                              DropdownMenuItem(value: AppConstants.tableAvailable, child: Text('Available')),
                              DropdownMenuItem(value: AppConstants.tableOccupied, child: Text('Occupied')),
                              DropdownMenuItem(value: AppConstants.tableBilled, child: Text('Billed')),
                              DropdownMenuItem(value: AppConstants.tableReserved, child: Text('Reserved')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedStatusFilter = val);
                            },
                          ),
                        ],
                      ),
              ),

              // Scrollable Status Legend Bar (Zero clipping on narrow mobile screens)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: AppColors.surfaceLight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildLegendItem('Available', AppColors.tableAvailable, tables.where((t) => t.status == AppConstants.tableAvailable).length),
                      const SizedBox(width: 16),
                      _buildLegendItem('Occupied', AppColors.tableOccupied, tables.where((t) => t.status == AppConstants.tableOccupied).length),
                      const SizedBox(width: 16),
                      _buildLegendItem('Billed', AppColors.tableBilled, tables.where((t) => t.status == AppConstants.tableBilled).length),
                      const SizedBox(width: 16),
                      _buildLegendItem('Reserved', AppColors.tableReserved, tables.where((t) => t.status == AppConstants.tableReserved).length),
                    ],
                  ),
                ),
              ),

              // Responsive Table Grid
              Expanded(
                child: filteredTables.isEmpty
                    ? const Center(
                        child: Text(
                          'No tables found for this filter.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : GridView.builder(
                        padding: Responsive.screenPadding(context),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          childAspectRatio: isMobile ? 1.25 : 1.15,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredTables.length,
                        itemBuilder: (context, index) {
                          final table = filteredTables[index];
                          Color statusColor = AppColors.tableAvailable;
                          if (table.status == AppConstants.tableOccupied) statusColor = AppColors.tableOccupied;
                          if (table.status == AppConstants.tableBilled) statusColor = AppColors.tableBilled;
                          if (table.status == AppConstants.tableReserved) statusColor = AppColors.tableReserved;

                          return Card(
                            color: AppColors.surface,
                            clipBehavior: Clip.antiAlias,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: statusColor, width: 2.0),
                            ),
                            child: InkWell(
                              onTap: () async {
                                ref.read(selectedTableIdProvider.notifier).state = table.id;
                                final ordersDao = ref.read(ordersDaoProvider);
                                final tablesDao = ref.read(tablesDaoProvider);
                                Order? order;
                                if (table.currentOrderId != null) {
                                  order = await ordersDao.getOrderById(table.currentOrderId!);
                                }
                                if (order == null) {
                                  final newOrderId = await ref.read(orderControllerProvider).createNewTokenOrder(orderType: 'dine_in');
                                  await tablesDao.updateTableStatus(table.id, AppConstants.tableOccupied, orderId: newOrderId);
                                  order = await ordersDao.getOrderById(newOrderId);
                                }
                                if (order != null && context.mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OrderTakingScreen(order: order!),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Top Row: Table Name, Status Pill & Overflow-proof Popup Menu
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Flexible(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    table.tableNo,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withValues(alpha: 0.15),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  table.status.toUpperCase(),
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    fontWeight: FontWeight.bold,
                                                    color: statusColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // More options (Edit / Delete / Reserve)
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: PopupMenuButton<String>(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textSecondary),
                                            onSelected: (action) => _handleTableAction(action, table, context, ref),
                                            itemBuilder: (ctx) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit, size: 18, color: AppColors.primary),
                                                    SizedBox(width: 8),
                                                    Text('Edit Seats / Name'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 'reserve',
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      table.status == AppConstants.tableReserved ? Icons.event_available : Icons.bookmark,
                                                      size: 18,
                                                      color: AppColors.tableReserved,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(table.status == AppConstants.tableReserved ? 'Mark Available' : 'Mark Reserved'),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete_forever, size: 18, color: AppColors.error),
                                                    SizedBox(width: 8),
                                                    Text('Delete Table', style: TextStyle(color: AppColors.error)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Seating Capacity Row
                                    Row(
                                      children: [
                                        const Icon(Icons.people_outline, size: 14, color: AppColors.textSecondary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            '${table.capacity} Seats',
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Active Order Tag
                                    if (table.currentOrderId != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'Order #${table.currentOrderId}',
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          '$label ($count)',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  void _handleTableAction(String action, RestaurantTable table, BuildContext context, WidgetRef ref) {
    if (action == 'edit') {
      _showAddEditTableDialog(context, ref, table: table);
    } else if (action == 'reserve') {
      final newStatus = table.status == AppConstants.tableReserved ? AppConstants.tableAvailable : AppConstants.tableReserved;
      ref.read(tablesDaoProvider).updateTableStatus(table.id, newStatus);
    } else if (action == 'delete') {
      if (table.status == AppConstants.tableOccupied || table.status == AppConstants.tableBilled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot delete Table ${table.tableNo} while it is ${table.status.toUpperCase()} with an active order!'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      _confirmDeleteTable(context, ref, table);
    }
  }

  void _confirmDeleteTable(BuildContext context, WidgetRef ref, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: Text('Delete Table ${table.tableNo}?'),
          content: Text('Are you sure you want to delete Table ${table.tableNo} (${table.capacity} seats)? This operation cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                await ref.read(tablesDaoProvider).deleteTable(table.id);
                if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                messenger.showSnackBar(
                  SnackBar(content: Text('Table ${table.tableNo} deleted successfully.')),
                );
              },
              child: const Text('Delete Table', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddEditTableDialog(BuildContext context, WidgetRef ref, {RestaurantTable? table}) {
    final tableNoController = TextEditingController(text: table?.tableNo ?? '');
    int capacity = table?.capacity ?? 4;

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(table == null ? 'Add New Table' : 'Edit Table ${table.tableNo}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: tableNoController,
                      decoration: const InputDecoration(
                        labelText: 'Table Number / Name',
                        hintText: 'e.g. T-11, VIP-1, Terrace 3',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Seating Capacity (People Seats):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),

                    // Preset Seat Chips (2, 4, 6, 8, 12, 16)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [2, 4, 6, 8, 12, 16].map((seats) {
                        final isSelected = capacity == seats;
                        return ChoiceChip(
                          label: Text('$seats Seats'),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (_) {
                            setDialogState(() => capacity = seats);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Custom Capacity:', style: TextStyle(color: AppColors.textSecondary)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                              onPressed: () {
                                if (capacity > 1) setDialogState(() => capacity--);
                              },
                            ),
                            Text('$capacity Seats', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                              onPressed: () {
                                setDialogState(() => capacity++);
                              },
                            ),
                          ],
                        ),
                      ],
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
                    final messenger = ScaffoldMessenger.of(context);
                    final tableNo = tableNoController.text.trim();
                    if (tableNo.isEmpty) {
                      ScaffoldMessenger.of(dialogCtx).showSnackBar(
                        const SnackBar(content: Text('Please enter a table number.')),
                      );
                      return;
                    }

                    final tablesDao = ref.read(tablesDaoProvider);
                    if (table == null) {
                      final existing = await tablesDao.getAllTables();
                      await tablesDao.createTable(
                        RestaurantTablesCompanion.insert(
                          tableNo: tableNo,
                          capacity: drift.Value(capacity),
                          displayOrder: drift.Value(existing.length + 1),
                        ),
                      );
                    } else {
                      await tablesDao.updateTable(
                        table.copyWith(
                          tableNo: tableNo,
                          capacity: capacity,
                        ),
                      );
                    }

                    if (dialogCtx.mounted) Navigator.pop(dialogCtx);
                    messenger.showSnackBar(
                      SnackBar(content: Text(table == null ? 'Table $tableNo created successfully!' : 'Table $tableNo updated!')),
                    );
                  },
                  child: Text(table == null ? 'Add Table' : 'Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
