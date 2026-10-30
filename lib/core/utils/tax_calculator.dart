class TaxBreakup {
  final double subtotal;
  final double discountAmount;
  final double taxableAmount;
  final double cgstRate;
  final double cgstAmount;
  final double sgstRate;
  final double sgstAmount;
  final double totalTax;
  final double grandTotalBeforeRound;
  final double roundOff;
  final double grandTotal;

  TaxBreakup({
    required this.subtotal,
    required this.discountAmount,
    required this.taxableAmount,
    required this.cgstRate,
    required this.cgstAmount,
    required this.sgstRate,
    required this.sgstAmount,
    required this.totalTax,
    required this.grandTotalBeforeRound,
    required this.roundOff,
    required this.grandTotal,
  });
}

class TaxCalculator {
  /// Calculates Tax, Discount, Round-Off and Grand Total
  /// GST split into CGST & SGST equally (e.g. 5% GST = 2.5% CGST + 2.5% SGST)
  static TaxBreakup calculate({
    required double subtotal,
    required double discountVal,
    required String discountType, // 'flat' or 'percent'
    required double defaultTaxRate, // e.g. 5.0 for 5%
    bool isTaxInclusive = false,
    bool isCompositionScheme = false, // Bill of supply mode: tax = 0
  }) {
    // 1. Calculate discount
    double discountAmount = 0.0;
    if (discountType == 'percent') {
      discountAmount = (subtotal * discountVal) / 100.0;
    } else {
      discountAmount = discountVal;
    }
    if (discountAmount > subtotal) discountAmount = subtotal;

    final double netSubtotal = subtotal - discountAmount;

    if (isCompositionScheme) {
      // Bill of supply - No tax split shown
      final double grandTotalBeforeRound = netSubtotal;
      final double grandTotalRounded = grandTotalBeforeRound.roundToDouble();
      final double roundOff = grandTotalRounded - grandTotalBeforeRound;

      return TaxBreakup(
        subtotal: subtotal,
        discountAmount: discountAmount,
        taxableAmount: netSubtotal,
        cgstRate: 0.0,
        cgstAmount: 0.0,
        sgstRate: 0.0,
        sgstAmount: 0.0,
        totalTax: 0.0,
        grandTotalBeforeRound: grandTotalBeforeRound,
        roundOff: roundOff,
        grandTotal: grandTotalRounded,
      );
    }

    double cgstRate = defaultTaxRate / 2.0;
    double sgstRate = defaultTaxRate / 2.0;
    double cgstAmount = 0.0;
    double sgstAmount = 0.0;
    double taxableAmount = netSubtotal;

    if (isTaxInclusive) {
      // Net price contains tax: Tax = Net - (Net / (1 + Rate/100))
      final double taxFactor = 1.0 + (defaultTaxRate / 100.0);
      taxableAmount = netSubtotal / taxFactor;
      final double totalTax = netSubtotal - taxableAmount;
      cgstAmount = totalTax / 2.0;
      sgstAmount = totalTax / 2.0;
    } else {
      // Tax added on top
      cgstAmount = (taxableAmount * cgstRate) / 100.0;
      sgstAmount = (taxableAmount * sgstRate) / 100.0;
    }

    final double totalTax = cgstAmount + sgstAmount;
    final double grandTotalBeforeRound = isTaxInclusive
        ? netSubtotal
        : (taxableAmount + totalTax);

    final double grandTotalRounded = grandTotalBeforeRound.roundToDouble();
    final double roundOff = grandTotalRounded - grandTotalBeforeRound;

    return TaxBreakup(
      subtotal: subtotal,
      discountAmount: discountAmount,
      taxableAmount: taxableAmount,
      cgstRate: cgstRate,
      cgstAmount: cgstAmount,
      sgstRate: sgstRate,
      sgstAmount: sgstAmount,
      totalTax: totalTax,
      grandTotalBeforeRound: grandTotalBeforeRound,
      roundOff: roundOff,
      grandTotal: grandTotalRounded,
    );
  }
}
