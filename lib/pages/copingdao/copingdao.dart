import 'dart:developer';

import 'package:bip39/bip39.dart' as bip39;
import 'package:dependencecoping/pages/copingdao/solprice.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive/hive.dart';
import 'package:solana/solana.dart';

const String walletBox = 'walletBox';
const String seedPhraseKey = 'seedPhrase';

class Wallet {
  Wallet(
      {required this.address, required this.balance, required this.solPrice});
  final String address;
  final double balance;
  final SolanaPrice? solPrice;
}

class CopeScreen extends StatelessWidget {
  const CopeScreen({
    required this.setPage,
    super.key,
  });

  final void Function(int) setPage;

  Future<Wallet> wall() async {
    final box = await Hive.openBox(walletBox);
    await box.put(seedPhraseKey,
        'crystal scout antique seek shell engage comfort bounce win rally napkin juice');

    final sc = SolanaClient(
        rpcUrl: Uri.parse('http://127.0.0.1:8899'),
        websocketUrl: Uri.parse('ws://127.0.0.1:8900'));

    String? m = box.get(seedPhraseKey) as String?;

    if (m == null || m == '') {
      m = bip39.generateMnemonic();
      await box.put(seedPhraseKey, m);
    } else {
      log('Using cached seed phrase and wallet information');
    }

    final w = await Ed25519HDKeyPair.fromMnemonic(m);
    final bal = await sc.rpcClient.getBalance(w.publicKey.toString());
    final balance = bal.value.toDouble() / 1000000000;

    final price = await getSolanaPrice();

    return Wallet(address: w.address, balance: balance, solPrice: price);
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
                  FutureBuilder<Wallet>(
                      // ignore: discarded_futures
                      future: wall(),
                      builder: (final context, final snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (!snapshot.hasData) {
                          return const Text('Loading...');
                        }

                        final wallet = snapshot.requireData;
                        final SolanaPrice solPrice = wallet.solPrice ??
                            SolanaPrice(price: 0, change1h: 0);

                        final usd = wallet.balance * solPrice.price;

                        String upordown = solPrice.change1h.toStringAsFixed(4);
                        bool isup = false;
                        if (upordown[0] != '-') {
                          upordown = '+$upordown';
                          isup = true;
                        }

                        final t = Theme.of(context);
                        final color = isup
                            ? t.colorScheme.primary
                            : t.colorScheme.secondary;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${wallet.address.substring(0, 4)}...${wallet.address.substring(wallet.address.length - 4, wallet.address.length)}',
                                style: t.textTheme.bodyMedium),
                            Text('${wallet.balance.toStringAsFixed(6)} SOL'),
                            solPrice.price > 0
                                ? Text(
                                    '${usd.toStringAsFixed(2)}\$ $upordown% ${isup ? '↑' : '↓'}',
                                    style: t.textTheme.labelSmall
                                        ?.copyWith(color: color),
                                  )
                                : const Text('can\'t retrieve price'),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  CopyButton(addr: wallet.address),
                                ],
                              ),
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

class CopyButton extends StatefulWidget {
  const CopyButton({
    required this.addr,
    super.key,
  });

  final String addr;

  @override
  CopyButtonState createState() => CopyButtonState();
}

class CopyButtonState extends State<CopyButton> {
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.addr));
    tooltipKey.currentState?.ensureTooltipVisible();
    log('Copied: ${widget.addr}');
  }

  @override
  Widget build(final BuildContext context) => Tooltip(
        key: tooltipKey,
        message: 'Copied',
        triggerMode: TooltipTriggerMode.manual,
        child: TextButton(
          onPressed: _copyToClipboard,
          child: const Text('Copy'),
        ),
      );
}
