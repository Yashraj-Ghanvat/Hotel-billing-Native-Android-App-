import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotel_billing_app/main.dart';

void main() {
  testWidgets('Hotel Billing App Smoke Test', (WidgetTester tester) async {
    // Build our app wrapped with ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: HotelBillingApp(),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Verify app renders successfully
    expect(find.byType(HotelBillingApp), findsOneWidget);
  });
}
