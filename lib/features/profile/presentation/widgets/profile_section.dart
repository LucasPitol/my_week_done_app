import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];

    for (var index = 0; index < children.length; index++) {
      if (index > 0) {
        items.add(const Divider(height: 1));
      }
      items.add(children[index]);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      ),
    );
  }
}
