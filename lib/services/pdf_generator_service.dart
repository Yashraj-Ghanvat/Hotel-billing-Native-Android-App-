import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/tax_calculator.dart';
import '../data/datasources/local/app_database.dart';
import '../data/datasources/local/daos/orders_dao.dart';

class PdfGeneratorService {
  static Future<Uint8List> generateBillPdf({
    required Map<String, String> storeSettings,
    required Bill bill,
    required String tableNo,
    required List<OrderItemWithDetail> items,
    required TaxBreakup taxBreakup,
  }) async {
    final pdf = pw.Document();

    final hotelName = storeSettings['hotel_name'] ?? 'Hotel Billing';
    final address = storeSettings['hotel_address'] ?? '';
    final phone = storeSettings['hotel_phone'] ?? '';
    final gstin = storeSettings['gstin'] ?? '';
    final fssai = storeSettings['fssai'] ?? '';
    final isComposition = storeSettings['is_composition_scheme'] == 'true';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        margin: const pw.EdgeInsets.all(10),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(hotelName, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              if (address.isNotEmpty) pw.Text(address, style: const pw.TextStyle(fontSize: 9)),
              if (phone.isNotEmpty) pw.Text("Ph: $phone", style: const pw.TextStyle(fontSize: 9)),
              if (gstin.isNotEmpty) pw.Text("GSTIN: $gstin", style: const pw.TextStyle(fontSize: 9)),
              if (fssai.isNotEmpty) pw.Text("FSSAI: $fssai", style: const pw.TextStyle(fontSize: 9)),
              pw.SizedBox(height: 5),
              pw.Text(
                isComposition ? "BILL OF SUPPLY" : "TAX INVOICE",
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Bill No: ${bill.billNo}", style: const pw.TextStyle(fontSize: 9)),
                  pw.Text("Table: $tableNo", style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              pw.Text("Date: ${bill.createdAt.toString().substring(0, 16)}", style: const pw.TextStyle(fontSize: 9)),
              pw.Divider(thickness: 0.5),
              
              // Items Table
              pw.Table(
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(1.5),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Text("Item", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
                      pw.Text("Qty", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                      pw.Text("Total", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.right),
                    ],
                  ),
                  ...items.map((item) {
                    final lineTotal = item.orderItem.quantity * item.orderItem.priceAtOrder;
                    return pw.TableRow(
                      children: [
                        pw.Text(item.menuItem.name, style: const pw.TextStyle(fontSize: 8)),
                        pw.Text("${item.orderItem.quantity}", style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.center),
                        pw.Text(CurrencyFormatter.format(lineTotal, symbol: ''), style: const pw.TextStyle(fontSize: 8), textAlign: pw.TextAlign.right),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.Divider(thickness: 0.5),

              // Summary
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Subtotal", style: const pw.TextStyle(fontSize: 9)),
                  pw.Text(CurrencyFormatter.format(taxBreakup.subtotal), style: const pw.TextStyle(fontSize: 9)),
                ],
              ),
              if (taxBreakup.discountAmount > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Discount", style: const pw.TextStyle(fontSize: 9)),
                    pw.Text("-${CurrencyFormatter.format(taxBreakup.discountAmount)}", style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              if (!isComposition && taxBreakup.totalTax > 0) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("CGST (${taxBreakup.cgstRate.toStringAsFixed(1)}%)", style: const pw.TextStyle(fontSize: 9)),
                    pw.Text(CurrencyFormatter.format(taxBreakup.cgstAmount), style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("SGST (${taxBreakup.sgstRate.toStringAsFixed(1)}%)", style: const pw.TextStyle(fontSize: 9)),
                    pw.Text(CurrencyFormatter.format(taxBreakup.sgstAmount), style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
              ],
              pw.Divider(thickness: 0.5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("GRAND TOTAL", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  pw.Text(CurrencyFormatter.format(taxBreakup.grandTotal), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text("Thank You! Visit Again", style: const pw.TextStyle(fontSize: 9)),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  static Future<void> printOrSharePdf(Uint8List bytes) async {
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
  }
}
