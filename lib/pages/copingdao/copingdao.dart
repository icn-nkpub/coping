import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:solana/solana.dart';

class CopeScreen extends StatelessWidget {
  const CopeScreen({
    required this.setPage,
    super.key,
  });

  final void Function(int) setPage;

  Future<String> wall() async {
    final sc = SolanaClient(
        rpcUrl: Uri.parse('http://127.0.0.1:8899'),
        websocketUrl: Uri.parse('ws://127.0.0.1:8900'));
    print(sc);

    late final Wallet w;
    late final double balance;
    try {
      final sbt = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32
      ];

      // Finally, create a new wallet
      w = await Ed25519HDKeyPair.fromSeedWithHdPath(
        seed: sbt,
        hdPath: "m/44'/501'/0'/0'",
      );
      print(w.address);
      final bal = await sc.rpcClient.getBalance(w.publicKey.toString());
      balance = bal.value.toDouble() / 1000000000;
    } catch (e) {
      print(e);
    }

    return '${w.address.substring(0, 4)}...${w.address.substring(w.address.length - 5, w.address.length - 1)}, $balance SOL';
  }

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          TopBar(
            setPage: setPage,
            subTitle: AppLocalizations.of(context)!.screenAssistant,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ignore: discarded_futures
                  FutureBuilder(
                      future: wall(),
                      builder: (final context, final snapshot) {
                        if (!snapshot.hasData) {
                          return const Text('...');
                        }

                        return Text(snapshot.requireData);
                      })
                ],
              ),
            ),
          ),
        ],
      );
}
