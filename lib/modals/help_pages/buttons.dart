import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ControlButtonsHelpPage extends StatelessWidget {
  const ControlButtonsHelpPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Guy(text: 'Control buttons', face: Assets.guy.positive),
          Expanded(
              child: ListView(
            children: [
              const SizedBox(height: 16),
              handedControls(context, 1, paused: true),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim ligula, fringilla ac urna at, consectetur elementum nunc. Nullam mattis dapibus iaculis.'),
              ),
              handedControls(context, 1),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim ligula, fringilla ac urna at, consectetur elementum nunc. Nullam mattis dapibus iaculis.'),
              ),
              handedControls(context, 2.15, paused: true),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim ligula, fringilla ac urna at, consectetur elementum nunc. Nullam mattis dapibus iaculis.'),
              ),
              handedControls(context, 3.2, paused: true),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim ligula, fringilla ac urna at, consectetur elementum nunc. Nullam mattis dapibus iaculis.'),
              ),
            ],
          ))
        ],
      );

  Handed handedControls(final BuildContext context, final double i, {final bool paused = false}) => Handed(
        computeTop: (final s, final av) => s - 4 * av,
        computeLeft: (final s, final av) => (2 * i - 1) * (s / 6),
        duration: const Duration(seconds: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            paused
                ? IconButton.filledTonal(
                    onPressed: () {},
                    icon: SvgIcon(
                      assetPath: Assets.icons.playCircle,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  )
                : IconButton.filledTonal(
                    onPressed: () {},
                    icon: SvgIcon(
                      assetPath: Assets.icons.stopCircle,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
            IconButton.filledTonal(
              onPressed: () {},
              icon: SvgIcon(
                assetPath: Assets.icons.history,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            IconButton.filledTonal(
              onPressed: () {},
              icon: SvgIcon(
                assetPath: Assets.icons.checklist,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      );
}
