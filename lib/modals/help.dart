import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/buttons.dart';
import 'package:dependencecoping/modals/help_pages/intro.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpModal extends StatelessWidget {
  const HelpModal({
    super.key,
  });

  @override
  Widget build(final BuildContext context) {
    final localSurface = ElevationOverlay.applySurfaceTint(
      Theme.of(context).colorScheme.background,
      Theme.of(context).colorScheme.primary,
      1,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: localSurface,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: localSurface,
        ),
        child: SafeArea(
          left: false,
          top: false,
          right: false,
          minimum: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                      },
                      icon: SvgIcon(
                        assetPath: Assets.icons.arrowBack,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.helpSwipeAction,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                        onPressed: () {
                          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                        },
                        icon: SvgIcon(assetPath: Assets.icons.arrowBack),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: SizedBox(
                  width: double.maxFinite,
                  child: PageView(
                    children: const [
                      HelpPageContainer(helpPage: IntroHelpPage()),
                      HelpPageContainer(helpPage: ControlButtonsHelpPage()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelpPageContainer extends StatelessWidget {
  const HelpPageContainer({
    required this.helpPage,
    super.key,
  });

  final Widget helpPage;

  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border.all(color: Theme.of(context).colorScheme.tertiaryContainer, width: 4),
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: helpPage,
        ),
      );
}
