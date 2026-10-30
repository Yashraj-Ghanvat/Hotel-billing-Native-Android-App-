import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/database_provider.dart';
import '../../providers/settings_provider.dart';

class StoreSettingsScreen extends ConsumerStatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  ConsumerState<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends ConsumerState<StoreSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _gstinController;
  late TextEditingController _fssaiController;
  late TextEditingController _taxRateController;
  late TextEditingController _prefixController;
  bool _isComposition = false;
  bool _isTaxInclusive = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _gstinController = TextEditingController();
    _fssaiController = TextEditingController();
    _taxRateController = TextEditingController();
    _prefixController = TextEditingController();
  }

  void _populate(Map<String, String> settings) {
    if (_isLoaded) return;
    _nameController.text = settings[AppConstants.keyHotelName] ?? AppConstants.defaultHotelName;
    _addressController.text = settings[AppConstants.keyHotelAddress] ?? AppConstants.defaultAddress;
    _phoneController.text = settings[AppConstants.keyHotelPhone] ?? AppConstants.defaultPhone;
    _gstinController.text = settings[AppConstants.keyGSTIN] ?? AppConstants.defaultGSTIN;
    _fssaiController.text = settings[AppConstants.keyFSSAI] ?? AppConstants.defaultFSSAI;
    _taxRateController.text = settings[AppConstants.keyDefaultTaxRate] ?? '5.0';
    _prefixController.text = settings[AppConstants.keyInvoicePrefix] ?? AppConstants.defaultInvoicePrefix;
    _isComposition = settings[AppConstants.keyIsCompositionScheme] == 'true';
    _isTaxInclusive = settings[AppConstants.keyTaxInclusive] == 'true';
    _isLoaded = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _gstinController.dispose();
    _fssaiController.dispose();
    _taxRateController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Store Profile & Tax Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, _) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.error))),
        data: (settings) {
          _populate(settings);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Hotel / Restaurant Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Store Address'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Contact Phone Number'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _gstinController,
                  decoration: const InputDecoration(labelText: 'GSTIN Number (e.g. 27AAAAA0000A1Z5)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _fssaiController,
                  decoration: const InputDecoration(labelText: 'FSSAI License Number (Optional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _taxRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Default Tax Rate % (e.g. 5.0)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _prefixController,
                  decoration: const InputDecoration(labelText: 'Invoice Number Prefix (e.g. INV)'),
                ),
                const SizedBox(height: 16),

                // Bill of Supply / Composition Scheme Toggle
                SwitchListTile(
                  title: const Text('Composition Scheme (Bill of Supply)', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text('Hides tax breakup on bills for composition tax payers'),
                  value: _isComposition,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) => setState(() => _isComposition = val),
                ),

                // Tax Inclusive Toggle
                SwitchListTile(
                  title: const Text('Tax Inclusive Pricing', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    _isTaxInclusive
                        ? 'ON: Item prices include GST tax (Total Bill = Subtotal)'
                        : 'OFF: GST tax is added ON TOP of total bill (Total Bill = Subtotal + Tax)',
                  ),
                  value: _isTaxInclusive,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) => setState(() => _isTaxInclusive = val),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('SAVE STORE SETTINGS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final settingsDao = ref.read(settingsDaoProvider);
                        await settingsDao.updateBatchSettings({
                          AppConstants.keyHotelName: _nameController.text.trim(),
                          AppConstants.keyHotelAddress: _addressController.text.trim(),
                          AppConstants.keyHotelPhone: _phoneController.text.trim(),
                          AppConstants.keyGSTIN: _gstinController.text.trim(),
                          AppConstants.keyFSSAI: _fssaiController.text.trim(),
                          AppConstants.keyDefaultTaxRate: _taxRateController.text.trim(),
                          AppConstants.keyInvoicePrefix: _prefixController.text.trim(),
                          AppConstants.keyIsCompositionScheme: _isComposition ? 'true' : 'false',
                          AppConstants.keyTaxInclusive: _isTaxInclusive ? 'true' : 'false',
                        });

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Store settings updated successfully!')),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
