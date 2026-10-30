import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class NumericKeypad extends StatelessWidget {
  final Function(String) onKeyPress;
  final VoidCallback onDelete;
  final VoidCallback? onSubmit;
  final String submitText;

  const NumericKeypad({
    super.key,
    required this.onKeyPress,
    required this.onDelete,
    this.onSubmit,
    this.submitText = 'ENTER',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 10),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 10),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildButton('C', color: AppColors.error, onTap: onDelete)),
              const SizedBox(width: 8),
              Expanded(child: _buildButton('0', onTap: () => onKeyPress('0'))),
              const SizedBox(width: 8),
              Expanded(child: _buildButton('⌫', color: AppColors.warning, onTap: onDelete)),
            ],
          ),
          if (onSubmit != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  submitText,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _buildButton(keys[0], onTap: () => onKeyPress(keys[0]))),
        const SizedBox(width: 8),
        Expanded(child: _buildButton(keys[1], onTap: () => onKeyPress(keys[1]))),
        const SizedBox(width: 8),
        Expanded(child: _buildButton(keys[2], onTap: () => onKeyPress(keys[2]))),
      ],
    );
  }

  Widget _buildButton(String text, {Color? color, required VoidCallback onTap}) {
    return Material(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      elevation: color == null ? 1 : 0,
      shadowColor: const Color(0x142C1E14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: color == null ? Border.all(color: AppColors.borders) : null,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color != null ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
