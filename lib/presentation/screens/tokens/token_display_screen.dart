import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/order_provider.dart';

class TokenDisplayScreen extends ConsumerWidget {
  const TokenDisplayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayOrdersAsync = ref.watch(todayOrdersStreamProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Icon(Icons.tv, color: AppColors.primary),
            SizedBox(width: 10),
            Text(
              'CUSTOMER TOKEN DISPLAY',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ],
        ),
      ),
      body: todayOrdersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
        data: (ordersList) {
          final preparingList = ordersList.where((o) => o.tokenStatus == 'preparing').toList();
          final readyList = ordersList.where((o) => o.tokenStatus == 'ready').toList();

          return Row(
            children: [
              // Preparing Tokens Column (Left)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.5), width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.soup_kitchen, color: AppColors.warning, size: 28),
                            SizedBox(width: 10),
                            Text(
                              'PREPARING IN KITCHEN',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.warning),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: preparingList.isEmpty
                            ? const Center(child: Text('No Tokens Preparing', style: TextStyle(color: Colors.grey, fontSize: 18)))
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.8,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: preparingList.length,
                                itemBuilder: (context, index) {
                                  final order = preparingList[index];
                                  final formattedToken = '#${order.tokenNo.toString().padLeft(3, '0')}';
                                  return _displayTokenTile(formattedToken, AppColors.warning);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              // Ready Tokens Column (Right)
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.5), width: 2),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_active, color: AppColors.success, size: 28),
                            SizedBox(width: 10),
                            Text(
                              'READY FOR PICKUP',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.success),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: readyList.isEmpty
                            ? const Center(child: Text('No Tokens Ready', style: TextStyle(color: Colors.grey, fontSize: 18)))
                            : GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.8,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: readyList.length,
                                itemBuilder: (context, index) {
                                  final order = readyList[index];
                                  final formattedToken = '#${order.tokenNo.toString().padLeft(3, '0')}';
                                  return _displayTokenTile(formattedToken, AppColors.success, isPulse: true);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _displayTokenTile(String token, Color color, {bool isPulse = false}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        token,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
