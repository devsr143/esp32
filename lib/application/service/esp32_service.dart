
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Esp32Service {
  Esp32Service({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const String baseUrl = 'http://192.168.4.1';

  Future<String?> sendBin(String assetPath) async {
    try {
      ByteData data;
      try {
        data = await rootBundle.load(assetPath);
      } catch (e) {
        return 'Asset not found: $assetPath';
      }

      final Uint8List bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/update'),
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'update', // standard field name for ESP32 OTA
          bytes,
          filename: assetPath.split('/').last,
        ),
      );

      final streamedResponse = await _client
          .send(request)
          .timeout(const Duration(minutes: 5));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return null; // Success
      } else {
        return 'HTTP Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('ESP32 BIN error: $e');
      return 'Connection error: $e';
    }
  }

  void dispose() {
    _client.close();
  }
}
