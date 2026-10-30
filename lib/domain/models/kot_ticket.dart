class KotItem {
  final String name;
  final int quantity;
  final String? notes;

  KotItem({
    required this.name,
    required this.quantity,
    this.notes,
  });
}

class KotTicket {
  final int orderId;
  final int tokenNo;
  final String orderType; // 'takeaway' or 'dine_in'
  final String waiterName;
  final DateTime timestamp;
  final bool isAdditionKot;
  final List<KotItem> items;

  KotTicket({
    required this.orderId,
    required this.tokenNo,
    required this.orderType,
    required this.waiterName,
    required this.timestamp,
    required this.isAdditionKot,
    required this.items,
  });

  String get formattedToken => '#${tokenNo.toString().padLeft(3, '0')}';
  String get tableNo => formattedToken;
  String get orderTypeLabel => orderType == 'dine_in' ? 'DINE-IN' : 'TAKEAWAY (PARCEL)';
}
