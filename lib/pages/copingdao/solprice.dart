import 'dart:convert';
import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

const String solPriceBox = 'solPriceBox';
const String solPriceKey = 'solana_price';
const String solTimestampKey = 'solana_timestamp';
const int ttlInSeconds = 300; // TTL set to 5 minutes (300 seconds)

Future<double?> getSolanaPrice() async {
  final box = await Hive.openBox(solPriceBox);

  final cachedPrice = box.get(solPriceKey) as double?;
  final cachedTimestamp = box.get(solTimestampKey) as DateTime?;

  if (cachedPrice != null && cachedTimestamp != null) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(cachedTimestamp).inSeconds;

    if (difference < ttlInSeconds) {
      log('Returning cached SOL price: $cachedPrice');
      return cachedPrice;
    }
  }

  const String url =
      'https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd';

  try {
    final Uri uri = Uri.parse(url);
    final http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;

      final solanaData = data['solana'] as Map<String, dynamic>?;
      final price = solanaData?['usd'] as num?;

      if (price != null) {
        final priceDouble = price.toDouble();

        await box.put(solPriceKey, priceDouble);
        await box.put(solTimestampKey, DateTime.now());

        log('Fetched and cached new SOL price: $priceDouble');
        return priceDouble;
      } else {
        log('Failed to parse SOL price from response data', error: data);
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
