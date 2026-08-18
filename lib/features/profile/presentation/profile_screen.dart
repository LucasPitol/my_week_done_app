import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/glass/glass_layout_metrics.dart';
import '../../../providers/glass_effects_provider.dart';
import '../../../providers/theme_mode_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reduceEffectsAsync = ref.watch(glassEffectsSettingsProvider);
    final systemReduceTransparency =
        ref.watch(systemReduceTransparencyProvider).value ?? false;
    final themePreferenceAsync = ref.watch(themeModeSettingsProvider);
    final themePreference =
        themePreferenceAsync.value ?? AppThemePreference.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: ListView(
        padding: GlassLayoutMetrics.scrollPadding(context).copyWith(
          left: 16,
          right: 16,
          top: 16,
        ),
        children: [
          Text(
            'Aparência',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
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
          const SizedBox(height: 12),
          Card(
            child: SwitchListTile(
              title: const Text('Reduzir transparência'),
              subtitle: Text(
                systemReduceTransparency
                    ? 'Ativo pelo sistema. Você pode forçar aqui também.'
                    : 'Substitui o efeito de vidro por superfícies sólidas.',
              ),
              value: (reduceEffectsAsync.value ?? false) || systemReduceTransparency,
              onChanged: (reduceEffectsAsync.isLoading || systemReduceTransparency)
                  ? null
                  : (value) {
                      ref
                          .read(glassEffectsSettingsProvider.notifier)
                          .setReduceEffects(value);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
