import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/modals/help_pages/_guy.dart';
import 'package:dependencecoping/modals/help_pages/_handed.dart';
import 'package:dependencecoping/pages/clock/countdown.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroHelpPage extends StatelessWidget {
  const IntroHelpPage({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Guy(text: 'Intro', face: Assets.guy.neutral),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16),
                Handed(
                  computeTop: (final s, final av) => 0,
                  computeLeft: (final s, final av) => 16 + ((s - 32) * av),
                  duration: const Duration(seconds: 15),
                  child: Stopwatch(
                    from: DateTime.now(),
                    frozen: !true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim ligula, fringilla ac urna at, consectetur elementum nunc. Nullam mattis dapibus iaculis. Donec id lectus in nunc sollicitudin ultrices. Sed euismod nulla nulla, et scelerisque justo fringilla eget. Quisque at lacus id sapien ultrices ornare. Fusce in diam lorem. Donec vel lacinia tellus, ac tempor quam. Nullam cursus non nisi a rutrum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Integer lobortis, eros id tempus tincidunt, magna metus molestie diam, in tempus libero lorem sit amet quam. Nulla ex mauris, tincidunt eu massa vel, faucibus condimentum lacus. Sed id justo mollis, tristique ante cursus, volutpat quam. Suspendisse euismod malesuada purus nec pretium. Curabitur ornare fermentum odio, eget volutpat felis lobortis sit amet.'),
                ),
                Handed(
                  computeTop: (final s, final av) => s - (av * 4),
                  computeLeft: (final s, final av) => s,
                  duration: const Duration(seconds: 1),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScoreCard(score: '9,320'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin enim ligula, fringilla ac urna at, consectetur elementum nunc. Nullam mattis dapibus iaculis. Donec id lectus in nunc sollicitudin ultrices. Sed euismod nulla nulla, et scelerisque justo fringilla eget. Quisque at lacus id sapien ultrices ornare. Fusce in diam lorem. Donec vel lacinia tellus, ac tempor quam. Nullam cursus non nisi a rutrum. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Integer lobortis, eros id tempus tincidunt, magna metus molestie diam, in tempus libero lorem sit amet quam. Nulla ex mauris, tincidunt eu massa vel, faucibus condimentum lacus. Sed id justo mollis, tristique ante cursus, volutpat quam. Suspendisse euismod malesuada purus nec pretium. Curabitur ornare fermentum odio, eget volutpat felis lobortis sit amet.'),
                ),
              ],
            ),
          )
        ],
      );
}
