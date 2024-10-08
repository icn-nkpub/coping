import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:bip39/bip39.dart' as bip39;
import 'package:dependencecoping/pages/dao/nft_gen.dart';
import 'package:dependencecoping/pages/dao/solprice.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:solana/solana.dart';

const String walletBox = 'walletBox';
const String seedPhraseKey = 'seedPhrase';

class Wallet {
  Wallet({required this.w, required this.balance, required this.solPrice});
  final Ed25519HDKeyPair w;
  final double balance;
  final SolanaPrice? solPrice;
}

class CopeScreen extends StatefulWidget {
  const CopeScreen({required this.setPage, super.key});

  final void Function(int) setPage;

  @override
  CopeScreenState createState() => CopeScreenState();
}

class CopeScreenState extends State<CopeScreen> {
  Wallet? wallet;
  bool isLoading = true;
  bool hasError = false;
  SolanaClient? client;

  @override
  void initState() {
    super.initState();
    unawaited(_loadWalletData());
  }

  Future<void> _loadWalletData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final box = await Hive.openBox(walletBox);
      final sc = client ??
          SolanaClient(
            rpcUrl: Platform.isWindows
                ? Uri.parse('http://127.0.0.1:8899')
                : Uri.parse('https://api.devnet.solana.com'),
            websocketUrl: Platform.isWindows
                ? Uri.parse('ws://127.0.0.1:8900')
                : Uri.parse('ws://api.devnet.solana.com'),
          );

      String? m = box.get(seedPhraseKey) as String?;
      if (m == null || m == '') {
        m = bip39.generateMnemonic();
        await box.put(seedPhraseKey, m);
      } else {
        log('Using cached seed phrase and wallet information');
      }

      final w = await Ed25519HDKeyPair.fromMnemonic(m);
      if (mounted) {
        setColor(context, keyColor(w.address).toColor());
      }
      final bal = await sc.rpcClient.getBalance(w.publicKey.toString());
      final balance = bal.value.toDouble() / 1000000000;
      final solPrice = await getSolanaPrice();

      setState(() {
        client = sc;
        wallet = Wallet(w: w, balance: balance, solPrice: solPrice);
        isLoading = false;
      });
      // ignore: avoid_catches_without_on_clauses
    } catch (e, stackTrace) {
      log('Error loading wallet: $e', error: e, stackTrace: stackTrace);
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> _requestAirdrop() async {
    if (client == null || wallet == null) {
      return;
    }

    await client!
        .requestAirdrop(address: wallet!.w.publicKey, lamports: 1000000000);

    final bal =
        await client!.rpcClient.getBalance(wallet!.w.publicKey.toString());
    final balance = bal.value.toDouble() / 1000000000;
    final solPrice = await getSolanaPrice();

    setState(() {
      wallet = Wallet(w: wallet!.w, balance: balance, solPrice: solPrice);
    });
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TopBar(
          setPage: widget.setPage,
          subTitle: AppLocalizations.of(context)!.screenAssistant,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (isLoading)
                  const Text('Loading...')
                else if (hasError)
                  const Text('Error loading wallet data')
                else if (wallet != null)
                  _buildWalletInfo(theme),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletInfo(final ThemeData theme) {
    if (wallet == null) {
      return const Text('Wallet is not connected');
    }

    final solPrice = wallet!.solPrice ?? SolanaPrice(price: 0, change1h: 0);
    final usd = wallet!.balance * solPrice.price;

    String upordown = solPrice.change1h.toStringAsFixed(4);
    bool isup = false;
    if (upordown[0] != '-') {
      upordown = '+$upordown';
      isup = true;
    }

    final color =
        isup ? theme.colorScheme.primary : theme.colorScheme.secondary;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.string(
            nftGen(wallet!.w.address),
            width: MediaQuery.sizeOf(context).width,
          ),
          Text(
            '${wallet!.balance.toStringAsFixed(6)} SOL',
            style: theme.textTheme.bodyLarge?.copyWith(
                fontVariations: [const FontVariation('wght', 1000.0)]),
          ),
          solPrice.price > 0
              ? Text(
                  '${usd.toStringAsFixed(2)}\$ $upordown% ${isup ? '↑' : '↓'}',
                  style: theme.textTheme.labelSmall?.copyWith(color: color),
                )
              : const Text('can\'t retrieve price'),
          Text(
            '${wallet!.w.address.substring(0, 4)}...${wallet!.w.address.substring(wallet!.w.address.length - 4, wallet!.w.address.length)}',
            style: theme.textTheme.bodyMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                CopyButton(addr: wallet!.w.address),
                TextButton(
                  onPressed: _requestAirdrop,
                  child: const Text('Airdrop'),
                ),
                TextButton(
                  onPressed: () async {
                    final box = await Hive.openBox(walletBox);
                    final m = bip39.generateMnemonic();
                    await box.put(seedPhraseKey, m);
                    await _loadWalletData();
                  },
                  child: const Text('Regenerate'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.addr));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Address copied to clipboard',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    log('Copied: ${widget.addr}');
  }

  @override
  Widget build(final BuildContext context) => TextButton(
        onPressed: _copyToClipboard,
        child: const Text('Copy'),
      );
}
