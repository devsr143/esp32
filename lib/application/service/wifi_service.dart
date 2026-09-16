import 'package:wifi_iot/wifi_iot.dart';

class WifiService {
  Future<bool> isWifiEnabled() async {
    return await WiFiForIoTPlugin.isEnabled();
  }

  Future<void> openWifiSettings() async {
    await WiFiForIoTPlugin.setEnabled(true);
  }
}