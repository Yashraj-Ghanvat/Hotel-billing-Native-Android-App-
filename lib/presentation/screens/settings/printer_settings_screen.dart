import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/permission_service.dart';
import '../../providers/database_provider.dart';
import '../../providers/printer_provider.dart';
import '../../providers/settings_provider.dart';

class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;
  bool _isScanning = false;
  String _printerType = 'bluetooth'; // 'bluetooth' or 'wifi'
  String _paperWidth = '58'; // '58' or '80'
  final TextEditingController _ipController = TextEditingController(text: '192.168.1.200');
  final TextEditingController _portController = TextEditingController(text: '9100');

  @override
  void initState() {
    super.initState();
    _loadPrinterSettings();
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _loadPrinterSettings() async {
    setState(() => _isScanning = true);
    await PermissionService.requestBluetoothPermissions();

    final printerService = ref.read(printerServiceProvider);
    final devices = await printerService.getBondedDevices();

    final settingsMap = ref.read(settingsStreamProvider).value ?? {};
    _printerType = settingsMap[AppConstants.keyPrinterType] ?? AppConstants.defaultPrinterType;
    _paperWidth = settingsMap[AppConstants.keyPaperWidth] ?? AppConstants.defaultPaperWidth;

    _ipController.text = settingsMap[AppConstants.keyPrinterIp] ?? AppConstants.defaultPrinterIp;
    _portController.text = settingsMap[AppConstants.keyPrinterPort] ?? AppConstants.defaultPrinterPort;

    final savedMac = settingsMap[AppConstants.keyPrinterMac];
    BluetoothDevice? matched;
    if (savedMac != null && savedMac.isNotEmpty) {
      for (var d in devices) {
        if (d.address == savedMac) {
          matched = d;
          break;
        }
      }
    }

    setState(() {
      _devices = devices;
      _selectedDevice = matched ?? (devices.isNotEmpty ? devices.first : null);
      _isScanning = false;
    });
  }

  Future<void> _saveWifiSettings() async {
    final settingsDao = ref.read(settingsDaoProvider);
    await settingsDao.setSetting(AppConstants.keyPrinterType, 'wifi');
    await settingsDao.setSetting(AppConstants.keyPrinterIp, _ipController.text.trim());
    await settingsDao.setSetting(AppConstants.keyPrinterPort, _portController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wi-Fi / LAN Printer settings saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final printerService = ref.watch(printerServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Configuration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPrinterSettings,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Connection Interface Selector (Bluetooth vs Wi-Fi/LAN)
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Printer Connection Interface', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          avatar: const Icon(Icons.bluetooth, size: 18),
                          label: const Text('Bluetooth'),
                          selected: _printerType == 'bluetooth',
                          onSelected: (val) async {
                            if (val) {
                              setState(() => _printerType = 'bluetooth');
                              await ref.read(settingsDaoProvider).setSetting(AppConstants.keyPrinterType, 'bluetooth');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ChoiceChip(
                          avatar: const Icon(Icons.wifi, size: 18),
                          label: const Text('Wi-Fi / LAN Network'),
                          selected: _printerType == 'wifi',
                          onSelected: (val) async {
                            if (val) {
                              setState(() => _printerType = 'wifi');
                              await ref.read(settingsDaoProvider).setSetting(AppConstants.keyPrinterType, 'wifi');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Paper Roll Width Selector (58mm vs 80mm)
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Printer Paper Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('58 mm (2 inch Thermal)'),
                          selected: _paperWidth == '58',
                          onSelected: (val) {
                            if (val) {
                              setState(() => _paperWidth = '58');
                              ref.read(settingsDaoProvider).setSetting(AppConstants.keyPaperWidth, '58');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('80 mm (3 inch Thermal)'),
                          selected: _paperWidth == '80',
                          onSelected: (val) {
                            if (val) {
                              setState(() => _paperWidth = '80');
                              ref.read(settingsDaoProvider).setSetting(AppConstants.keyPaperWidth, '80');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Dynamic Section: Bluetooth Devices OR Wi-Fi / LAN Network Printer Setup
          if (_printerType == 'bluetooth')
            Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Paired Bluetooth Devices', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        if (_isScanning) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (_devices.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No paired Bluetooth printers found.\nPlease pair printer in Android Bluetooth settings first.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      )
                    else
                      Column(
                        children: _devices.map((device) {
                          return RadioListTile<BluetoothDevice>(
                            title: Text(device.name ?? 'Unknown Device', style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(device.address ?? ''),
                            value: device,
                            groupValue: _selectedDevice,
                            activeColor: AppColors.primary,
                            onChanged: (val) async {
                              if (val != null) {
                                setState(() => _selectedDevice = val);
                                final settingsDao = ref.read(settingsDaoProvider);
                                await settingsDao.setSetting(AppConstants.keyPrinterMac, val.address ?? '');
                                await settingsDao.setSetting(AppConstants.keyPrinterName, val.name ?? '');
                                await settingsDao.setSetting(AppConstants.keyPrinterType, 'bluetooth');

                                // Connect to device
                                await printerService.connect(val);
                              }
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            )
          else
            Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Wi-Fi / LAN Network Printer Setup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text(
                      'Connect printer to router via Ethernet / Wi-Fi. Ensure phone/tablet is on the same network.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _ipController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Printer IP Address',
                        hintText: 'e.g. 192.168.1.200',
                        prefixIcon: Icon(Icons.dns),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _portController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Port (Default: 9100)',
                        hintText: '9100',
                        prefixIcon: Icon(Icons.settings_ethernet),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save Wi-Fi Configuration'),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                        onPressed: _saveWifiSettings,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 30),

          // Test Print Button
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('TEST PRINT TICKET', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final settings = ref.read(settingsStreamProvider).value ?? {};
                final hotelName = settings[AppConstants.keyHotelName] ?? "Hotel Billing POS";

                if (_printerType == 'wifi') {
                  final ip = _ipController.text.trim();
                  final port = int.tryParse(_portController.text.trim()) ?? 9100;
                  final printed = await printerService.printTestWifi(ip: ip, port: port, hotelName: hotelName);
                  if (printed) {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Test print sent to Wi-Fi printer ($ip:$port)!')),
                    );
                  } else {
                    messenger.showSnackBar(
                      SnackBar(content: Text('Failed to connect to Wi-Fi printer at $ip:$port. Check network.')),
                    );
                  }
                } else {
                  if (_selectedDevice == null) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Please select a paired Bluetooth printer.')),
                    );
                    return;
                  }
                  final connected = await printerService.connect(_selectedDevice!);
                  if (connected) {
                    final bluePrinter = BlueThermalPrinter.instance;
                    bluePrinter.printCustom("=== TEST PRINT ===", 2, 1);
                    bluePrinter.printCustom(hotelName, 1, 1);
                    bluePrinter.printCustom("Bluetooth printer configured successfully!", 0, 1);
                    bluePrinter.printNewLine();
                    bluePrinter.printNewLine();
                    bluePrinter.paperCut();
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Bluetooth test print sent successfully!')),
                    );
                  } else {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Failed to connect to Bluetooth printer. Ensure printer is ON.')),
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
