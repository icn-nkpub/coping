import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<double?> getSolanaPrice() async {
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
        return price.toDouble();
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
  } catch (e, stackTrace) {
    log('Unknown error fetching SOL price', error: e, stackTrace: stackTrace);
    return null;
  }
}
