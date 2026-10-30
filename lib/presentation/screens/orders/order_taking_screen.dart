import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../providers/database_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/printer_provider.dart';
import '../billing/checkout_screen.dart';

class OrderTakingScreen extends ConsumerStatefulWidget {
  final Order order;

  const OrderTakingScreen({super.key, required this.order});

  @override
  ConsumerState<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends ConsumerState<OrderTakingScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _mobileTabController;
  late String _orderType;

  @override
  void initState() {
    super.initState();
    _mobileTabController = TabController(length: 2, vsync: this);
    _orderType = widget.order.orderType;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mobileTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final menuItemsAsync = ref.watch(filteredMenuItemsStreamProvider);
    final selectedCatId = ref.watch(selectedCategoryIdProvider);
    final orderItemsAsync = ref.watch(orderItemsStreamProvider);
    final isMobile = Responsive.isMobile(context);

    final orderItemsCount = orderItemsAsync.value?.length ?? 0;
    final formattedToken = '#${widget.order.tokenNo.toString().padLeft(3, '0')}';

    // Build Menu View Component
    Widget buildMenuView() {
      final menuColumns = Responsive.gridColumnCount(context, itemWidth: 150.0, minColumns: 2, maxColumns: 4);

      return Column(
        children: [
          // Order Type Selector (Takeaway vs Dine-In)
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borders),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      avatar: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: const Text('PARCEL / TAKEAWAY'),
                      selected: _orderType == 'takeaway',
                      onSelected: (val) async {
                        if (val) {
                          setState(() => _orderType = 'takeaway');
                          await ref.read(ordersDaoProvider).updateOrderType(widget.order.id, 'takeaway');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      avatar: const Icon(Icons.restaurant, size: 16),
                      label: const Text('DINE-IN'),
                      selected: _orderType == 'dine_in',
                      onSelected: (val) async {
                        if (val) {
                          setState(() => _orderType = 'dine_in');
                          await ref.read(ordersDaoProvider).updateOrderType(widget.order.id, 'dine_in');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(menuSearchQueryProvider.notifier).state = val;
              },
              decoration: InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(menuSearchQueryProvider.notifier).state = '';
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Horizontal Categories Tab Bar
          categoriesAsync.when(
            loading: () => const SizedBox(height: 50),
            error: (_, __) => const SizedBox(height: 50),
            data: (categories) {
              return SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    ChoiceChip(
                      label: const Text('All Items'),
                      selected: selectedCatId == null,
                      onSelected: (_) {
                        ref.read(selectedCategoryIdProvider.notifier).state = null;
                      },
                    ),
                    const SizedBox(width: 8),
                    ...categories.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(cat.name),
                          selected: selectedCatId == cat.id,
                          onSelected: (_) {
                            ref.read(selectedCategoryIdProvider.notifier).state = cat.id;
                          },
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          // Menu Items Grid
          Expanded(
            child: menuItemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text('No menu items found', style: TextStyle(color: AppColors.textSecondary)),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: menuColumns,
                    childAspectRatio: 1.1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      color: AppColors.surface,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          ref.read(orderControllerProvider).updateItemQuantity(
                            menuItem: item,
                            quantityDelta: 1,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: item.isVeg ? AppColors.veg : AppColors.nonVeg,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        CurrencyFormatter.format(item.price),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.add, size: 16, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    }

    // Build Cart Summary View Component
    Widget buildCartView() {
      return Container(
        color: AppColors.surface,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: AppColors.surfaceLight,
                border: Border(bottom: BorderSide(color: AppColors.borders)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Token $formattedToken Cart',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  orderItemsAsync.when(
                    data: (items) => Text('${items.length} Items', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
            ),

            // Cart Items List
            Expanded(
              child: orderItemsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.textMuted),
                          SizedBox(height: 10),
                          Text('Cart is empty', style: TextStyle(color: AppColors.textSecondary)),
                          Text('Tap menu items to add', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    );
                  }

                  double orderSubtotal = 0;
                  for (var item in items) {
                    orderSubtotal += item.orderItem.quantity * item.orderItem.priceAtOrder;
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(10),
                          itemCount: items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borders),
                          itemBuilder: (context, index) {
                            final orderDetail = items[index];
                            final lineTotal = orderDetail.orderItem.quantity * orderDetail.orderItem.priceAtOrder;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          orderDetail.menuItem.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                      ),
                                      Text(
                                        CurrencyFormatter.format(lineTotal),
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // KOT Status Badge
                                      if (orderDetail.orderItem.kotPrintedQuantity > 0)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.info.withValues(alpha: 0.15),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            'KOT Sent (${orderDetail.orderItem.kotPrintedQuantity})',
                                            style: const TextStyle(fontSize: 10, color: AppColors.info, fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      else
                                        const Text('Not Printed', style: TextStyle(fontSize: 10, color: AppColors.warning)),

                                      // Quantity Controls (+ / -)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline, size: 22, color: AppColors.error),
                                            onPressed: () {
                                              ref.read(orderControllerProvider).updateItemQuantity(
                                                menuItem: orderDetail.menuItem,
                                                quantityDelta: -1,
                                              );
                                            },
                                          ),
                                          Text(
                                            '${orderDetail.orderItem.quantity}',
                                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline, size: 22, color: AppColors.primary),
                                            onPressed: () {
                                              ref.read(orderControllerProvider).updateItemQuantity(
                                                menuItem: orderDetail.menuItem,
                                                quantityDelta: 1,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Footer Controls & Subtotal
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceLight,
                          border: Border(top: BorderSide(color: AppColors.borders)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal:', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                                Text(
                                  CurrencyFormatter.format(orderSubtotal),
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                // KOT Printer Button
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.print, size: 18),
                                    label: const Text('Send KOT'),
                                    onPressed: () async {
                                      final messenger = ScaffoldMessenger.of(context);
                                      final ticket = await ref.read(orderControllerProvider).prepareKotTicket(widget.order.id);
                                      if (ticket == null) {
                                        messenger.showSnackBar(
                                          const SnackBar(content: Text('No new unprinted items for KOT.')),
                                        );
                                        return;
                                      }

                                      final printerService = ref.read(printerServiceProvider);
                                      final settings = ref.read(settingsStreamProvider).value ?? {};
                                      final paperWidth = settings['paper_width_mm'] ?? '58';

                                      final printed = await printerService.printKot(
                                        ticket: ticket,
                                        paperWidth: paperWidth,
                                        storeSettings: settings,
                                      );

                                      if (printed) {
                                        await ref.read(orderControllerProvider).confirmKotPrinted(widget.order.id);
                                        messenger.showSnackBar(
                                          SnackBar(content: Text(ticket.isAdditionKot ? 'Addition KOT Printed!' : 'KOT Printed Successfully!')),
                                        );
                                      } else {
                                        messenger.showSnackBar(
                                          const SnackBar(content: Text('Printer disconnected or off. Check printer settings.')),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Checkout Button
                                Expanded(
                                  child: ElevatedButton.icon(
                                    icon: const Icon(Icons.receipt_long, size: 18),
                                    label: const Text('Checkout'),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                    onPressed: () {
                                      if (items.isEmpty) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CheckoutScreen(
                                            order: widget.order,
                                            items: items,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Token $formattedToken Order'),
          bottom: TabBar(
            controller: _mobileTabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: [
              const Tab(icon: Icon(Icons.restaurant_menu), text: 'Menu Items'),
              Tab(
                icon: Badge.count(
                  count: orderItemsCount,
                  isLabelVisible: orderItemsCount > 0,
                  child: const Icon(Icons.shopping_cart),
                ),
                text: 'Order Cart',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _mobileTabController,
          children: [
            buildMenuView(),
            buildCartView(),
          ],
        ),
      );
    }

    // Tablet Side-by-Side View
    return Scaffold(
      appBar: AppBar(
        title: Text('Token $formattedToken Order Taking'),
      ),
      body: Row(
        children: [
          Expanded(flex: 6, child: buildMenuView()),
          const VerticalDivider(width: 1, color: AppColors.borders),
          Expanded(flex: 4, child: buildCartView()),
        ],
      ),
    );
  }
}
