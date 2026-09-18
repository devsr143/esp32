import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';

class WifiService {
  Future<bool> isWifiEnabled() async {
    return await WiFiForIoTPlugin.isEnabled();
  }

  Future<void> openWifiSettings() async {
    if (Platform.isAndroid) {
      const AndroidIntent intent = AndroidIntent(
        action: 'android.settings.WIFI_SETTINGS',
      );
      await intent.launch();
    } else {
      await WiFiForIoTPlugin.setEnabled(true);
    }
  }

  Future<bool> isEsp32Connected() async {
    try {
      // Try to ping the default ESP32 IP address
      final response = await http.get(Uri.parse('http://192.168.4.1')).timeout(const Duration(seconds: 3));
      // If we get any response, we can reach it
      return true;
    } catch (e) {
      return false;
    }
  }
}
