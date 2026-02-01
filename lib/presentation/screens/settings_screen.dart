import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/settings_controller.dart';
import '../../l10n/app_localizations.dart';
import 'data_backup_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: settingsAsync.when(
        data: (settings) => ListView(
          children: [
            SwitchListTile(
              title: Text(l10n.intentPrompt),
              subtitle: Text(l10n.intentPromptDescription),
              value: settings.intentPromptEnabled,
              onChanged: (value) {
                ref.read(settingsControllerProvider.notifier).toggleIntentPrompt(value);
              },
            ),
            if (settings.intentPromptEnabled)
              ListTile(
                title: Text(l10n.threshold),
                subtitle: Text('${settings.intentPromptThreshold.toStringAsFixed(2)} €'),
                trailing: SizedBox(
                  width: 200,
                  child: Slider(
                    value: settings.intentPromptThreshold,
                    min: 0,
                    max: 500,
                    divisions: 50,
                    label: settings.intentPromptThreshold.toStringAsFixed(0),
                    onChanged: (value) {
                      ref.read(settingsControllerProvider.notifier).setThreshold(value);
                    },
                  ),
                ),
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.backup),
              title: Text(l10n.dataAndBackup),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DataBackupScreen()),
                );
              },
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }
}
