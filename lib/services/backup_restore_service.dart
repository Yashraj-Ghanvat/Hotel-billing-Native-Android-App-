import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../data/datasources/local/app_database.dart';

class BackupRestoreService {
  final AppDatabase db;

  BackupRestoreService(this.db);

  /// Gets or creates the dedicated public Documents directory folder named "HotelBillingPOS"
  Future<Directory> getBackupDirectory() async {
    Directory? targetDir;

    if (!kIsWeb && Platform.isAndroid) {
      // 1. Try public Documents directory on Android (/storage/emulated/0/Documents/HotelBillingPOS)
      final publicDocs = Directory('/storage/emulated/0/Documents/HotelBillingPOS');
      try {
        if (!await publicDocs.exists()) {
          await publicDocs.create(recursive: true);
        }
        return publicDocs;
      } catch (e) {
        debugPrint('Public Documents folder creation note: $e');
      }

      // 2. Fallback to external storage directory + HotelBillingPOS
      try {
        final extDir = await getExternalStorageDirectory();
        if (extDir != null) {
          targetDir = Directory('${extDir.path}/HotelBillingPOS');
        }
      } catch (_) {}
    }

    // 3. Fallback to application documents directory
    if (targetDir == null) {
      final appDocs = await getApplicationDocumentsDirectory();
      targetDir = Directory('${appDocs.path}/HotelBillingPOS');
    }

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }
    return targetDir;
  }

  /// Exports full database state (Users, Categories, Menu, Orders, Items, Bills, Settings, DayClose) to JSON
  Future<String> exportToJson() async {
    final usersList = await db.select(db.users).get();
    final categoriesList = await db.select(db.categories).get();
    final menuItemsList = await db.select(db.menuItems).get();
    final ordersList = await db.select(db.orders).get();
    final orderItemsList = await db.select(db.orderItems).get();
    final billsList = await db.select(db.bills).get();
    final settingsList = await db.select(db.settings).get();
    final dayCloseList = await db.select(db.dayClose).get();

    final data = {
      'version': 1,
      'exported_at': DateTime.now().toIso8601String(),
      'users': usersList.map((u) => {
        'id': u.id,
        'name': u.name,
        'role': u.role,
        'pinHash': u.pinHash,
        'salt': u.salt,
        'isActive': u.isActive,
        'createdAt': u.createdAt.toIso8601String(),
      }).toList(),
      'categories': categoriesList.map((c) => {
        'id': c.id,
        'name': c.name,
        'displayOrder': c.displayOrder,
        'isActive': c.isActive,
      }).toList(),
      'menuItems': menuItemsList.map((m) => {
        'id': m.id,
        'categoryId': m.categoryId,
        'name': m.name,
        'price': m.price,
        'taxRate': m.taxRate,
        'hsnCode': m.hsnCode,
        'isVeg': m.isVeg,
        'isActive': m.isActive,
      }).toList(),
      'settings': settingsList.map((s) => {
        'key': s.key,
        'value': s.value,
      }).toList(),
      'orders': ordersList.map((o) => {
        'id': o.id,
        'tokenNo': o.tokenNo,
        'orderType': o.orderType,
        'tokenStatus': o.tokenStatus,
        'waiterId': o.waiterId,
        'status': o.status,
        'createdAt': o.createdAt.toIso8601String(),
        'updatedAt': o.updatedAt.toIso8601String(),
      }).toList(),
      'orderItems': orderItemsList.map((oi) => {
        'id': oi.id,
        'orderId': oi.orderId,
        'itemId': oi.itemId,
        'quantity': oi.quantity,
        'priceAtOrder': oi.priceAtOrder,
        'taxRateAtOrder': oi.taxRateAtOrder,
        'notes': oi.notes,
        'status': oi.status,
        'kotPrintedQuantity': oi.kotPrintedQuantity,
      }).toList(),
      'bills': billsList.map((b) => {
        'id': b.id,
        'orderId': b.orderId,
        'billNo': b.billNo,
        'subtotal': b.subtotal,
        'discount': b.discount,
        'discountType': b.discountType,
        'taxAmount': b.taxAmount,
        'cgstAmount': b.cgstAmount,
        'sgstAmount': b.sgstAmount,
        'roundOff': b.roundOff,
        'total': b.total,
        'paymentMode': b.paymentMode,
        'isVoid': b.isVoid,
        'voidReason': b.voidReason,
        'voidByUserId': b.voidByUserId,
        'createdAt': b.createdAt.toIso8601String(),
      }).toList(),
      'dayClose': dayCloseList.map((dc) => {
        'id': dc.id,
        'date': dc.date.toIso8601String(),
        'openingCash': dc.openingCash,
        'closingCash': dc.closingCash,
        'totalSales': dc.totalSales,
        'totalOrders': dc.totalOrders,
        'discrepancy': dc.discrepancy,
        'closedByUserId': dc.closedByUserId,
        'createdAt': dc.createdAt.toIso8601String(),
      }).toList(),
    };

    return jsonEncode(data);
  }

  /// Saves timestamped JSON backup file into Documents/HotelBillingPOS folder
  Future<File?> saveBackupToFile() async {
    final jsonStr = await exportToJson();
    if (kIsWeb) return null;

    final backupDir = await getBackupDirectory();

    final now = DateTime.now();
    final timestamp = "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    final file = File('${backupDir.path}/hotel_pos_backup_$timestamp.json');
    return await file.writeAsString(jsonStr);
  }

  /// Lists all backup files in Documents/HotelBillingPOS sorted newest first
  Future<List<FileSystemEntity>> getAvailableBackups() async {
    if (kIsWeb) return [];
    try {
      final backupDir = await getBackupDirectory();
      if (!await backupDir.exists()) return [];

      final entities = backupDir.listSync();
      final backupFiles = entities.where((e) => e is File && e.path.endsWith('.json')).toList();

      backupFiles.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
      return backupFiles;
    } catch (e) {
      debugPrint('Error listing backups: $e');
      return [];
    }
  }

  /// Restores database state from a File object
  Future<bool> restoreFromFile(File file) async {
    try {
      final content = await file.readAsString();
      return await restoreFromJson(content);
    } catch (e) {
      return false;
    }
  }

  /// Restores database state from JSON string
  Future<bool> restoreFromJson(String jsonStr) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonStr);

      await db.transaction(() async {
        // Restore Users
        if (data.containsKey('users')) {
          for (var u in data['users']) {
            await db.into(db.users).insertOnConflictUpdate(UsersCompanion(
              id: Value(u['id']),
              name: Value(u['name']),
              role: Value(u['role']),
              pinHash: Value(u['pinHash']),
              salt: Value(u['salt']),
              isActive: Value(u['isActive'] ?? true),
              createdAt: u['createdAt'] != null ? Value(DateTime.parse(u['createdAt'])) : const Value.absent(),
            ));
          }
        }

        // Restore Categories
        if (data.containsKey('categories')) {
          for (var c in data['categories']) {
            await db.into(db.categories).insertOnConflictUpdate(CategoriesCompanion(
              id: Value(c['id']),
              name: Value(c['name']),
              displayOrder: Value(c['displayOrder']),
              isActive: Value(c['isActive'] ?? true),
            ));
          }
        }

        // Restore Menu Items
        if (data.containsKey('menuItems')) {
          for (var m in data['menuItems']) {
            await db.into(db.menuItems).insertOnConflictUpdate(MenuItemsCompanion(
              id: Value(m['id']),
              categoryId: Value(m['categoryId']),
              name: Value(m['name']),
              price: Value(m['price']),
              taxRate: Value(m['taxRate']),
              hsnCode: Value(m['hsnCode']),
              isVeg: Value(m['isVeg'] ?? true),
              isActive: Value(m['isActive'] ?? true),
            ));
          }
        }

        // Restore Settings
        if (data.containsKey('settings')) {
          for (var s in data['settings']) {
            await db.into(db.settings).insertOnConflictUpdate(SettingsCompanion.insert(
              key: s['key'],
              value: s['value'],
            ));
          }
        }

        // Restore Orders
        if (data.containsKey('orders')) {
          for (var o in data['orders']) {
            await db.into(db.orders).insertOnConflictUpdate(OrdersCompanion(
              id: Value(o['id']),
              tokenNo: Value(o['tokenNo']),
              orderType: Value(o['orderType']),
              tokenStatus: Value(o['tokenStatus']),
              waiterId: Value(o['waiterId']),
              status: Value(o['status']),
              createdAt: o['createdAt'] != null ? Value(DateTime.parse(o['createdAt'])) : const Value.absent(),
              updatedAt: o['updatedAt'] != null ? Value(DateTime.parse(o['updatedAt'])) : const Value.absent(),
            ));
          }
        }

        // Restore OrderItems
        if (data.containsKey('orderItems')) {
          for (var oi in data['orderItems']) {
            await db.into(db.orderItems).insertOnConflictUpdate(OrderItemsCompanion(
              id: Value(oi['id']),
              orderId: Value(oi['orderId']),
              itemId: Value(oi['itemId']),
              quantity: Value(oi['quantity']),
              priceAtOrder: Value(oi['priceAtOrder']),
              taxRateAtOrder: Value(oi['taxRateAtOrder']),
              notes: Value(oi['notes']),
              status: Value(oi['status']),
              kotPrintedQuantity: Value(oi['kotPrintedQuantity'] ?? 0),
            ));
          }
        }

        // Restore Bills
        if (data.containsKey('bills')) {
          for (var b in data['bills']) {
            await db.into(db.bills).insertOnConflictUpdate(BillsCompanion(
              id: Value(b['id']),
              orderId: Value(b['orderId']),
              billNo: Value(b['billNo']),
              subtotal: Value(b['subtotal']),
              discount: Value(b['discount']),
              discountType: Value(b['discountType']),
              taxAmount: Value(b['taxAmount']),
              cgstAmount: Value(b['cgstAmount']),
              sgstAmount: Value(b['sgstAmount']),
              roundOff: Value(b['roundOff']),
              total: Value(b['total']),
              paymentMode: Value(b['paymentMode']),
              isVoid: Value(b['isVoid'] ?? false),
              voidReason: Value(b['voidReason']),
              voidByUserId: Value(b['voidByUserId']),
              createdAt: b['createdAt'] != null ? Value(DateTime.parse(b['createdAt'])) : const Value.absent(),
            ));
          }
        }

        // Restore DayClose
        if (data.containsKey('dayClose')) {
          for (var dc in data['dayClose']) {
            await db.into(db.dayClose).insertOnConflictUpdate(DayCloseCompanion(
              id: Value(dc['id']),
              date: Value(DateTime.parse(dc['date'])),
              openingCash: Value(dc['openingCash']),
              closingCash: Value(dc['closingCash']),
              totalSales: Value(dc['totalSales']),
              totalOrders: Value(dc['totalOrders']),
              discrepancy: Value(dc['discrepancy']),
              closedByUserId: Value(dc['closedByUserId']),
              createdAt: dc['createdAt'] != null ? Value(DateTime.parse(dc['createdAt'])) : const Value.absent(),
            ));
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint('Restore error: $e');
      return false;
    }
  }
}
