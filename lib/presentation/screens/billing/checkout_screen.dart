import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/tax_calculator.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/datasources/local/daos/orders_dao.dart';
import '../../providers/database_provider.dart';
import '../../providers/printer_provider.dart';
import '../../providers/settings_provider.dart';
import 'invoice_view_screen.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final Order order;
  final List<OrderItemWithDetail> items;

  const CheckoutScreen({
    super.key,
    required this.order,
    required this.items,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  double _discountVal = 0.0;
  String _discountType = 'flat'; // 'flat' or 'percent'
  String _paymentMode = 'cash'; // 'cash', 'card', 'upi'
  final TextEditingController _discountController = TextEditingController();

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsMap = ref.watch(settingsStreamProvider).value ?? {};
    final defaultTaxRate = double.tryParse(settingsMap[AppConstants.keyDefaultTaxRate] ?? '5.0') ?? 5.0;
    final isTaxInclusive = settingsMap[AppConstants.keyTaxInclusive] == 'true';
    final isComposition = settingsMap[AppConstants.keyIsCompositionScheme] == 'true';
    final invoicePrefix = settingsMap[AppConstants.keyInvoicePrefix] ?? 'INV';
    final isMobile = Responsive.isMobile(context);
    final formattedToken = '#${widget.order.tokenNo.toString().padLeft(3, '0')}';

    double subtotal = 0;
    for (var item in widget.items) {
      subtotal += item.orderItem.quantity * item.orderItem.priceAtOrder;
    }

    final taxBreakup = TaxCalculator.calculate(
      subtotal: subtotal,
      discountVal: _discountVal,
      discountType: _discountType,
      defaultTaxRate: defaultTaxRate,
      isTaxInclusive: isTaxInclusive,
      isCompositionScheme: isComposition,
    );

    // Summary Column Component
    Widget buildOrderSummary() {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Text('Token $formattedToken Summary (${widget.items.length} items)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            isMobile
                ? Column(
                    children: widget.items.map((item) {
                      final total = item.orderItem.quantity * item.orderItem.priceAtOrder;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.menuItem.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text('${item.orderItem.quantity} x ${CurrencyFormatter.format(item.orderItem.priceAtOrder)}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(total),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : Expanded(
                    child: ListView.separated(
                      itemCount: widget.items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final total = item.orderItem.quantity * item.orderItem.priceAtOrder;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.menuItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${item.orderItem.quantity} x ${CurrencyFormatter.format(item.orderItem.priceAtOrder)}'),
                          trailing: Text(
                            CurrencyFormatter.format(total),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );
    }

    // Calculations & Payment Form Component
    Widget buildCalculationsForm() {
      return Container(
        color: AppColors.surface,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Discount & Calculations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Discount Controls
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Discount Amount / %',
                        prefixIcon: Icon(Icons.discount_outlined),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _discountVal = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ToggleButtons(
                    isSelected: [_discountType == 'flat', _discountType == 'percent'],
                    onPressed: (index) {
                      setState(() {
                        _discountType = index == 0 ? 'flat' : 'percent';
                      });
                    },
                    children: const [
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('₹ Flat')),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text('% Percent')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Financial Calculations Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borders),
                ),
                child: Column(
                  children: [
                    _calcRow('Subtotal:', CurrencyFormatter.format(taxBreakup.subtotal)),
                    if (taxBreakup.discountAmount > 0)
                      _calcRow('Discount:', '-${CurrencyFormatter.format(taxBreakup.discountAmount)}', color: AppColors.error),
                    _calcRow('Taxable Amount:', CurrencyFormatter.format(taxBreakup.taxableAmount)),
                    if (!isComposition && taxBreakup.totalTax > 0) ...[
                      _calcRow('CGST (${taxBreakup.cgstRate.toStringAsFixed(1)}%):', CurrencyFormatter.format(taxBreakup.cgstAmount)),
                      _calcRow('SGST (${taxBreakup.sgstRate.toStringAsFixed(1)}%):', CurrencyFormatter.format(taxBreakup.sgstAmount)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          isTaxInclusive
                              ? '(GST included in prices)'
                              : '(GST ${defaultTaxRate.toStringAsFixed(1)}% added on top of subtotal)',
                          style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                    if (isComposition)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('(Composition Scheme — Bill of Supply)', style: TextStyle(fontSize: 12, color: AppColors.warning)),
                      ),
                    if (taxBreakup.roundOff != 0)
                      _calcRow('Round Off:', taxBreakup.roundOff > 0 ? '+${taxBreakup.roundOff.toStringAsFixed(2)}' : taxBreakup.roundOff.toStringAsFixed(2)),
                    const Divider(height: 16),
                    _calcRow('GRAND TOTAL:', CurrencyFormatter.format(taxBreakup.grandTotal), isBold: true, fontSize: 18, color: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Payment Mode Selection
              const Text('Select Payment Mode', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _paymentChip('cash', 'CASH', Icons.money),
                  const SizedBox(width: 8),
                  _paymentChip('card', 'CARD', Icons.credit_card),
                  const SizedBox(width: 8),
                  _paymentChip('upi', 'UPI / QR', Icons.qr_code_2),
                ],
              ),

              const SizedBox(height: 24),

              // Settle & Print Bill Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 22),
                  label: const Text('SETTLE & PRINT BILL', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final billsDao = ref.read(billsDaoProvider);
                    final printerService = ref.read(printerServiceProvider);

                    // Create Bill in DB
                    final createdBill = await billsDao.createBillTransaction(
                      orderId: widget.order.id,
                      invoicePrefix: invoicePrefix,
                      subtotal: taxBreakup.subtotal,
                      discount: taxBreakup.discountAmount,
                      discountType: _discountType,
                      taxAmount: taxBreakup.totalTax,
                      cgstAmount: taxBreakup.cgstAmount,
                      sgstAmount: taxBreakup.sgstAmount,
                      roundOff: taxBreakup.roundOff,
                      total: taxBreakup.grandTotal,
                      paymentMode: _paymentMode,
                    );

                    // Trigger Printer
                    final paperWidth = settingsMap[AppConstants.keyPaperWidth] ?? '58';
                    await printerService.printBill(
                      storeSettings: settingsMap,
                      bill: createdBill,
                      tableNo: formattedToken,
                      items: widget.items,
                      taxBreakup: taxBreakup,
                      paperWidth: paperWidth,
                    );

                    // Navigate to Invoice View / PDF Screen
                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => InvoiceViewScreen(
                          bill: createdBill,
                          tokenNo: formattedToken,
                          items: widget.items,
                          taxBreakup: taxBreakup,
                          storeSettings: settingsMap,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isMobile) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Checkout — Token $formattedToken'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildOrderSummary(),
              const Divider(height: 1, color: AppColors.borders),
              buildCalculationsForm(),
            ],
          ),
        ),
      );
    }

    // Tablet Side-by-Side View
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout — Token $formattedToken'),
      ),
      body: Row(
        children: [
          Expanded(flex: 5, child: buildOrderSummary()),
          const VerticalDivider(width: 1, color: AppColors.borders),
          Expanded(flex: 5, child: buildCalculationsForm()),
        ],
      ),
    );
  }

  Widget _calcRow(String title, String val, {bool isBold = false, double fontSize = 14, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            val,
            style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: color ?? AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _paymentChip(String mode, String label, IconData icon) {
    final isSelected = _paymentMode == mode;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _paymentMode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.borders),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
