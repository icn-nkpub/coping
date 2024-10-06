import 'package:bip39/bip39.dart' as bip39;
import 'package:dependencecoping/pages/copingdao/solprice.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:solana/solana.dart';

class Wallet {
  Wallet({required this.address, required this.balance});
  final String address;
  final double balance;
}

class CopeScreen extends StatelessWidget {
  const CopeScreen({
    required this.setPage,
    super.key,
  });

  final void Function(int) setPage;

  Future<Wallet> wall() async {
    final sc = SolanaClient(
        rpcUrl: Uri.parse('http://127.0.0.1:8899'),
        websocketUrl: Uri.parse('ws://127.0.0.1:8900'));

    var m = bip39.generateMnemonic();
    m = 'crystal scout antique seek shell engage comfort bounce win rally napkin juice';

    final w = await Ed25519HDKeyPair.fromMnemonic(m);
    final bal = await sc.rpcClient.getBalance(w.publicKey.toString());
    final balance = bal.value.toDouble() / 1000000000;

    return Wallet(address: w.address, balance: balance);
  }

  Future<Wallet> wallMock() async => Wallet(
      address: 'DVEqKrqiNPB8XLN9UmgLuEjEbdEovS9qKiLfcENTo23F', balance: 2.94300100002);

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
                  FutureBuilder<Wallet>(
                      // ignore: discarded_futures
                      future: wallMock(),
                      builder: (final context, final snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Text('Loading...');
                        }

                        final wallet = snapshot.requireData;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Address: ${wallet.address}'),
                            Text(
                                'Balance: ${wallet.balance.toStringAsFixed(6)} SOL'),
                            FutureBuilder(
                              // ignore: discarded_futures
                              future: getSolanaPrice(),
                              builder: (final context, final snapshot) {
                                if (snapshot.hasError) {
                                  return Text(snapshot.error.toString());
                                }
                                if (!snapshot.hasData) {
                                  return const Text('Loading...');
                                }

                                final usd =
                                    wallet.balance * (snapshot.data ?? 0);

                                if (usd == 0) {
                                  return const Text('Invalid...');
                                }

                                return Text(
                                    'Dolas: ${usd.toStringAsFixed(2)}\$');
                              },
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),
          ),
        ],
      );
}
