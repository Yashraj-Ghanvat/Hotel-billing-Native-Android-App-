import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request Bluetooth & Location permissions required for thermal printing
  static Future<bool> requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();

    bool btConnectGranted = statuses[Permission.bluetoothConnect]?.isGranted ?? true;
    bool btScanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? true;
    bool locationGranted = statuses[Permission.location]?.isGranted ?? true;

    return btConnectGranted && btScanGranted && locationGranted;
  }

  /// Request Storage permissions for JSON / PDF export
  static Future<bool> requestStoragePermissions() async {
    if (await Permission.storage.isGranted || await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    return (statuses[Permission.storage]?.isGranted ?? false) ||
           (statuses[Permission.manageExternalStorage]?.isGranted ?? false);
  }
}
