import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_billing_app/core/utils/tax_calculator.dart';

void main() {
  group('TaxCalculator Tests', () {
    test('Standard 5% GST Exclusive calculation', () {
      final result = TaxCalculator.calculate(
        subtotal: 1000.0,
        discountVal: 0.0,
        discountType: 'flat',
        defaultTaxRate: 5.0,
        isTaxInclusive: false,
        isCompositionScheme: false,
      );

      expect(result.subtotal, 1000.0);
      expect(result.taxableAmount, 1000.0);
      expect(result.cgstRate, 2.5);
      expect(result.cgstAmount, 25.0);
      expect(result.sgstRate, 2.5);
      expect(result.sgstAmount, 25.0);
      expect(result.totalTax, 50.0);
      expect(result.grandTotal, 1050.0);
    });

    test('Flat Discount & GST calculation', () {
      final result = TaxCalculator.calculate(
        subtotal: 1000.0,
        discountVal: 100.0,
        discountType: 'flat',
        defaultTaxRate: 5.0,
        isTaxInclusive: false,
        isCompositionScheme: false,
      );

      expect(result.discountAmount, 100.0);
      expect(result.taxableAmount, 900.0);
      expect(result.cgstAmount, 22.5);
      expect(result.sgstAmount, 22.5);
      expect(result.totalTax, 45.0);
      expect(result.grandTotal, 945.0);
    });

    test('Composition Scheme (Bill of Supply) - Zero Tax', () {
      final result = TaxCalculator.calculate(
        subtotal: 500.0,
        discountVal: 0.0,
        discountType: 'flat',
        defaultTaxRate: 5.0,
        isTaxInclusive: false,
        isCompositionScheme: true,
      );

      expect(result.cgstAmount, 0.0);
      expect(result.sgstAmount, 0.0);
      expect(result.totalTax, 0.0);
      expect(result.grandTotal, 500.0);
    });
  });
}
