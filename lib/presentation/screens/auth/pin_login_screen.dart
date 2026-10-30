import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/numeric_keypad.dart';

class PinLoginScreen extends ConsumerStatefulWidget {
  const PinLoginScreen({super.key});

  @override
  ConsumerState<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends ConsumerState<PinLoginScreen> {
  String _pin = '';
  String? _errorMessage;
  bool _isLoading = false;

  void _handleKeyPress(String digit) {
    if (_pin.length < 6) {
      setState(() {
        _pin += digit;
        _errorMessage = null;
      });
      if (_pin.length == 4) {
        _submitPin();
      }
    }
  }

  void _handleDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _errorMessage = null;
      });
    }
  }

  Future<void> _submitPin() async {
    if (_pin.isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await ref.read(authProvider.notifier).loginWithPin(_pin);

    if (!mounted) return;

    if (!success) {
      setState(() {
        _isLoading = false;
        _pin = '';
        _errorMessage = 'Invalid PIN. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.restaurant_menu_rounded,
                      size: 54,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'HOTEL BILLING POS',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Enter Staff PIN to Unlock',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // PIN Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      final isFilled = index < _pin.length;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFilled ? AppColors.primary : AppColors.surface,
                          border: Border.all(
                            color: isFilled ? AppColors.primary : AppColors.borders,
                            width: 2,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 14),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 14),
                    ),

                  const SizedBox(height: 24),

                  // Numeric Keypad
                  if (_isLoading)
                    const CircularProgressIndicator(color: AppColors.primary)
                  else
                    NumericKeypad(
                      onKeyPress: _handleKeyPress,
                      onDelete: _handleDelete,
                      onSubmit: _submitPin,
                      submitText: 'LOGIN',
                    ),

                  const SizedBox(height: 24),
                  // Demo PIN hint
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borders),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline, size: 16, color: AppColors.info),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Default PINs — Admin: 1234 | Cashier: 5678 | Waiter: 1111',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
