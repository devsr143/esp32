import 'package:esp32/application/model/program_block.dart';
import 'package:http/http.dart' as http;

class Esp32CommandService {
  Esp32CommandService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  final http.Client _client;

  static const String baseUrl = 'http://192.168.4.1';

  Future<bool> sendCommand(ProgramBlock block) async {
    final String endpoint;

    switch (block.type) {
      case CommandType.forward:
        endpoint = '$baseUrl/forward?sec=${block.seconds}';
        break;

      case CommandType.backward:
        endpoint = '$baseUrl/backward?sec=${block.seconds}';
        break;

      case CommandType.left:
        endpoint = '$baseUrl/left?deg=${block.degrees}';
        break;

      case CommandType.right:
        endpoint = '$baseUrl/right?deg=${block.degrees}';
        break;

      case CommandType.circle:
        endpoint = '$baseUrl/circle';
        break;

      case CommandType.stop:
        endpoint = '$baseUrl/stop';
        break;

      case CommandType.delay:
        endpoint = '$baseUrl/delay?sec=${block.seconds}';
        break;

      case CommandType.loop:
        return true;
    }

    try {
      final response = await _client
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 15));

      return response.statusCode >= 200 &&
          response.statusCode < 300;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}


