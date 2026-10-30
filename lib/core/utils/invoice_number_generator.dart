class InvoiceNumberGenerator {
  /// Gets the Indian Financial Year string e.g. "2627" for FY 2026-2027
  static String getFinancialYearCode([DateTime? date]) {
    final d = date ?? DateTime.now();
    int startYear = d.month >= 4 ? d.year : d.year - 1;
    int endYear = startYear + 1;

    String startYY = (startYear % 100).toString().padLeft(2, '0');
    String endYY = (endYear % 100).toString().padLeft(2, '0');

    return '$startYY$endYY';
  }

  /// Formats sequential sequence number e.g. prefix="INV", sequence=42 => "INV-2627-00042"
  static String formatInvoiceNumber({
    required String prefix,
    required int sequence,
    DateTime? date,
  }) {
    final fyCode = getFinancialYearCode(date);
    final formattedSeq = sequence.toString().padLeft(5, '0');
    final cleanPrefix = prefix.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    return '$cleanPrefix-$fyCode-$formattedSeq';
  }
}
