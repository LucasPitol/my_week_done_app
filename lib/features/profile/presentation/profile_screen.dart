import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../core/constants/profile_constants.dart';
import '../../../core/theme/nav_layout_metrics.dart';
import '../../../core/utils/clipboard_utils.dart';
import '../../../core/utils/url_launch_utils.dart';
import '../../../providers/theme_mode_provider.dart';
import '../providers/package_info_provider.dart';
import 'widgets/clear_data_dialog.dart';
import 'widgets/pix_qr_sheet.dart';
import 'widgets/profile_section.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themePreferenceAsync = ref.watch(themeModeSettingsProvider);
    final themePreference =
        themePreferenceAsync.value ?? AppThemePreference.system;
    final packageInfoAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: ListView(
        padding: NavLayoutMetrics.scrollPadding(context).copyWith(
          left: 16,
          right: 16,
          top: 16,
        ),
        children: [
          ProfileSection(
            title: 'Aparência',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tema',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),
                    SegmentedButton<AppThemePreference>(
                      segments: const [
                        ButtonSegment(
                          value: AppThemePreference.light,
                          label: Text('Claro'),
                        ),
                        ButtonSegment(
                          value: AppThemePreference.dark,
                          label: Text('Escuro'),
                        ),
                        ButtonSegment(
                          value: AppThemePreference.system,
                          label: Text('Sistema'),
                        ),
                      ],
                      selected: {themePreference},
                      onSelectionChanged: themePreferenceAsync.isLoading
                          ? null
                          : (selection) {
                              ref
                                  .read(themeModeSettingsProvider.notifier)
                                  .setPreference(selection.first);
                            },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ProfileSection(
            title: 'Apoie o projeto',
            child: ProfileSettingsCard(
              children: [
                ListTile(
                  title: const Text('Pix'),
                  subtitle: Text(
                    ProfileConstants.pixKey,
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    tooltip: 'Ver QR code',
                    icon: const Icon(TablerIcons.qrcode),
                    onPressed: () => showPixQrSheet(context),
                  ),
                  onTap: () => copyToClipboard(
                    context,
                    text: ProfileConstants.pixKey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ProfileSection(
            title: 'Sobre',
            child: ProfileSettingsCard(
              children: [
                ListTile(
                  title: const Text('Versão'),
                  trailing: packageInfoAsync.when(
                    data: (info) => Text(
                      '${info.version} (${info.buildNumber})',
                      style: theme.textTheme.bodySmall,
                    ),
                    loading: () => const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (error, stackTrace) => Text(
                      '—',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Avalie o app'),
                  trailing: const Icon(TablerIcons.chevron_right),
                  onTap: requestAppReview,
                ),
                ListTile(
                  title: const Text('Política de privacidade'),
                  trailing: const Icon(TablerIcons.external_link),
                  onTap: () => launchExternalUrl(
                    ProfileConstants.privacyPolicyUrl,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ProfileSection(
            title: 'Dados',
            child: ProfileSettingsCard(
              children: [
                ListTile(
                  title: Text(
                    'Limpar dados',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  subtitle: Text(
                    'Remove rotinas, conclusões e tarefas soltas',
                    style: theme.textTheme.bodySmall,
                  ),
                  trailing: Icon(
                    TablerIcons.trash,
                    color: theme.colorScheme.error,
                  ),
                  onTap: () async {
                    final cleared = await showClearDataFlow(context, ref);
                    if (cleared && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Dados apagados'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
