import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/datasources/local/daos/orders_dao.dart';
import '../../providers/database_provider.dart';
import '../../providers/order_provider.dart';
import '../orders/order_taking_screen.dart';
import 'token_display_screen.dart';

class TokenPosScreen extends ConsumerStatefulWidget {
  const TokenPosScreen({super.key});

  @override
  ConsumerState<TokenPosScreen> createState() => _TokenPosScreenState();
}

class _TokenPosScreenState extends ConsumerState<TokenPosScreen> {
  String _filterStatus = 'all'; // 'all', 'preparing', 'ready', 'completed'

  @override
  Widget build(BuildContext context) {
    final todayOrdersAsync = ref.watch(todayOrdersStreamProvider);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Token POS & Kitchen Display'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tv),
            tooltip: 'Open TV Customer Token Display',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TokenDisplayScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: todayOrdersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
        data: (ordersList) {
          final preparingOrders = ordersList.where((o) => o.tokenStatus == 'preparing').toList();
          final readyOrders = ordersList.where((o) => o.tokenStatus == 'ready').toList();
          final completedOrders = ordersList.where((o) => o.tokenStatus == 'completed').toList();

          List<Order> filteredList = ordersList;
          if (_filterStatus == 'preparing') filteredList = preparingOrders;
          if (_filterStatus == 'ready') filteredList = readyOrders;
          if (_filterStatus == 'completed') filteredList = completedOrders;

          final gridColumns = Responsive.gridColumnCount(context, itemWidth: 280.0, minColumns: 1, maxColumns: 4);

          return Padding(
            padding: Responsive.screenPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Metrics & New Order Bar
                if (isMobile)
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _metricCard('Total', '${ordersList.length}', Icons.confirmation_number, AppColors.primary)),
                          const SizedBox(width: 8),
                          Expanded(child: _metricCard('Preparing', '${preparingOrders.length}', Icons.soup_kitchen, AppColors.warning)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _metricCard('Ready', '${readyOrders.length}', Icons.notifications_active, AppColors.success)),
                          const SizedBox(width: 8),
                          Expanded(child: _metricCard('Completed', '${completedOrders.length}', Icons.check_circle, AppColors.textMuted)),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(child: _metricCard('Total Tokens Today', '${ordersList.length}', Icons.confirmation_number, AppColors.primary)),
                      const SizedBox(width: 10),
                      Expanded(child: _metricCard('Preparing (Kitchen)', '${preparingOrders.length}', Icons.soup_kitchen, AppColors.warning)),
                      const SizedBox(width: 10),
                      Expanded(child: _metricCard('Ready for Pickup', '${readyOrders.length}', Icons.notifications_active, AppColors.success)),
                      const SizedBox(width: 10),
                      Expanded(child: _metricCard('Delivered / Done', '${completedOrders.length}', Icons.check_circle, AppColors.textMuted)),
                    ],
                  ),

                const SizedBox(height: 16),

                // Controls Bar: Filter Chips & New Order Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: Text('All (${ordersList.length})'),
                            selected: _filterStatus == 'all',
                            onSelected: (_) => setState(() => _filterStatus = 'all'),
                          ),
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: Text('Preparing (${preparingOrders.length})'),
                            selected: _filterStatus == 'preparing',
                            onSelected: (_) => setState(() => _filterStatus = 'preparing'),
                          ),
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: Text('Ready (${readyOrders.length})'),
                            selected: _filterStatus == 'ready',
                            onSelected: (_) => setState(() => _filterStatus = 'ready'),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('NEW TOKEN ORDER', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: () async {
                        final orderId = await ref.read(orderControllerProvider).createNewTokenOrder(orderType: 'takeaway');
                        if (!context.mounted) return;
                        final ordersDao = ref.read(ordersDaoProvider);
                        final newOrder = await ordersDao.getOrderById(orderId);
                        if (newOrder != null && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderTakingScreen(order: newOrder),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tokens Grid
                Expanded(
                  child: filteredList.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.confirmation_number_outlined, size: 60, color: AppColors.textMuted),
                              SizedBox(height: 12),
                              Text('No Token Orders Found', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                              Text('Click "NEW TOKEN ORDER" to create one', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridColumns,
                            childAspectRatio: 1.35,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final order = filteredList[index];
                            return _TokenCardItem(order: order);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _metricCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TokenCardItem extends ConsumerWidget {
  final Order order;

  const _TokenCardItem({required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersDao = ref.watch(ordersDaoProvider);
    final formattedToken = '#${order.tokenNo.toString().padLeft(3, '0')}';
    final isTakeaway = order.orderType == 'takeaway';

    Color statusColor = AppColors.warning;
    String statusText = 'PREPARING';
    if (order.tokenStatus == 'ready') {
      statusColor = AppColors.success;
      statusText = 'READY!';
    } else if (order.tokenStatus == 'completed') {
      statusColor = AppColors.textMuted;
      statusText = 'DONE';
    }

    return Card(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withValues(alpha: 0.5), width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ref.read(selectedOrderIdProvider.notifier).state = order.id;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => OrderTakingScreen(order: order)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header Row: Token # and Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      formattedToken,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusColor),
                    ),
                  ),
                ],
              ),

              // Subheader: Order Type & Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(isTakeaway ? Icons.shopping_bag_outlined : Icons.restaurant, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        isTakeaway ? 'PARCEL' : 'DINE-IN',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Text(
                    order.createdAt.toString().substring(11, 16),
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),

              // Items Summary Preview
              Expanded(
                child: StreamBuilder<List<OrderItemWithDetail>>(
                  stream: ordersDao.watchOrderItemsWithDetail(order.id),
                  builder: (context, snapshot) {
                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('No items added', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      );
                    }
                    final summaryStr = items.map((i) => '${i.menuItem.name} x${i.orderItem.quantity}').join(', ');
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        summaryStr,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    );
                  },
                ),
              ),

              // Action Buttons Row
              Row(
                children: [
                  if (order.tokenStatus == 'preparing')
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.notifications_active, size: 16),
                        label: const Text('MARK READY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 34),
                        ),
                        onPressed: () async {
                          await ordersDao.updateTokenStatus(order.id, 'ready');
                        },
                      ),
                    ),
                  if (order.tokenStatus == 'ready')
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('DELIVER / DONE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 34),
                        ),
                        onPressed: () async {
                          await ordersDao.updateTokenStatus(order.id, 'completed');
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
