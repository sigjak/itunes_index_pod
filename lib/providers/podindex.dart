import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'dart:convert';

Map<String, String> prepHeaders() {
  var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  var newUnixTime = unixTime.toString();
  // Change to your API key...
  var apiKey = 'YE9BH8C5YDXWMCPZM9T8';
  // Change to your API secret...
  var apiSecret = 'qQmfzdA3kGmnrChfYTuk3TnqQQj\$rPRt6RykHUDA';
  var firstChunk = utf8.encode(apiKey);
  var secondChunk = utf8.encode(apiSecret);
  var thirdChunk = utf8.encode(newUnixTime);

  var output = AccumulatorSink<Digest>();
  var input = sha1.startChunkedConversion(output);

  input.add(firstChunk);
  input.add(secondChunk);
  input.add(thirdChunk);
  input.close();
  var digest = output.events.single;

  var headers = <String, String>{
    'X-Auth-Date': newUnixTime,
    'X-Auth-Key': apiKey,
    'Authorization': digest.toString(),
    'User-Agent': 'SomethingAwesome/1.0.1'
  };

  return headers;
}
