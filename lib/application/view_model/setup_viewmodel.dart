import 'dart:typed_data';

import 'package:esp32/application/service/bin_service.dart';
import 'package:esp32/application/service/wifi_service.dart';
import 'package:flutter/material.dart';

class SetupViewModel extends ChangeNotifier {
  final WifiService _wifiService;
  final FirmwareService _firmwareService;

  SetupViewModel({
    WifiService? wifiService,
    FirmwareService? firmwareService,
  })  : _wifiService = wifiService ?? WifiService(),
        _firmwareService = firmwareService ?? FirmwareService();

  // ===========================================================================
  // CLASS FIRMWARE FILES
  // ===========================================================================

  final Map<int, String> classFirmwareFiles = {
    3: 'assets/firmware/Shapes_Modified_3.ino.bin',
    4: 'assets/firmware/class_4.bin',
    5: 'assets/firmware/class_5.bin',
    6: 'assets/firmware/class_6.bin',
    7: 'assets/firmware/class_7.bin',
    8: 'assets/firmware/class_8.bin',
    9: 'assets/firmware/class_9.bin',
    10: 'assets/firmware/class_10.bin',
  };

  // ===========================================================================
  // STATE
  // ===========================================================================

  int selectedClass = 3;

  bool isWifiEnabled = false;
  bool isCheckingConnection = false;
  bool isUploadingFirmware = false;

  double uploadProgress = 0;

  String wifiStatus = 'Checking Wi-Fi...';

  String status = 'Connect your phone to the ESP32 hotspot.';

  bool get isEsp32Connected => isWifiEnabled;

  String? get selectedFirmwarePath =>
      classFirmwareFiles[selectedClass];

  // ===========================================================================
  // INITIAL CHECK
  // ===========================================================================

  Future<void> initialize() async {
    await checkWifiStatus();
  }

  // ===========================================================================
  // WIFI STATUS
  // ===========================================================================

  Future<void> checkWifiStatus() async {
    try {
      final enabled = await _wifiService.isWifiEnabled();

      isWifiEnabled = enabled;

      if (enabled) {
        wifiStatus = 'Wi-Fi is enabled';

        status =
            'Wi-Fi is ON ✓\n\n'
            'Connect your phone to the ESP32 hotspot.\n\n'
            'ESP32 IP:\n'
            '192.168.4.1';
      } else {
        wifiStatus = 'Please enable Wi-Fi';

        status =
            'Wi-Fi is OFF.\n\n'
            'Please enable Wi-Fi and connect to '
            'the ESP32 hotspot.';
      }

      uploadProgress = 0;

      notifyListeners();
    } catch (e) {
      isWifiEnabled = false;
      wifiStatus = 'Unable to check Wi-Fi';
      status = 'Unable to check Wi-Fi.\n\n$e';

      notifyListeners();
    }
  }

  // ===========================================================================
  // OPEN WIFI SETTINGS
  // ===========================================================================

  Future<void> openWifiSettings() async {
    await _wifiService.openWifiSettings();
  }

  // ===========================================================================
  // CONNECT / CHECK ESP32
  // ===========================================================================

  Future<void> connectToEsp32() async {
    if (isCheckingConnection) return;

    isCheckingConnection = true;
    status = 'Checking Wi-Fi connection...';

    notifyListeners();

    try {
      final enabled = await _wifiService.isWifiEnabled();

      isWifiEnabled = enabled;

      if (enabled) {
        wifiStatus = 'Connected to ESP32 hotspot';

        status =
            'ESP32 Connected ✓\n\n'
            'Wi-Fi is ready.\n\n'
            'You can choose a class and send '
            'the BIN file.';
      } else {
        wifiStatus = 'ESP32 not connected';

        status =
            'Wi-Fi is OFF.\n\n'
            'Please enable Wi-Fi and connect to '
            'the ESP32 hotspot.';
      }
    } catch (e) {
      isWifiEnabled = false;
      wifiStatus = 'ESP32 not connected';
      status = 'Unable to check Wi-Fi.\n\n$e';
    } finally {
      isCheckingConnection = false;
      notifyListeners();
    }
  }

  // ===========================================================================
  // CLASS SELECTION
  // ===========================================================================

  void selectClass(int? classNumber) {
    if (classNumber == null ||
        isUploadingFirmware ||
        !isEsp32Connected) {
      return;
    }

    selectedClass = classNumber;
    uploadProgress = 0;

    status =
        'Class $classNumber selected.\n\n'
        'Press Send BIN to continue.';

    notifyListeners();
  }

  // ===========================================================================
  // LOAD FIRMWARE
  // ===========================================================================

  Future<Uint8List> loadSelectedFirmware() async {
    final assetPath = classFirmwareFiles[selectedClass];

    if (assetPath == null) {
      throw Exception(
        'No BIN file found for Class $selectedClass.',
      );
    }

    return await _firmwareService.loadFirmware(assetPath);
  }

  // ===========================================================================
  // UPLOAD FIRMWARE
  // ===========================================================================

  Future<bool> uploadSelectedClassFirmware() async {
    if (isUploadingFirmware) return false;

    if (!isEsp32Connected) {
      status =
          'Please connect your phone to the '
          'ESP32 hotspot first.';

      notifyListeners();
      return false;
    }

    final assetPath = classFirmwareFiles[selectedClass];

    if (assetPath == null) {
      status = 'No BIN file found for Class $selectedClass.';

      notifyListeners();
      return false;
    }

    try {
      isUploadingFirmware = true;
      uploadProgress = 0;

      status =
          'Loading Class $selectedClass BIN file...\n\n'
          '$assetPath';

      notifyListeners();

      final firmwareBytes = await loadSelectedFirmware();

      uploadProgress = 0.2;

      status =
          'Firmware loaded successfully ✓\n\n'
          'Class: $selectedClass\n'
          'File: $assetPath\n'
          'Size: ${firmwareBytes.length} bytes\n\n'
          'Sending BIN to ESP32...';

      notifyListeners();

      final result = await _firmwareService.uploadFirmware(
        firmwareBytes: firmwareBytes,
        classNumber: selectedClass,
      );

      uploadProgress = 0.85;

      status = 'Waiting for ESP32 response...';

      notifyListeners();

      if (result.isSuccess) {
        uploadProgress = 1;

        status =
            'Class $selectedClass BIN sent successfully ✓\n\n'
            'HTTP: ${result.statusCode}\n\n'
            'ESP32 response:\n'
            '${result.responseBody}';

        notifyListeners();

        return true;
      } else {
        uploadProgress = 0;

        status =
            'BIN upload failed ✗\n\n'
            'HTTP Status: ${result.statusCode}\n\n'
            '${result.responseBody}';

        notifyListeners();

        return false;
      }
    } on FlutterError catch (e) {
      uploadProgress = 0;

      status =
          'Asset loading failed.\n\n'
          'Check this path in pubspec.yaml:\n'
          '$assetPath\n\n'
          '$e';

      notifyListeners();

      return false;
    } catch (e) {
      uploadProgress = 0;
      status = 'BIN upload error:\n\n$e';

      notifyListeners();

      return false;
    } finally {
      isUploadingFirmware = false;
      notifyListeners();
    }
  }
}