
import 'package:esp32/application/service/wifi_service.dart';
import 'package:flutter/material.dart';

class SetupViewModel extends ChangeNotifier {
  final WifiService _wifiService;

  SetupViewModel({WifiService? wifiService})
    : _wifiService = wifiService ?? WifiService();

  int selectedClass = 3;

  bool isWifiEnabled = false;
  bool isCheckingConnection = false;
  bool _isEsp32Connected = false;

  String wifiStatus = 'Checking Wi-Fi...';

  String status = 'Connect your phone to the ESP32 hotspot.';

  bool get isEsp32Connected => _isEsp32Connected;

  Future<void> initialize() async {
    await checkWifiStatus();
  }

  Future<void> checkWifiStatus() async {
    await connectToEsp32();
  }

  Future<void> openWifiSettings() async {
    await _wifiService.openWifiSettings();
  }

  Future<void> connectToEsp32() async {
    if (isCheckingConnection) return;

    isCheckingConnection = true;
    status = 'Checking Wi-Fi connection...';
    notifyListeners();

    try {
      final enabled = await _wifiService.isWifiEnabled();
      isWifiEnabled = enabled;

      if (enabled) {
        final espConnected = await _wifiService.isEsp32Connected();
        _isEsp32Connected = espConnected;

        if (espConnected) {
          wifiStatus = 'Connected to ESP32 hotspot';
          status =
              'ESP32 Connected ✓\n\n'
              'Wi-Fi is ready.\n\n'
              'You can choose a class and continue.';
        } else {
          wifiStatus = 'ESP32 not connected';
          status =
              'Wi-Fi is ON, but ESP32 is not connected.\n\n'
              'Please connect your phone to the ESP32 hotspot.';
        }
      } else {
        _isEsp32Connected = false;
        wifiStatus = 'ESP32 not connected';
        status =
            'Wi-Fi is OFF.\n\n'
            'Please enable Wi-Fi and connect to '
            'the ESP32 hotspot.';
      }
    } catch (e) {
      isWifiEnabled = false;
      _isEsp32Connected = false;
      wifiStatus = 'ESP32 not connected';
      status = 'Unable to check Wi-Fi.\n\n$e';
    } finally {
      isCheckingConnection = false;
      notifyListeners();
    }
  }

  void selectClass(int? classNumber) {
    if (classNumber == null || !isEsp32Connected) {
      return;
    }

    selectedClass = classNumber;
    status =
        'Class $classNumber selected.\n\n'
        'Press Continue to see activities.';
    notifyListeners();
  }
}
