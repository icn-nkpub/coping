import 'package:bip39/bip39.dart' as bip39;
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

    var m = bip39.generateMnemonic();
    print(m);
    m = 'crystal scout antique seek shell engage comfort bounce win rally napkin juice';

    // Finally, create a new wallet
    final w = await Ed25519HDKeyPair.fromMnemonic(m);
    print(w.address);
    final bal = await sc.rpcClient.getBalance(w.publicKey.toString());
    final balance = bal.value.toDouble() / 1000000000;

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
                  FutureBuilder(
                      // ignore: discarded_futures
                      future: wall(),
                      builder: (final context, final snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
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
