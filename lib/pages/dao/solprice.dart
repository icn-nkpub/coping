import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

const String solPriceBox = 'solPriceBox';
const String solPriceKey = 'solanaPrice';
const String solPriceChangeKey = 'solanaPrice:Change';
const String solPriceKeyTTL = 'TTL:solanaPrice';
const int ttlInSeconds = 3600; // TTL set to 1 hour (3600 seconds)

class SolanaPrice {
  SolanaPrice({required this.price, required this.change1h});
  final double price;
  final double change1h;
}

Future<SolanaPrice?> getSolanaPrice() async {
  final box = await Hive.openBox(solPriceBox);

  final cachedPrice = box.get(solPriceKey) as double?;
  final cachedPriceChange = box.get(solPriceChangeKey) as double?;
  final cachedTimestamp = box.get(solPriceKeyTTL) as DateTime?;

  if (cachedPrice != null &&
      cachedPriceChange != null &&
      cachedTimestamp != null) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(cachedTimestamp).inSeconds;

    if (difference < ttlInSeconds) {
      log('Returning cached SOL price: $cachedPrice with 1h change: $cachedPriceChange%');
      return SolanaPrice(price: cachedPrice, change1h: cachedPriceChange);
    }
  }

  const String url =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=solana&price_change_percentage=1h';

  try {
    final Uri uri = Uri.parse(url);
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;

      if (data.isNotEmpty) {
        final solanaData = data[0] as Map<String, dynamic>?;
        final price = solanaData?['current_price'] as num?;
        final priceChangePercentage1h =
            solanaData?['price_change_percentage_1h_in_currency'] as num?;

        if (price != null && priceChangePercentage1h != null) {
          final priceDouble = price.toDouble();
          final priceChangeDouble = priceChangePercentage1h.toDouble();

          await box.put(solPriceKey, priceDouble);
          await box.put(solPriceChangeKey, priceChangeDouble);
          await box.put(solPriceKeyTTL, DateTime.now());

          log('Fetched and cached new SOL price: $priceDouble with 1h change: $priceChangeDouble%');
          return SolanaPrice(price: priceDouble, change1h: priceChangeDouble);
        } else {
          log('Failed to parse SOL price or 1-hour change from response data',
              error: data);
          return null;
        }
      } else {
        log('No data received from CoinGecko API');
        return null;
      }
    } else {
      log('Failed to load SOL price: ${response.statusCode} ${response.reasonPhrase}');
      return null;
    }
  } on FormatException catch (e, stackTrace) {
    log('JSON format error: $e', error: e, stackTrace: stackTrace);
    return null;
  } on http.ClientException catch (e, stackTrace) {
    log('HTTP client error: $e', error: e, stackTrace: stackTrace);
    return null;
    // ignore: avoid_catches_without_on_clauses
  } catch (e, stackTrace) {
    log('Unknown error fetching SOL price', error: e, stackTrace: stackTrace);
    return null;
  }
}
