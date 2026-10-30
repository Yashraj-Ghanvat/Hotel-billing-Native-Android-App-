class AppConstants {
  static const String appName = 'Hotel Billing POS';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleCashier = 'cashier';
  static const String roleWaiter = 'waiter';

  // Table Statuses
  static const String tableAvailable = 'available';
  static const String tableOccupied = 'occupied';
  static const String tableBilled = 'billed';
  static const String tableReserved = 'reserved';

  // Order Statuses
  static const String orderOpen = 'open';
  static const String orderBilled = 'billed';
  static const String orderPaid = 'paid';
  static const String orderCancelled = 'cancelled';

  // Order Item Statuses
  static const String itemPending = 'pending';
  static const String itemKotSent = 'kot_sent';
  static const String itemServed = 'served';
  static const String itemCancelled = 'cancelled';

  // Settings Keys
  static const String keyHotelName = 'hotel_name';
  static const String keyHotelAddress = 'hotel_address';
  static const String keyHotelPhone = 'hotel_phone';
  static const String keyGSTIN = 'gstin';
  static const String keyFSSAI = 'fssai';
  static const String keyDefaultTaxRate = 'default_tax_rate';
  static const String keyCurrencySymbol = 'currency_symbol';
  static const String keyInvoicePrefix = 'invoice_prefix';
  static const String keyPrinterType = 'printer_type'; // 'bluetooth' or 'wifi'
  static const String keyPrinterMac = 'printer_mac';
  static const String keyPrinterName = 'printer_name';
  static const String keyPrinterIp = 'printer_ip'; // e.g. '192.168.1.200'
  static const String keyPrinterPort = 'printer_port'; // e.g. '9100'
  static const String keyPaperWidth = 'paper_width_mm'; // '58' or '80'
  static const String keyIsCompositionScheme = 'is_composition_scheme'; // 'true' or 'false' (Bill of Supply)
  static const String keyTaxInclusive = 'is_tax_inclusive'; // 'true' or 'false'

  // Default Values
  static const String defaultHotelName = 'Royal Hotel & Restaurant';
  static const String defaultAddress = '123 Main Street, City';
  static const String defaultPhone = '+91 9876543210';
  static const String defaultGSTIN = '27AAAAA0000A1Z5';
  static const String defaultFSSAI = '12345678901234';
  static const double defaultTaxRateVal = 5.0; // 5% GST
  static const String defaultCurrencySymbol = '₹';
  static const String defaultInvoicePrefix = 'INV';
  static const String defaultPaperWidth = '58';
  static const String defaultPrinterType = 'bluetooth';
  static const String defaultPrinterIp = '192.168.1.200';
  static const String defaultPrinterPort = '9100';
}
