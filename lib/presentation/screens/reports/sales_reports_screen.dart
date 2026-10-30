import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/responsive.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../services/backup_restore_service.dart';
import '../../providers/database_provider.dart';

class SalesReportsScreen extends ConsumerStatefulWidget {
  const SalesReportsScreen({super.key});

  @override
  ConsumerState<SalesReportsScreen> createState() => _SalesReportsScreenState();
}

class _SalesReportsScreenState extends ConsumerState<SalesReportsScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final startOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 0, 0, 0);
    final endOfDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59);

    final billsDao = ref.watch(billsDaoProvider);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Reports & Day Register'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Bill>>(
        stream: billsDao.watchBillsForDateRange(startOfDay, endOfDay),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final bills = snapshot.data ?? [];
          final validBills = bills.where((b) => !b.isVoid).toList();

          double totalSales = 0.0;
          double totalTax = 0.0;
          double cashSales = 0.0;
          double cardSales = 0.0;
          double upiSales = 0.0;

          for (var b in validBills) {
            totalSales += b.total;
            totalTax += b.taxAmount;
            if (b.paymentMode == 'cash') cashSales += b.total;
            if (b.paymentMode == 'card') cardSales += b.total;
            if (b.paymentMode == 'upi') upiSales += b.total;
          }

          return SingleChildScrollView(
            padding: Responsive.screenPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Summary — ${_selectedDate.toString().substring(0, 10)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),

                // Responsive Metrics Layout
                if (isMobile)
                  Column(
                    children: [
                      _metricCardItem('Total Revenue', CurrencyFormatter.format(totalSales), Icons.payments, AppColors.primary),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _metricCardItem('Total Bills', '${validBills.length}', Icons.receipt, AppColors.secondary)),
                          const SizedBox(width: 10),
                          Expanded(child: _metricCardItem('Total Tax', CurrencyFormatter.format(totalTax), Icons.account_balance, AppColors.accent)),
                        ],
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(child: _metricCardItem('Total Revenue', CurrencyFormatter.format(totalSales), Icons.payments, AppColors.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: _metricCardItem('Total Bills', '${validBills.length}', Icons.receipt, AppColors.secondary)),
                      const SizedBox(width: 12),
                      Expanded(child: _metricCardItem('Total Tax', CurrencyFormatter.format(totalTax), Icons.account_balance, AppColors.accent)),
                    ],
                  ),
                const SizedBox(height: 20),

                // Payment Breakdown Card
                Card(
                  color: AppColors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Payment Modes Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _paymentRow('Cash Sales', CurrencyFormatter.format(cashSales), Icons.money),
                        _paymentRow('Card Sales', CurrencyFormatter.format(cardSales), Icons.credit_card),
                        _paymentRow('UPI Sales', CurrencyFormatter.format(upiSales), Icons.qr_code_2),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Day Open / Day Close Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.lock_clock),
                    label: const Text('Perform Day Close Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                    onPressed: () => _showDayCloseDialog(context, totalSales, cashSales, validBills.length),
                  ),
                ),

                const SizedBox(height: 24),
                const Text('Recent Bills', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                validBills.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(child: Text('No bills created for this date.', style: TextStyle(color: AppColors.textSecondary))),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: validBills.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final bill = validBills[index];
                          return Card(
                            color: AppColors.surface,
                            child: ListTile(
                              title: Text(bill.billNo, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Time: ${bill.createdAt.toString().substring(11, 16)} | Mode: ${bill.paymentMode.toUpperCase()}'),
                              trailing: Text(
                                CurrencyFormatter.format(bill.total),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _metricCardItem(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _paymentRow(String label, String amount, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
          Text(amount, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showDayCloseDialog(BuildContext context, double totalSales, double expectedCashSales, int totalOrders) {
    final openingCashController = TextEditingController(text: '1000');
    final actualClosingCashController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Day Close Cash Register'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: openingCashController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Opening Till Cash (₹)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: actualClosingCashController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Actual Closing Cash in Till (₹)'),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Day Sales:', style: TextStyle(fontSize: 12)),
                          Text(CurrencyFormatter.format(totalSales), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Expected Cash in Till:', style: TextStyle(fontSize: 12)),
                          Text(CurrencyFormatter.format(expectedCashSales), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogCtx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final opening = double.tryParse(openingCashController.text.trim()) ?? 0.0;
                final actualClosing = double.tryParse(actualClosingCashController.text.trim()) ?? 0.0;
                final expectedTotalCash = opening + expectedCashSales;
                final discrepancy = actualClosing - expectedTotalCash;

                // Automatically trigger daily backup copy to Documents/HotelBillingPOS folder
                final db = ref.read(databaseProvider);
                final backupService = BackupRestoreService(db);
                final backupFile = await backupService.saveBackupToFile();

                if (dialogCtx.mounted) Navigator.pop(dialogCtx);

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(discrepancy == 0 ? 'Day Closed Perfectly!' : 'Day Closed — Discrepancy Found'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expected Total Cash in Till: ${CurrencyFormatter.format(expectedTotalCash)}'),
                        Text('Actual Counted Cash: ${CurrencyFormatter.format(actualClosing)}'),
                        const SizedBox(height: 10),
                        Text(
                          'Discrepancy: ${CurrencyFormatter.format(discrepancy)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: discrepancy == 0 ? AppColors.success : AppColors.error,
                          ),
                        ),
                        if (backupFile != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Automated Backup Saved to:\nDocuments/HotelBillingPOS/${backupFile.path.split(Platform.pathSeparator).last}',
                            style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                    ],
                  ),
                );
              },
              child: const Text('Confirm Day Close'),
            ),
          ],
        );
      },
    );
  }
}
