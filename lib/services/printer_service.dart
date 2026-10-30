import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/currency_formatter.dart';
import '../core/utils/tax_calculator.dart';
import '../data/datasources/local/app_database.dart';
import '../data/datasources/local/daos/orders_dao.dart';
import '../domain/models/kot_ticket.dart';

class PrinterService {
  final BlueThermalPrinter _bluetooth = BlueThermalPrinter.instance;

  Future<List<BluetoothDevice>> getBondedDevices() async {
    if (kIsWeb) {
      return [BluetoothDevice('Web Demo Printer (Chrome)', '00:00:00:00')];
    }
    try {
      final devices = await _bluetooth.getBondedDevices();
      return devices;
    } catch (e) {
      return [];
    }
  }

  Future<bool> isConnected() async {
    if (kIsWeb) return true;
    final connected = await _bluetooth.isConnected;
    return connected ?? false;
  }

  Future<bool> connect(BluetoothDevice device) async {
    if (kIsWeb) return true;
    try {
      final alreadyConnected = await _bluetooth.isConnected;
      if (alreadyConnected == true) return true;
      await _bluetooth.connect(device);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> disconnect() async {
    if (kIsWeb) return;
    try {
      await _bluetooth.disconnect();
    } catch (_) {}
  }

  /// Send ESC/POS raw bytes directly over Wi-Fi / LAN TCP Socket (Port 9100)
  Future<bool> sendBytesToWifiPrinter({
    required String ip,
    required int port,
    required List<int> bytes,
    Duration timeout = const Duration(seconds: 4),
  }) async {
    if (kIsWeb) {
      debugPrint("WEB DEMO WI-FI PRINT: Sent ${bytes.length} bytes to $ip:$port");
      return true;
    }
    try {
      final socket = await Socket.connect(ip, port, timeout: timeout);
      socket.add(bytes);
      await socket.flush();
      await socket.close();
      return true;
    } catch (e) {
      debugPrint("Wi-Fi Printer Connection Error ($ip:$port): $e");
      return false;
    }
  }

  /// Print Test Ticket via Wi-Fi / LAN
  Future<bool> printTestWifi({
    required String ip,
    required int port,
    required String hotelName,
  }) async {
    final esc = EscPosBuilder();
    esc.init();
    esc.alignCenter();
    esc.setSize(doubleHeight: true, doubleWidth: true);
    esc.text("=== TEST PRINT ===");
    esc.setSize();
    esc.text(hotelName);
    esc.text("Wi-Fi / LAN Network Printer Configured!");
    esc.cut();

    return await sendBytesToWifiPrinter(ip: ip, port: port, bytes: esc.bytes);
  }

  /// Print Kitchen Order Ticket (KOT) - Auto routes to Bluetooth or Wi-Fi
  Future<bool> printKot({
    required KotTicket ticket,
    required String paperWidth, // '58' or '80'
    Map<String, String>? storeSettings,
  }) async {
    final printerType = storeSettings?[AppConstants.keyPrinterType] ?? AppConstants.defaultPrinterType;

    if (printerType == 'wifi') {
      final ip = storeSettings?[AppConstants.keyPrinterIp] ?? AppConstants.defaultPrinterIp;
      final portStr = storeSettings?[AppConstants.keyPrinterPort] ?? AppConstants.defaultPrinterPort;
      final port = int.tryParse(portStr) ?? 9100;
      return await _printKotWifi(ticket: ticket, paperWidth: paperWidth, ip: ip, port: port);
    }

    // Default: Bluetooth Print
    if (kIsWeb) {
      debugPrint("WEB DEMO PRINT KOT: Table ${ticket.tableNo}, Items: ${ticket.items.length}");
      return true;
    }
    final connected = await isConnected();
    if (!connected) return false;

    try {
      final int maxChar = paperWidth == '80' ? 48 : 32;

      _bluetooth.printNewLine();
      _bluetooth.printCustom(ticket.isAdditionKot ? "*** ADDITION KOT ***" : "*** KITCHEN ORDER TICKET ***", 2, 1);
      _bluetooth.printNewLine();
      
      _bluetooth.printCustom("Table: ${ticket.tableNo}", 2, 0);
      _bluetooth.printLeftRight("Order #: ${ticket.orderId}", "Waiter: ${ticket.waiterName}", 0);
      _bluetooth.printCustom("Time: ${ticket.timestamp.toString().substring(0, 16)}", 0, 0);
      
      _bluetooth.printCustom(_divider(maxChar), 0, 1);
      _bluetooth.printLeftRight("ITEM NAME", "QTY", 1);
      _bluetooth.printCustom(_divider(maxChar), 0, 1);

      for (var item in ticket.items) {
        _bluetooth.printLeftRight(item.name, "${item.quantity}", 1);
        if (item.notes != null && item.notes!.isNotEmpty) {
          _bluetooth.printCustom("   Note: ${item.notes}", 0, 0);
        }
      }

      _bluetooth.printCustom(_divider(maxChar), 0, 1);
      _bluetooth.printNewLine();
      _bluetooth.printNewLine();
      _bluetooth.paperCut();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Print Customer Final Bill - Auto routes to Bluetooth or Wi-Fi
  Future<bool> printBill({
    required Map<String, String> storeSettings,
    required Bill bill,
    required String tableNo,
    required List<OrderItemWithDetail> items,
    required TaxBreakup taxBreakup,
    required String paperWidth, // '58' or '80'
  }) async {
    final printerType = storeSettings[AppConstants.keyPrinterType] ?? AppConstants.defaultPrinterType;

    if (printerType == 'wifi') {
      final ip = storeSettings[AppConstants.keyPrinterIp] ?? AppConstants.defaultPrinterIp;
      final portStr = storeSettings[AppConstants.keyPrinterPort] ?? AppConstants.defaultPrinterPort;
      final port = int.tryParse(portStr) ?? 9100;
      return await _printBillWifi(
        storeSettings: storeSettings,
        bill: bill,
        tableNo: tableNo,
        items: items,
        taxBreakup: taxBreakup,
        paperWidth: paperWidth,
        ip: ip,
        port: port,
      );
    }

    // Default: Bluetooth Print
    if (kIsWeb) {
      debugPrint("WEB DEMO PRINT BILL: Bill No ${bill.billNo}, Total: ${taxBreakup.grandTotal}");
      return true;
    }
    final connected = await isConnected();
    if (!connected) return false;

    try {
      final int maxChar = paperWidth == '80' ? 48 : 32;
      final hotelName = storeSettings['hotel_name'] ?? 'Hotel Billing';
      final address = storeSettings['hotel_address'] ?? '';
      final phone = storeSettings['hotel_phone'] ?? '';
      final gstin = storeSettings['gstin'] ?? '';
      final fssai = storeSettings['fssai'] ?? '';
      final isComposition = storeSettings['is_composition_scheme'] == 'true';

      _bluetooth.printNewLine();
      _bluetooth.printCustom(hotelName, 2, 1);
      if (address.isNotEmpty) _bluetooth.printCustom(address, 0, 1);
      if (phone.isNotEmpty) _bluetooth.printCustom("Ph: $phone", 0, 1);
      if (gstin.isNotEmpty) _bluetooth.printCustom("GSTIN: $gstin", 0, 1);
      if (fssai.isNotEmpty) _bluetooth.printCustom("FSSAI: $fssai", 0, 1);
      
      if (isComposition) {
        _bluetooth.printCustom("BILL OF SUPPLY", 1, 1);
        _bluetooth.printCustom("(Composition tax payer, not eligible to collect tax)", 0, 1);
      } else {
        _bluetooth.printCustom("TAX INVOICE", 1, 1);
      }

      _bluetooth.printCustom(_divider(maxChar), 0, 1);
      _bluetooth.printLeftRight("Bill No: ${bill.billNo}", "Table: $tableNo", 0);
      _bluetooth.printCustom("Date: ${bill.createdAt.toString().substring(0, 16)}", 0, 0);
      _bluetooth.printCustom(_divider(maxChar), 0, 1);

      // Item headers
      _bluetooth.printLeftRight("Item (Qty x Price)", "Total", 1);
      _bluetooth.printCustom(_divider(maxChar), 0, 1);

      for (var item in items) {
        final lineTotal = item.orderItem.quantity * item.orderItem.priceAtOrder;
        _bluetooth.printLeftRight(
          "${item.menuItem.name} (${item.orderItem.quantity} x ${item.orderItem.priceAtOrder.toStringAsFixed(0)})",
          CurrencyFormatter.format(lineTotal, symbol: ''),
          0,
        );
      }

      _bluetooth.printCustom(_divider(maxChar), 0, 1);
      _bluetooth.printLeftRight("Subtotal", CurrencyFormatter.format(taxBreakup.subtotal, symbol: ''), 0);

      if (taxBreakup.discountAmount > 0) {
        _bluetooth.printLeftRight("Discount", "-${CurrencyFormatter.format(taxBreakup.discountAmount, symbol: '')}", 0);
      }

      if (!isComposition && taxBreakup.totalTax > 0) {
        _bluetooth.printLeftRight("CGST (${taxBreakup.cgstRate.toStringAsFixed(1)}%)", CurrencyFormatter.format(taxBreakup.cgstAmount, symbol: ''), 0);
        _bluetooth.printLeftRight("SGST (${taxBreakup.sgstRate.toStringAsFixed(1)}%)", CurrencyFormatter.format(taxBreakup.sgstAmount, symbol: ''), 0);
      }

      if (taxBreakup.roundOff != 0) {
        _bluetooth.printLeftRight("Round Off", taxBreakup.roundOff > 0 ? "+${taxBreakup.roundOff.toStringAsFixed(2)}" : taxBreakup.roundOff.toStringAsFixed(2), 0);
      }

      _bluetooth.printCustom(_divider(maxChar), 0, 1);
      _bluetooth.printLeftRight("GRAND TOTAL", CurrencyFormatter.format(taxBreakup.grandTotal), 2);
      _bluetooth.printLeftRight("Payment Mode", bill.paymentMode.toUpperCase(), 0);
      _bluetooth.printCustom(_divider(maxChar), 0, 1);

      _bluetooth.printCustom("Thank You! Visit Again", 1, 1);
      _bluetooth.printNewLine();
      _bluetooth.printNewLine();
      _bluetooth.paperCut();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Internal: Print KOT over Wi-Fi ESC/POS Socket
  Future<bool> _printKotWifi({
    required KotTicket ticket,
    required String paperWidth,
    required String ip,
    required int port,
  }) async {
    final int maxChar = paperWidth == '80' ? 48 : 32;
    final esc = EscPosBuilder();
    esc.init();

    esc.alignCenter();
    esc.setSize(doubleHeight: true, doubleWidth: true);
    esc.text(ticket.isAdditionKot ? "*** ADDITION KOT ***" : "*** KITCHEN ORDER TICKET ***");
    esc.setSize();
    esc.feed(1);

    esc.alignLeft();
    esc.setSize(doubleHeight: true);
    esc.text("Table: ${ticket.tableNo}");
    esc.setSize();
    esc.leftRight("Order #: ${ticket.orderId}", "Waiter: ${ticket.waiterName}", maxChar);
    esc.text("Time: ${ticket.timestamp.toString().substring(0, 16)}");

    esc.divider(maxChar);
    esc.leftRight("ITEM NAME", "QTY", maxChar);
    esc.divider(maxChar);

    for (var item in ticket.items) {
      esc.leftRight(item.name, "${item.quantity}", maxChar);
      if (item.notes != null && item.notes!.isNotEmpty) {
        esc.text("   Note: ${item.notes}");
      }
    }

    esc.divider(maxChar);
    esc.cut();

    return await sendBytesToWifiPrinter(ip: ip, port: port, bytes: esc.bytes);
  }

  /// Internal: Print Bill over Wi-Fi ESC/POS Socket
  Future<bool> _printBillWifi({
    required Map<String, String> storeSettings,
    required Bill bill,
    required String tableNo,
    required List<OrderItemWithDetail> items,
    required TaxBreakup taxBreakup,
    required String paperWidth,
    required String ip,
    required int port,
  }) async {
    final int maxChar = paperWidth == '80' ? 48 : 32;
    final hotelName = storeSettings['hotel_name'] ?? 'Hotel Billing';
    final address = storeSettings['hotel_address'] ?? '';
    final phone = storeSettings['hotel_phone'] ?? '';
    final gstin = storeSettings['gstin'] ?? '';
    final fssai = storeSettings['fssai'] ?? '';
    final isComposition = storeSettings['is_composition_scheme'] == 'true';

    final esc = EscPosBuilder();
    esc.init();

    esc.alignCenter();
    esc.setSize(doubleHeight: true, doubleWidth: true);
    esc.text(hotelName);
    esc.setSize();

    if (address.isNotEmpty) esc.text(address);
    if (phone.isNotEmpty) esc.text("Ph: $phone");
    if (gstin.isNotEmpty) esc.text("GSTIN: $gstin");
    if (fssai.isNotEmpty) esc.text("FSSAI: $fssai");
    esc.feed(1);

    if (isComposition) {
      esc.text("BILL OF SUPPLY");
      esc.text("(Composition tax payer, not eligible to collect tax)");
    } else {
      esc.text("TAX INVOICE");
    }

    esc.divider(maxChar);
    esc.alignLeft();
    esc.leftRight("Bill No: ${bill.billNo}", "Table: $tableNo", maxChar);
    esc.text("Date: ${bill.createdAt.toString().substring(0, 16)}");
    esc.divider(maxChar);

    esc.leftRight("Item (Qty x Price)", "Total", maxChar);
    esc.divider(maxChar);

    for (var item in items) {
      final lineTotal = item.orderItem.quantity * item.orderItem.priceAtOrder;
      esc.leftRight(
        "${item.menuItem.name} (${item.orderItem.quantity} x ${item.orderItem.priceAtOrder.toStringAsFixed(0)})",
        CurrencyFormatter.format(lineTotal, symbol: ''),
        maxChar,
      );
    }

    esc.divider(maxChar);
    esc.leftRight("Subtotal", CurrencyFormatter.format(taxBreakup.subtotal, symbol: ''), maxChar);

    if (taxBreakup.discountAmount > 0) {
      esc.leftRight("Discount", "-${CurrencyFormatter.format(taxBreakup.discountAmount, symbol: '')}", maxChar);
    }

    if (!isComposition && taxBreakup.totalTax > 0) {
      esc.leftRight("CGST (${taxBreakup.cgstRate.toStringAsFixed(1)}%)", CurrencyFormatter.format(taxBreakup.cgstAmount, symbol: ''), maxChar);
      esc.leftRight("SGST (${taxBreakup.sgstRate.toStringAsFixed(1)}%)", CurrencyFormatter.format(taxBreakup.sgstAmount, symbol: ''), maxChar);
    }

    if (taxBreakup.roundOff != 0) {
      esc.leftRight("Round Off", taxBreakup.roundOff > 0 ? "+${taxBreakup.roundOff.toStringAsFixed(2)}" : taxBreakup.roundOff.toStringAsFixed(2), maxChar);
    }

    esc.divider(maxChar);
    esc.setSize(doubleHeight: true);
    esc.leftRight("GRAND TOTAL", CurrencyFormatter.format(taxBreakup.grandTotal), maxChar);
    esc.setSize();
    esc.leftRight("Payment Mode", bill.paymentMode.toUpperCase(), maxChar);
    esc.divider(maxChar);

    esc.alignCenter();
    esc.text("Thank You! Visit Again");
    esc.cut();

    return await sendBytesToWifiPrinter(ip: ip, port: port, bytes: esc.bytes);
  }

  String _divider(int length) => List.filled(length, '-').join();
}

/// Helper class for constructing standard ESC/POS bytes
class EscPosBuilder {
  final List<int> _bytes = [];

  List<int> get bytes => List.unmodifiable(_bytes);

  void init() {
    _bytes.addAll([0x1B, 0x40]); // ESC @ Init
  }

  void alignLeft() {
    _bytes.addAll([0x1B, 0x61, 0x00]);
  }

  void alignCenter() {
    _bytes.addAll([0x1B, 0x61, 0x01]);
  }

  void alignRight() {
    _bytes.addAll([0x1B, 0x61, 0x02]);
  }

  void setBold(bool bold) {
    _bytes.addAll([0x1B, 0x45, bold ? 0x01 : 0x00]);
  }

  void setSize({bool doubleHeight = false, bool doubleWidth = false}) {
    int val = 0;
    if (doubleHeight) val |= 0x10;
    if (doubleWidth) val |= 0x20;
    _bytes.addAll([0x1D, 0x21, val]);
  }

  void text(String str, {bool newline = true}) {
    _bytes.addAll(utf8.encode(str));
    if (newline) _bytes.add(0x0A);
  }

  void leftRight(String left, String right, int maxChar) {
    final spaces = maxChar - left.length - right.length;
    if (spaces > 0) {
      text('$left${' ' * spaces}$right');
    } else {
      text('$left $right');
    }
  }

  void divider(int maxChar) {
    text('-' * maxChar);
  }

  void feed([int lines = 2]) {
    for (int i = 0; i < lines; i++) {
      _bytes.add(0x0A);
    }
  }

  void cut() {
    feed(3);
    _bytes.addAll([0x1D, 0x56, 0x42, 0x00]); // GS V 66 0 Full cut
  }
}
