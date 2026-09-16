import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FirmwareService {
  static const String baseUrl = 'http://192.168.4.1';
  static const String otaUrl = '$baseUrl/update';

  // Must match the token in your ESP32 firmware.
  static const String otaToken =
      'change-me-to-something-long-and-random';

  Future<Uint8List> loadFirmware(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);

    final Uint8List firmwareBytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    if (firmwareBytes.isEmpty) {
      throw Exception('Firmware file is empty.');
    }

    return firmwareBytes;
  }

  Future<FirmwareUploadResult> uploadFirmware({
    required Uint8List firmwareBytes,
    required int classNumber,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(otaUrl),
    );

    request.headers['X-OTA-Token'] = otaToken;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        firmwareBytes,
        filename: 'class_$classNumber.bin',
      ),
    );

    final streamedResponse = await request.send().timeout(
      const Duration(minutes: 5),
    );

    final responseBody = await streamedResponse.stream.bytesToString();

    return FirmwareUploadResult(
      statusCode: streamedResponse.statusCode,
      responseBody: responseBody,
    );
  }
}

class FirmwareUploadResult {
  final int statusCode;
  final String responseBody;

  const FirmwareUploadResult({
    required this.statusCode,
    required this.responseBody,
  });

  bool get isSuccess =>
      statusCode >= 200 && statusCode < 300;
}