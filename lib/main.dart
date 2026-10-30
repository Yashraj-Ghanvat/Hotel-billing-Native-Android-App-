import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/auth/pin_login_screen.dart';
import 'presentation/screens/home/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force landscape orientation on Android tablet POS devices
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    const ProviderScope(
      child: HotelBillingApp(),
    ),
  );
}

class HotelBillingApp extends ConsumerWidget {
  const HotelBillingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSession = ref.watch(authProvider);

    return MaterialApp(
      title: 'Hotel Billing POS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: userSession == null ? const PinLoginScreen() : const MainNavigationScreen(),
    );
  }
}
