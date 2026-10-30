import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/tax_calculator.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/datasources/local/daos/orders_dao.dart';
import '../../../services/pdf_generator_service.dart';
import '../../providers/printer_provider.dart';

class InvoiceViewScreen extends ConsumerWidget {
  final Bill bill;
  final String tokenNo;
  final List<OrderItemWithDetail> items;
  final TaxBreakup taxBreakup;
  final Map<String, String> storeSettings;

  const InvoiceViewScreen({
    super.key,
    required this.bill,
    required this.tokenNo,
    required this.items,
    required this.taxBreakup,
    required this.storeSettings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice ${bill.billNo}'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                child: const Icon(Icons.check, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text('Payment Successful & Bill Settled!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Invoice: ${bill.billNo}', style: const TextStyle(fontSize: 16, color: AppColors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Token: $tokenNo | Total Paid: ${CurrencyFormatter.format(bill.total)} (${bill.paymentMode.toUpperCase()})', style: const TextStyle(color: AppColors.textSecondary)),

              const SizedBox(height: 30),

              // Re-Print Thermal Receipt Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.print),
                  label: const Text('Re-Print Thermal Receipt'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () async {
                    final printerService = ref.read(printerServiceProvider);
                    final paperWidth = storeSettings['paper_width_mm'] ?? '58';
                    await printerService.printBill(
                      storeSettings: storeSettings,
                      bill: bill,
                      tableNo: tokenNo,
                      items: items,
                      taxBreakup: taxBreakup,
                      paperWidth: paperWidth,
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              // PDF Preview & Share Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('View / Print PDF Bill'),
                  onPressed: () async {
                    final pdfBytes = await PdfGeneratorService.generateBillPdf(
                      storeSettings: storeSettings,
                      bill: bill,
                      tableNo: tokenNo,
                      items: items,
                      taxBreakup: taxBreakup,
                    );
                    await PdfGeneratorService.printOrSharePdf(pdfBytes);
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Done / Return to Token POS Screen
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('Return to Token POS Screen', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
