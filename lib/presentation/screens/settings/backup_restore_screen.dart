import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/backup_restore_service.dart';
import '../../../services/permission_service.dart';
import '../../providers/database_provider.dart';

class BackupRestoreScreen extends ConsumerStatefulWidget {
  const BackupRestoreScreen({super.key});

  @override
  ConsumerState<BackupRestoreScreen> createState() => _BackupRestoreScreenState();
}

class _BackupRestoreScreenState extends ConsumerState<BackupRestoreScreen> {
  bool _isProcessing = false;
  String? _statusMessage;
  List<FileSystemEntity> _availableBackups = [];
  String _backupFolderPath = 'Documents/HotelBillingPOS';

  @override
  void initState() {
    super.initState();
    _refreshAvailableBackups();
  }

  Future<void> _refreshAvailableBackups() async {
    final db = ref.read(databaseProvider);
    final backupService = BackupRestoreService(db);
    final folder = await backupService.getBackupDirectory();
    final backups = await backupService.getAvailableBackups();

    if (mounted) {
      setState(() {
        _backupFolderPath = folder.path;
        _availableBackups = backups;
      });
    }
  }

  Future<void> _handleExportBackup() async {
    setState(() {
      _isProcessing = true;
      _statusMessage = 'Exporting database backup to Documents folder...';
    });

    await PermissionService.requestStoragePermissions();

    final db = ref.read(databaseProvider);
    final backupService = BackupRestoreService(db);
    final file = await backupService.saveBackupToFile();

    await _refreshAvailableBackups();

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _statusMessage = file != null
            ? 'Backup copy saved successfully!\nLocation: ${file.path}'
            : 'Backup generated in web demo mode.';
      });
    }
  }

  Future<void> _handleRestoreFile(File file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Restore Data'),
        content: Text('Are you sure you want to restore data from backup:\n${file.path.split(Platform.pathSeparator).last}?\nExisting database entries will be updated.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm Restore'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isProcessing = true;
      _statusMessage = 'Restoring database state...';
    });

    final db = ref.read(databaseProvider);
    final backupService = BackupRestoreService(db);
    final ok = await backupService.restoreFromFile(file);

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _statusMessage = ok
            ? 'Data restored successfully from ${file.path.split(Platform.pathSeparator).last}!'
            : 'Failed to restore backup file. Invalid format or corrupted file.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final backupService = BackupRestoreService(db);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Backup & Restoration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Backup Files',
            onPressed: _refreshAvailableBackups,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Header Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.folder_special, color: AppColors.primary, size: 26),
                      SizedBox(width: 10),
                      Text(
                        'File Manager Backup Folder',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All database backup copies are stored in File Manager under the "Documents/HotelBillingPOS" folder.\n\nPath: $_backupFolderPath',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Export Backup Card
            Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.download_for_offline, color: AppColors.primary, size: 28),
                        SizedBox(width: 12),
                        Text('Export New Backup Copy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Creates a timestamped JSON backup copy in Documents/HotelBillingPOS folder. Multiple copies (2-3+) remain saved for easy historical data retrieval.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_alt),
                        label: const Text('CREATE BACKUP COPY NOW', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                        onPressed: _isProcessing ? null : _handleExportBackup,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Available Backup Copies List Card
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
                        Row(
                          children: [
                            const Icon(Icons.history, color: AppColors.secondary, size: 26),
                            const SizedBox(width: 10),
                            Text(
                              'Saved Backup Copies (${_availableBackups.length})',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20, color: AppColors.primary),
                          onPressed: _refreshAvailableBackups,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select any existing backup copy from Documents/HotelBillingPOS to instantly restore your data:',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 12),

                    if (_availableBackups.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: const Text(
                          'No backup copies found yet in Documents/HotelBillingPOS folder.\nClick "CREATE BACKUP COPY NOW" above to export your first backup.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _availableBackups.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.borders),
                        itemBuilder: (context, index) {
                          final fileEntity = _availableBackups[index] as File;
                          final fileName = fileEntity.path.split(Platform.pathSeparator).last;
                          final stat = fileEntity.statSync();
                          final modifiedStr = stat.modified.toString().substring(0, 16);
                          final sizeKb = (stat.size / 1024).toStringAsFixed(1);

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.insert_drive_file, color: AppColors.primary, size: 20),
                            ),
                            title: Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text('Date: $modifiedStr | Size: $sizeKb KB', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                            trailing: ElevatedButton.icon(
                              icon: const Icon(Icons.restore, size: 16),
                              label: const Text('RESTORE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              onPressed: _isProcessing ? null : () => _handleRestoreFile(fileEntity),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Pick Other External Backup File Card
            Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.folder_open, color: AppColors.accent, size: 26),
                        SizedBox(width: 10),
                        Text('Pick External Backup File', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('Browse and restore from custom storage locations (e.g. Google Drive, SD card, Pendrive).'),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.file_upload),
                        label: const Text('BROWSE FILE MANAGER'),
                        onPressed: _isProcessing
                            ? null
                            : () async {
                                final result = await FilePicker.platform.pickFiles(type: FileType.any);
                                if (result != null) {
                                  setState(() {
                                    _isProcessing = true;
                                    _statusMessage = 'Restoring database from backup file...';
                                  });
                                  String? content;
                                  if (result.files.single.bytes != null) {
                                    content = String.fromCharCodes(result.files.single.bytes!);
                                  } else if (result.files.single.path != null) {
                                    final file = File(result.files.single.path!);
                                    content = await file.readAsString();
                                  }
                                  final ok = content != null ? await backupService.restoreFromJson(content) : false;
                                  await _refreshAvailableBackups();
                                  if (mounted) {
                                    setState(() {
                                      _isProcessing = false;
                                      _statusMessage = ok ? 'Data restored successfully!' : 'Failed to restore backup file. Invalid format.';
                                    });
                                  }
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_statusMessage != null)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _statusMessage!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
