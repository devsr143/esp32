// // // // // // // // // // import 'dart:io';
// // // // // // // // // // import 'dart:typed_data';
// // // // // // // // // // import 'package:flutter/material.dart';
// // // // // // // // // // import 'package:flutter/services.dart';
// // // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // // import 'package:wifi_iot/wifi_iot.dart';
// // // // // // // // // // import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// // // // // // // // // // import 'package:ffmpeg_kit_flutter_new/return_code.dart';

// // // // // // // // // // void main() {
// // // // // // // // // //   WidgetsFlutterBinding.ensureInitialized();
// // // // // // // // // //   runApp(const KNOWLIBOTApp());
// // // // // // // // // // }

// // // // // // // // // // class KNOWLIBOTApp extends StatelessWidget {
// // // // // // // // // //   const KNOWLIBOTApp({super.key});

// // // // // // // // // //   @override
// // // // // // // // // //   Widget build(BuildContext context) {
// // // // // // // // // //     return MaterialApp(
// // // // // // // // // //       debugShowCheckedModeBanner: false,
// // // // // // // // // //       title: 'KNOWLIBOT',
// // // // // // // // // //       theme: ThemeData(
// // // // // // // // // //         useMaterial3: true,
// // // // // // // // // //         colorSchemeSeed: Colors.blue,
// // // // // // // // // //       ),
// // // // // // // // // //       home: const HomePage(),
// // // // // // // // // //     );
// // // // // // // // // //   }
// // // // // // // // // // }

// // // // // // // // // // // ============================================================
// // // // // // // // // // // HOME PAGE
// // // // // // // // // // // ============================================================

// // // // // // // // // // class HomePage extends StatefulWidget {
// // // // // // // // // //   const HomePage({super.key});

// // // // // // // // // //   @override
// // // // // // // // // //   State<HomePage> createState() => _HomePageState();
// // // // // // // // // // }

// // // // // // // // // // class _HomePageState extends State<HomePage>
// // // // // // // // // //     with WidgetsBindingObserver {

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // ESP32
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   static const String baseUrl =
// // // // // // // // // //       'http://192.168.4.1';

// // // // // // // // // //   static const String wavUrl =
// // // // // // // // // //       '$baseUrl/stream';

// // // // // // // // // //   static const String videoUrl =
// // // // // // // // // //       '$baseUrl/videostream';

// // // // // // // // // //   static const String otaUrl =
// // // // // // // // // //       '$baseUrl/update';

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // ASSETS
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   static const String wavAsset =
// // // // // // // // // //       'assets/audio/Ring09.wav';

// // // // // // // // // //   static const String videoAsset =
// // // // // // // // // //       'assets/videos/thum.mp4';

// // // // // // // // // //   // IMPORTANT:
// // // // // // // // // //   // Exact location of your firmware file.
// // // // // // // // // //   static const String ledFirmwareAsset =
// // // // // // // // // //       'assets/firmware/TEST.ino.bin';

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // VIDEO SETTINGS
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   static const int videoWidth = 480;
// // // // // // // // // //   static const int videoHeight = 320;

// // // // // // // // // //   static const int videoFps = 15;

// // // // // // // // // //   static const int jpegQuality = 15;

// // // // // // // // // //   static const int maxJpegFrameSize =
// // // // // // // // // //       80 * 1024;

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // AUDIO
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   static const int audioSampleRate = 16000;
// // // // // // // // // //   static const int audioChannels = 1;
// // // // // // // // // //   static const int audioBits = 16;

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // STATE
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   bool isWifiEnabled = false;

// // // // // // // // // //   // No separate ESP32 test button.
// // // // // // // // // //   //
// // // // // // // // // //   // When Wi-Fi is enabled and the phone is connected to
// // // // // // // // // //   // the ESP32 hotspot, the send buttons are enabled.
// // // // // // // // // //   bool get isConnected => isWifiEnabled;

// // // // // // // // // //   bool isBusy = false;

// // // // // // // // // //   double progress = 0.0;

// // // // // // // // // //   String status = 'Checking Wi-Fi...';

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // INIT
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   @override
// // // // // // // // // //   void initState() {
// // // // // // // // // //     super.initState();

// // // // // // // // // //     WidgetsBinding.instance.addObserver(this);

// // // // // // // // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // // // // // // // //       checkWifi();
// // // // // // // // // //     });
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // APP LIFECYCLE
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   @override
// // // // // // // // // //   void didChangeAppLifecycleState(
// // // // // // // // // //     AppLifecycleState state,
// // // // // // // // // //   ) {
// // // // // // // // // //     super.didChangeAppLifecycleState(state);

// // // // // // // // // //     if (state == AppLifecycleState.resumed) {
// // // // // // // // // //       checkWifi();
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   @override
// // // // // // // // // //   void dispose() {
// // // // // // // // // //     WidgetsBinding.instance.removeObserver(this);
// // // // // // // // // //     super.dispose();
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // STATUS
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   void updateStatus(String value) {
// // // // // // // // // //     if (!mounted) return;

// // // // // // // // // //     setState(() {
// // // // // // // // // //       status = value;
// // // // // // // // // //     });
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // PROGRESS
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   void updateProgress(double value) {
// // // // // // // // // //     if (!mounted) return;

// // // // // // // // // //     setState(() {
// // // // // // // // // //       progress = value.clamp(0.0, 1.0);
// // // // // // // // // //     });
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // MESSAGE
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   void showMessage(String message) {
// // // // // // // // // //     if (!mounted) return;

// // // // // // // // // //     ScaffoldMessenger.of(context)
// // // // // // // // // //         .hideCurrentSnackBar();

// // // // // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // // // //       SnackBar(
// // // // // // // // // //         content: Text(message),
// // // // // // // // // //         duration: const Duration(seconds: 3),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // CHECK WIFI
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<void> checkWifi() async {
// // // // // // // // // //     try {
// // // // // // // // // //       final enabled =
// // // // // // // // // //           await WiFiForIoTPlugin.isEnabled();

// // // // // // // // // //       if (!mounted) return;

// // // // // // // // // //       setState(() {
// // // // // // // // // //         isWifiEnabled = enabled;

// // // // // // // // // //         if (enabled) {
// // // // // // // // // //           status =
// // // // // // // // // //               'Wi-Fi is ON ✓\n\n'
// // // // // // // // // //               'Connect your phone to the ESP32 hotspot.\n\n'
// // // // // // // // // //               'ESP32 IP:\n'
// // // // // // // // // //               '192.168.4.1';

// // // // // // // // // //           progress = 0.0;
// // // // // // // // // //         } else {
// // // // // // // // // //           status =
// // // // // // // // // //               'Wi-Fi is OFF\n\n'
// // // // // // // // // //               'Please enable Wi-Fi.';

// // // // // // // // // //           progress = 0.0;
// // // // // // // // // //         }
// // // // // // // // // //       });

// // // // // // // // // //       if (!enabled) {
// // // // // // // // // //         showWifiEnableMessage();
// // // // // // // // // //       }
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'Unable to check Wi-Fi.\n\n$e',
// // // // // // // // // //       );
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // WIFI ENABLE MESSAGE
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   void showWifiEnableMessage() {
// // // // // // // // // //     if (!mounted) return;

// // // // // // // // // //     ScaffoldMessenger.of(context)
// // // // // // // // // //         .hideCurrentSnackBar();

// // // // // // // // // //     ScaffoldMessenger.of(context).showSnackBar(
// // // // // // // // // //       SnackBar(
// // // // // // // // // //         content: const Text(
// // // // // // // // // //           'Wi-Fi is OFF. Please enable Wi-Fi.',
// // // // // // // // // //         ),
// // // // // // // // // //         duration: const Duration(seconds: 8),
// // // // // // // // // //         action: SnackBarAction(
// // // // // // // // // //           label: 'ENABLE',
// // // // // // // // // //           onPressed: () {
// // // // // // // // // //             showWifiConfirmation();
// // // // // // // // // //           },
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // WIFI CONFIRMATION
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<void> showWifiConfirmation() async {
// // // // // // // // // //     if (!mounted) return;

// // // // // // // // // //     final result = await showDialog<bool>(
// // // // // // // // // //       context: context,
// // // // // // // // // //       builder: (context) {
// // // // // // // // // //         return AlertDialog(
// // // // // // // // // //           title: const Text(
// // // // // // // // // //             'Enable Wi-Fi',
// // // // // // // // // //           ),
// // // // // // // // // //           content: const Text(
// // // // // // // // // //             'Wi-Fi is currently disabled.\n\n'
// // // // // // // // // //             'Android Wi-Fi settings will open '
// // // // // // // // // //             'so you can enable Wi-Fi manually.',
// // // // // // // // // //           ),
// // // // // // // // // //           actions: [
// // // // // // // // // //             TextButton(
// // // // // // // // // //               onPressed: () {
// // // // // // // // // //                 Navigator.pop(
// // // // // // // // // //                   context,
// // // // // // // // // //                   false,
// // // // // // // // // //                 );
// // // // // // // // // //               },
// // // // // // // // // //               child: const Text(
// // // // // // // // // //                 'CANCEL',
// // // // // // // // // //               ),
// // // // // // // // // //             ),
// // // // // // // // // //             ElevatedButton(
// // // // // // // // // //               onPressed: () {
// // // // // // // // // //                 Navigator.pop(
// // // // // // // // // //                   context,
// // // // // // // // // //                   true,
// // // // // // // // // //                 );
// // // // // // // // // //               },
// // // // // // // // // //               child: const Text(
// // // // // // // // // //                 'OPEN SETTINGS',
// // // // // // // // // //               ),
// // // // // // // // // //             ),
// // // // // // // // // //           ],
// // // // // // // // // //         );
// // // // // // // // // //       },
// // // // // // // // // //     );

// // // // // // // // // //     if (result == true) {
// // // // // // // // // //       try {
// // // // // // // // // //         await WiFiForIoTPlugin.setEnabled(
// // // // // // // // // //           true,
// // // // // // // // // //           shouldOpenSettings: true,
// // // // // // // // // //         );
// // // // // // // // // //       } catch (e) {
// // // // // // // // // //         showMessage(
// // // // // // // // // //           'Could not open Wi-Fi settings.',
// // // // // // // // // //         );
// // // // // // // // // //       }
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // LOAD LED FIRMWARE
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<Uint8List> loadFirmware() async {
// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'Loading LED firmware...\n\n'
// // // // // // // // // //       'File:\n'
// // // // // // // // // //       '$ledFirmwareAsset',
// // // // // // // // // //     );

// // // // // // // // // //     try {
// // // // // // // // // //       final data = await rootBundle.load(
// // // // // // // // // //         ledFirmwareAsset,
// // // // // // // // // //       );

// // // // // // // // // //       final firmwareBytes =
// // // // // // // // // //           data.buffer.asUint8List(
// // // // // // // // // //         data.offsetInBytes,
// // // // // // // // // //         data.lengthInBytes,
// // // // // // // // // //       );

// // // // // // // // // //       if (firmwareBytes.isEmpty) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'Firmware file is empty.',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       return firmwareBytes;
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       throw Exception(
// // // // // // // // // //         'Could not load firmware asset.\n\n'
// // // // // // // // // //         'Expected file:\n'
// // // // // // // // // //         '$ledFirmwareAsset\n\n'
// // // // // // // // // //         'Make sure the file exists and is '
// // // // // // // // // //         'declared in pubspec.yaml.\n\n'
// // // // // // // // // //         'Error:\n'
// // // // // // // // // //         '$e',
// // // // // // // // // //       );
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   // send led firmware

// // // // // // // // // //   Future<void> sendLedFirmware() async {
// // // // // // // // // //   if (!isWifiEnabled) {
// // // // // // // // // //     showWifiEnableMessage();
// // // // // // // // // //     return;
// // // // // // // // // //   }

// // // // // // // // // //   if (isBusy) return;

// // // // // // // // // //   setState(() {
// // // // // // // // // //     isBusy = true;
// // // // // // // // // //     progress = 0.0;
// // // // // // // // // //     status = 'Loading LED firmware...';
// // // // // // // // // //   });

// // // // // // // // // //   try {
// // // // // // // // // //     const firmwarePath =
// // // // // // // // // //         'assets/firmware/TEST.ino.bin';

// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'Loading firmware...\n\n'
// // // // // // // // // //       'File:\n'
// // // // // // // // // //       '$firmwarePath',
// // // // // // // // // //     );

// // // // // // // // // //     final ByteData data =
// // // // // // // // // //         await rootBundle.load(firmwarePath);

// // // // // // // // // //     final Uint8List firmwareBytes =
// // // // // // // // // //         data.buffer.asUint8List(
// // // // // // // // // //       data.offsetInBytes,
// // // // // // // // // //       data.lengthInBytes,
// // // // // // // // // //     );

// // // // // // // // // //     if (firmwareBytes.isEmpty) {
// // // // // // // // // //       throw Exception(
// // // // // // // // // //         'Firmware file is empty:\n'
// // // // // // // // // //         '$firmwarePath',
// // // // // // // // // //       );
// // // // // // // // // //     }

// // // // // // // // // //     print(
// // // // // // // // // //       'Firmware loaded successfully.',
// // // // // // // // // //     );

// // // // // // // // // //     print(
// // // // // // // // // //       'Firmware size: '
// // // // // // // // // //       '${firmwareBytes.length} bytes',
// // // // // // // // // //     );

// // // // // // // // // //     updateProgress(0.10);

// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'FIRMWARE LOADED ✓\n\n'
// // // // // // // // // //       'File:\n'
// // // // // // // // // //       '$firmwarePath\n\n'
// // // // // // // // // //       'Size: '
// // // // // // // // // //       '${(firmwareBytes.length / 1024).toStringAsFixed(2)} KB\n\n'
// // // // // // // // // //       'Preparing upload...',
// // // // // // // // // //     );

// // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // //     // CREATE OTA REQUEST
// // // // // // // // // //     // ----------------------------------------------------------

// // // // // // // // // //     final request = http.MultipartRequest(
// // // // // // // // // //       'POST',
// // // // // // // // // //       Uri.parse(otaUrl),
// // // // // // // // // //     );

// // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // //     // ADD FIRMWARE
// // // // // // // // // //     // ----------------------------------------------------------

// // // // // // // // // //     request.files.add(
// // // // // // // // // //       http.MultipartFile.fromBytes(
// // // // // // // // // //         'file',
// // // // // // // // // //         firmwareBytes,
// // // // // // // // // //         filename: 'TEST.ino.bin',
// // // // // // // // // //       ),
// // // // // // // // // //     );

// // // // // // // // // //     updateProgress(0.20);

// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'LED FIRMWARE READY ✓\n\n'
// // // // // // // // // //       'File:\n'
// // // // // // // // // //       'TEST.ino.bin\n\n'
// // // // // // // // // //       'Size: '
// // // // // // // // // //       '${(firmwareBytes.length / 1024).toStringAsFixed(2)} KB\n\n'
// // // // // // // // // //       'Uploading to ESP32...',
// // // // // // // // // //     );

// // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // //     // SEND OTA
// // // // // // // // // //     // ----------------------------------------------------------

// // // // // // // // // //     final response =
// // // // // // // // // //         await request.send().timeout(
// // // // // // // // // //       const Duration(minutes: 5),
// // // // // // // // // //     );

// // // // // // // // // //     updateProgress(0.90);

// // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // //     // READ ESP32 RESPONSE
// // // // // // // // // //     // ----------------------------------------------------------

// // // // // // // // // //     final responseBody =
// // // // // // // // // //         await response.stream.bytesToString();

// // // // // // // // // //     print(
// // // // // // // // // //       'OTA HTTP status: '
// // // // // // // // // //       '${response.statusCode}',
// // // // // // // // // //     );

// // // // // // // // // //     print(
// // // // // // // // // //       'OTA response: '
// // // // // // // // // //       '$responseBody',
// // // // // // // // // //     );

// // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // //     // CHECK RESULT
// // // // // // // // // //     // ----------------------------------------------------------

// // // // // // // // // //     if (response.statusCode >= 200 &&
// // // // // // // // // //         response.statusCode < 300) {
// // // // // // // // // //       updateProgress(1.0);

// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'LED FIRMWARE UPLOADED ✓\n\n'
// // // // // // // // // //         'File:\n'
// // // // // // // // // //         'TEST.ino.bin\n\n'
// // // // // // // // // //         'Size: '
// // // // // // // // // //         '${(firmwareBytes.length / 1024).toStringAsFixed(2)} KB\n\n'
// // // // // // // // // //         'HTTP: ${response.statusCode}\n\n'
// // // // // // // // // //         'ESP32 response:\n'
// // // // // // // // // //         '$responseBody\n\n'
// // // // // // // // // //         'ESP32 is restarting...',
// // // // // // // // // //       );

// // // // // // // // // //       showMessage(
// // // // // // // // // //         'LED firmware uploaded successfully.',
// // // // // // // // // //       );
// // // // // // // // // //     } else {
// // // // // // // // // //       throw Exception(
// // // // // // // // // //         'ESP32 returned HTTP '
// // // // // // // // // //         '${response.statusCode}\n\n'
// // // // // // // // // //         '$responseBody',
// // // // // // // // // //       );
// // // // // // // // // //     }
// // // // // // // // // //   } catch (e) {
// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'LED FIRMWARE LOAD/UPLOAD FAILED ✗\n\n'
// // // // // // // // // //       '$e\n\n'
// // // // // // // // // //       'Check that this file exists:\n'
// // // // // // // // // //       'assets/firmware/TEST.ino.bin\n\n'
// // // // // // // // // //       'Also check pubspec.yaml asset configuration.',
// // // // // // // // // //     );

// // // // // // // // // //     showMessage(
// // // // // // // // // //       'Could not load or upload firmware.',
// // // // // // // // // //     );
// // // // // // // // // //   } finally {
// // // // // // // // // //     if (!mounted) return;

// // // // // // // // // //     setState(() {
// // // // // // // // // //       isBusy = false;
// // // // // // // // // //     });
// // // // // // // // // //   }
// // // // // // // // // // }

// // // // // // // // // // // Future<void> sendLedFirmware() async {
// // // // // // // // // // //   if (!isWifiEnabled) {
// // // // // // // // // // //     showWifiEnableMessage();
// // // // // // // // // // //     return;
// // // // // // // // // // //   }

// // // // // // // // // // //   if (isBusy) return;

// // // // // // // // // // //   setState(() {
// // // // // // // // // // //     isBusy = true;
// // // // // // // // // // //     progress = 0.0;
// // // // // // // // // // //     status = 'Loading LED firmware...';
// // // // // // // // // // //   });

// // // // // // // // // // //   try {
// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     // LOAD FIRMWARE
// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     const firmwarePath = 'assets/firmware/TEST.ino.bin';
// // // // // // // // // // //     final ByteData firmwareData = await rootBundle.load(firmwarePath);
// // // // // // // // // // //     final Uint8List firmwareBytes = firmwareData.buffer.asUint8List(
// // // // // // // // // // //       firmwareData.offsetInBytes,
// // // // // // // // // // //       firmwareData.lengthInBytes,
// // // // // // // // // // //     );

// // // // // // // // // // //     if (firmwareBytes.isEmpty) {
// // // // // // // // // // //       throw Exception('Firmware file is empty:\n$firmwarePath');
// // // // // // // // // // //     }

// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     // LOAD AUDIO
// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     const audioPath = 'assets/audio/Ring09.wav';
// // // // // // // // // // //     final ByteData audioData = await rootBundle.load(audioPath);
// // // // // // // // // // //     final Uint8List audioBytes = audioData.buffer.asUint8List(
// // // // // // // // // // //       audioData.offsetInBytes,
// // // // // // // // // // //       audioData.lengthInBytes,
// // // // // // // // // // //     );

// // // // // // // // // // //     if (audioBytes.isEmpty) {
// // // // // // // // // // //       throw Exception('Audio file is empty:\n$audioPath');
// // // // // // // // // // //     }

// // // // // // // // // // //     updateProgress(0.10);
// // // // // // // // // // //     updateStatus(
// // // // // // // // // // //       'FIRMWARE + AUDIO LOADED ✓\n\n'
// // // // // // // // // // //       'Firmware: ${(firmwareBytes.length / 1024).toStringAsFixed(2)} KB\n'
// // // // // // // // // // //       'Audio: ${(audioBytes.length / 1024).toStringAsFixed(2)} KB\n\n'
// // // // // // // // // // //       'Preparing upload...',
// // // // // // // // // // //     );

// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     // CREATE OTA REQUEST
// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     final request = http.MultipartRequest('POST', Uri.parse(otaUrl));

// // // // // // // // // // //     // Add firmware file
// // // // // // // // // // //     request.files.add(
// // // // // // // // // // //       http.MultipartFile.fromBytes(
// // // // // // // // // // //         'firmware',
// // // // // // // // // // //         firmwareBytes,
// // // // // // // // // // //         filename: 'TEST.ino.bin',
// // // // // // // // // // //       ),
// // // // // // // // // // //     );

// // // // // // // // // // //     // Add audio file
// // // // // // // // // // //     request.files.add(
// // // // // // // // // // //       http.MultipartFile.fromBytes(
// // // // // // // // // // //         'audio',
// // // // // // // // // // //         audioBytes,
// // // // // // // // // // //         filename: 'Ring09.wav',
// // // // // // // // // // //         contentType: http.MediaType('audio', 'wav'),
// // // // // // // // // // //       ),
// // // // // // // // // // //     );

// // // // // // // // // // //     updateProgress(0.20);
// // // // // // // // // // //     updateStatus('Uploading firmware + audio to ESP32...');

// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     // SEND OTA
// // // // // // // // // // //     // ----------------------------------------------------------
// // // // // // // // // // //     final response = await request.send().timeout(const Duration(minutes: 5));
// // // // // // // // // // //     final responseBody = await response.stream.bytesToString();

// // // // // // // // // // //     updateProgress(0.90);

// // // // // // // // // // //     if (response.statusCode >= 200 && response.statusCode < 300) {
// // // // // // // // // // //       updateProgress(1.0);
// // // // // // // // // // //       updateStatus(
// // // // // // // // // // //         'UPLOAD COMPLETE ✓\n\n'
// // // // // // // // // // //         'Firmware + Audio sent successfully.\n\n'
// // // // // // // // // // //         'HTTP: ${response.statusCode}\n\n'
// // // // // // // // // // //         'ESP32 response:\n$responseBody',
// // // // // // // // // // //       );
// // // // // // // // // // //       showMessage('Firmware + Audio uploaded successfully.');
// // // // // // // // // // //     } else {
// // // // // // // // // // //       throw Exception('ESP32 returned HTTP ${response.statusCode}\n\n$responseBody');
// // // // // // // // // // //     }
// // // // // // // // // // //   } catch (e) {
// // // // // // // // // // //     updateStatus('UPLOAD FAILED ✗\n\n$e');
// // // // // // // // // // //     showMessage('Could not upload firmware + audio.');
// // // // // // // // // // //   } finally {
// // // // // // // // // // //     if (!mounted) return;
// // // // // // // // // // //     setState(() {
// // // // // // // // // // //       isBusy = false;
// // // // // // // // // // //     });
// // // // // // // // // // //   }
// // // // // // // // // // // }

// // // // // // // // // // //   // ============================================================
// // // // // // // // // // //   // SEND WAV
// // // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<void> sendWav() async {
// // // // // // // // // //     if (!isWifiEnabled) {
// // // // // // // // // //       showWifiEnableMessage();
// // // // // // // // // //       return;
// // // // // // // // // //     }

// // // // // // // // // //     if (isBusy) return;

// // // // // // // // // //     setState(() {
// // // // // // // // // //       isBusy = true;
// // // // // // // // // //       progress = 0.0;
// // // // // // // // // //       status = 'Loading WAV file...';
// // // // // // // // // //     });

// // // // // // // // // //     try {
// // // // // // // // // //       final data =
// // // // // // // // // //           await rootBundle.load(wavAsset);

// // // // // // // // // //       final wavBytes =
// // // // // // // // // //           data.buffer.asUint8List(
// // // // // // // // // //         data.offsetInBytes,
// // // // // // // // // //         data.lengthInBytes,
// // // // // // // // // //       );

// // // // // // // // // //       if (wavBytes.isEmpty) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'WAV file is empty.',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       updateProgress(0.2);

// // // // // // // // // //       final request = http.Request(
// // // // // // // // // //         'POST',
// // // // // // // // // //         Uri.parse(wavUrl),
// // // // // // // // // //       );

// // // // // // // // // //       request.headers['Content-Type'] =
// // // // // // // // // //           'audio/wav';

// // // // // // // // // //       request.headers['X-Audio-Format'] =
// // // // // // // // // //           'wav';

// // // // // // // // // //       request.headers[
// // // // // // // // // //               'X-Audio-Sample-Rate'] =
// // // // // // // // // //           audioSampleRate.toString();

// // // // // // // // // //       request.headers['X-Audio-Channels'] =
// // // // // // // // // //           audioChannels.toString();

// // // // // // // // // //       request.headers['X-Audio-Bits'] =
// // // // // // // // // //           audioBits.toString();

// // // // // // // // // //       request.contentLength =
// // // // // // // // // //           wavBytes.length;

// // // // // // // // // //       request.bodyBytes = wavBytes;

// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'Sending WAV...\n\n'
// // // // // // // // // //         'Size: ${wavBytes.length} bytes',
// // // // // // // // // //       );

// // // // // // // // // //       final response = await request
// // // // // // // // // //           .send()
// // // // // // // // // //           .timeout(
// // // // // // // // // //             const Duration(seconds: 60),
// // // // // // // // // //           );

// // // // // // // // // //       final responseBody =
// // // // // // // // // //           await response.stream.bytesToString();

// // // // // // // // // //       if (response.statusCode >= 200 &&
// // // // // // // // // //           response.statusCode < 300) {
// // // // // // // // // //         updateProgress(1.0);

// // // // // // // // // //         updateStatus(
// // // // // // // // // //           'WAV SENT ✓\n\n'
// // // // // // // // // //           'HTTP ${response.statusCode}\n\n'
// // // // // // // // // //           '$responseBody',
// // // // // // // // // //         );

// // // // // // // // // //         showMessage(
// // // // // // // // // //           'WAV sent successfully.',
// // // // // // // // // //         );
// // // // // // // // // //       } else {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'HTTP ${response.statusCode}\n'
// // // // // // // // // //           '$responseBody',
// // // // // // // // // //         );
// // // // // // // // // //       }
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'WAV SEND FAILED ✗\n\n$e',
// // // // // // // // // //       );
// // // // // // // // // //     } finally {
// // // // // // // // // //       if (!mounted) return;

// // // // // // // // // //       setState(() {
// // // // // // // // // //         isBusy = false;
// // // // // // // // // //       });
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // PREPARE VIDEO
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<String> prepareVideo(
// // // // // // // // // //     Directory directory,
// // // // // // // // // //   ) async {
// // // // // // // // // //     final videoFile = File(
// // // // // // // // // //       '${directory.path}/input.mp4',
// // // // // // // // // //     );

// // // // // // // // // //     final data =
// // // // // // // // // //         await rootBundle.load(videoAsset);

// // // // // // // // // //     final bytes =
// // // // // // // // // //         data.buffer.asUint8List(
// // // // // // // // // //       data.offsetInBytes,
// // // // // // // // // //       data.lengthInBytes,
// // // // // // // // // //     );

// // // // // // // // // //     await videoFile.writeAsBytes(
// // // // // // // // // //       bytes,
// // // // // // // // // //       flush: true,
// // // // // // // // // //     );

// // // // // // // // // //     return videoFile.path;
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // GET VIDEO DURATION
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<double> getVideoDuration(
// // // // // // // // // //     String videoPath,
// // // // // // // // // //   ) async {
// // // // // // // // // //     double duration = 10.0;

// // // // // // // // // //     try {
// // // // // // // // // //       final session =
// // // // // // // // // //           await FFmpegKit.execute(
// // // // // // // // // //         '-i "$videoPath" -f null -',
// // // // // // // // // //       );

// // // // // // // // // //       final output =
// // // // // // // // // //           await session.getOutput();

// // // // // // // // // //       if (output != null) {
// // // // // // // // // //         final regex = RegExp(
// // // // // // // // // //           r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)',
// // // // // // // // // //         );

// // // // // // // // // //         final match =
// // // // // // // // // //             regex.firstMatch(output);

// // // // // // // // // //         if (match != null) {
// // // // // // // // // //           final hours =
// // // // // // // // // //               int.parse(match.group(1)!);

// // // // // // // // // //           final minutes =
// // // // // // // // // //               int.parse(match.group(2)!);

// // // // // // // // // //           final seconds =
// // // // // // // // // //               double.parse(
// // // // // // // // // //             match.group(3)!,
// // // // // // // // // //           );

// // // // // // // // // //           duration =
// // // // // // // // // //               hours * 3600 +
// // // // // // // // // //               minutes * 60 +
// // // // // // // // // //               seconds;
// // // // // // // // // //         }
// // // // // // // // // //       }
// // // // // // // // // //     } catch (_) {}

// // // // // // // // // //     return duration;
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // EXTRACT VIDEO → JPEG
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<Directory> extractVideoFrames(
// // // // // // // // // //     String videoPath,
// // // // // // // // // //     String outputDirectory,
// // // // // // // // // //   ) async {
// // // // // // // // // //     final framesDirectory =
// // // // // // // // // //         Directory(
// // // // // // // // // //       '$outputDirectory/frames',
// // // // // // // // // //     );

// // // // // // // // // //     if (await framesDirectory.exists()) {
// // // // // // // // // //       await framesDirectory.delete(
// // // // // // // // // //         recursive: true,
// // // // // // // // // //       );
// // // // // // // // // //     }

// // // // // // // // // //     await framesDirectory.create(
// // // // // // // // // //       recursive: true,
// // // // // // // // // //     );

// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'Converting video to JPEG...\n\n'
// // // // // // // // // //       '$videoWidth × $videoHeight\n'
// // // // // // // // // //       '$videoFps FPS\n\n'
// // // // // // // // // //       'No rotation applied.',
// // // // // // // // // //     );

// // // // // // // // // //     final outputPattern =
// // // // // // // // // //         '${framesDirectory.path}/frame_%06d.jpg';

// // // // // // // // // //     final command =
// // // // // // // // // //         '-y '
// // // // // // // // // //         '-i "$videoPath" '
// // // // // // // // // //         '-vf "scale=$videoWidth:$videoHeight:'
// // // // // // // // // //         'force_original_aspect_ratio=disable,'
// // // // // // // // // //         'fps=$videoFps,'
// // // // // // // // // //         'format=yuvj420p" '
// // // // // // // // // //         '-q:v $jpegQuality '
// // // // // // // // // //         '"$outputPattern"';

// // // // // // // // // //     final session =
// // // // // // // // // //         await FFmpegKit.execute(
// // // // // // // // // //       command,
// // // // // // // // // //     );

// // // // // // // // // //     final returnCode =
// // // // // // // // // //         await session.getReturnCode();

// // // // // // // // // //     if (!ReturnCode.isSuccess(
// // // // // // // // // //       returnCode,
// // // // // // // // // //     )) {
// // // // // // // // // //       final output =
// // // // // // // // // //           await session.getOutput();

// // // // // // // // // //       throw Exception(
// // // // // // // // // //         'Video conversion failed.\n\n'
// // // // // // // // // //         '$output',
// // // // // // // // // //       );
// // // // // // // // // //     }

// // // // // // // // // //     return framesDirectory;
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // JPEG VALIDATION
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   bool isValidJpeg(
// // // // // // // // // //     Uint8List bytes,
// // // // // // // // // //   ) {
// // // // // // // // // //     if (bytes.length < 4) {
// // // // // // // // // //       return false;
// // // // // // // // // //     }

// // // // // // // // // //     final start =
// // // // // // // // // //         bytes[0] == 0xFF &&
// // // // // // // // // //         bytes[1] == 0xD8;

// // // // // // // // // //     final last =
// // // // // // // // // //         bytes.length - 1;

// // // // // // // // // //     final end =
// // // // // // // // // //         bytes[last - 1] == 0xFF &&
// // // // // // // // // //         bytes[last] == 0xD9;

// // // // // // // // // //     return start && end;
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // CREATE 4-BYTE LITTLE-ENDIAN LENGTH
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Uint8List createLengthHeader(
// // // // // // // // // //     int length,
// // // // // // // // // //   ) {
// // // // // // // // // //     final data = ByteData(4);

// // // // // // // // // //     data.setUint32(
// // // // // // // // // //       0,
// // // // // // // // // //       length,
// // // // // // // // // //       Endian.little,
// // // // // // // // // //     );

// // // // // // // // // //     return data.buffer.asUint8List();
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // CALCULATE TOTAL STREAM SIZE
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<int> calculateTotalStreamSize(
// // // // // // // // // //     List<File> frameFiles,
// // // // // // // // // //   ) async {
// // // // // // // // // //     int total = 0;

// // // // // // // // // //     for (final file in frameFiles) {
// // // // // // // // // //       final size =
// // // // // // // // // //           await file.length();

// // // // // // // // // //       if (size <= 0) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'Empty JPEG file:\n'
// // // // // // // // // //           '${file.path}',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       if (size > maxJpegFrameSize) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'JPEG too large:\n'
// // // // // // // // // //           '${file.path}\n\n'
// // // // // // // // // //           'Size: $size bytes\n'
// // // // // // // // // //           'Maximum: '
// // // // // // // // // //           '$maxJpegFrameSize bytes',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       total += 4;
// // // // // // // // // //       total += size;
// // // // // // // // // //     }

// // // // // // // // // //     return total;
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // SEND VIDEO STREAM
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<void> sendVideoStream(
// // // // // // // // // //     List<File> frameFiles,
// // // // // // // // // //   ) async {
// // // // // // // // // //     if (frameFiles.isEmpty) {
// // // // // // // // // //       throw Exception(
// // // // // // // // // //         'No JPEG frames found.',
// // // // // // // // // //       );
// // // // // // // // // //     }

// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'Calculating video size...',
// // // // // // // // // //     );

// // // // // // // // // //     final totalBytes =
// // // // // // // // // //         await calculateTotalStreamSize(
// // // // // // // // // //       frameFiles,
// // // // // // // // // //     );

// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'Video ready.\n\n'
// // // // // // // // // //       'Frames: ${frameFiles.length}\n'
// // // // // // // // // //       'Total: '
// // // // // // // // // //       '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
// // // // // // // // // //       'Starting upload...',
// // // // // // // // // //     );

// // // // // // // // // //     final request =
// // // // // // // // // //         http.StreamedRequest(
// // // // // // // // // //       'POST',
// // // // // // // // // //       Uri.parse(videoUrl),
// // // // // // // // // //     );

// // // // // // // // // //     request.headers[
// // // // // // // // // //             'Content-Type'] =
// // // // // // // // // //         'application/octet-stream';

// // // // // // // // // //     request.headers['Accept'] =
// // // // // // // // // //         '*/*';

// // // // // // // // // //     request.contentLength =
// // // // // // // // // //         totalBytes;

// // // // // // // // // //     final responseFuture =
// // // // // // // // // //         request.send().timeout(
// // // // // // // // // //       const Duration(minutes: 10),
// // // // // // // // // //     );

// // // // // // // // // //     int sentBytes = 0;

// // // // // // // // // //     for (int i = 0;
// // // // // // // // // //         i < frameFiles.length;
// // // // // // // // // //         i++) {
// // // // // // // // // //       final file =
// // // // // // // // // //           frameFiles[i];

// // // // // // // // // //       final frameBytes =
// // // // // // // // // //           await file.readAsBytes();

// // // // // // // // // //       if (!isValidJpeg(
// // // // // // // // // //         frameBytes,
// // // // // // // // // //       )) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'Invalid JPEG frame: '
// // // // // // // // // //           '${i + 1}',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       if (frameBytes.length >
// // // // // // // // // //           maxJpegFrameSize) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'Frame ${i + 1} is too large.\n'
// // // // // // // // // //           'Size: ${frameBytes.length}\n'
// // // // // // // // // //           'Maximum: '
// // // // // // // // // //           '$maxJpegFrameSize',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       final lengthHeader =
// // // // // // // // // //           createLengthHeader(
// // // // // // // // // //         frameBytes.length,
// // // // // // // // // //       );

// // // // // // // // // //       request.sink.add(
// // // // // // // // // //         lengthHeader,
// // // // // // // // // //       );

// // // // // // // // // //       sentBytes += 4;

// // // // // // // // // //       request.sink.add(
// // // // // // // // // //         frameBytes,
// // // // // // // // // //       );

// // // // // // // // // //       sentBytes +=
// // // // // // // // // //           frameBytes.length;

// // // // // // // // // //       final uploadRatio =
// // // // // // // // // //           sentBytes / totalBytes;

// // // // // // // // // //       final uiProgress =
// // // // // // // // // //           0.20 +
// // // // // // // // // //           uploadRatio * 0.75;

// // // // // // // // // //       updateProgress(
// // // // // // // // // //         uiProgress,
// // // // // // // // // //       );

// // // // // // // // // //       if (i % 10 == 0 ||
// // // // // // // // // //           i == frameFiles.length - 1) {
// // // // // // // // // //         final percent =
// // // // // // // // // //             (uploadRatio * 100).toInt();

// // // // // // // // // //         final mb =
// // // // // // // // // //             sentBytes /
// // // // // // // // // //             1024 /
// // // // // // // // // //             1024;

// // // // // // // // // //         updateStatus(
// // // // // // // // // //           'UPLOADING VIDEO...\n\n'
// // // // // // // // // //           'Frame: ${i + 1} / '
// // // // // // // // // //           '${frameFiles.length}\n'
// // // // // // // // // //           'Upload: $percent%\n'
// // // // // // // // // //           'Data: '
// // // // // // // // // //           '${mb.toStringAsFixed(2)} MB / '
// // // // // // // // // //           '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
// // // // // // // // // //           'ESP32 protocol:\n'
// // // // // // // // // //           '[4-byte length][JPEG]',
// // // // // // // // // //         );
// // // // // // // // // //       }
// // // // // // // // // //     }

// // // // // // // // // //     await request.sink.close();

// // // // // // // // // //     updateProgress(0.95);

// // // // // // // // // //     updateStatus(
// // // // // // // // // //       'UPLOAD COMPLETE ✓\n\n'
// // // // // // // // // //       'All video data sent from Flutter.\n\n'
// // // // // // // // // //       'Waiting for ESP32 response...',
// // // // // // // // // //     );

// // // // // // // // // //     final response =
// // // // // // // // // //         await responseFuture;

// // // // // // // // // //     final responseBody =
// // // // // // // // // //         await response.stream
// // // // // // // // // //             .bytesToString();

// // // // // // // // // //     if (response.statusCode >= 200 &&
// // // // // // // // // //         response.statusCode < 300) {
// // // // // // // // // //       updateProgress(1.0);

// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'VIDEO RECEIVED BY ESP32 ✓\n\n'
// // // // // // // // // //         'Frames: ${frameFiles.length}\n'
// // // // // // // // // //         'HTTP: ${response.statusCode}\n\n'
// // // // // // // // // //         'ESP32 response:\n'
// // // // // // // // // //         '$responseBody',
// // // // // // // // // //       );

// // // // // // // // // //       showMessage(
// // // // // // // // // //         'ESP32 received the video.',
// // // // // // // // // //       );
// // // // // // // // // //     } else {
// // // // // // // // // //       throw Exception(
// // // // // // // // // //         'ESP32 returned HTTP '
// // // // // // // // // //         '${response.statusCode}\n\n'
// // // // // // // // // //         '$responseBody',
// // // // // // // // // //       );
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // SEND VIDEO
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<void> sendVideo() async {
// // // // // // // // // //     if (!isWifiEnabled) {
// // // // // // // // // //       showWifiEnableMessage();
// // // // // // // // // //       return;
// // // // // // // // // //     }

// // // // // // // // // //     if (isBusy) return;

// // // // // // // // // //     setState(() {
// // // // // // // // // //       isBusy = true;
// // // // // // // // // //       progress = 0.0;
// // // // // // // // // //       status =
// // // // // // // // // //           'Preparing video...';
// // // // // // // // // //     });

// // // // // // // // // //     Directory? workDirectory;

// // // // // // // // // //     try {
// // // // // // // // // //       try {
// // // // // // // // // //         await rootBundle.load(
// // // // // // // // // //           videoAsset,
// // // // // // // // // //         );
// // // // // // // // // //       } catch (_) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'Video file not found.\n\n'
// // // // // // // // // //           'Add:\n'
// // // // // // // // // //           '$videoAsset\n\n'
// // // // // // // // // //           'to pubspec.yaml.',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       workDirectory =
// // // // // // // // // //           await Directory.systemTemp
// // // // // // // // // //               .createTemp(
// // // // // // // // // //         'knowlibot_video_',
// // // // // // // // // //       );

// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'Loading video...',
// // // // // // // // // //       );

// // // // // // // // // //       final videoPath =
// // // // // // // // // //           await prepareVideo(
// // // // // // // // // //         workDirectory,
// // // // // // // // // //       );

// // // // // // // // // //       updateProgress(0.05);

// // // // // // // // // //       final duration =
// // // // // // // // // //           await getVideoDuration(
// // // // // // // // // //         videoPath,
// // // // // // // // // //       );

// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'Original video duration:\n'
// // // // // // // // // //         '${duration.toStringAsFixed(2)} seconds',
// // // // // // // // // //       );

// // // // // // // // // //       final framesDirectory =
// // // // // // // // // //           await extractVideoFrames(
// // // // // // // // // //         videoPath,
// // // // // // // // // //         workDirectory.path,
// // // // // // // // // //       );

// // // // // // // // // //       updateProgress(0.20);

// // // // // // // // // //       final frameFiles =
// // // // // // // // // //           framesDirectory
// // // // // // // // // //               .listSync()
// // // // // // // // // //               .whereType<File>()
// // // // // // // // // //               .where(
// // // // // // // // // //                 (file) =>
// // // // // // // // // //                     file.path
// // // // // // // // // //                         .toLowerCase()
// // // // // // // // // //                         .endsWith('.jpg'),
// // // // // // // // // //               )
// // // // // // // // // //               .toList();

// // // // // // // // // //       frameFiles.sort(
// // // // // // // // // //         (a, b) =>
// // // // // // // // // //             a.path.compareTo(b.path),
// // // // // // // // // //       );

// // // // // // // // // //       if (frameFiles.isEmpty) {
// // // // // // // // // //         throw Exception(
// // // // // // // // // //           'No JPEG video frames were generated.',
// // // // // // // // // //         );
// // // // // // // // // //       }

// // // // // // // // // //       final expectedFrames =
// // // // // // // // // //           (duration * videoFps).round();

// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'VIDEO CONVERSION COMPLETE ✓\n\n'
// // // // // // // // // //         'Original duration: '
// // // // // // // // // //         '${duration.toStringAsFixed(2)} sec\n\n'
// // // // // // // // // //         'Generated frames: '
// // // // // // // // // //         '${frameFiles.length}\n'
// // // // // // // // // //         'Expected frames: '
// // // // // // // // // //         '$expectedFrames\n\n'
// // // // // // // // // //         'Resolution: '
// // // // // // // // // //         '$videoWidth × $videoHeight\n\n'
// // // // // // // // // //         'FPS: $videoFps\n\n'
// // // // // // // // // //         'Rotation: NONE\n\n'
// // // // // // // // // //         'Preparing upload...',
// // // // // // // // // //       );

// // // // // // // // // //       await sendVideoStream(
// // // // // // // // // //         frameFiles,
// // // // // // // // // //       );
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'VIDEO FAILED ✗\n\n$e',
// // // // // // // // // //       );

// // // // // // // // // //       showMessage(
// // // // // // // // // //         'Video sending failed.',
// // // // // // // // // //       );
// // // // // // // // // //     } finally {
// // // // // // // // // //       if (workDirectory != null) {
// // // // // // // // // //         try {
// // // // // // // // // //           if (await workDirectory.exists()) {
// // // // // // // // // //             await workDirectory.delete(
// // // // // // // // // //               recursive: true,
// // // // // // // // // //             );
// // // // // // // // // //           }
// // // // // // // // // //         } catch (_) {}
// // // // // // // // // //       }

// // // // // // // // // //       if (!mounted) return;

// // // // // // // // // //       setState(() {
// // // // // // // // // //         isBusy = false;
// // // // // // // // // //       });
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // ESP32 STATUS
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   Future<void> getEsp32Status() async {
// // // // // // // // // //     if (!isWifiEnabled) {
// // // // // // // // // //       showWifiEnableMessage();
// // // // // // // // // //       return;
// // // // // // // // // //     }

// // // // // // // // // //     if (isBusy) {
// // // // // // // // // //       return;
// // // // // // // // // //     }

// // // // // // // // // //     try {
// // // // // // // // // //       final response = await http
// // // // // // // // // //           .get(
// // // // // // // // // //             Uri.parse(
// // // // // // // // // //               '$baseUrl/status',
// // // // // // // // // //             ),
// // // // // // // // // //           )
// // // // // // // // // //           .timeout(
// // // // // // // // // //             const Duration(seconds: 5),
// // // // // // // // // //           );

// // // // // // // // // //       if (response.statusCode == 200) {
// // // // // // // // // //         updateStatus(
// // // // // // // // // //           'ESP32 STATUS\n\n'
// // // // // // // // // //           '${response.body}',
// // // // // // // // // //         );
// // // // // // // // // //       } else {
// // // // // // // // // //         updateStatus(
// // // // // // // // // //           'STATUS ERROR\n\n'
// // // // // // // // // //           'HTTP ${response.statusCode}\n\n'
// // // // // // // // // //           '${response.body}',
// // // // // // // // // //         );
// // // // // // // // // //       }
// // // // // // // // // //     } catch (e) {
// // // // // // // // // //       updateStatus(
// // // // // // // // // //         'STATUS ERROR\n\n$e',
// // // // // // // // // //       );
// // // // // // // // // //     }
// // // // // // // // // //   }

// // // // // // // // // //   // ============================================================
// // // // // // // // // //   // UI
// // // // // // // // // //   // ============================================================

// // // // // // // // // //   @override
// // // // // // // // // //   Widget build(
// // // // // // // // // //     BuildContext context,
// // // // // // // // // //   ) {
// // // // // // // // // //     return Scaffold(
// // // // // // // // // //       appBar: AppBar(
// // // // // // // // // //         title: const Text(
// // // // // // // // // //           'KNOWLIBOT',
// // // // // // // // // //           style: TextStyle(
// // // // // // // // // //             fontWeight: FontWeight.bold,
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //         centerTitle: true,
// // // // // // // // // //       ),

// // // // // // // // // //       body: SafeArea(
// // // // // // // // // //         child: SingleChildScrollView(
// // // // // // // // // //           padding:
// // // // // // // // // //               const EdgeInsets.all(20),

// // // // // // // // // //           child: Column(
// // // // // // // // // //             crossAxisAlignment:
// // // // // // // // // //                 CrossAxisAlignment.stretch,

// // // // // // // // // //             children: [

// // // // // // // // // //               // ==================================================
// // // // // // // // // //               // WIFI STATUS
// // // // // // // // // //               // ==================================================

// // // // // // // // // //               Card(
// // // // // // // // // //                 color: isWifiEnabled
// // // // // // // // // //                     ? Colors.green.shade50
// // // // // // // // // //                     : Colors.red.shade50,

// // // // // // // // // //                 child: Padding(
// // // // // // // // // //                   padding:
// // // // // // // // // //                       const EdgeInsets.all(16),

// // // // // // // // // //                   child: Row(
// // // // // // // // // //                     children: [

// // // // // // // // // //                       Icon(
// // // // // // // // // //                         isWifiEnabled
// // // // // // // // // //                             ? Icons.wifi
// // // // // // // // // //                             : Icons.wifi_off,
// // // // // // // // // //                         size: 35,
// // // // // // // // // //                         color: isWifiEnabled
// // // // // // // // // //                             ? Colors.green
// // // // // // // // // //                             : Colors.red,
// // // // // // // // // //                       ),

// // // // // // // // // //                       const SizedBox(
// // // // // // // // // //                         width: 12,
// // // // // // // // // //                       ),

// // // // // // // // // //                       Expanded(
// // // // // // // // // //                         child: Column(
// // // // // // // // // //                           crossAxisAlignment:
// // // // // // // // // //                               CrossAxisAlignment.start,

// // // // // // // // // //                           children: [

// // // // // // // // // //                             Text(
// // // // // // // // // //                               isWifiEnabled
// // // // // // // // // //                                   ? 'Wi-Fi Connected'
// // // // // // // // // //                                   : 'Wi-Fi is OFF',

// // // // // // // // // //                               style:
// // // // // // // // // //                                   const TextStyle(
// // // // // // // // // //                                 fontSize: 18,
// // // // // // // // // //                                 fontWeight:
// // // // // // // // // //                                     FontWeight.bold,
// // // // // // // // // //                               ),
// // // // // // // // // //                             ),

// // // // // // // // // //                             const SizedBox(
// // // // // // // // // //                               height: 4,
// // // // // // // // // //                             ),

// // // // // // // // // //                             Text(
// // // // // // // // // //                               isWifiEnabled
// // // // // // // // // //                                   ? 'Ready to communicate with ESP32.'
// // // // // // // // // //                                   : 'Wi-Fi must be enabled.',

// // // // // // // // // //                               style:
// // // // // // // // // //                                   TextStyle(
// // // // // // // // // //                                 color:
// // // // // // // // // //                                     Colors.grey[700],
// // // // // // // // // //                               ),
// // // // // // // // // //                             ),
// // // // // // // // // //                           ],
// // // // // // // // // //                         ),
// // // // // // // // // //                       ),

// // // // // // // // // //                       if (!isWifiEnabled)
// // // // // // // // // //                         ElevatedButton(
// // // // // // // // // //                           onPressed:
// // // // // // // // // //                               isBusy
// // // // // // // // // //                                   ? null
// // // // // // // // // //                                   : showWifiConfirmation,

// // // // // // // // // //                           child:
// // // // // // // // // //                               const Text(
// // // // // // // // // //                             'ENABLE',
// // // // // // // // // //                           ),
// // // // // // // // // //                         ),
// // // // // // // // // //                     ],
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),

// // // // // // // // // //               const SizedBox(
// // // // // // // // // //                 height: 16,
// // // // // // // // // //               ),

// // // // // // // // // //               // ==================================================
// // // // // // // // // //               // ESP32 STATUS
// // // // // // // // // //               // ==================================================

// // // // // // // // // //               Card(
// // // // // // // // // //                 color: isConnected
// // // // // // // // // //                     ? Colors.green.shade50
// // // // // // // // // //                     : Colors.grey.shade100,

// // // // // // // // // //                 child: Padding(
// // // // // // // // // //                   padding:
// // // // // // // // // //                       const EdgeInsets.all(16),

// // // // // // // // // //                   child: Column(
// // // // // // // // // //                     crossAxisAlignment:
// // // // // // // // // //                         CrossAxisAlignment.start,

// // // // // // // // // //                     children: [

// // // // // // // // // //                       Row(
// // // // // // // // // //                         children: [

// // // // // // // // // //                           Icon(
// // // // // // // // // //                             isConnected
// // // // // // // // // //                                 ? Icons.check_circle
// // // // // // // // // //                                 : Icons.cancel,

// // // // // // // // // //                             color: isConnected
// // // // // // // // // //                                 ? Colors.green
// // // // // // // // // //                                 : Colors.grey,
// // // // // // // // // //                           ),

// // // // // // // // // //                           const SizedBox(
// // // // // // // // // //                             width: 10,
// // // // // // // // // //                           ),

// // // // // // // // // //                           Text(
// // // // // // // // // //                             isConnected
// // // // // // // // // //                                 ? 'ESP32 Connected'
// // // // // // // // // //                                 : 'ESP32 Not Connected',

// // // // // // // // // //                             style:
// // // // // // // // // //                                 const TextStyle(
// // // // // // // // // //                               fontSize: 17,
// // // // // // // // // //                               fontWeight:
// // // // // // // // // //                                   FontWeight.bold,
// // // // // // // // // //                             ),
// // // // // // // // // //                           ),
// // // // // // // // // //                         ],
// // // // // // // // // //                       ),

// // // // // // // // // //                       const SizedBox(
// // // // // // // // // //                         height: 12,
// // // // // // // // // //                       ),

// // // // // // // // // //                       Text(
// // // // // // // // // //                         'ESP32 IP: 192.168.4.1',

// // // // // // // // // //                         style:
// // // // // // // // // //                             TextStyle(
// // // // // // // // // //                           color:
// // // // // // // // // //                               Colors.grey[700],
// // // // // // // // // //                         ),
// // // // // // // // // //                       ),

// // // // // // // // // //                       const SizedBox(
// // // // // // // // // //                         height: 6,
// // // // // // // // // //                       ),

// // // // // // // // // //                       Text(
// // // // // // // // // //                         isConnected
// // // // // // // // // //                             ? 'Wi-Fi is ready. You can send firmware, audio and video.'
// // // // // // // // // //                             : 'Enable Wi-Fi and connect to the ESP32 hotspot.',

// // // // // // // // // //                         style:
// // // // // // // // // //                             TextStyle(
// // // // // // // // // //                           color:
// // // // // // // // // //                               Colors.grey[700],
// // // // // // // // // //                         ),
// // // // // // // // // //                       ),
// // // // // // // // // //                     ],
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),

// // // // // // // // // //               const SizedBox(
// // // // // // // // // //                 height: 20,
// // // // // // // // // //               ),

// // // // // // // // // //               // ==================================================
// // // // // // // // // //               // SEND LED FIRMWARE
// // // // // // // // // //               // ==================================================

// // // // // // // // // //               SizedBox(
// // // // // // // // // //                 height: 58,

// // // // // // // // // //                 child:
// // // // // // // // // //                     ElevatedButton.icon(

// // // // // // // // // //                   onPressed:
// // // // // // // // // //                       (!isWifiEnabled ||
// // // // // // // // // //                               isBusy)
// // // // // // // // // //                           ? null
// // // // // // // // // //                           : sendLedFirmware,

// // // // // // // // // //                   icon: isBusy
// // // // // // // // // //                       ? const SizedBox(
// // // // // // // // // //                           width: 22,
// // // // // // // // // //                           height: 22,

// // // // // // // // // //                           child:
// // // // // // // // // //                               CircularProgressIndicator(
// // // // // // // // // //                             strokeWidth: 2,
// // // // // // // // // //                             color:
// // // // // // // // // //                                 Colors.white,
// // // // // // // // // //                           ),
// // // // // // // // // //                         )

// // // // // // // // // //                       : const Icon(
// // // // // // // // // //                           Icons.lightbulb,
// // // // // // // // // //                         ),

// // // // // // // // // //                   label: Text(
// // // // // // // // // //                     isBusy
// // // // // // // // // //                         ? 'UPLOADING...'
// // // // // // // // // //                         : 'SEND LED FIRMWARE',

// // // // // // // // // //                     style:
// // // // // // // // // //                         const TextStyle(
// // // // // // // // // //                       fontSize: 16,
// // // // // // // // // //                       fontWeight:
// // // // // // // // // //                           FontWeight.bold,
// // // // // // // // // //                     ),
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),

// // // // // // // // // //               const SizedBox(
// // // // // // // // // //                 height: 12,
// // // // // // // // // //               ),

// // // // // // // // // //               // ==================================================
// // // // // // // // // //               // SEND WAV
// // // // // // // // // //               // ==================================================

// // // // // // // // // //               SizedBox(
// // // // // // // // // //                 height: 52,

// // // // // // // // // //                 child:
// // // // // // // // // //                     ElevatedButton.icon(

// // // // // // // // // //                   onPressed:
// // // // // // // // // //                       (!isWifiEnabled ||
// // // // // // // // // //                               isBusy)
// // // // // // // // // //                           ? null
// // // // // // // // // //                           : sendWav,

// // // // // // // // // //                   icon: const Icon(
// // // // // // // // // //                     Icons.audiotrack,
// // // // // // // // // //                   ),

// // // // // // // // // //                   label: const Text(
// // // // // // // // // //                     'SEND WAV',
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),

// // // // // // // // // //               const SizedBox(
// // // // // // // // // //                 height: 12,
// // // // // // // // // //               ),

// // // // // // // // // //               // ==================================================
// // // // // // // // // //               // SEND VIDEO
// // // // // // // // // //               // ==================================================

// // // // // // // // // //               SizedBox(
// // // // // // // // // //                 height: 58,

// // // // // // // // // //                 child:
// // // // // // // // // //                     ElevatedButton.icon(

// // // // // // // // // //                   onPressed:
// // // // // // // // // //                       (!isWifiEnabled ||
// // // // // // // // // //                               isBusy)
// // // // // // // // // //                           ? null
// // // // // // // // // //                           : sendVideo,

// // // // // // // // // //                   icon: isBusy
// // // // // // // // // //                       ? const SizedBox(
// // // // // // // // // //                           width: 22,
// // // // // // // // // //                           height: 22,

// // // // // // // // // //                           child:
// // // // // // // // // //                               CircularProgressIndicator(
// // // // // // // // // //                             strokeWidth: 2,
// // // // // // // // // //                             color:
// // // // // // // // // //                                 Colors.white,
// // // // // // // // // //                           ),
// // // // // // // // // //                         )

// // // // // // // // // //                       : const Icon(
// // // // // // // // // //                           Icons.videocam,
// // // // // // // // // //                         ),

// // // // // // // // // //                   label: Text(
// // // // // // // // // //                     isBusy
// // // // // // // // // //                         ? 'SENDING VIDEO...'
// // // // // // // // // //                         : 'SEND VIDEO',

// // // // // // // // // //                     style:
// // // // // // // // // //                         const TextStyle(
// // // // // // // // // //                       fontSize: 16,
// // // // // // // // // //                       fontWeight:
// // // // // // // // // //                           FontWeight.bold,
// // // // // // // // // //                     ),
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),

// // // // // // // // // //               const SizedBox(
// // // // // // // // // //                 height: 24,
// // // // // // // // // //               ),

// // // // // // // // // //               // ==================================================
// // // // // // // // // //               // PROGRESS
// // // // // // // // // //               // ==================================================

// // // // // // // // // //               if (isBusy ||
// // // // // // // // // //                   progress > 0) ...[

// // // // // // // // // //                 LinearProgressIndicator(
// // // // // // // // // //                   value: progress,
// // // // // // // // // //                   minHeight: 8,
// // // // // // // // // //                 ),

// // // // // // // // // //                 const SizedBox(
// // // // // // // // // //                   height: 10,
// // // // // // // // // //                 ),

// // // // // // // // // //                 Text(
// // // // // // // // // //                   '${(progress * 100).toInt()}%',

// // // // // // // // // //                   textAlign:
// // // // // // // // // //                       TextAlign.center,

// // // // // // // // // //                   style:
// // // // // // // // // //                       const TextStyle(
// // // // // // // // // //                     fontWeight:
// // // // // // // // // //                         FontWeight.bold,
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),

// // // // // // // // // //                 const SizedBox(
// // // // // // // // // //                   height: 20,
// // // // // // // // // //                 ),
// // // // // // // // // //               ],

// // // // // // // // // //               // ==================================================
// // // // // // // // // //               // STATUS
// // // // // // // // // //               // ==================================================

// // // // // // // // // //               Card(
// // // // // // // // // //                 child: Padding(
// // // // // // // // // //                   padding:
// // // // // // // // // //                       const EdgeInsets.all(16),

// // // // // // // // // //                   child: Column(
// // // // // // // // // //                     crossAxisAlignment:
// // // // // // // // // //                         CrossAxisAlignment.start,

// // // // // // // // // //                     children: [

// // // // // // // // // //                       const Text(
// // // // // // // // // //                         'Status',

// // // // // // // // // //                         style:
// // // // // // // // // //                             TextStyle(
// // // // // // // // // //                           fontSize: 18,
// // // // // // // // // //                           fontWeight:
// // // // // // // // // //                               FontWeight.bold,
// // // // // // // // // //                         ),
// // // // // // // // // //                       ),

// // // // // // // // // //                       const SizedBox(
// // // // // // // // // //                         height: 12,
// // // // // // // // // //                       ),

// // // // // // // // // //                       Container(
// // // // // // // // // //                         width:
// // // // // // // // // //                             double.infinity,

// // // // // // // // // //                         padding:
// // // // // // // // // //                             const EdgeInsets.all(
// // // // // // // // // //                           15,
// // // // // // // // // //                         ),

// // // // // // // // // //                         decoration:
// // // // // // // // // //                             BoxDecoration(
// // // // // // // // // //                           color: Colors
// // // // // // // // // //                               .grey
// // // // // // // // // //                               .shade100,

// // // // // // // // // //                           borderRadius:
// // // // // // // // // //                               BorderRadius
// // // // // // // // // //                                   .circular(
// // // // // // // // // //                             10,
// // // // // // // // // //                           ),
// // // // // // // // // //                         ),

// // // // // // // // // //                         child:
// // // // // // // // // //                             SelectableText(
// // // // // // // // // //                           status,

// // // // // // // // // //                           style:
// // // // // // // // // //                               const TextStyle(
// // // // // // // // // //                             fontSize: 14,
// // // // // // // // // //                             height: 1.5,
// // // // // // // // // //                           ),
// // // // // // // // // //                         ),
// // // // // // // // // //                       ),
// // // // // // // // // //                     ],
// // // // // // // // // //                   ),
// // // // // // // // // //                 ),
// // // // // // // // // //               ),
// // // // // // // // // //             ],
// // // // // // // // // //           ),
// // // // // // // // // //         ),
// // // // // // // // // //       ),
// // // // // // // // // //     );
// // // // // // // // // //   }
// // // // // // // // // // }

// // // // // // // import 'package:flutter/material.dart';

// // // // // // // void main() {
// // // // // // //   runApp(const RobotBlocksApp());
// // // // // // // }

// // // // // // // class RobotBlocksApp extends StatelessWidget {
// // // // // // //   const RobotBlocksApp({super.key});

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return MaterialApp(
// // // // // // //       debugShowCheckedModeBanner: false,
// // // // // // //       title: 'Robot Commands',
// // // // // // //       theme: ThemeData(
// // // // // // //         useMaterial3: true,
// // // // // // //         scaffoldBackgroundColor: const Color(0xFFF4F7FB),
// // // // // // //         colorScheme: ColorScheme.fromSeed(
// // // // // // //           seedColor: const Color(0xFF7B45D6),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       home: const RobotBlocksPage(),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // // // // enum CommandType {
// // // // // // //   forward,
// // // // // // //   backword,
// // // // // // //   left,
// // // // // // //   right,
// // // // // // //   stop,
// // // // // // //   loop,
// // // // // // //   delay,
// // // // // // // }

// // // // // // // class ProgramBlock {
// // // // // // //   ProgramBlock({
// // // // // // //     required this.id,
// // // // // // //     required this.type,
// // // // // // //     this.seconds = 1,
// // // // // // //   });

// // // // // // //   final int id;
// // // // // // //   final CommandType type;
// // // // // // //   int seconds;
// // // // // // // }

// // // // // // // class RobotBlocksPage extends StatefulWidget {
// // // // // // //   const RobotBlocksPage({super.key});

// // // // // // //   @override
// // // // // // //   State<RobotBlocksPage> createState() => _RobotBlocksPageState();
// // // // // // // }

// // // // // // // class _RobotBlocksPageState extends State<RobotBlocksPage> {
// // // // // // //   final List<ProgramBlock> _program = [];

// // // // // // //   final GlobalKey _dropAreaKey = GlobalKey();

// // // // // // //   final List<CommandType> _paletteBlocks = const [
// // // // // // //     CommandType.forward,
// // // // // // //     CommandType.backword,
// // // // // // //     CommandType.left,
// // // // // // //     CommandType.right,
// // // // // // //     CommandType.stop,
// // // // // // //     CommandType.loop,
// // // // // // //     CommandType.delay,
// // // // // // //   ];

// // // // // // //   int _nextBlockId = 0;
// // // // // // //   bool _isExecuting = false;
// // // // // // //   bool _isAutoScrolling = false;
// // // // // // //   int? _activeBlockId;
// // // // // // //   int? _dropInsertIndex;

// // // // // // //   String _status = 'Drag blocks into the program area.';

// // // // // // //   bool _needsSeconds(CommandType type) {
// // // // // // //     return type == CommandType.forward ||
// // // // // // //         type == CommandType.backword ||
// // // // // // //         type == CommandType.delay;
// // // // // // //   }

// // // // // // //   String _label(CommandType type) {
// // // // // // //     switch (type) {
// // // // // // //       case CommandType.forward:
// // // // // // //         return 'forward';
// // // // // // //       case CommandType.backword:
// // // // // // //         return 'backword';
// // // // // // //       case CommandType.left:
// // // // // // //         return 'left';
// // // // // // //       case CommandType.right:
// // // // // // //         return 'right';
// // // // // // //       case CommandType.stop:
// // // // // // //         return 'stop';
// // // // // // //       case CommandType.loop:
// // // // // // //         return 'loop';
// // // // // // //       case CommandType.delay:
// // // // // // //         return 'delay';
// // // // // // //     }
// // // // // // //   }

// // // // // // //   IconData _icon(CommandType type) {
// // // // // // //     switch (type) {
// // // // // // //       case CommandType.forward:
// // // // // // //         return Icons.arrow_upward_rounded;
// // // // // // //       case CommandType.backword:
// // // // // // //         return Icons.arrow_downward_rounded;
// // // // // // //       case CommandType.left:
// // // // // // //         return Icons.turn_left_rounded;
// // // // // // //       case CommandType.right:
// // // // // // //         return Icons.turn_right_rounded;
// // // // // // //       case CommandType.stop:
// // // // // // //         return Icons.stop_circle_rounded;
// // // // // // //       case CommandType.loop:
// // // // // // //         return Icons.loop_rounded;
// // // // // // //       case CommandType.delay:
// // // // // // //         return Icons.timer_outlined;
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Color _color(CommandType type) {
// // // // // // //     switch (type) {
// // // // // // //       case CommandType.stop:
// // // // // // //         return const Color(0xFFE84B3C);

// // // // // // //       case CommandType.loop:
// // // // // // //       case CommandType.delay:
// // // // // // //         return const Color(0xFFFFAB19);

// // // // // // //       case CommandType.forward:
// // // // // // //       case CommandType.backword:
// // // // // // //       case CommandType.left:
// // // // // // //       case CommandType.right:
// // // // // // //         return const Color(0xFF4C97FF);
// // // // // // //     }
// // // // // // //   }

// // // // // // //   Future<void> _scrollToDropArea() async {
// // // // // // //     if (_isAutoScrolling) return;

// // // // // // //     final BuildContext? dropAreaContext = _dropAreaKey.currentContext;

// // // // // // //     if (dropAreaContext == null) return;

// // // // // // //     _isAutoScrolling = true;

// // // // // // //     try {
// // // // // // //       await Scrollable.ensureVisible(
// // // // // // //         dropAreaContext,
// // // // // // //         duration: const Duration(milliseconds: 500),
// // // // // // //         curve: Curves.easeInOut,
// // // // // // //         alignment: 0.30,
// // // // // // //       );
// // // // // // //     } finally {
// // // // // // //       if (mounted) {
// // // // // // //         _isAutoScrolling = false;
// // // // // // //       }
// // // // // // //     }
// // // // // // //   }

// // // // // // //   void _insertBlockAt(CommandType type, int index) {
// // // // // // //     if (_isExecuting) return;

// // // // // // //     final safeIndex = index.clamp(0, _program.length);

// // // // // // //     setState(() {
// // // // // // //       _program.insert(
// // // // // // //         safeIndex,
// // // // // // //         ProgramBlock(
// // // // // // //           id: _nextBlockId++,
// // // // // // //           type: type,
// // // // // // //           seconds: 1,
// // // // // // //         ),
// // // // // // //       );

// // // // // // //       _dropInsertIndex = null;
// // // // // // //       _status = '${_label(type)} inserted.';
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _removeBlock(int id) {
// // // // // // //     if (_isExecuting) return;

// // // // // // //     setState(() {
// // // // // // //       _program.removeWhere((block) => block.id == id);
// // // // // // //       _status = 'Block removed.';
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _clearProgram() {
// // // // // // //     if (_isExecuting) return;

// // // // // // //     setState(() {
// // // // // // //       _program.clear();
// // // // // // //       _activeBlockId = null;
// // // // // // //       _dropInsertIndex = null;
// // // // // // //       _status = 'Program cleared.';
// // // // // // //     });
// // // // // // //   }

// // // // // // //   void _stopExecution() {
// // // // // // //     if (!_isExecuting) return;

// // // // // // //     setState(() {
// // // // // // //       _isExecuting = false;
// // // // // // //       _activeBlockId = null;
// // // // // // //       _status = 'Execution stopped.';
// // // // // // //     });
// // // // // // //   }

// // // // // // //   Future<void> _pause(Duration duration) async {
// // // // // // //     await Future.delayed(duration);
// // // // // // //   }

// // // // // // //   Future<void> _executeProgram() async {
// // // // // // //     if (_isExecuting) return;

// // // // // // //     if (_program.isEmpty) {
// // // // // // //       setState(() {
// // // // // // //         _status = 'Please drop at least one block before executing.';
// // // // // // //       });
// // // // // // //       return;
// // // // // // //     }

// // // // // // //     setState(() {
// // // // // // //       _isExecuting = true;
// // // // // // //       _activeBlockId = null;
// // // // // // //       _status = 'Program started.';
// // // // // // //     });

// // // // // // //     final List<ProgramBlock> programSnapshot =
// // // // // // //         List<ProgramBlock>.from(_program);

// // // // // // //     for (final block in programSnapshot) {
// // // // // // //       if (!mounted || !_isExecuting) return;

// // // // // // //       setState(() {
// // // // // // //         _activeBlockId = block.id;
// // // // // // //         _status = 'Executing: ${_label(block.type)}';
// // // // // // //       });

// // // // // // //       switch (block.type) {
// // // // // // //         case CommandType.forward:
// // // // // // //           if (!mounted || !_isExecuting) return;

// // // // // // //           setState(() {
// // // // // // //             _status =
// // // // // // //                 'Moving forward for ${block.seconds} second${block.seconds == 1 ? '' : 's'}...';
// // // // // // //           });

// // // // // // //           await _pause(Duration(seconds: block.seconds));
// // // // // // //           break;

// // // // // // //         case CommandType.backword:
// // // // // // //           if (!mounted || !_isExecuting) return;

// // // // // // //           setState(() {
// // // // // // //             _status =
// // // // // // //                 'Moving backword for ${block.seconds} second${block.seconds == 1 ? '' : 's'}...';
// // // // // // //           });

// // // // // // //           await _pause(Duration(seconds: block.seconds));
// // // // // // //           break;

// // // // // // //         case CommandType.left:
// // // // // // //           if (!mounted || !_isExecuting) return;

// // // // // // //           setState(() {
// // // // // // //             _status = 'Turning left...';
// // // // // // //           });

// // // // // // //           await _pause(const Duration(milliseconds: 500));
// // // // // // //           break;

// // // // // // //         case CommandType.right:
// // // // // // //           if (!mounted || !_isExecuting) return;

// // // // // // //           setState(() {
// // // // // // //             _status = 'Turning right...';
// // // // // // //           });

// // // // // // //           await _pause(const Duration(milliseconds: 500));
// // // // // // //           break;

// // // // // // //         case CommandType.loop:
// // // // // // //           if (!mounted || !_isExecuting) return;

// // // // // // //           setState(() {
// // // // // // //             _status = 'Executing loop...';
// // // // // // //           });

// // // // // // //           await _pause(const Duration(milliseconds: 500));
// // // // // // //           break;

// // // // // // //         case CommandType.delay:
// // // // // // //           if (!mounted || !_isExecuting) return;

// // // // // // //           setState(() {
// // // // // // //             _status =
// // // // // // //                 'Waiting ${block.seconds} second${block.seconds == 1 ? '' : 's'}...';
// // // // // // //           });

// // // // // // //           await _pause(Duration(seconds: block.seconds));
// // // // // // //           break;

// // // // // // //         case CommandType.stop:
// // // // // // //           if (!mounted) return;

// // // // // // //           setState(() {
// // // // // // //             _isExecuting = false;
// // // // // // //             _activeBlockId = null;
// // // // // // //             _status = 'Stop block reached. Program ended.';
// // // // // // //           });
// // // // // // //           return;
// // // // // // //       }

// // // // // // //       if (!mounted || !_isExecuting) return;
// // // // // // //     }

// // // // // // //     if (!mounted || !_isExecuting) return;

// // // // // // //     setState(() {
// // // // // // //       _isExecuting = false;
// // // // // // //       _activeBlockId = null;
// // // // // // //       _status = 'Program completed.';
// // // // // // //     });
// // // // // // //   }

// // // // // // //   @override
// // // // // // //   Widget build(BuildContext context) {
// // // // // // //     return Scaffold(
// // // // // // //       appBar: AppBar(
// // // // // // //         elevation: 0,
// // // // // // //         backgroundColor: const Color(0xFF7B45D6),
// // // // // // //         foregroundColor: Colors.white,
// // // // // // //         title: const Text(
// // // // // // //           'Robot Commands',
// // // // // // //           style: TextStyle(
// // // // // // //             fontWeight: FontWeight.w800,
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       body: SafeArea(
// // // // // // //         child: Center(
// // // // // // //           child: ConstrainedBox(
// // // // // // //             constraints: const BoxConstraints(maxWidth: 540),
// // // // // // //             child: SingleChildScrollView(
// // // // // // //               padding: const EdgeInsets.all(18),
// // // // // // //               child: Column(
// // // // // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                 children: [
// // // // // // //                   const Text(
// // // // // // //                     'Command Blocks',
// // // // // // //                     style: TextStyle(
// // // // // // //                       fontSize: 24,
// // // // // // //                       fontWeight: FontWeight.w800,
// // // // // // //                       color: Color(0xFF293B4D),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 6),
// // // // // // //                   const Text(
// // // // // // //                     'Drag blocks into the drop area to build your program.',
// // // // // // //                     style: TextStyle(
// // // // // // //                       color: Color(0xFF6A7A8D),
// // // // // // //                       fontSize: 15,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 18),

// // // // // // //                   _buildPalette(),

// // // // // // //                   const SizedBox(height: 28),

// // // // // // //                   const Text(
// // // // // // //                     'Program Drop Area',
// // // // // // //                     style: TextStyle(
// // // // // // //                       fontSize: 20,
// // // // // // //                       fontWeight: FontWeight.w800,
// // // // // // //                       color: Color(0xFF293B4D),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                   const SizedBox(height: 10),

// // // // // // //                   KeyedSubtree(
// // // // // // //                     key: _dropAreaKey,
// // // // // // //                     child: _buildDropArea(),
// // // // // // //                   ),

// // // // // // //                   const SizedBox(height: 18),

// // // // // // //                   _buildActionButtons(),

// // // // // // //                   const SizedBox(height: 14),

// // // // // // //                   _buildStatusCard(),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildPalette() {
// // // // // // //     return Column(
// // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //       children: [
// // // // // // //         for (final type in _paletteBlocks)
// // // // // // //           Padding(
// // // // // // //             padding: const EdgeInsets.only(bottom: 4),
// // // // // // //             child: Draggable<CommandType>(
// // // // // // //               data: type,
// // // // // // //               onDragStarted: _scrollToDropArea,
// // // // // // //               feedback: Material(
// // // // // // //                 color: Colors.transparent,
// // // // // // //                 child: Opacity(
// // // // // // //                   opacity: 0.88,
// // // // // // //                   child: SizedBox(
// // // // // // //                     width: 300,
// // // // // // //                     child: _buildCommandBlock(
// // // // // // //                       type: type,
// // // // // // //                       showTopConnector: false,
// // // // // // //                       showBottomConnector: true,
// // // // // // //                       seconds: _needsSeconds(type) ? 1 : null,
// // // // // // //                       showDelete: false,
// // // // // // //                       showSecondsPicker: true,
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               childWhenDragging: Opacity(
// // // // // // //                 opacity: 0.35,
// // // // // // //                 child: _buildCommandBlock(
// // // // // // //                   type: type,
// // // // // // //                   showTopConnector: false,
// // // // // // //                   showBottomConnector: true,
// // // // // // //                   seconds: _needsSeconds(type) ? 1 : null,
// // // // // // //                   showDelete: false,
// // // // // // //                   showSecondsPicker: true,
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //               child: _buildCommandBlock(
// // // // // // //                 type: type,
// // // // // // //                 showTopConnector: false,
// // // // // // //                 showBottomConnector: true,
// // // // // // //                 seconds: _needsSeconds(type) ? 1 : null,
// // // // // // //                 showDelete: false,
// // // // // // //                 showSecondsPicker: true,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildDropArea() {
// // // // // // //     return DragTarget<CommandType>(
// // // // // // //       onWillAcceptWithDetails: (details) {
// // // // // // //         return !_isExecuting;
// // // // // // //       },
// // // // // // //       onMove: (details) {
// // // // // // //         if (_isExecuting) return;

// // // // // // //         final RenderBox? box =
// // // // // // //             _dropAreaKey.currentContext?.findRenderObject() as RenderBox?;

// // // // // // //         if (box == null) return;

// // // // // // //         final Offset localPosition = box.globalToLocal(details.offset);

// // // // // // //         const double blockHeight = 61;

// // // // // // //         int insertIndex =
// // // // // // //             ((localPosition.dy - 18) / blockHeight).round();

// // // // // // //         insertIndex = insertIndex.clamp(0, _program.length);

// // // // // // //         if (_dropInsertIndex != insertIndex) {
// // // // // // //           setState(() {
// // // // // // //             _dropInsertIndex = insertIndex;
// // // // // // //           });
// // // // // // //         }
// // // // // // //       },
// // // // // // //       onLeave: (_) {
// // // // // // //         if (!_isExecuting && mounted) {
// // // // // // //           setState(() {
// // // // // // //             _dropInsertIndex = null;
// // // // // // //           });
// // // // // // //         }
// // // // // // //       },
// // // // // // //       onAcceptWithDetails: (details) {
// // // // // // //         final int index = _dropInsertIndex ?? _program.length;

// // // // // // //         _insertBlockAt(details.data, index);
// // // // // // //       },
// // // // // // //       builder: (context, candidateData, rejectedData) {
// // // // // // //         final bool isHovering = candidateData.isNotEmpty;

// // // // // // //         return AnimatedContainer(
// // // // // // //           duration: const Duration(milliseconds: 150),
// // // // // // //           width: double.infinity,
// // // // // // //           constraints: const BoxConstraints(minHeight: 185),
// // // // // // //           padding: const EdgeInsets.fromLTRB(14, 18, 14, 22),
// // // // // // //           decoration: BoxDecoration(
// // // // // // //             color: isHovering
// // // // // // //                 ? const Color(0xFFE9F4FF)
// // // // // // //                 : Colors.white,
// // // // // // //             borderRadius: BorderRadius.circular(16),
// // // // // // //             border: Border.all(
// // // // // // //               color: isHovering
// // // // // // //                   ? const Color(0xFF4C97FF)
// // // // // // //                   : const Color(0xFFC8D4E0),
// // // // // // //               width: isHovering ? 2.5 : 2,
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           child: _program.isEmpty
// // // // // // //               ? const Column(
// // // // // // //                   mainAxisSize: MainAxisSize.min,
// // // // // // //                   children: [
// // // // // // //                     SizedBox(height: 18),
// // // // // // //                     Icon(
// // // // // // //                       Icons.move_down_rounded,
// // // // // // //                       size: 50,
// // // // // // //                       color: Color(0xFF4C97FF),
// // // // // // //                     ),
// // // // // // //                     SizedBox(height: 10),
// // // // // // //                     Text(
// // // // // // //                       'Drop blocks here',
// // // // // // //                       style: TextStyle(
// // // // // // //                         fontSize: 19,
// // // // // // //                         fontWeight: FontWeight.w800,
// // // // // // //                         color: Color(0xFF35465A),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     SizedBox(height: 6),
// // // // // // //                     Text(
// // // // // // //                       'Blocks will connect in the order you drop them.',
// // // // // // //                       textAlign: TextAlign.center,
// // // // // // //                       style: TextStyle(
// // // // // // //                         color: Color(0xFF6D7C8E),
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                     SizedBox(height: 18),
// // // // // // //                   ],
// // // // // // //                 )
// // // // // // //               : Column(
// // // // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //                   children: [
// // // // // // //                     for (int index = 0; index < _program.length; index++) ...[
// // // // // // //                       if (_dropInsertIndex == index && isHovering)
// // // // // // //                         _buildDropIndicator(),

// // // // // // //                       _buildProgramBlock(
// // // // // // //                         block: _program[index],
// // // // // // //                         index: index,
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                     if (_dropInsertIndex == _program.length && isHovering)
// // // // // // //                       _buildDropIndicator(),
// // // // // // //                   ],
// // // // // // //                 ),
// // // // // // //         );
// // // // // // //       },
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildDropIndicator() {
// // // // // // //     return Padding(
// // // // // // //       padding: const EdgeInsets.only(
// // // // // // //         left: 28,
// // // // // // //         top: 2,
// // // // // // //         bottom: 2,
// // // // // // //       ),
// // // // // // //       child: Container(
// // // // // // //         width: 300,
// // // // // // //         height: 8,
// // // // // // //         decoration: BoxDecoration(
// // // // // // //           color: const Color(0xFF4C97FF),
// // // // // // //           borderRadius: BorderRadius.circular(4),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildProgramBlock({
// // // // // // //     required ProgramBlock block,
// // // // // // //     required int index,
// // // // // // //   }) {
// // // // // // //     final bool isFirst = index == 0;
// // // // // // //     final bool isLast = index == _program.length - 1;
// // // // // // //     final bool isActive = _activeBlockId == block.id;

// // // // // // //     return Row(
// // // // // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // // // // //       children: [
// // // // // // //         SizedBox(
// // // // // // //           width: 28,
// // // // // // //           child: Padding(
// // // // // // //             padding: const EdgeInsets.only(top: 16),
// // // // // // //             child: Text(
// // // // // // //               '${index + 1}',
// // // // // // //               textAlign: TextAlign.center,
// // // // // // //               style: const TextStyle(
// // // // // // //                 color: Color(0xFF7C8D9F),
// // // // // // //                 fontWeight: FontWeight.w800,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         Expanded(
// // // // // // //           child: _buildCommandBlock(
// // // // // // //             type: block.type,
// // // // // // //             showTopConnector: !isFirst,
// // // // // // //             showBottomConnector: !isLast,
// // // // // // //             isActive: isActive,
// // // // // // //             showDelete: !_isExecuting,
// // // // // // //             seconds: _needsSeconds(block.type) ? block.seconds : null,
// // // // // // //             showSecondsPicker: true,
// // // // // // //             onDelete: () => _removeBlock(block.id),
// // // // // // //             onSecondsChanged: (seconds) {
// // // // // // //               if (_isExecuting) return;

// // // // // // //               setState(() {
// // // // // // //                 block.seconds = seconds;
// // // // // // //               });
// // // // // // //             },
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildCommandBlock({
// // // // // // //     required CommandType type,
// // // // // // //     required bool showTopConnector,
// // // // // // //     required bool showBottomConnector,
// // // // // // //     bool isActive = false,
// // // // // // //     bool showDelete = false,
// // // // // // //     bool showSecondsPicker = false,
// // // // // // //     int? seconds,
// // // // // // //     VoidCallback? onDelete,
// // // // // // //     ValueChanged<int>? onSecondsChanged,
// // // // // // //   }) {
// // // // // // //     final Color blockColor = _color(type);

// // // // // // //     return Align(
// // // // // // //       alignment: Alignment.centerLeft,
// // // // // // //       child: SizedBox(
// // // // // // //         width: 300,
// // // // // // //         height: 61,
// // // // // // //         child: Stack(
// // // // // // //           clipBehavior: Clip.none,
// // // // // // //           children: [
// // // // // // //             Container(
// // // // // // //               height: 52,
// // // // // // //               width: 300,
// // // // // // //               padding: const EdgeInsets.symmetric(
// // // // // // //                 horizontal: 12,
// // // // // // //                 vertical: 7,
// // // // // // //               ),
// // // // // // //               decoration: BoxDecoration(
// // // // // // //                 color: blockColor,
// // // // // // //                 borderRadius: BorderRadius.circular(7),
// // // // // // //                 border: isActive
// // // // // // //                     ? Border.all(
// // // // // // //                         color: Colors.white,
// // // // // // //                         width: 2.5,
// // // // // // //                       )
// // // // // // //                     : null,
// // // // // // //                 boxShadow: [
// // // // // // //                   BoxShadow(
// // // // // // //                     color: blockColor.withOpacity(0.30),
// // // // // // //                     offset: const Offset(0, 3),
// // // // // // //                     blurRadius: 0,
// // // // // // //                   ),
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //               child: Row(
// // // // // // //                 children: [
// // // // // // //                   Icon(
// // // // // // //                     _icon(type),
// // // // // // //                     color: Colors.white,
// // // // // // //                     size: 20,
// // // // // // //                   ),
// // // // // // //                   const SizedBox(width: 8),

// // // // // // //                   Text(
// // // // // // //                     _label(type),
// // // // // // //                     style: const TextStyle(
// // // // // // //                       color: Colors.white,
// // // // // // //                       fontSize: 15,
// // // // // // //                       fontWeight: FontWeight.w800,
// // // // // // //                     ),
// // // // // // //                   ),

// // // // // // //                   const Spacer(),

// // // // // // //                   if (seconds != null && showSecondsPicker)
// // // // // // //                     _buildSecondsPicker(
// // // // // // //                       value: seconds,
// // // // // // //                       onChanged: onSecondsChanged,
// // // // // // //                     ),

// // // // // // //                   if (seconds != null && showSecondsPicker) ...[
// // // // // // //                     const SizedBox(width: 5),
// // // // // // //                     const Text(
// // // // // // //                       'sec',
// // // // // // //                       style: TextStyle(
// // // // // // //                         color: Colors.white,
// // // // // // //                         fontSize: 13,
// // // // // // //                         fontWeight: FontWeight.w800,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ],

// // // // // // //                   if (showDelete) ...[
// // // // // // //                     const SizedBox(width: 3),
// // // // // // //                     IconButton(
// // // // // // //                       tooltip: 'Remove block',
// // // // // // //                       onPressed: onDelete,
// // // // // // //                       icon: const Icon(
// // // // // // //                         Icons.close_rounded,
// // // // // // //                         color: Colors.white,
// // // // // // //                         size: 18,
// // // // // // //                       ),
// // // // // // //                       padding: EdgeInsets.zero,
// // // // // // //                       constraints: const BoxConstraints(
// // // // // // //                         minWidth: 30,
// // // // // // //                         minHeight: 30,
// // // // // // //                       ),
// // // // // // //                     ),
// // // // // // //                   ],
// // // // // // //                 ],
// // // // // // //               ),
// // // // // // //             ),

// // // // // // //             if (showTopConnector)
// // // // // // //               Positioned(
// // // // // // //                 top: 0,
// // // // // // //                 left: 20,
// // // // // // //                 child: Container(
// // // // // // //                   width: 38,
// // // // // // //                   height: 8,
// // // // // // //                   decoration: const BoxDecoration(
// // // // // // //                     color: Color(0xFFF4F7FB),
// // // // // // //                     borderRadius: BorderRadius.only(
// // // // // // //                       bottomLeft: Radius.circular(4),
// // // // // // //                       bottomRight: Radius.circular(4),
// // // // // // //                     ),
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),

// // // // // // //             if (showBottomConnector)
// // // // // // //               Positioned(
// // // // // // //                 top: 51,
// // // // // // //                 left: 20,
// // // // // // //                 child: Container(
// // // // // // //                   width: 38,
// // // // // // //                   height: 10,
// // // // // // //                   decoration: BoxDecoration(
// // // // // // //                     color: blockColor,
// // // // // // //                     borderRadius: const BorderRadius.only(
// // // // // // //                       bottomLeft: Radius.circular(4),
// // // // // // //                       bottomRight: Radius.circular(4),
// // // // // // //                     ),
// // // // // // //                     boxShadow: [
// // // // // // //                       BoxShadow(
// // // // // // //                         color: blockColor.withOpacity(0.30),
// // // // // // //                         offset: const Offset(0, 3),
// // // // // // //                         blurRadius: 0,
// // // // // // //                       ),
// // // // // // //                     ],
// // // // // // //                   ),
// // // // // // //                 ),
// // // // // // //               ),
// // // // // // //           ],
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildSecondsPicker({
// // // // // // //     required int value,
// // // // // // //     required ValueChanged<int>? onChanged,
// // // // // // //   }) {
// // // // // // //     return Container(
// // // // // // //       height: 28,
// // // // // // //       padding: const EdgeInsets.symmetric(horizontal: 7),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: Colors.white,
// // // // // // //         borderRadius: BorderRadius.circular(14),
// // // // // // //       ),
// // // // // // //       child: DropdownButtonHideUnderline(
// // // // // // //         child: DropdownButton<int>(
// // // // // // //           value: value,
// // // // // // //           icon: const Icon(
// // // // // // //             Icons.arrow_drop_down_rounded,
// // // // // // //             color: Color(0xFF573F0C),
// // // // // // //             size: 19,
// // // // // // //           ),
// // // // // // //           dropdownColor: Colors.white,
// // // // // // //           borderRadius: BorderRadius.circular(10),
// // // // // // //           style: const TextStyle(
// // // // // // //             color: Color(0xFF573F0C),
// // // // // // //             fontSize: 13,
// // // // // // //             fontWeight: FontWeight.w800,
// // // // // // //           ),
// // // // // // //           items: List.generate(
// // // // // // //             16,
// // // // // // //             (index) => DropdownMenuItem<int>(
// // // // // // //               value: index,
// // // // // // //               child: Text('$index'),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //           onChanged: (newValue) {
// // // // // // //             if (newValue != null) {
// // // // // // //               onChanged?.call(newValue);
// // // // // // //             }
// // // // // // //           },
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildActionButtons() {
// // // // // // //     return Row(
// // // // // // //       children: [
// // // // // // //         Expanded(
// // // // // // //           child: ElevatedButton.icon(
// // // // // // //             onPressed: _isExecuting ? null : _executeProgram,
// // // // // // //             icon: const Icon(Icons.play_arrow_rounded),
// // // // // // //             label: const Text('Execute'),
// // // // // // //             style: ElevatedButton.styleFrom(
// // // // // // //               minimumSize: const Size.fromHeight(52),
// // // // // // //               backgroundColor: const Color(0xFF2EAA56),
// // // // // // //               foregroundColor: Colors.white,
// // // // // // //               disabledBackgroundColor: const Color(0xFFA7DDB7),
// // // // // // //               disabledForegroundColor: Colors.white,
// // // // // // //               textStyle: const TextStyle(
// // // // // // //                 fontSize: 17,
// // // // // // //                 fontWeight: FontWeight.w800,
// // // // // // //               ),
// // // // // // //               shape: RoundedRectangleBorder(
// // // // // // //                 borderRadius: BorderRadius.circular(12),
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //         const SizedBox(width: 10),
// // // // // // //         OutlinedButton.icon(
// // // // // // //           onPressed: _isExecuting ? _stopExecution : _clearProgram,
// // // // // // //           icon: Icon(
// // // // // // //             _isExecuting
// // // // // // //                 ? Icons.stop_rounded
// // // // // // //                 : Icons.delete_outline_rounded,
// // // // // // //           ),
// // // // // // //           label: Text(_isExecuting ? 'Stop' : 'Clear'),
// // // // // // //           style: OutlinedButton.styleFrom(
// // // // // // //             minimumSize: const Size(112, 52),
// // // // // // //             foregroundColor: _isExecuting
// // // // // // //                 ? const Color(0xFFE84B3C)
// // // // // // //                 : const Color(0xFF536578),
// // // // // // //             side: BorderSide(
// // // // // // //               color: _isExecuting
// // // // // // //                   ? const Color(0xFFE84B3C)
// // // // // // //                   : const Color(0xFFB8C5D2),
// // // // // // //             ),
// // // // // // //             textStyle: const TextStyle(
// // // // // // //               fontSize: 15,
// // // // // // //               fontWeight: FontWeight.w800,
// // // // // // //             ),
// // // // // // //             shape: RoundedRectangleBorder(
// // // // // // //               borderRadius: BorderRadius.circular(12),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ),
// // // // // // //       ],
// // // // // // //     );
// // // // // // //   }

// // // // // // //   Widget _buildStatusCard() {
// // // // // // //     return Container(
// // // // // // //       width: double.infinity,
// // // // // // //       padding: const EdgeInsets.all(14),
// // // // // // //       decoration: BoxDecoration(
// // // // // // //         color: _isExecuting
// // // // // // //             ? const Color(0xFFEAF8EF)
// // // // // // //             : Colors.white,
// // // // // // //         borderRadius: BorderRadius.circular(12),
// // // // // // //         border: Border.all(
// // // // // // //           color: _isExecuting
// // // // // // //               ? const Color(0xFF94D9A8)
// // // // // // //               : const Color(0xFFDDE6EE),
// // // // // // //         ),
// // // // // // //       ),
// // // // // // //       child: Row(
// // // // // // //         children: [
// // // // // // //           Icon(
// // // // // // //             _isExecuting
// // // // // // //                 ? Icons.play_circle_fill_rounded
// // // // // // //                 : Icons.info_outline_rounded,
// // // // // // //             color: _isExecuting
// // // // // // //                 ? const Color(0xFF2EAA56)
// // // // // // //                 : const Color(0xFF4C97FF),
// // // // // // //           ),
// // // // // // //           const SizedBox(width: 10),
// // // // // // //           Expanded(
// // // // // // //             child: Text(
// // // // // // //               _status,
// // // // // // //               style: const TextStyle(
// // // // // // //                 color: Color(0xFF425467),
// // // // // // //                 fontWeight: FontWeight.w600,
// // // // // // //               ),
// // // // // // //             ),
// // // // // // //           ),
// // // // // // //         ],
// // // // // // //       ),
// // // // // // //     );
// // // // // // //   }
// // // // // // // }

// // // // import 'dart:async';

// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:wifi_iot/wifi_iot.dart';

// // // // void main() {
// // // //   WidgetsFlutterBinding.ensureInitialized();
// // // //   runApp(const RobotBlocksApp());
// // // // }

// // // // // ============================================================
// // // // // APP
// // // // // ============================================================

// // // // class RobotBlocksApp extends StatelessWidget {
// // // //   const RobotBlocksApp({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       debugShowCheckedModeBanner: false,
// // // //       title: 'Robot Commands',
// // // //       theme: ThemeData(
// // // //         useMaterial3: true,
// // // //         scaffoldBackgroundColor: const Color(0xFFF4F7FB),
// // // //         colorScheme: ColorScheme.fromSeed(
// // // //           seedColor: const Color(0xFF7B45D6),
// // // //         ),
// // // //       ),
// // // //       home: const RobotBlocksPage(),
// // // //     );
// // // //   }
// // // // }

// // // // // ============================================================
// // // // // COMMAND TYPES
// // // // // ============================================================

// // // // enum CommandType {
// // // //   forward,
// // // //   backword,
// // // //   left,
// // // //   right,
// // // //   stop,
// // // //   loop,
// // // //   delay,
// // // // }

// // // // // ============================================================
// // // // // PROGRAM BLOCK MODEL
// // // // // ============================================================

// // // // class ProgramBlock {
// // // //   ProgramBlock({
// // // //     required this.id,
// // // //     required this.type,
// // // //     this.seconds = 1,
// // // //   });

// // // //   final int id;
// // // //   final CommandType type;

// // // //   // This value is changed only from the Program Drop Area.
// // // //   int seconds;
// // // // }

// // // // // ============================================================
// // // // // MAIN PAGE
// // // // // ============================================================

// // // // class RobotBlocksPage extends StatefulWidget {
// // // //   const RobotBlocksPage({super.key});

// // // //   @override
// // // //   State<RobotBlocksPage> createState() => _RobotBlocksPageState();
// // // // }

// // // // class _RobotBlocksPageState extends State<RobotBlocksPage>
// // // //     with WidgetsBindingObserver {
// // // //   // ==========================================================
// // // //   // ESP32 WIFI SETTINGS
// // // //   // ==========================================================

// // // //   static const String baseUrl = 'http://192.168.4.1';
// // // //   static const String testUrl = '$baseUrl/';

// // // //   bool _isWifiEnabled = false;
// // // //   bool _isEsp32Connected = false;
// // // //   bool _isCheckingConnection = false;

// // // //   String _wifiStatus = 'Checking Wi-Fi...';

// // // //   // ==========================================================
// // // //   // PROGRAM SETTINGS
// // // //   // ==========================================================

// // // //   final List<ProgramBlock> _program = [];

// // // //   final GlobalKey _dropAreaKey = GlobalKey();

// // // //   final List<CommandType> _paletteBlocks = const [
// // // //     CommandType.forward,
// // // //     CommandType.backword,
// // // //     CommandType.left,
// // // //     CommandType.right,
// // // //     CommandType.stop,
// // // //     CommandType.loop,
// // // //     CommandType.delay,
// // // //   ];

// // // //   int _nextBlockId = 0;

// // // //   bool _isExecuting = false;
// // // //   bool _isAutoScrolling = false;

// // // //   int? _activeBlockId;
// // // //   int? _dropInsertIndex;

// // // //   String _status = 'Drag blocks into the program area.';

// // // //   // ==========================================================
// // // //   // INITIALIZATION
// // // //   // ==========================================================

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();

// // // //     WidgetsBinding.instance.addObserver(this);

// // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //       _checkWifi();
// // // //     });
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     WidgetsBinding.instance.removeObserver(this);
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   void didChangeAppLifecycleState(AppLifecycleState state) {
// // // //     super.didChangeAppLifecycleState(state);

// // // //     if (state == AppLifecycleState.resumed) {
// // // //       _checkWifi();
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // WIFI CHECK
// // // //   // ==========================================================

// // // //   Future<void> _checkWifi() async {
// // // //     try {
// // // //       final bool enabled = await WiFiForIoTPlugin.isEnabled();

// // // //       if (!mounted) return;

// // // //       setState(() {
// // // //         _isWifiEnabled = enabled;

// // // //         if (!enabled) {
// // // //           _isEsp32Connected = false;
// // // //           _wifiStatus = 'Wi-Fi is disabled.';
// // // //         } else {
// // // //           _wifiStatus =
// // // //               'Wi-Fi is enabled.\nConnect to the ESP32 hotspot.';
// // // //         }
// // // //       });
// // // //     } catch (e) {
// // // //       if (!mounted) return;

// // // //       setState(() {
// // // //         _isWifiEnabled = false;
// // // //         _isEsp32Connected = false;
// // // //         _wifiStatus = 'Unable to check Wi-Fi.';
// // // //       });
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // CONNECT TO ESP32
// // // //   // ==========================================================

// // // //   Future<void> _connectToEsp32() async {
// // // //     if (_isCheckingConnection || _isExecuting) return;

// // // //     setState(() {
// // // //       _isCheckingConnection = true;
// // // //       _isEsp32Connected = false;
// // // //       _wifiStatus = 'Checking ESP32 connection...';
// // // //     });

// // // //     try {
// // // //       final bool wifiEnabled = await WiFiForIoTPlugin.isEnabled();

// // // //       if (!wifiEnabled) {
// // // //         if (!mounted) return;

// // // //         setState(() {
// // // //           _isWifiEnabled = false;
// // // //           _isEsp32Connected = false;
// // // //           _wifiStatus = 'Please enable Wi-Fi first.';
// // // //         });

// // // //         _showMessage('Please enable Wi-Fi on your phone.');
// // // //         return;
// // // //       }

// // // //       if (!mounted) return;

// // // //       setState(() {
// // // //         _isWifiEnabled = true;
// // // //         _wifiStatus = 'Connecting to KNOWLIBOT...';
// // // //       });

// // // //       final response = await http
// // // //           .get(Uri.parse(testUrl))
// // // //           .timeout(const Duration(seconds: 10));

// // // //       if (!mounted) return;

// // // //       if (response.statusCode >= 200 &&
// // // //           response.statusCode < 300) {
// // // //         setState(() {
// // // //           _isEsp32Connected = true;
// // // //           _wifiStatus =
// // // //               'Connected to KNOWLIBOT\n'
// // // //               'HTTP Status: ${response.statusCode}';
// // // //           _status = 'ESP32 connected successfully.';
// // // //         });

// // // //         _showMessage('KNOWLIBOT connected successfully.');
// // // //       } else {
// // // //         setState(() {
// // // //           _isEsp32Connected = false;
// // // //           _wifiStatus =
// // // //               'ESP32 responded with an error.\n'
// // // //               'HTTP Status: ${response.statusCode}';
// // // //         });

// // // //         _showMessage('ESP32 responded with an error.');
// // // //       }
// // // //     } on TimeoutException {
// // // //       if (!mounted) return;

// // // //       setState(() {
// // // //         _isEsp32Connected = false;
// // // //         _wifiStatus =
// // // //             'Connection timed out.\n'
// // // //             'Make sure your phone is connected to the ESP32 hotspot.';
// // // //       });

// // // //       _showMessage('Connection timed out.');
// // // //     } catch (e) {
// // // //       if (!mounted) return;

// // // //       setState(() {
// // // //         _isEsp32Connected = false;
// // // //         _wifiStatus =
// // // //             'Connection failed.\n'
// // // //             'Connect to the ESP32 hotspot and try again.';
// // // //       });

// // // //       _showMessage(
// // // //         'Could not connect. Connect to the ESP32 hotspot first.',
// // // //       );
// // // //     } finally {
// // // //       if (!mounted) return;

// // // //       setState(() {
// // // //         _isCheckingConnection = false;
// // // //       });
// // // //     }
// // // //   }

// // // //   void _showMessage(String message) {
// // // //     if (!mounted) return;

// // // //     ScaffoldMessenger.of(context)
// // // //       ..hideCurrentSnackBar()
// // // //       ..showSnackBar(
// // // //         SnackBar(
// // // //           content: Text(message),
// // // //           behavior: SnackBarBehavior.floating,
// // // //         ),
// // // //       );
// // // //   }

// // // //   // ==========================================================
// // // //   // COMMAND HELPERS
// // // //   // ==========================================================

// // // //   bool _needsSeconds(CommandType type) {
// // // //     return type == CommandType.forward ||
// // // //         type == CommandType.backword ||
// // // //         type == CommandType.delay;
// // // //   }

// // // //   String _label(CommandType type) {
// // // //     switch (type) {
// // // //       case CommandType.forward:
// // // //         return 'forward';
// // // //       case CommandType.backword:
// // // //         return 'backword';
// // // //       case CommandType.left:
// // // //         return 'left';
// // // //       case CommandType.right:
// // // //         return 'right';
// // // //       case CommandType.stop:
// // // //         return 'stop';
// // // //       case CommandType.loop:
// // // //         return 'loop';
// // // //       case CommandType.delay:
// // // //         return 'delay';
// // // //     }
// // // //   }

// // // //   IconData _icon(CommandType type) {
// // // //     switch (type) {
// // // //       case CommandType.forward:
// // // //         return Icons.arrow_upward_rounded;
// // // //       case CommandType.backword:
// // // //         return Icons.arrow_downward_rounded;
// // // //       case CommandType.left:
// // // //         return Icons.turn_left_rounded;
// // // //       case CommandType.right:
// // // //         return Icons.turn_right_rounded;
// // // //       case CommandType.stop:
// // // //         return Icons.stop_circle_rounded;
// // // //       case CommandType.loop:
// // // //         return Icons.loop_rounded;
// // // //       case CommandType.delay:
// // // //         return Icons.timer_outlined;
// // // //     }
// // // //   }

// // // //   Color _color(CommandType type) {
// // // //     switch (type) {
// // // //       case CommandType.stop:
// // // //         return const Color(0xFFE84B3C);

// // // //       case CommandType.loop:
// // // //       case CommandType.delay:
// // // //         return const Color(0xFFFFAB19);

// // // //       case CommandType.forward:
// // // //       case CommandType.backword:
// // // //       case CommandType.left:
// // // //       case CommandType.right:
// // // //         return const Color(0xFF4C97FF);
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // AUTO SCROLL
// // // //   // ==========================================================

// // // //   Future<void> _scrollToDropArea() async {
// // // //     if (_isAutoScrolling) return;

// // // //     final BuildContext? dropAreaContext =
// // // //         _dropAreaKey.currentContext;

// // // //     if (dropAreaContext == null) return;

// // // //     _isAutoScrolling = true;

// // // //     try {
// // // //       await Scrollable.ensureVisible(
// // // //         dropAreaContext,
// // // //         duration: const Duration(milliseconds: 500),
// // // //         curve: Curves.easeInOut,
// // // //         alignment: 0.30,
// // // //       );
// // // //     } finally {
// // // //       if (mounted) {
// // // //         _isAutoScrolling = false;
// // // //       }
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // PROGRAM MANAGEMENT
// // // //   // ==========================================================

// // // //   void _insertBlockAt(
// // // //     CommandType type,
// // // //     int index,
// // // //   ) {
// // // //     if (_isExecuting) return;

// // // //     final int safeIndex = index.clamp(
// // // //       0,
// // // //       _program.length,
// // // //     );

// // // //     setState(() {
// // // //       _program.insert(
// // // //         safeIndex,
// // // //         ProgramBlock(
// // // //           id: _nextBlockId++,
// // // //           type: type,

// // // //           // Default seconds value.
// // // //           // User can change it from the Program Drop Area.
// // // //           seconds: 1,
// // // //         ),
// // // //       );

// // // //       _dropInsertIndex = null;
// // // //       _status = '${_label(type)} inserted.';
// // // //     });
// // // //   }

// // // //   void _removeBlock(int id) {
// // // //     if (_isExecuting) return;

// // // //     setState(() {
// // // //       _program.removeWhere(
// // // //         (block) => block.id == id,
// // // //       );

// // // //       _status = 'Block removed.';
// // // //     });
// // // //   }

// // // //   void _clearProgram() {
// // // //     if (_isExecuting) return;

// // // //     setState(() {
// // // //       _program.clear();
// // // //       _activeBlockId = null;
// // // //       _dropInsertIndex = null;
// // // //       _status = 'Program cleared.';
// // // //     });
// // // //   }

// // // //   // ==========================================================
// // // //   // PROGRAM EXECUTION
// // // //   // ==========================================================

// // // //   void _stopExecution() {
// // // //     if (!_isExecuting) return;

// // // //     setState(() {
// // // //       _isExecuting = false;
// // // //       _activeBlockId = null;
// // // //       _status = 'Execution stopped.';
// // // //     });
// // // //   }

// // // //   Future<void> _pause(Duration duration) async {
// // // //     await Future.delayed(duration);
// // // //   }

// // // //   Future<void> _executeProgram() async {
// // // //     if (_isExecuting) return;

// // // //     if (_program.isEmpty) {
// // // //       setState(() {
// // // //         _status =
// // // //             'Please drop at least one block before executing.';
// // // //       });
// // // //       return;
// // // //     }

// // // //     if (!_isEsp32Connected) {
// // // //       _showMessage(
// // // //         'Please connect to the ESP32 before executing.',
// // // //       );

// // // //       setState(() {
// // // //         _status = 'ESP32 is not connected.';
// // // //       });

// // // //       return;
// // // //     }

// // // //     setState(() {
// // // //       _isExecuting = true;
// // // //       _activeBlockId = null;
// // // //       _status = 'Program started.';
// // // //     });

// // // //     final List<ProgramBlock> programSnapshot =
// // // //         List<ProgramBlock>.from(_program);

// // // //     for (final block in programSnapshot) {
// // // //       if (!mounted || !_isExecuting) return;

// // // //       setState(() {
// // // //         _activeBlockId = block.id;
// // // //         _status = 'Executing: ${_label(block.type)}';
// // // //       });

// // // //       switch (block.type) {
// // // //         case CommandType.forward:
// // // //           if (!mounted || !_isExecuting) return;

// // // //           setState(() {
// // // //             _status =
// // // //                 'Moving forward for ${block.seconds} second${block.seconds == 1 ? '' : 's'}...';
// // // //           });

// // // //           await _pause(
// // // //             Duration(seconds: block.seconds),
// // // //           );
// // // //           break;

// // // //         case CommandType.backword:
// // // //           if (!mounted || !_isExecuting) return;

// // // //           setState(() {
// // // //             _status =
// // // //                 'Moving backword for ${block.seconds} second${block.seconds == 1 ? '' : 's'}...';
// // // //           });

// // // //           await _pause(
// // // //             Duration(seconds: block.seconds),
// // // //           );
// // // //           break;

// // // //         case CommandType.left:
// // // //           if (!mounted || !_isExecuting) return;

// // // //           setState(() {
// // // //             _status = 'Turning left...';
// // // //           });

// // // //           await _pause(
// // // //             const Duration(milliseconds: 500),
// // // //           );
// // // //           break;

// // // //         case CommandType.right:
// // // //           if (!mounted || !_isExecuting) return;

// // // //           setState(() {
// // // //             _status = 'Turning right...';
// // // //           });

// // // //           await _pause(
// // // //             const Duration(milliseconds: 500),
// // // //           );
// // // //           break;

// // // //         case CommandType.loop:
// // // //           if (!mounted || !_isExecuting) return;

// // // //           setState(() {
// // // //             _status = 'Executing loop...';
// // // //           });

// // // //           await _pause(
// // // //             const Duration(milliseconds: 500),
// // // //           );
// // // //           break;

// // // //         case CommandType.delay:
// // // //           if (!mounted || !_isExecuting) return;

// // // //           setState(() {
// // // //             _status =
// // // //                 'Waiting ${block.seconds} second${block.seconds == 1 ? '' : 's'}...';
// // // //           });

// // // //           await _pause(
// // // //             Duration(seconds: block.seconds),
// // // //           );
// // // //           break;

// // // //         case CommandType.stop:
// // // //           if (!mounted) return;

// // // //           setState(() {
// // // //             _isExecuting = false;
// // // //             _activeBlockId = null;
// // // //             _status = 'Stop block reached. Program ended.';
// // // //           });

// // // //           return;
// // // //       }

// // // //       if (!mounted || !_isExecuting) return;
// // // //     }

// // // //     if (!mounted || !_isExecuting) return;

// // // //     setState(() {
// // // //       _isExecuting = false;
// // // //       _activeBlockId = null;
// // // //       _status = 'Program completed.';
// // // //     });
// // // //   }

// // // //   // ==========================================================
// // // //   // MAIN BUILD
// // // //   // ==========================================================

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         elevation: 0,
// // // //         backgroundColor: const Color(0xFF7B45D6),
// // // //         foregroundColor: Colors.white,
// // // //         title: const Text(
// // // //           'Robot Commands',
// // // //           style: TextStyle(
// // // //             fontWeight: FontWeight.w800,
// // // //           ),
// // // //         ),
// // // //         actions: [
// // // //           Padding(
// // // //             padding: const EdgeInsets.only(right: 14),
// // // //             child: Center(
// // // //               child: Icon(
// // // //                 _isEsp32Connected
// // // //                     ? Icons.wifi
// // // //                     : Icons.wifi_off,
// // // //                 color: _isEsp32Connected
// // // //                     ? Colors.greenAccent
// // // //                     : Colors.white,
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //       body: SafeArea(
// // // //         child: Center(
// // // //           child: ConstrainedBox(
// // // //             constraints: const BoxConstraints(
// // // //               maxWidth: 540,
// // // //             ),
// // // //             child: SingleChildScrollView(
// // // //               padding: const EdgeInsets.all(18),
// // // //               child: Column(
// // // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                 children: [
// // // //                   _buildWifiCard(),

// // // //                   const SizedBox(height: 22),

// // // //                   const Text(
// // // //                     'Command Blocks',
// // // //                     style: TextStyle(
// // // //                       fontSize: 24,
// // // //                       fontWeight: FontWeight.w800,
// // // //                       color: Color(0xFF293B4D),
// // // //                     ),
// // // //                   ),

// // // //                   const SizedBox(height: 6),

// // // //                   const Text(
// // // //                     'Drag blocks into the drop area to build your program.',
// // // //                     style: TextStyle(
// // // //                       color: Color(0xFF6A7A8D),
// // // //                       fontSize: 15,
// // // //                     ),
// // // //                   ),

// // // //                   const SizedBox(height: 18),

// // // //                   _buildPalette(),

// // // //                   const SizedBox(height: 28),

// // // //                   const Text(
// // // //                     'Program Drop Area',
// // // //                     style: TextStyle(
// // // //                       fontSize: 20,
// // // //                       fontWeight: FontWeight.w800,
// // // //                       color: Color(0xFF293B4D),
// // // //                     ),
// // // //                   ),

// // // //                   const SizedBox(height: 10),

// // // //                   KeyedSubtree(
// // // //                     key: _dropAreaKey,
// // // //                     child: _buildDropArea(),
// // // //                   ),

// // // //                   const SizedBox(height: 18),

// // // //                   _buildActionButtons(),

// // // //                   const SizedBox(height: 14),

// // // //                   _buildStatusCard(),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // WIFI CARD
// // // //   // ==========================================================

// // // //   Widget _buildWifiCard() {
// // // //     final bool connected = _isEsp32Connected;

// // // //     return Container(
// // // //       width: double.infinity,
// // // //       padding: const EdgeInsets.all(16),
// // // //       decoration: BoxDecoration(
// // // //         color: connected
// // // //             ? const Color(0xFFEAF8EF)
// // // //             : Colors.white,
// // // //         borderRadius: BorderRadius.circular(16),
// // // //         border: Border.all(
// // // //           color: connected
// // // //               ? const Color(0xFF91D6A5)
// // // //               : const Color(0xFFD5DFE8),
// // // //         ),
// // // //       ),
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           Row(
// // // //             children: [
// // // //               Icon(
// // // //                 connected
// // // //                     ? Icons.wifi_rounded
// // // //                     : Icons.wifi_off_rounded,
// // // //                 size: 30,
// // // //                 color: connected
// // // //                     ? const Color(0xFF2EAA56)
// // // //                     : const Color(0xFF7C8D9F),
// // // //               ),
// // // //               const SizedBox(width: 12),
// // // //               Expanded(
// // // //                 child: Column(
// // // //                   crossAxisAlignment:
// // // //                       CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     Text(
// // // //                       connected
// // // //                           ? 'KNOWLIBOT Connected'
// // // //                           : 'ESP32 Connection',
// // // //                       style: const TextStyle(
// // // //                         fontSize: 18,
// // // //                         fontWeight: FontWeight.w800,
// // // //                         color: Color(0xFF293B4D),
// // // //                       ),
// // // //                     ),
// // // //                     const SizedBox(height: 4),
// // // //                     Text(
// // // //                       _wifiStatus,
// // // //                       style: const TextStyle(
// // // //                         color: Color(0xFF68798A),
// // // //                         fontSize: 13,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //               if (_isCheckingConnection)
// // // //                 const SizedBox(
// // // //                   width: 22,
// // // //                   height: 22,
// // // //                   child: CircularProgressIndicator(
// // // //                     strokeWidth: 2.5,
// // // //                   ),
// // // //                 ),
// // // //             ],
// // // //           ),

// // // //           const SizedBox(height: 14),

// // // //           Row(
// // // //             children: [
// // // //               Expanded(
// // // //                 child: Text(
// // // //                   'ESP32 IP: 192.168.4.1',
// // // //                   style: TextStyle(
// // // //                     color: Colors.grey.shade700,
// // // //                     fontSize: 13,
// // // //                     fontWeight: FontWeight.w600,
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               ElevatedButton.icon(
// // // //                 onPressed: _isCheckingConnection
// // // //                     ? null
// // // //                     : _connectToEsp32,
// // // //                 icon: const Icon(
// // // //                   Icons.link_rounded,
// // // //                   size: 18,
// // // //                 ),
// // // //                 label: Text(
// // // //                   connected ? 'Reconnect' : 'Connect',
// // // //                 ),
// // // //                 style: ElevatedButton.styleFrom(
// // // //                   backgroundColor: const Color(0xFF7B45D6),
// // // //                   foregroundColor: Colors.white,
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                     horizontal: 14,
// // // //                     vertical: 11,
// // // //                   ),
// // // //                   shape: RoundedRectangleBorder(
// // // //                     borderRadius: BorderRadius.circular(10),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),

// // // //           if (!_isWifiEnabled) ...[
// // // //             const SizedBox(height: 10),
// // // //             Text(
// // // //               'Enable Wi-Fi and connect your phone to the ESP32 hotspot manually.',
// // // //               style: TextStyle(
// // // //                 color: Colors.orange.shade800,
// // // //                 fontSize: 12,
// // // //                 fontWeight: FontWeight.w600,
// // // //               ),
// // // //             ),
// // // //           ],
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // PALETTE
// // // //   // ==========================================================

// // // //   Widget _buildPalette() {
// // // //     return Column(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         for (final type in _paletteBlocks)
// // // //           Padding(
// // // //             padding: const EdgeInsets.only(bottom: 4),
// // // //             child: _buildPaletteBlock(type),
// // // //           ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildPaletteBlock(CommandType type) {
// // // //     return Draggable<CommandType>(
// // // //       data: type,
// // // //       onDragStarted: _scrollToDropArea,
// // // //       feedback: Material(
// // // //         color: Colors.transparent,
// // // //         child: Opacity(
// // // //           opacity: 0.88,
// // // //           child: SizedBox(
// // // //             width: 300,
// // // //             child: _buildCommandBlock(
// // // //               type: type,
// // // //               showTopConnector: false,
// // // //               showBottomConnector: true,
// // // //               showDelete: false,

// // // //               // No seconds dropdown in palette.
// // // //               seconds: null,
// // // //               showSecondsPicker: false,
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //       childWhenDragging: Opacity(
// // // //         opacity: 0.35,
// // // //         child: _buildCommandBlock(
// // // //           type: type,
// // // //           showTopConnector: false,
// // // //           showBottomConnector: true,
// // // //           showDelete: false,

// // // //           // No seconds dropdown in palette.
// // // //           seconds: null,
// // // //           showSecondsPicker: false,
// // // //         ),
// // // //       ),
// // // //       child: _buildCommandBlock(
// // // //         type: type,
// // // //         showTopConnector: false,
// // // //         showBottomConnector: true,
// // // //         showDelete: false,

// // // //         // No seconds dropdown in palette.
// // // //         seconds: null,
// // // //         showSecondsPicker: false,
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // DROP AREA
// // // //   // ==========================================================

// // // //   Widget _buildDropArea() {
// // // //     return DragTarget<CommandType>(
// // // //       onWillAcceptWithDetails: (details) {
// // // //         return !_isExecuting;
// // // //       },
// // // //       onMove: (details) {
// // // //         if (_isExecuting) return;

// // // //         final RenderBox? box =
// // // //             _dropAreaKey.currentContext?.findRenderObject()
// // // //                 as RenderBox?;

// // // //         if (box == null) return;

// // // //         final Offset localPosition =
// // // //             box.globalToLocal(details.offset);

// // // //         const double blockHeight = 61;

// // // //         int insertIndex =
// // // //             ((localPosition.dy - 18) / blockHeight).round();

// // // //         insertIndex = insertIndex.clamp(
// // // //           0,
// // // //           _program.length,
// // // //         );

// // // //         if (_dropInsertIndex != insertIndex) {
// // // //           setState(() {
// // // //             _dropInsertIndex = insertIndex;
// // // //           });
// // // //         }
// // // //       },
// // // //       onLeave: (_) {
// // // //         if (!_isExecuting && mounted) {
// // // //           setState(() {
// // // //             _dropInsertIndex = null;
// // // //           });
// // // //         }
// // // //       },
// // // //       onAcceptWithDetails: (details) {
// // // //         final int index =
// // // //             _dropInsertIndex ?? _program.length;

// // // //         _insertBlockAt(
// // // //           details.data,
// // // //           index,
// // // //         );
// // // //       },
// // // //       builder: (
// // // //         context,
// // // //         candidateData,
// // // //         rejectedData,
// // // //       ) {
// // // //         final bool isHovering =
// // // //             candidateData.isNotEmpty;

// // // //         return AnimatedContainer(
// // // //           duration: const Duration(milliseconds: 150),
// // // //           width: double.infinity,
// // // //           constraints: const BoxConstraints(
// // // //             minHeight: 185,
// // // //           ),
// // // //           padding: const EdgeInsets.fromLTRB(
// // // //             14,
// // // //             18,
// // // //             14,
// // // //             22,
// // // //           ),
// // // //           decoration: BoxDecoration(
// // // //             color: isHovering
// // // //                 ? const Color(0xFFE9F4FF)
// // // //                 : Colors.white,
// // // //             borderRadius: BorderRadius.circular(16),
// // // //             border: Border.all(
// // // //               color: isHovering
// // // //                   ? const Color(0xFF4C97FF)
// // // //                   : const Color(0xFFC8D4E0),
// // // //               width: isHovering ? 2.5 : 2,
// // // //             ),
// // // //           ),
// // // //           child: _program.isEmpty
// // // //               ? _buildEmptyDropArea()
// // // //               : Column(
// // // //                   crossAxisAlignment:
// // // //                       CrossAxisAlignment.start,
// // // //                   children: [
// // // //                     for (
// // // //                       int index = 0;
// // // //                       index < _program.length;
// // // //                       index++
// // // //                     ) ...[
// // // //                       if (_dropInsertIndex == index &&
// // // //                           isHovering)
// // // //                         _buildDropIndicator(),

// // // //                       _buildProgramBlock(
// // // //                         block: _program[index],
// // // //                         index: index,
// // // //                       ),
// // // //                     ],
// // // //                     if (_dropInsertIndex ==
// // // //                             _program.length &&
// // // //                         isHovering)
// // // //                       _buildDropIndicator(),
// // // //                   ],
// // // //                 ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // //   Widget _buildEmptyDropArea() {
// // // //     return const Column(
// // // //       mainAxisSize: MainAxisSize.min,
// // // //       children: [
// // // //         SizedBox(height: 18),
// // // //         Icon(
// // // //           Icons.move_down_rounded,
// // // //           size: 50,
// // // //           color: Color(0xFF4C97FF),
// // // //         ),
// // // //         SizedBox(height: 10),
// // // //         Text(
// // // //           'Drop blocks here',
// // // //           style: TextStyle(
// // // //             fontSize: 19,
// // // //             fontWeight: FontWeight.w800,
// // // //             color: Color(0xFF35465A),
// // // //           ),
// // // //         ),
// // // //         SizedBox(height: 6),
// // // //         Text(
// // // //           'Blocks will connect in the order you drop them.',
// // // //           textAlign: TextAlign.center,
// // // //           style: TextStyle(
// // // //             color: Color(0xFF6D7C8E),
// // // //           ),
// // // //         ),
// // // //         SizedBox(height: 18),
// // // //       ],
// // // //     );
// // // //   }

// // // //   Widget _buildDropIndicator() {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.only(
// // // //         left: 28,
// // // //         top: 2,
// // // //         bottom: 2,
// // // //       ),
// // // //       child: Container(
// // // //         width: 300,
// // // //         height: 8,
// // // //         decoration: BoxDecoration(
// // // //           color: const Color(0xFF4C97FF),
// // // //           borderRadius: BorderRadius.circular(4),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // PROGRAM BLOCK
// // // //   // ==========================================================

// // // //   Widget _buildProgramBlock({
// // // //     required ProgramBlock block,
// // // //     required int index,
// // // //   }) {
// // // //     final bool isFirst = index == 0;
// // // //     final bool isLast = index == _program.length - 1;
// // // //     final bool isActive = _activeBlockId == block.id;

// // // //     return Row(
// // // //       crossAxisAlignment: CrossAxisAlignment.start,
// // // //       children: [
// // // //         SizedBox(
// // // //           width: 28,
// // // //           child: Padding(
// // // //             padding: const EdgeInsets.only(top: 16),
// // // //             child: Text(
// // // //               '${index + 1}',
// // // //               textAlign: TextAlign.center,
// // // //               style: const TextStyle(
// // // //                 color: Color(0xFF7C8D9F),
// // // //                 fontWeight: FontWeight.w800,
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //         Expanded(
// // // //           child: _buildCommandBlock(
// // // //             type: block.type,
// // // //             showTopConnector: !isFirst,
// // // //             showBottomConnector: !isLast,
// // // //             isActive: isActive,
// // // //             showDelete: !_isExecuting,

// // // //             // Seconds dropdown is shown ONLY here,
// // // //             // inside the Program Drop Area.
// // // //             seconds: _needsSeconds(block.type)
// // // //                 ? block.seconds
// // // //                 : null,
// // // //             showSecondsPicker: _needsSeconds(block.type),

// // // //             onDelete: () {
// // // //               _removeBlock(block.id);
// // // //             },

// // // //             onSecondsChanged: (newSeconds) {
// // // //               if (_isExecuting) return;

// // // //               setState(() {
// // // //                 block.seconds = newSeconds;
// // // //               });
// // // //             },
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // COMMAND BLOCK UI
// // // //   // ==========================================================

// // // //   Widget _buildCommandBlock({
// // // //     required CommandType type,
// // // //     required bool showTopConnector,
// // // //     required bool showBottomConnector,
// // // //     bool isActive = false,
// // // //     bool showDelete = false,
// // // //     bool showSecondsPicker = false,
// // // //     int? seconds,
// // // //     VoidCallback? onDelete,
// // // //     ValueChanged<int>? onSecondsChanged,
// // // //   }) {
// // // //     final Color blockColor = _color(type);

// // // //     return Align(
// // // //       alignment: Alignment.centerLeft,
// // // //       child: SizedBox(
// // // //         width: 300,
// // // //         height: 61,
// // // //         child: Stack(
// // // //           clipBehavior: Clip.none,
// // // //           children: [
// // // //             Container(
// // // //               height: 52,
// // // //               width: 300,
// // // //               padding: const EdgeInsets.symmetric(
// // // //                 horizontal: 12,
// // // //                 vertical: 7,
// // // //               ),
// // // //               decoration: BoxDecoration(
// // // //                 color: blockColor,
// // // //                 borderRadius: BorderRadius.circular(7),
// // // //                 border: isActive
// // // //                     ? Border.all(
// // // //                         color: Colors.white,
// // // //                         width: 2.5,
// // // //                       )
// // // //                     : null,
// // // //                 boxShadow: [
// // // //                   BoxShadow(
// // // //                     color: blockColor.withOpacity(0.30),
// // // //                     offset: const Offset(0, 3),
// // // //                     blurRadius: 0,
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //               child: Row(
// // // //                 children: [
// // // //                   Icon(
// // // //                     _icon(type),
// // // //                     color: Colors.white,
// // // //                     size: 20,
// // // //                   ),

// // // //                   const SizedBox(width: 8),

// // // //                   Text(
// // // //                     _label(type),
// // // //                     style: const TextStyle(
// // // //                       color: Colors.white,
// // // //                       fontSize: 15,
// // // //                       fontWeight: FontWeight.w800,
// // // //                     ),
// // // //                   ),

// // // //                   const Spacer(),

// // // //                   // This appears only when called from
// // // //                   // the Program Drop Area.
// // // //                   if (seconds != null &&
// // // //                       showSecondsPicker)
// // // //                     _buildSecondsPicker(
// // // //                       value: seconds,
// // // //                       onChanged: onSecondsChanged,
// // // //                     ),

// // // //                   // "sec" appears only in Program Drop Area.
// // // //                   if (seconds != null &&
// // // //                       showSecondsPicker) ...[
// // // //                     const SizedBox(width: 5),
// // // //                     const Text(
// // // //                       'sec',
// // // //                       style: TextStyle(
// // // //                         color: Colors.white,
// // // //                         fontSize: 13,
// // // //                         fontWeight: FontWeight.w800,
// // // //                       ),
// // // //                     ),
// // // //                   ],

// // // //                   if (showDelete) ...[
// // // //                     const SizedBox(width: 3),
// // // //                     IconButton(
// // // //                       tooltip: 'Remove block',
// // // //                       onPressed: onDelete,
// // // //                       icon: const Icon(
// // // //                         Icons.close_rounded,
// // // //                         color: Colors.white,
// // // //                         size: 18,
// // // //                       ),
// // // //                       padding: EdgeInsets.zero,
// // // //                       constraints: const BoxConstraints(
// // // //                         minWidth: 30,
// // // //                         minHeight: 30,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ],
// // // //               ),
// // // //             ),

// // // //             // Top connector
// // // //             if (showTopConnector)
// // // //               Positioned(
// // // //                 top: 0,
// // // //                 left: 20,
// // // //                 child: Container(
// // // //                   width: 38,
// // // //                   height: 8,
// // // //                   decoration: const BoxDecoration(
// // // //                     color: Color(0xFFF4F7FB),
// // // //                     borderRadius: BorderRadius.only(
// // // //                       bottomLeft: Radius.circular(4),
// // // //                       bottomRight: Radius.circular(4),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //             // Bottom connector
// // // //             if (showBottomConnector)
// // // //               Positioned(
// // // //                 top: 51,
// // // //                 left: 20,
// // // //                 child: Container(
// // // //                   width: 38,
// // // //                   height: 10,
// // // //                   decoration: BoxDecoration(
// // // //                     color: blockColor,
// // // //                     borderRadius: const BorderRadius.only(
// // // //                       bottomLeft: Radius.circular(4),
// // // //                       bottomRight: Radius.circular(4),
// // // //                     ),
// // // //                     boxShadow: [
// // // //                       BoxShadow(
// // // //                         color: blockColor.withOpacity(0.30),
// // // //                         offset: const Offset(0, 3),
// // // //                         blurRadius: 0,
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // SECONDS PICKER
// // // //   // ==========================================================

// // // //   Widget _buildSecondsPicker({
// // // //     required int value,
// // // //     required ValueChanged<int>? onChanged,
// // // //   }) {
// // // //     return Container(
// // // //       height: 28,
// // // //       padding: const EdgeInsets.symmetric(
// // // //         horizontal: 7,
// // // //       ),
// // // //       decoration: BoxDecoration(
// // // //         color: Colors.white,
// // // //         borderRadius: BorderRadius.circular(14),
// // // //       ),
// // // //       child: DropdownButtonHideUnderline(
// // // //         child: DropdownButton<int>(
// // // //           value: value,
// // // //           icon: const Icon(
// // // //             Icons.arrow_drop_down_rounded,
// // // //             color: Color(0xFF573F0C),
// // // //             size: 19,
// // // //           ),
// // // //           dropdownColor: Colors.white,
// // // //           borderRadius: BorderRadius.circular(10),
// // // //           style: const TextStyle(
// // // //             color: Color(0xFF573F0C),
// // // //             fontSize: 13,
// // // //             fontWeight: FontWeight.w800,
// // // //           ),
// // // //           items: List.generate(
// // // //             16,
// // // //             (index) {
// // // //               return DropdownMenuItem<int>(
// // // //                 value: index,
// // // //                 child: Text('$index'),
// // // //               );
// // // //             },
// // // //           ),
// // // //           onChanged: (newValue) {
// // // //             if (newValue != null) {
// // // //               onChanged?.call(newValue);
// // // //             }
// // // //           },
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // ACTION BUTTONS
// // // //   // ==========================================================

// // // //   Widget _buildActionButtons() {
// // // //     return Row(
// // // //       children: [
// // // //         Expanded(
// // // //           child: ElevatedButton.icon(
// // // //             onPressed: _isExecuting
// // // //                 ? null
// // // //                 : _executeProgram,
// // // //             icon: const Icon(
// // // //               Icons.play_arrow_rounded,
// // // //             ),
// // // //             label: const Text('Execute'),
// // // //             style: ElevatedButton.styleFrom(
// // // //               minimumSize: const Size.fromHeight(52),
// // // //               backgroundColor: const Color(0xFF2EAA56),
// // // //               foregroundColor: Colors.white,
// // // //               disabledBackgroundColor:
// // // //                   const Color(0xFFA7DDB7),
// // // //               disabledForegroundColor: Colors.white,
// // // //               textStyle: const TextStyle(
// // // //                 fontSize: 17,
// // // //                 fontWeight: FontWeight.w800,
// // // //               ),
// // // //               shape: RoundedRectangleBorder(
// // // //                 borderRadius: BorderRadius.circular(12),
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ),

// // // //         const SizedBox(width: 10),

// // // //         OutlinedButton.icon(
// // // //           onPressed: _isExecuting
// // // //               ? _stopExecution
// // // //               : _clearProgram,
// // // //           icon: Icon(
// // // //             _isExecuting
// // // //                 ? Icons.stop_rounded
// // // //                 : Icons.delete_outline_rounded,
// // // //           ),
// // // //           label: Text(
// // // //             _isExecuting ? 'Stop' : 'Clear',
// // // //           ),
// // // //           style: OutlinedButton.styleFrom(
// // // //             minimumSize: const Size(112, 52),
// // // //             foregroundColor: _isExecuting
// // // //                 ? const Color(0xFFE84B3C)
// // // //                 : const Color(0xFF536578),
// // // //             side: BorderSide(
// // // //               color: _isExecuting
// // // //                   ? const Color(0xFFE84B3C)
// // // //                   : const Color(0xFFB8C5D2),
// // // //             ),
// // // //             textStyle: const TextStyle(
// // // //               fontSize: 15,
// // // //               fontWeight: FontWeight.w800,
// // // //             ),
// // // //             shape: RoundedRectangleBorder(
// // // //               borderRadius: BorderRadius.circular(12),
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ],
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // STATUS CARD
// // // //   // ==========================================================

// // // //   Widget _buildStatusCard() {
// // // //     return Container(
// // // //       width: double.infinity,
// // // //       padding: const EdgeInsets.all(14),
// // // //       decoration: BoxDecoration(
// // // //         color: _isExecuting
// // // //             ? const Color(0xFFEAF8EF)
// // // //             : Colors.white,
// // // //         borderRadius: BorderRadius.circular(12),
// // // //         border: Border.all(
// // // //           color: _isExecuting
// // // //               ? const Color(0xFF94D9A8)
// // // //               : const Color(0xFFDDE6EE),
// // // //         ),
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           Icon(
// // // //             _isExecuting
// // // //                 ? Icons.play_circle_fill_rounded
// // // //                 : Icons.info_outline_rounded,
// // // //             color: _isExecuting
// // // //                 ? const Color(0xFF2EAA56)
// // // //                 : const Color(0xFF4C97FF),
// // // //           ),

// // // //           const SizedBox(width: 10),

// // // //           Expanded(
// // // //             child: Text(
// // // //               _status,
// // // //               style: const TextStyle(
// // // //                 color: Color(0xFF425467),
// // // //                 fontWeight: FontWeight.w600,
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // import 'dart:async';
// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:wifi_iot/wifi_iot.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   runApp(const KnowliBotApp());
// // }

// // class KnowliBotApp extends StatelessWidget {
// //   const KnowliBotApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Knowli Bot',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         useMaterial3: true,
// //         colorSchemeSeed: Colors.deepPurple,
// //         scaffoldBackgroundColor: const Color(0xfff5f5fa),
// //       ),
// //       home: const ScratchProgramPage(),
// //     );
// //   }
// // }

// // // -----------------------------------------------------------------------------
// // // COMMAND TYPES
// // // -----------------------------------------------------------------------------

// // enum CommandType {
// //   forward,
// //   backward,
// //   left,
// //   right,
// //   stop,
// //   loop,
// //   delay,
// // }

// // extension CommandTypeExtension on CommandType {
// //   String get title {
// //     switch (this) {
// //       case CommandType.forward:
// //         return 'Move Forward';
// //       case CommandType.backward:
// //         return 'Move Backward';
// //       case CommandType.left:
// //         return 'Turn Left';
// //       case CommandType.right:
// //         return 'Turn Right';
// //       case CommandType.stop:
// //         return 'Stop';
// //       case CommandType.loop:
// //         return 'Repeat';
// //       case CommandType.delay:
// //         return 'Delay';
// //     }
// //   }

// //   IconData get icon {
// //     switch (this) {
// //       case CommandType.forward:
// //         return Icons.arrow_upward;
// //       case CommandType.backward:
// //         return Icons.arrow_downward;
// //       case CommandType.left:
// //         return Icons.arrow_back;
// //       case CommandType.right:
// //         return Icons.arrow_forward;
// //       case CommandType.stop:
// //         return Icons.stop;
// //       case CommandType.loop:
// //         return Icons.repeat;
// //       case CommandType.delay:
// //         return Icons.timer;
// //     }
// //   }

// //   Color get color {
// //     switch (this) {
// //       case CommandType.forward:
// //         return Colors.green;
// //       case CommandType.backward:
// //         return Colors.orange;
// //       case CommandType.left:
// //         return Colors.blue;
// //       case CommandType.right:
// //         return Colors.indigo;
// //       case CommandType.stop:
// //         return Colors.red;
// //       case CommandType.loop:
// //         return Colors.purple;
// //       case CommandType.delay:
// //         return Colors.teal;
// //     }
// //   }

// //   bool get requiresSeconds {
// //     return this == CommandType.forward ||
// //         this == CommandType.backward ||
// //         this == CommandType.delay;
// //   }
// // }

// // // -----------------------------------------------------------------------------
// // // PROGRAM BLOCK MODEL
// // // -----------------------------------------------------------------------------

// // class ProgramBlock {
// //   final int id;
// //   final CommandType type;
// //   int seconds;

// //   ProgramBlock({
// //     required this.id,
// //     required this.type,
// //     this.seconds = 1,
// //   });
// // }

// // // -----------------------------------------------------------------------------
// // // MAIN PAGE
// // // -----------------------------------------------------------------------------

// // class ScratchProgramPage extends StatefulWidget {
// //   const ScratchProgramPage({super.key});

// //   @override
// //   State<ScratchProgramPage> createState() => _ScratchProgramPageState();
// // }

// // class _ScratchProgramPageState extends State<ScratchProgramPage> {
// //   // ESP32 configuration
// //   static const String baseUrl = 'http://192.168.4.1';
// //   static const String connectionUrl = '$baseUrl/';
// //   static const String otaUrl = '$baseUrl/update';

// //   // Replace this token with the same token used in your ESP32 firmware.
// //   static const String otaToken =
// //       'change-me-to-something-long-and-random';

// //   // Already-added firmware assets
// //   final Map<int, String> classFirmwareFiles = {
// //     3: 'assets/firmware/class_3.bin',
// //     4: 'assets/firmware/class_4.bin',
// //     5: 'assets/firmware/class_5.bin',
// //     6: 'assets/firmware/class_6.bin',
// //     7: 'assets/firmware/class_7.bin',
// //     8: 'assets/firmware/class_8.bin',
// //     9: 'assets/firmware/class_9.bin',
// //     10: 'assets/firmware/class_10.bin',
// //   };

// //   int selectedClass = 3;

// //   bool isWifiEnabled = false;
// //   bool isEsp32Connected = false;
// //   bool isCheckingConnection = false;
// //   bool isUploadingFirmware = false;
// //   bool isExecuting = false;

// //   double uploadProgress = 0;

// //   String wifiStatus = 'Checking Wi-Fi...';
// //   String status = 'Select a class and upload its firmware.';

// //   final List<ProgramBlock> program = [];

// //   int nextBlockId = 0;

// //   final ScrollController programScrollController = ScrollController();

// //   int? activeBlockId;

// //   // ---------------------------------------------------------------------------
// //   // WIFI CHECK
// //   // ---------------------------------------------------------------------------

// //   Future<void> checkWifiStatus() async {
// //     try {
// //       final enabled = await WiFiForIoTPlugin.isEnabled();

// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = enabled;
// //         wifiStatus = enabled
// //             ? 'Wi-Fi is enabled'
// //             : 'Please enable Wi-Fi on your phone';
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = false;
// //         wifiStatus = 'Unable to check Wi-Fi';
// //       });
// //     }
// //   }

// //   // ---------------------------------------------------------------------------
// //   // ESP32 CONNECTION CHECK
// //   // ---------------------------------------------------------------------------

// //   Future<void> connectToEsp32() async {
// //     if (isCheckingConnection) return;

// //     setState(() {
// //       isCheckingConnection = true;
// //       isEsp32Connected = false;
// //       status = 'Connecting to ESP32...';
// //     });

// //     try {
// //       final response = await http
// //           .get(Uri.parse(connectionUrl))
// //           .timeout(const Duration(seconds: 5));

// //       if (!mounted) return;

// //       if (response.statusCode >= 200 && response.statusCode < 300) {
// //         setState(() {
// //           isEsp32Connected = true;
// //           status = 'ESP32 connected successfully.';
// //           wifiStatus = 'Connected to ESP32 hotspot';
// //         });
// //       } else {
// //         setState(() {
// //           isEsp32Connected = false;
// //           status =
// //               'ESP32 connection failed. Status: ${response.statusCode}';
// //           wifiStatus = 'ESP32 not connected';
// //         });
// //       }
// //     } on TimeoutException {
// //       if (!mounted) return;

// //       setState(() {
// //         isEsp32Connected = false;
// //         status =
// //             'Connection timeout. Make sure your phone is connected to the ESP32 hotspot.';
// //         wifiStatus = 'ESP32 not connected';
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         isEsp32Connected = false;
// //         status =
// //             'Connection failed. Connect to the ESP32 Wi-Fi hotspot first.';
// //         wifiStatus = 'ESP32 not connected';
// //       });
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isCheckingConnection = false;
// //       });
// //     }
// //   }

// //   // ---------------------------------------------------------------------------
// //   // CLASS SELECTION
// //   // ---------------------------------------------------------------------------

// //   void selectClass(int classNumber) {
// //     if (isUploadingFirmware || isExecuting) return;

// //     setState(() {
// //       selectedClass = classNumber;
// //       status =
// //           'Class $classNumber selected. Press Upload Firmware to send its .bin file.';
// //     });
// //   }

// //   // ---------------------------------------------------------------------------
// //   // FIRMWARE UPLOAD
// //   // ---------------------------------------------------------------------------

// //   Future<void> uploadSelectedClassFirmware() async {
// //     if (isUploadingFirmware) return;

// //     if (!isEsp32Connected) {
// //       setState(() {
// //         status = 'Please connect to the ESP32 before uploading firmware.';
// //       });
// //       return;
// //     }

// //     final String? assetPath = classFirmwareFiles[selectedClass];

// //     if (assetPath == null) {
// //       setState(() {
// //         status = 'No firmware asset found for Class $selectedClass.';
// //       });
// //       return;
// //     }

// //     try {
// //       setState(() {
// //         isUploadingFirmware = true;
// //         uploadProgress = 0;
// //         status = 'Loading Class $selectedClass firmware...';
// //       });

// //       final ByteData data = await rootBundle.load(assetPath);

// //       final Uint8List firmwareBytes = data.buffer.asUint8List(
// //         data.offsetInBytes,
// //         data.lengthInBytes,
// //       );

// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0.25;
// //         status =
// //             'Sending Class $selectedClass firmware to ESP32...\n'
// //             'File size: ${firmwareBytes.lengthInBytes} bytes';
// //       });

// //       final request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse(otaUrl),
// //       );

// //       request.headers['X-OTA-Token'] = otaToken;

// //       request.files.add(
// //         http.MultipartFile.fromBytes(
// //           'file',
// //           firmwareBytes,
// //           filename: 'class_$selectedClass.bin',
// //         ),
// //       );

// //       final streamedResponse = await request.send();

// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0.85;
// //         status = 'Waiting for ESP32 response...';
// //       });

// //       final responseBody =
// //           await streamedResponse.stream.bytesToString();

// //       if (!mounted) return;

// //       if (streamedResponse.statusCode >= 200 &&
// //           streamedResponse.statusCode < 300) {
// //         setState(() {
// //           uploadProgress = 1;
// //           status =
// //               'Class $selectedClass firmware uploaded successfully.\n'
// //               '$responseBody';
// //         });
// //       } else {
// //         setState(() {
// //           uploadProgress = 0;
// //           status =
// //               'Firmware upload failed.\n'
// //               'HTTP Status: ${streamedResponse.statusCode}\n'
// //               '$responseBody';
// //         });
// //       }
// //     } on FlutterError catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0;
// //         status =
// //             'Asset loading failed.\n'
// //             'Check the .bin path in pubspec.yaml.\n$e';
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0;
// //         status = 'Firmware upload error:\n$e';
// //       });
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isUploadingFirmware = false;
// //       });
// //     }
// //   }

// //   // ---------------------------------------------------------------------------
// //   // SCRATCH PROGRAM FUNCTIONS
// //   // ---------------------------------------------------------------------------

// //   void addBlock(CommandType type) {
// //     setState(() {
// //       program.add(
// //         ProgramBlock(
// //           id: nextBlockId++,
// //           type: type,
// //           seconds: type == CommandType.delay ? 1 : 1,
// //         ),
// //       );

// //       status = '${type.title} block added to the program.';
// //     });

// //     scrollProgramToBottom();
// //   }

// //   void insertBlockAt(CommandType type, int index) {
// //     setState(() {
// //       program.insert(
// //         index,
// //         ProgramBlock(
// //           id: nextBlockId++,
// //           type: type,
// //           seconds: 1,
// //         ),
// //       );

// //       status = '${type.title} block inserted.';
// //     });
// //   }

// //   void removeBlock(int index) {
// //     if (index < 0 || index >= program.length) return;

// //     setState(() {
// //       final removedBlock = program.removeAt(index);
// //       status = '${removedBlock.type.title} block removed.';
// //     });
// //   }

// //   void clearProgram() {
// //     if (isExecuting) return;

// //     setState(() {
// //       program.clear();
// //       activeBlockId = null;
// //       status = 'Program cleared.';
// //     });
// //   }

// //   Future<void> executeProgram() async {
// //     if (isExecuting) return;

// //     if (program.isEmpty) {
// //       setState(() {
// //         status = 'Add some blocks before executing.';
// //       });
// //       return;
// //     }

// //     setState(() {
// //       isExecuting = true;
// //       activeBlockId = null;
// //       status = 'Executing program...';
// //     });

// //     try {
// //       for (final block in program) {
// //         if (!isExecuting) break;

// //         setState(() {
// //           activeBlockId = block.id;
// //           status = 'Executing: ${block.type.title}';
// //         });

// //         await executeBlock(block);
// //       }

// //       if (!mounted) return;

// //       setState(() {
// //         activeBlockId = null;

// //         if (isExecuting) {
// //           status = 'Program completed.';
// //         } else {
// //           status = 'Program stopped.';
// //         }

// //         isExecuting = false;
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         activeBlockId = null;
// //         isExecuting = false;
// //         status = 'Execution error: $e';
// //       });
// //     }
// //   }

// //   Future<void> executeBlock(ProgramBlock block) async {
// //     switch (block.type) {
// //       case CommandType.forward:
// //         // Add your ESP32 forward command here.
// //         await Future.delayed(
// //           Duration(seconds: block.seconds),
// //         );
// //         break;

// //       case CommandType.backward:
// //         // Add your ESP32 backward command here.
// //         await Future.delayed(
// //           Duration(seconds: block.seconds),
// //         );
// //         break;

// //       case CommandType.left:
// //         // Add your ESP32 left command here.
// //         await Future.delayed(const Duration(seconds: 1));
// //         break;

// //       case CommandType.right:
// //         // Add your ESP32 right command here.
// //         await Future.delayed(const Duration(seconds: 1));
// //         break;

// //       case CommandType.stop:
// //         // Add your ESP32 stop command here.
// //         await Future.delayed(const Duration(seconds: 1));
// //         break;

// //       case CommandType.loop:
// //         // Add loop handling here if required.
// //         await Future.delayed(const Duration(seconds: 1));
// //         break;

// //       case CommandType.delay:
// //         await Future.delayed(
// //           Duration(seconds: block.seconds),
// //         );
// //         break;
// //     }
// //   }

// //   void stopProgram() {
// //     if (!isExecuting) return;

// //     setState(() {
// //       isExecuting = false;
// //       activeBlockId = null;
// //       status = 'Program stopped.';
// //     });
// //   }

// //   void scrollProgramToBottom() {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!programScrollController.hasClients) return;

// //       programScrollController.animateTo(
// //         programScrollController.position.maxScrollExtent,
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeOut,
// //       );
// //     });
// //   }

// //   // ---------------------------------------------------------------------------
// //   // UI
// //   // ---------------------------------------------------------------------------

// //   @override
// //   void initState() {
// //     super.initState();
// //     checkWifiStatus();
// //   }

// //   @override
// //   void dispose() {
// //     programScrollController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Knowli Bot Scratch Programming',
// //           style: TextStyle(fontWeight: FontWeight.bold),
// //         ),
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             onPressed: isCheckingConnection
// //                 ? null
// //                 : connectToEsp32,
// //             icon: isCheckingConnection
// //                 ? const SizedBox(
// //                     width: 20,
// //                     height: 20,
// //                     child: CircularProgressIndicator(
// //                       strokeWidth: 2,
// //                     ),
// //                   )
// //                 : const Icon(Icons.refresh),
// //             tooltip: 'Check ESP32 connection',
// //           ),
// //         ],
// //       ),
// //       body: SafeArea(
// //         child: OrientationBuilder(
// //           builder: (context, orientation) {
// //             return orientation == Orientation.landscape
// //                 ? buildLandscapeLayout()
// //                 : buildPortraitLayout();
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildPortraitLayout() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           buildConnectionCard(),
// //           const SizedBox(height: 16),
// //           buildClassFirmwareCard(),
// //           const SizedBox(height: 16),
// //           SizedBox(
// //             height: 500,
// //             child: buildScratchWorkspace(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildLandscapeLayout() {
// //     return Row(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         SizedBox(
// //           width: 300,
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.all(14),
// //             child: Column(
// //               children: [
// //                 buildConnectionCard(),
// //                 const SizedBox(height: 14),
// //                 buildClassFirmwareCard(),
// //               ],
// //             ),
// //           ),
// //         ),
// //         Expanded(
// //           child: Padding(
// //             padding: const EdgeInsets.fromLTRB(0, 14, 14, 14),
// //             child: buildScratchWorkspace(),
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // CONNECTION CARD
// //   // ---------------------------------------------------------------------------

// //   Widget buildConnectionCard() {
// //     return Card(
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Row(
// //               children: [
// //                 Icon(Icons.wifi, color: Colors.deepPurple),
// //                 SizedBox(width: 8),
// //                 Text(
// //                   'ESP32 Connection',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 14),
// //             Row(
// //               children: [
// //                 Icon(
// //                   isEsp32Connected
// //                       ? Icons.check_circle
// //                       : Icons.cancel,
// //                   color: isEsp32Connected
// //                       ? Colors.green
// //                       : Colors.red,
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: Text(
// //                     isEsp32Connected
// //                         ? 'ESP32 Connected'
// //                         : 'ESP32 Not Connected',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w600,
// //                       color: isEsp32Connected
// //                           ? Colors.green
// //                           : Colors.red,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 6),
// //             Text(
// //               wifiStatus,
// //               style: TextStyle(
// //                 color: Colors.grey.shade700,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton.icon(
// //                 onPressed: isCheckingConnection
// //                     ? null
// //                     : connectToEsp32,
// //                 icon: isCheckingConnection
// //                     ? const SizedBox(
// //                         width: 18,
// //                         height: 18,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                         ),
// //                       )
// //                     : const Icon(Icons.link),
// //                 label: Text(
// //                   isCheckingConnection
// //                       ? 'Checking...'
// //                       : 'Connect to ESP32',
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // CLASS AND FIRMWARE CARD
// //   // ---------------------------------------------------------------------------

// //   Widget buildClassFirmwareCard() {
// //     return Card(
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Row(
// //               children: [
// //                 Icon(
// //                   Icons.school,
// //                   color: Colors.deepPurple,
// //                 ),
// //                 SizedBox(width: 8),
// //                 Text(
// //                   'Class Firmware',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 14),
// //             DropdownButtonFormField<int>(
// //               value: selectedClass,
// //               decoration: const InputDecoration(
// //                 labelText: 'Choose Class',
// //                 border: OutlineInputBorder(),
// //                 prefixIcon: Icon(Icons.class_),
// //               ),
// //               items: List.generate(
// //                 8,
// //                 (index) {
// //                   final classNumber = index + 3;

// //                   return DropdownMenuItem<int>(
// //                     value: classNumber,
// //                     child: Text('Class $classNumber'),
// //                   );
// //                 },
// //               ),
// //               onChanged: isUploadingFirmware
// //                   ? null
// //                   : (value) {
// //                       if (value == null) return;
// //                       selectClass(value);
// //                     },
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               'Selected file:\n${classFirmwareFiles[selectedClass]}',
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: Colors.grey.shade700,
// //               ),
// //             ),
// //             const SizedBox(height: 12),
// //             if (isUploadingFirmware)
// //               Column(
// //                 children: [
// //                   LinearProgressIndicator(
// //                     value: uploadProgress == 0
// //                         ? null
// //                         : uploadProgress,
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     '${(uploadProgress * 100).toInt()}%',
// //                     style: const TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                 ],
// //               ),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton.icon(
// //                 onPressed: isUploadingFirmware
// //                     ? null
// //                     : uploadSelectedClassFirmware,
// //                 icon: isUploadingFirmware
// //                     ? const SizedBox(
// //                         width: 18,
// //                         height: 18,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                         ),
// //                       )
// //                     : const Icon(Icons.upload_file),
// //                 label: Text(
// //                   isUploadingFirmware
// //                       ? 'Uploading...'
// //                       : 'Upload Class $selectedClass Firmware',
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // SCRATCH WORKSPACE
// //   // ---------------------------------------------------------------------------

// //   Widget buildScratchWorkspace() {
// //     return Card(
// //       elevation: 2,
// //       clipBehavior: Clip.antiAlias,
// //       child: Column(
// //         children: [
// //           buildWorkspaceHeader(),
// //           Expanded(
// //             child: Row(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 SizedBox(
// //                   width: 230,
// //                   child: buildCommandPalette(),
// //                 ),
// //                 const VerticalDivider(
// //                   width: 1,
// //                   thickness: 1,
// //                 ),
// //                 Expanded(
// //                   child: buildProgramDropArea(),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           buildWorkspaceBottomBar(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildWorkspaceHeader() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 16,
// //         vertical: 12,
// //       ),
// //       color: Colors.deepPurple,
// //       child: const Row(
// //         children: [
// //           Icon(
// //             Icons.extension,
// //             color: Colors.white,
// //           ),
// //           SizedBox(width: 8),
// //           Text(
// //             'Scratch Program',
// //             style: TextStyle(
// //               color: Colors.white,
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // COMMAND PALETTE
// //   // ---------------------------------------------------------------------------

// //   Widget buildCommandPalette() {
// //     final commands = CommandType.values;

// //     return Container(
// //       color: const Color(0xfffafafa),
// //       padding: const EdgeInsets.all(12),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             'Command Blocks',
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             'Drag blocks into the program area',
// //             style: TextStyle(
// //               fontSize: 11,
// //               color: Colors.grey.shade600,
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Expanded(
// //             child: ListView.separated(
// //               itemCount: commands.length,
// //               separatorBuilder: (_, __) =>
// //                   const SizedBox(height: 8),
// //               itemBuilder: (context, index) {
// //                 final command = commands[index];

// //                 return Draggable<CommandType>(
// //                   data: command,
// //                   feedback: Material(
// //                     color: Colors.transparent,
// //                     child: SizedBox(
// //                       width: 205,
// //                       child: buildCommandBlock(
// //                         type: command,
// //                         showSecondsPicker: false,
// //                         showDelete: false,
// //                       ),
// //                     ),
// //                   ),
// //                   childWhenDragging: Opacity(
// //                     opacity: 0.35,
// //                     child: buildCommandBlock(
// //                       type: command,
// //                       showSecondsPicker: false,
// //                       showDelete: false,
// //                     ),
// //                   ),
// //                   child: buildCommandBlock(
// //                     type: command,
// //                     showSecondsPicker: false,
// //                     showDelete: false,
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // PROGRAM DROP AREA
// //   // ---------------------------------------------------------------------------

// //   Widget buildProgramDropArea() {
// //     return DragTarget<CommandType>(
// //       onWillAcceptWithDetails: (details) => !isExecuting,
// //       onAcceptWithDetails: (details) {
// //         addBlock(details.data);
// //       },
// //       builder: (context, candidateData, rejectedData) {
// //         final isDragging = candidateData.isNotEmpty;

// //         return Container(
// //           color: isDragging
// //               ? Colors.deepPurple.withOpacity(0.06)
// //               : Colors.white,
// //           padding: const EdgeInsets.all(14),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   const Icon(
// //                     Icons.code,
// //                     color: Colors.deepPurple,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   const Text(
// //                     'Program Area',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const Spacer(),
// //                   Text(
// //                     '${program.length} blocks',
// //                     style: TextStyle(
// //                       color: Colors.grey.shade600,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               Expanded(
// //                 child: program.isEmpty
// //                     ? buildEmptyProgramArea(isDragging)
// //                     : ListView.builder(
// //                         controller: programScrollController,
// //                         itemCount: program.length,
// //                         itemBuilder: (context, index) {
// //                           final block = program[index];

// //                           return Padding(
// //                             padding: const EdgeInsets.only(
// //                               bottom: 8,
// //                             ),
// //                             child: buildProgramBlock(
// //                               block: block,
// //                               index: index,
// //                             ),
// //                           );
// //                         },
// //                       ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget buildEmptyProgramArea(bool isDragging) {
// //     return Container(
// //       width: double.infinity,
// //       decoration: BoxDecoration(
// //         border: Border.all(
// //           color: isDragging
// //               ? Colors.deepPurple
// //               : Colors.grey.shade300,
// //           width: 2,
// //         ),
// //         borderRadius: BorderRadius.circular(12),
// //         color: isDragging
// //             ? Colors.deepPurple.withOpacity(0.05)
// //             : Colors.grey.shade50,
// //       ),
// //       child: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.touch_app,
// //               size: 45,
// //               color: isDragging
// //                   ? Colors.deepPurple
// //                   : Colors.grey.shade400,
// //             ),
// //             const SizedBox(height: 10),
// //             Text(
// //               isDragging
// //                   ? 'Drop block here'
// //                   : 'Drag command blocks here',
// //               style: TextStyle(
// //                 color: isDragging
// //                     ? Colors.deepPurple
// //                     : Colors.grey.shade600,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               'Seconds can be changed inside the program',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 color: Colors.grey.shade500,
// //                 fontSize: 11,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // PROGRAM BLOCK
// //   // ---------------------------------------------------------------------------

// //   Widget buildProgramBlock({
// //     required ProgramBlock block,
// //     required int index,
// //   }) {
// //     final isActive = activeBlockId == block.id;

// //     return DragTarget<CommandType>(
// //       onWillAcceptWithDetails: (details) => !isExecuting,
// //       onAcceptWithDetails: (details) {
// //         insertBlockAt(details.data, index);
// //       },
// //       builder: (context, candidateData, rejectedData) {
// //         return AnimatedContainer(
// //           duration: const Duration(milliseconds: 200),
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(12),
// //             boxShadow: isActive
// //                 ? [
// //                     BoxShadow(
// //                       color: Colors.deepPurple.withOpacity(0.35),
// //                       blurRadius: 12,
// //                       spreadRadius: 2,
// //                     ),
// //                   ]
// //                 : null,
// //           ),
// //           child: buildCommandBlock(
// //             type: block.type,
// //             seconds: block.seconds,
// //             showSecondsPicker: block.type.requiresSeconds,
// //             showDelete: true,
// //             isActive: isActive,
// //             onSecondsChanged: (value) {
// //               setState(() {
// //                 block.seconds = value;
// //               });
// //             },
// //             onDelete: () {
// //               removeBlock(index);
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // COMMAND BLOCK WIDGET
// //   // ---------------------------------------------------------------------------

// //   Widget buildCommandBlock({
// //     required CommandType type,
// //     int seconds = 1,
// //     bool showSecondsPicker = false,
// //     bool showDelete = false,
// //     bool isActive = false,
// //     ValueChanged<int>? onSecondsChanged,
// //     VoidCallback? onDelete,
// //   }) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 10,
// //         vertical: 9,
// //       ),
// //       decoration: BoxDecoration(
// //         color: type.color,
// //         borderRadius: BorderRadius.circular(10),
// //         border: isActive
// //             ? Border.all(
// //                 color: Colors.white,
// //                 width: 3,
// //               )
// //             : null,
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(
// //             type.icon,
// //             color: Colors.white,
// //             size: 22,
// //           ),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: Text(
// //               type.title,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 13,
// //               ),
// //             ),
// //           ),

// //           // Seconds picker appears only inside program blocks.
// //           if (showSecondsPicker) ...[
// //             const Text(
// //               'Delay',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 11,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(width: 5),
// //             buildSecondsPicker(
// //               value: seconds,
// //               onChanged: onSecondsChanged,
// //             ),
// //             const SizedBox(width: 4),
// //             const Text(
// //               'sec',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 11,
// //               ),
// //             ),
// //           ],

// //           if (showDelete) ...[
// //             const SizedBox(width: 6),
// //             InkWell(
// //               onTap: isExecuting ? null : onDelete,
// //               borderRadius: BorderRadius.circular(20),
// //               child: const Padding(
// //                 padding: EdgeInsets.all(4),
// //                 child: Icon(
// //                   Icons.close,
// //                   color: Colors.white,
// //                   size: 19,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // SECONDS PICKER: 0 TO 15
// //   // ---------------------------------------------------------------------------

// //   Widget buildSecondsPicker({
// //     required int value,
// //     required ValueChanged<int>? onChanged,
// //   }) {
// //     return Container(
// //       height: 32,
// //       padding: const EdgeInsets.symmetric(horizontal: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<int>(
// //           value: value.clamp(0, 15),
// //           isDense: true,
// //           icon: const Icon(
// //             Icons.arrow_drop_down,
// //             size: 18,
// //           ),
// //           items: List.generate(
// //             16,
// //             (index) {
// //               return DropdownMenuItem<int>(
// //                 value: index,
// //                 child: Text(
// //                   '$index',
// //                   style: const TextStyle(
// //                     fontSize: 12,
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //           onChanged: isExecuting
// //               ? null
// //               : (newValue) {
// //                   if (newValue == null) return;
// //                   onChanged?.call(newValue);
// //                 },
// //         ),
// //       ),
// //     );
// //   }

// //   // ---------------------------------------------------------------------------
// //   // BOTTOM BAR
// //   // ---------------------------------------------------------------------------

// //   Widget buildWorkspaceBottomBar() {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade100,
// //         border: Border(
// //           top: BorderSide(
// //             color: Colors.grey.shade300,
// //           ),
// //         ),
// //       ),
// //       child: Column(
// //         children: [
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Text(
// //               status,
// //               style: const TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: ElevatedButton.icon(
// //                   onPressed: isExecuting
// //                       ? null
// //                       : executeProgram,
// //                   icon: const Icon(Icons.play_arrow),
// //                   label: const Text('Execute'),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: ElevatedButton.icon(
// //                   onPressed: isExecuting
// //                       ? stopProgram
// //                       : null,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.red,
// //                     foregroundColor: Colors.white,
// //                   ),
// //                   icon: const Icon(Icons.stop),
// //                   label: const Text('Stop'),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: OutlinedButton.icon(
// //                   onPressed: isExecuting
// //                       ? null
// //                       : clearProgram,
// //                   icon: const Icon(Icons.delete_outline),
// //                   label: const Text('Clear'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // import 'dart:async';
// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:wifi_iot/wifi_iot.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   runApp(const KnowliBotApp());
// // }

// // class KnowliBotApp extends StatelessWidget {
// //   const KnowliBotApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Knowli Bot',
// //       debugShowCheckedModeBanner: false,
// //       theme: ThemeData(
// //         useMaterial3: true,
// //         colorSchemeSeed: Colors.deepPurple,
// //         scaffoldBackgroundColor: const Color(0xfff5f5fa),
// //       ),
// //       home: const SetupPage(),
// //     );
// //   }
// // }

// // // =============================================================================
// // // SETUP PAGE
// // // =============================================================================

// // class SetupPage extends StatefulWidget {
// //   const SetupPage({super.key});

// //   @override
// //   State<SetupPage> createState() => _SetupPageState();
// // }

// // class _SetupPageState extends State<SetupPage>
// //     with WidgetsBindingObserver {
// //   // ===========================================================================
// //   // ESP32
// //   // ===========================================================================

// //   static const String baseUrl = 'http://192.168.4.1';
// //   static const String otaUrl = '$baseUrl/update';

// //   // Must match the token in your ESP32 firmware.
// //   static const String otaToken =
// //       'change-me-to-something-long-and-random';

// //   // ===========================================================================
// //   // CLASS FIRMWARE FILES
// //   // ===========================================================================

// //   final Map<int, String> classFirmwareFiles = {
// //     3: 'assets/firmware/Shapes_Modified.ino.bin',
// //     4: 'assets/firmware/class_4.bin',
// //     5: 'assets/firmware/class_5.bin',
// //     6: 'assets/firmware/class_6.bin',
// //     7: 'assets/firmware/class_7.bin',
// //     8: 'assets/firmware/class_8.bin',
// //     9: 'assets/firmware/class_9.bin',
// //     10: 'assets/firmware/class_10.bin',
// //   };

// //   int selectedClass = 3;

// //   // ===========================================================================
// //   // STATE
// //   // ===========================================================================

// //   bool isWifiEnabled = false;

// //   // IMPORTANT:
// //   // Same logic as your working second code.
// //   // Wi-Fi enabled = ready to communicate with ESP32 hotspot.
// //   bool get isEsp32Connected => isWifiEnabled;

// //   bool isCheckingConnection = false;
// //   bool isUploadingFirmware = false;

// //   double uploadProgress = 0;

// //   String wifiStatus = 'Checking Wi-Fi...';

// //   String status = 'Connect your phone to the ESP32 hotspot.';

// //   // ===========================================================================
// //   // INIT
// //   // ===========================================================================

// //   @override
// //   void initState() {
// //     super.initState();

// //     WidgetsBinding.instance.addObserver(this);

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       checkWifiStatus();
// //     });
// //   }

// //   // ===========================================================================
// //   // APP LIFECYCLE
// //   // ===========================================================================

// //   @override
// //   void didChangeAppLifecycleState(AppLifecycleState state) {
// //     super.didChangeAppLifecycleState(state);

// //     if (state == AppLifecycleState.resumed) {
// //       checkWifiStatus();
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     super.dispose();
// //   }

// //   // ===========================================================================
// //   // WIFI STATUS
// //   // ===========================================================================

// //   Future<void> checkWifiStatus() async {
// //     try {
// //       final enabled = await WiFiForIoTPlugin.isEnabled();

// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = enabled;

// //         if (enabled) {
// //           wifiStatus = 'Wi-Fi is enabled';

// //           status =
// //               'Wi-Fi is ON ✓\n\n'
// //               'Connect your phone to the ESP32 hotspot.\n\n'
// //               'ESP32 IP:\n'
// //               '192.168.4.1';
// //         } else {
// //           wifiStatus = 'Please enable Wi-Fi';

// //           status =
// //               'Wi-Fi is OFF.\n\n'
// //               'Please enable Wi-Fi and connect to the ESP32 hotspot.';
// //         }

// //         uploadProgress = 0;
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = false;
// //         wifiStatus = 'Unable to check Wi-Fi';
// //         status = 'Unable to check Wi-Fi.\n\n$e';
// //       });
// //     }
// //   }

// //   // ===========================================================================
// //   // CONNECT TO ESP32
// //   // ===========================================================================

// //   // IMPORTANT:
// //   // This does NOT call http.get('/') or '/status'.
// //   //
// //   // It uses the same working logic as your second code:
// //   // Wi-Fi enabled = connected/ready.
// //   //
// //   // Your ESP32 does not need a status endpoint for this.
// //   // ===========================================================================

// //   Future<void> connectToEsp32() async {
// //     if (isCheckingConnection) return;

// //     setState(() {
// //       isCheckingConnection = true;
// //       status = 'Checking Wi-Fi connection...';
// //     });

// //     try {
// //       final enabled = await WiFiForIoTPlugin.isEnabled();

// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = enabled;

// //         if (enabled) {
// //           wifiStatus = 'Connected to ESP32 hotspot';

// //           status =
// //               'ESP32 Connected ✓\n\n'
// //               'Wi-Fi is ready.\n\n'
// //               'You can choose a class and send the BIN file.';
// //         } else {
// //           wifiStatus = 'ESP32 not connected';

// //           status =
// //               'Wi-Fi is OFF.\n\n'
// //               'Please enable Wi-Fi and connect to the ESP32 hotspot.';
// //         }
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = false;
// //         wifiStatus = 'ESP32 not connected';
// //         status = 'Unable to check Wi-Fi.\n\n$e';
// //       });
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isCheckingConnection = false;
// //       });
// //     }
// //   }

// //   // ===========================================================================
// //   // CLASS SELECTION
// //   // ===========================================================================

// //   void selectClass(int? classNumber) {
// //     if (classNumber == null ||
// //         isUploadingFirmware ||
// //         !isEsp32Connected) {
// //       return;
// //     }

// //     setState(() {
// //       selectedClass = classNumber;
// //       uploadProgress = 0;

// //       status =
// //           'Class $classNumber selected.\n\n'
// //           'Press Send BIN to continue.';
// //     });
// //   }

// //   // ===========================================================================
// //   // LOAD FIRMWARE
// //   // ===========================================================================

// //   Future<Uint8List> loadSelectedFirmware() async {
// //     final assetPath = classFirmwareFiles[selectedClass];

// //     if (assetPath == null) {
// //       throw Exception(
// //         'No BIN file found for Class $selectedClass.',
// //       );
// //     }

// //     final ByteData data = await rootBundle.load(assetPath);

// //     final Uint8List firmwareBytes = data.buffer.asUint8List(
// //       data.offsetInBytes,
// //       data.lengthInBytes,
// //     );

// //     if (firmwareBytes.isEmpty) {
// //       throw Exception('Firmware file is empty.');
// //     }

// //     return firmwareBytes;
// //   }

// //   // ===========================================================================
// //   // UPLOAD SELECTED CLASS FIRMWARE
// //   // ===========================================================================

// //   Future<void> uploadSelectedClassFirmware() async {
// //     if (isUploadingFirmware) return;

// //     // IMPORTANT:
// //     // Use Wi-Fi state instead of HTTP connection test.
// //     if (!isEsp32Connected) {
// //       setState(() {
// //         status =
// //             'Please connect your phone to the ESP32 hotspot first.';
// //       });
// //       return;
// //     }

// //     final String? assetPath =
// //         classFirmwareFiles[selectedClass];

// //     if (assetPath == null) {
// //       setState(() {
// //         status =
// //             'No BIN file found for Class $selectedClass.';
// //       });
// //       return;
// //     }

// //     try {
// //       setState(() {
// //         isUploadingFirmware = true;
// //         uploadProgress = 0;
// //         status =
// //             'Loading Class $selectedClass BIN file...\n\n'
// //             '$assetPath';
// //       });

// //       final firmwareBytes = await loadSelectedFirmware();

// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0.2;

// //         status =
// //             'Firmware loaded successfully ✓\n\n'
// //             'Class: $selectedClass\n'
// //             'File: $assetPath\n'
// //             'Size: ${firmwareBytes.length} bytes\n\n'
// //             'Sending BIN to ESP32...';
// //       });

// //       final request = http.MultipartRequest(
// //         'POST',
// //         Uri.parse(otaUrl),
// //       );

// //       // IMPORTANT:
// //       // Keep this only if your ESP32 firmware checks X-OTA-Token.
// //       request.headers['X-OTA-Token'] = otaToken;

// //       request.files.add(
// //         http.MultipartFile.fromBytes(
// //           'file',
// //           firmwareBytes,
// //           filename: 'class_$selectedClass.bin',
// //         ),
// //       );

// //       final streamedResponse = await request.send().timeout(
// //         const Duration(minutes: 5),
// //       );

// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0.85;
// //         status = 'Waiting for ESP32 response...';
// //       });

// //       final responseBody =
// //           await streamedResponse.stream.bytesToString();

// //       if (!mounted) return;

// //       if (streamedResponse.statusCode >= 200 &&
// //           streamedResponse.statusCode < 300) {
// //         setState(() {
// //           uploadProgress = 1;
// //           status =
// //               'Class $selectedClass BIN sent successfully ✓\n\n'
// //               'HTTP: ${streamedResponse.statusCode}\n\n'
// //               'ESP32 response:\n'
// //               '$responseBody';
// //         });

// //         await Future.delayed(
// //           const Duration(milliseconds: 500),
// //         );

// //         if (!mounted) return;

// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(
// //             builder: (_) => ScratchProgramPage(
// //               selectedClass: selectedClass,
// //             ),
// //           ),
// //         );
// //       } else {
// //         setState(() {
// //           uploadProgress = 0;

// //           status =
// //               'BIN upload failed ✗\n\n'
// //               'HTTP Status: ${streamedResponse.statusCode}\n\n'
// //               '$responseBody';
// //         });
// //       }
// //     } on FlutterError catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0;

// //         status =
// //             'Asset loading failed.\n\n'
// //             'Check this path in pubspec.yaml:\n'
// //             '$assetPath\n\n'
// //             '$e';
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         uploadProgress = 0;
// //         status = 'BIN upload error:\n\n$e';
// //       });
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isUploadingFirmware = false;
// //       });
// //     }
// //   }

// //   // ===========================================================================
// //   // UI
// //   // ===========================================================================

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'Knowli Bot Setup',
// //           style: TextStyle(
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: SafeArea(
// //         child: Center(
// //           child: SingleChildScrollView(
// //             padding: const EdgeInsets.all(20),
// //             child: ConstrainedBox(
// //               constraints: const BoxConstraints(
// //                 maxWidth: 500,
// //               ),
// //               child: Column(
// //                 children: [
// //                   buildHeader(),
// //                   const SizedBox(height: 20),
// //                   buildConnectionCard(),
// //                   const SizedBox(height: 16),
// //                   buildClassCard(),
// //                   const SizedBox(height: 16),
// //                   buildStatusCard(),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildHeader() {
// //     return Column(
// //       children: [
// //         Container(
// //           height: 90,
// //           width: 90,
// //           decoration: BoxDecoration(
// //             color: Colors.deepPurple.withValues(alpha: 0.1),
// //             shape: BoxShape.circle,
// //           ),
// //           child: const Icon(
// //             Icons.smart_toy,
// //             size: 52,
// //             color: Colors.deepPurple,
// //           ),
// //         ),
// //         const SizedBox(height: 14),
// //         const Text(
// //           'Welcome to Knowli Bot',
// //           style: TextStyle(
// //             fontSize: 25,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         const SizedBox(height: 6),
// //         Text(
// //           'Connect your ESP32 and select a class',
// //           textAlign: TextAlign.center,
// //           style: TextStyle(
// //             color: Colors.grey.shade600,
// //             fontSize: 14,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   Widget buildConnectionCard() {
// //     return Card(
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.all(18),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Row(
// //               children: [
// //                 Icon(
// //                   Icons.wifi,
// //                   color: Colors.deepPurple,
// //                 ),
// //                 SizedBox(width: 8),
// //                 Text(
// //                   'ESP32 Connection',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             Row(
// //               children: [
// //                 Icon(
// //                   isEsp32Connected
// //                       ? Icons.check_circle
// //                       : Icons.cancel,
// //                   color: isEsp32Connected
// //                       ? Colors.green
// //                       : Colors.red,
// //                 ),
// //                 const SizedBox(width: 8),
// //                 Expanded(
// //                   child: Text(
// //                     isEsp32Connected
// //                         ? 'ESP32 Connected'
// //                         : 'ESP32 Not Connected',
// //                     style: TextStyle(
// //                       fontWeight: FontWeight.w600,
// //                       color: isEsp32Connected
// //                           ? Colors.green
// //                           : Colors.red,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 8),
// //             Text(
// //               wifiStatus,
// //               style: TextStyle(
// //                 color: Colors.grey.shade700,
// //               ),
// //             ),
// //             const SizedBox(height: 14),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton.icon(
// //                 onPressed: isCheckingConnection
// //                     ? null
// //                     : connectToEsp32,
// //                 icon: isCheckingConnection
// //                     ? const SizedBox(
// //                         height: 18,
// //                         width: 18,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                         ),
// //                       )
// //                     : const Icon(Icons.link),
// //                 label: Text(
// //                   isCheckingConnection
// //                       ? 'Checking...'
// //                       : 'Check ESP32 Connection',
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildClassCard() {
// //     return Card(
// //       elevation: 2,
// //       child: Padding(
// //         padding: const EdgeInsets.all(18),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Row(
// //               children: [
// //                 Icon(
// //                   Icons.school,
// //                   color: Colors.deepPurple,
// //                 ),
// //                 SizedBox(width: 8),
// //                 Text(
// //                   'Choose Class',
// //                   style: TextStyle(
// //                     fontSize: 18,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             const SizedBox(height: 16),
// //             DropdownButtonFormField<int>(
// //               value: selectedClass,
// //               decoration: const InputDecoration(
// //                 labelText: 'Select Class',
// //                 border: OutlineInputBorder(),
// //                 prefixIcon: Icon(Icons.class_),
// //               ),
// //               items: List.generate(
// //                 8,
// //                 (index) {
// //                   final classNumber = index + 3;

// //                   return DropdownMenuItem<int>(
// //                     value: classNumber,
// //                     child: Text(
// //                       'Class $classNumber',
// //                     ),
// //                   );
// //                 },
// //               ),
// //               onChanged:
// //                   (!isEsp32Connected || isUploadingFirmware)
// //                       ? null
// //                       : selectClass,
// //             ),
// //             const SizedBox(height: 12),
// //             Text(
// //               'Selected BIN file:',
// //               style: TextStyle(
// //                 fontSize: 12,
// //                 color: Colors.grey.shade600,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               classFirmwareFiles[selectedClass] ??
// //                   'No BIN file found',
// //               style: const TextStyle(
// //                 fontSize: 13,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             if (isUploadingFirmware)
// //               Column(
// //                 children: [
// //                   LinearProgressIndicator(
// //                     value: uploadProgress == 0
// //                         ? null
// //                         : uploadProgress,
// //                   ),
// //                   const SizedBox(height: 8),
// //                   Text(
// //                     '${(uploadProgress * 100).toInt()}%',
// //                     style: const TextStyle(
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 12),
// //                 ],
// //               ),
// //             SizedBox(
// //               width: double.infinity,
// //               child: ElevatedButton.icon(
// //                 onPressed:
// //                     (!isEsp32Connected || isUploadingFirmware)
// //                         ? null
// //                         : uploadSelectedClassFirmware,
// //                 icon: isUploadingFirmware
// //                     ? const SizedBox(
// //                         height: 18,
// //                         width: 18,
// //                         child: CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                           color: Colors.white,
// //                         ),
// //                       )
// //                     : const Icon(Icons.upload_file),
// //                 label: Text(
// //                   isUploadingFirmware
// //                       ? 'Sending BIN...'
// //                       : 'Send BIN & Continue',
// //                 ),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Colors.deepPurple,
// //                   foregroundColor: Colors.white,
// //                   padding: const EdgeInsets.symmetric(
// //                     vertical: 14,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildStatusCard() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.all(14),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(12),
// //       ),
// //       child: Row(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Icon(
// //             Icons.info_outline,
// //             color: Colors.deepPurple,
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Text(
// //               status,
// //               style: const TextStyle(
// //                 fontSize: 13,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // =============================================================================
// // // COMMAND TYPES
// // // =============================================================================

// // enum CommandType {
// //   forward,
// //   backward,
// //   left,
// //   right,
// //   stop,
// //   loop,
// //   delay,
// // }

// // extension CommandTypeExtension on CommandType {
// //   String get title {
// //     switch (this) {
// //       case CommandType.forward:
// //         return 'Move Forward';
// //       case CommandType.backward:
// //         return 'Move Backward';
// //       case CommandType.left:
// //         return 'Turn Left';
// //       case CommandType.right:
// //         return 'Turn Right';
// //       case CommandType.stop:
// //         return 'Stop';
// //       case CommandType.loop:
// //         return 'Repeat';
// //       case CommandType.delay:
// //         return 'Delay';
// //     }
// //   }

// //   IconData get icon {
// //     switch (this) {
// //       case CommandType.forward:
// //         return Icons.arrow_upward;
// //       case CommandType.backward:
// //         return Icons.arrow_downward;
// //       case CommandType.left:
// //         return Icons.arrow_back;
// //       case CommandType.right:
// //         return Icons.arrow_forward;
// //       case CommandType.stop:
// //         return Icons.stop;
// //       case CommandType.loop:
// //         return Icons.repeat;
// //       case CommandType.delay:
// //         return Icons.timer;
// //     }
// //   }

// //   Color get color {
// //     switch (this) {
// //       case CommandType.forward:
// //         return Colors.green;
// //       case CommandType.backward:
// //         return Colors.orange;
// //       case CommandType.left:
// //         return Colors.blue;
// //       case CommandType.right:
// //         return Colors.indigo;
// //       case CommandType.stop:
// //         return Colors.red;
// //       case CommandType.loop:
// //         return Colors.purple;
// //       case CommandType.delay:
// //         return Colors.teal;
// //     }
// //   }

// //   bool get requiresSeconds {
// //     return this == CommandType.forward ||
// //         this == CommandType.backward ||
// //         this == CommandType.delay;
// //   }
// // }

// // // =============================================================================
// // // PROGRAM BLOCK MODEL
// // // =============================================================================

// // class ProgramBlock {
// //   final int id;
// //   final CommandType type;
// //   int seconds;

// //   ProgramBlock({
// //     required this.id,
// //     required this.type,
// //     this.seconds = 1,
// //   });
// // }

// // // =============================================================================
// // // SCRATCH PROGRAM PAGE
// // // =============================================================================

// // class ScratchProgramPage extends StatefulWidget {
// //   final int selectedClass;

// //   const ScratchProgramPage({
// //     super.key,
// //     required this.selectedClass,
// //   });

// //   @override
// //   State<ScratchProgramPage> createState() =>
// //       _ScratchProgramPageState();
// // }

// // class _ScratchProgramPageState
// //     extends State<ScratchProgramPage> {
// //   bool isExecuting = false;

// //   double uploadProgress = 0;

// //   String status = 'Create your Scratch program.';

// //   final List<ProgramBlock> program = [];

// //   int nextBlockId = 0;

// //   final ScrollController programScrollController =
// //       ScrollController();

// //   int? activeBlockId;

// //   // ===========================================================================
// //   // PROGRAM FUNCTIONS
// //   // ===========================================================================

// //   void addBlock(CommandType type) {
// //     setState(() {
// //       program.add(
// //         ProgramBlock(
// //           id: nextBlockId++,
// //           type: type,
// //           seconds: 1,
// //         ),
// //       );

// //       status = '${type.title} block added.';
// //     });

// //     scrollProgramToBottom();
// //   }

// //   void insertBlockAt(CommandType type, int index) {
// //     setState(() {
// //       final safeIndex =
// //           index.clamp(0, program.length).toInt();

// //       program.insert(
// //         safeIndex,
// //         ProgramBlock(
// //           id: nextBlockId++,
// //           type: type,
// //           seconds: 1,
// //         ),
// //       );

// //       status = '${type.title} block inserted.';
// //     });
// //   }

// //   void removeBlock(int index) {
// //     if (index < 0 || index >= program.length) return;

// //     setState(() {
// //       final removedBlock = program.removeAt(index);

// //       status = '${removedBlock.type.title} block removed.';
// //     });
// //   }

// //   void clearProgram() {
// //     if (isExecuting) return;

// //     setState(() {
// //       program.clear();
// //       activeBlockId = null;
// //       status = 'Program cleared.';
// //     });
// //   }

// //   // ===========================================================================
// //   // EXECUTION
// //   // ===========================================================================

// //   Future<void> executeProgram() async {
// //     if (isExecuting) return;

// //     if (program.isEmpty) {
// //       setState(() {
// //         status = 'Add some blocks before executing.';
// //       });
// //       return;
// //     }

// //     setState(() {
// //       isExecuting = true;
// //       activeBlockId = null;
// //       status =
// //           'Executing Class ${widget.selectedClass} program...';
// //     });

// //     try {
// //       for (final block in program) {
// //         if (!isExecuting) break;

// //         setState(() {
// //           activeBlockId = block.id;
// //           status = 'Executing: ${block.type.title}';
// //         });

// //         await executeBlock(block);
// //       }

// //       if (!mounted) return;

// //       setState(() {
// //         activeBlockId = null;

// //         status = isExecuting
// //             ? 'Program completed.'
// //             : 'Program stopped.';

// //         isExecuting = false;
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         activeBlockId = null;
// //         isExecuting = false;
// //         status = 'Execution error: $e';
// //       });
// //     }
// //   }

// //   Future<void> executeBlock(ProgramBlock block) async {
// //     switch (block.type) {
// //       case CommandType.forward:
// //         // TODO: Send forward command to ESP32.
// //         await Future.delayed(
// //           Duration(seconds: block.seconds),
// //         );
// //         break;

// //       case CommandType.backward:
// //         // TODO: Send backward command to ESP32.
// //         await Future.delayed(
// //           Duration(seconds: block.seconds),
// //         );
// //         break;

// //       case CommandType.left:
// //         // TODO: Send left command to ESP32.
// //         await Future.delayed(
// //           const Duration(seconds: 1),
// //         );
// //         break;

// //       case CommandType.right:
// //         // TODO: Send right command to ESP32.
// //         await Future.delayed(
// //           const Duration(seconds: 1),
// //         );
// //         break;

// //       case CommandType.stop:
// //         // TODO: Send stop command to ESP32.
// //         await Future.delayed(
// //           const Duration(seconds: 1),
// //         );
// //         break;

// //       case CommandType.loop:
// //         // TODO: Add loop handling.
// //         await Future.delayed(
// //           const Duration(seconds: 1),
// //         );
// //         break;

// //       case CommandType.delay:
// //         await Future.delayed(
// //           Duration(seconds: block.seconds),
// //         );
// //         break;
// //     }
// //   }

// //   void stopProgram() {
// //     if (!isExecuting) return;

// //     setState(() {
// //       isExecuting = false;
// //       activeBlockId = null;
// //       status = 'Program stopped.';
// //     });
// //   }

// //   void scrollProgramToBottom() {
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       if (!programScrollController.hasClients) return;

// //       programScrollController.animateTo(
// //         programScrollController.position.maxScrollExtent,
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.easeOut,
// //       );
// //     });
// //   }

// //   // ===========================================================================
// //   // UI
// //   // ===========================================================================

// //   @override
// //   void dispose() {
// //     programScrollController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           'Class ${widget.selectedClass} Scratch Programming',
// //           style: const TextStyle(
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         centerTitle: true,
// //         actions: [
// //           IconButton(
// //             tooltip: 'Change Class',
// //             onPressed: isExecuting
// //                 ? null
// //                 : () {
// //                     Navigator.pushReplacement(
// //                       context,
// //                       MaterialPageRoute(
// //                         builder: (_) => const SetupPage(),
// //                       ),
// //                     );
// //                   },
// //             icon: const Icon(Icons.school),
// //           ),
// //         ],
// //       ),
// //       body: SafeArea(
// //         child: OrientationBuilder(
// //           builder: (context, orientation) {
// //             return orientation == Orientation.landscape
// //                 ? buildLandscapeLayout()
// //                 : buildPortraitLayout();
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildPortraitLayout() {
// //     return SingleChildScrollView(
// //       padding: const EdgeInsets.all(16),
// //       child: Column(
// //         children: [
// //           SizedBox(
// //             height: 500,
// //             child: buildScratchWorkspace(),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildLandscapeLayout() {
// //     return Padding(
// //       padding: const EdgeInsets.all(14),
// //       child: buildScratchWorkspace(),
// //     );
// //   }

// //   // ===========================================================================
// //   // SCRATCH WORKSPACE
// //   // ===========================================================================

// //   Widget buildScratchWorkspace() {
// //     return Card(
// //       elevation: 2,
// //       clipBehavior: Clip.antiAlias,
// //       child: Column(
// //         children: [
// //           buildWorkspaceHeader(),
// //           Expanded(
// //             child: Row(
// //               crossAxisAlignment: CrossAxisAlignment.stretch,
// //               children: [
// //                 SizedBox(
// //                   width: 230,
// //                   child: buildCommandPalette(),
// //                 ),
// //                 const VerticalDivider(
// //                   width: 1,
// //                   thickness: 1,
// //                 ),
// //                 Expanded(
// //                   child: buildProgramDropArea(),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           buildWorkspaceBottomBar(),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget buildWorkspaceHeader() {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 16,
// //         vertical: 12,
// //       ),
// //       color: Colors.deepPurple,
// //       child: Row(
// //         children: [
// //           const Icon(
// //             Icons.extension,
// //             color: Colors.white,
// //           ),
// //           const SizedBox(width: 8),
// //           Text(
// //             'Scratch Program - Class ${widget.selectedClass}',
// //             style: const TextStyle(
// //               color: Colors.white,
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ===========================================================================
// //   // COMMAND PALETTE
// //   // ===========================================================================

// //   Widget buildCommandPalette() {
// //     final commands = CommandType.values;

// //     return Container(
// //       color: const Color(0xfffafafa),
// //       padding: const EdgeInsets.all(12),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             'Command Blocks',
// //             style: TextStyle(
// //               fontSize: 16,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             'Drag blocks into the program area',
// //             style: TextStyle(
// //               fontSize: 11,
// //               color: Colors.grey.shade600,
// //             ),
// //           ),
// //           const SizedBox(height: 12),
// //           Expanded(
// //             child: ListView.separated(
// //               itemCount: commands.length,
// //               separatorBuilder: (_, __) =>
// //                   const SizedBox(height: 8),
// //               itemBuilder: (context, index) {
// //                 final command = commands[index];

// //                 return Draggable<CommandType>(
// //                   data: command,
// //                   feedback: Material(
// //                     color: Colors.transparent,
// //                     child: SizedBox(
// //                       width: 205,
// //                       child: buildCommandBlock(
// //                         type: command,
// //                         showSecondsPicker: false,
// //                         showDelete: false,
// //                       ),
// //                     ),
// //                   ),
// //                   childWhenDragging: Opacity(
// //                     opacity: 0.35,
// //                     child: buildCommandBlock(
// //                       type: command,
// //                       showSecondsPicker: false,
// //                       showDelete: false,
// //                     ),
// //                   ),
// //                   child: buildCommandBlock(
// //                     type: command,
// //                     showSecondsPicker: false,
// //                     showDelete: false,
// //                   ),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // ===========================================================================
// //   // PROGRAM DROP AREA
// //   // ===========================================================================

// //   Widget buildProgramDropArea() {
// //     return DragTarget<CommandType>(
// //       onWillAcceptWithDetails: (details) => !isExecuting,
// //       onAcceptWithDetails: (details) {
// //         addBlock(details.data);
// //       },
// //       builder: (context, candidateData, rejectedData) {
// //         final isDragging = candidateData.isNotEmpty;

// //         return Container(
// //           color: isDragging
// //               ? Colors.deepPurple.withOpacity(0.06)
// //               : Colors.white,
// //           padding: const EdgeInsets.all(14),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 children: [
// //                   const Icon(
// //                     Icons.code,
// //                     color: Colors.deepPurple,
// //                   ),
// //                   const SizedBox(width: 8),
// //                   const Text(
// //                     'Program Area',
// //                     style: TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const Spacer(),
// //                   Text(
// //                     '${program.length} blocks',
// //                     style: TextStyle(
// //                       color: Colors.grey.shade600,
// //                       fontSize: 12,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               Expanded(
// //                 child: program.isEmpty
// //                     ? buildEmptyProgramArea(isDragging)
// //                     : ListView.builder(
// //                         controller: programScrollController,
// //                         itemCount: program.length,
// //                         itemBuilder: (context, index) {
// //                           final block = program[index];

// //                           return Padding(
// //                             padding: const EdgeInsets.only(
// //                               bottom: 8,
// //                             ),
// //                             child: buildProgramBlock(
// //                               block: block,
// //                               index: index,
// //                             ),
// //                           );
// //                         },
// //                       ),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget buildEmptyProgramArea(bool isDragging) {
// //     return Container(
// //       width: double.infinity,
// //       decoration: BoxDecoration(
// //         border: Border.all(
// //           color: isDragging
// //               ? Colors.deepPurple
// //               : Colors.grey.shade300,
// //           width: 2,
// //         ),
// //         borderRadius: BorderRadius.circular(12),
// //         color: isDragging
// //             ? Colors.deepPurple.withOpacity(0.05)
// //             : Colors.grey.shade50,
// //       ),
// //       child: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               Icons.touch_app,
// //               size: 45,
// //               color: isDragging
// //                   ? Colors.deepPurple
// //                   : Colors.grey.shade400,
// //             ),
// //             const SizedBox(height: 10),
// //             Text(
// //               isDragging
// //                   ? 'Drop block here'
// //                   : 'Drag command blocks here',
// //               style: TextStyle(
// //                 color: isDragging
// //                     ? Colors.deepPurple
// //                     : Colors.grey.shade600,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               'Seconds can be changed inside the program',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 color: Colors.grey.shade500,
// //                 fontSize: 11,
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ===========================================================================
// //   // PROGRAM BLOCK
// //   // ===========================================================================

// //   Widget buildProgramBlock({
// //     required ProgramBlock block,
// //     required int index,
// //   }) {
// //     final isActive = activeBlockId == block.id;

// //     return DragTarget<CommandType>(
// //       onWillAcceptWithDetails: (details) => !isExecuting,
// //       onAcceptWithDetails: (details) {
// //         insertBlockAt(details.data, index);
// //       },
// //       builder: (context, candidateData, rejectedData) {
// //         return AnimatedContainer(
// //           duration: const Duration(milliseconds: 200),
// //           decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(12),
// //             boxShadow: isActive
// //                 ? [
// //                     BoxShadow(
// //                       color: Colors.deepPurple.withOpacity(0.35),
// //                       blurRadius: 12,
// //                       spreadRadius: 2,
// //                     ),
// //                   ]
// //                 : null,
// //           ),
// //           child: buildCommandBlock(
// //             type: block.type,
// //             seconds: block.seconds,
// //             showSecondsPicker: block.type.requiresSeconds,
// //             showDelete: true,
// //             isActive: isActive,
// //             onSecondsChanged: (value) {
// //               setState(() {
// //                 block.seconds = value;
// //               });
// //             },
// //             onDelete: () {
// //               removeBlock(index);
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   // ===========================================================================
// //   // COMMAND BLOCK WIDGET
// //   // ===========================================================================

// //   Widget buildCommandBlock({
// //     required CommandType type,
// //     int seconds = 1,
// //     bool showSecondsPicker = false,
// //     bool showDelete = false,
// //     bool isActive = false,
// //     ValueChanged<int>? onSecondsChanged,
// //     VoidCallback? onDelete,
// //   }) {
// //     return Container(
// //       width: double.infinity,
// //       padding: const EdgeInsets.symmetric(
// //         horizontal: 10,
// //         vertical: 9,
// //       ),
// //       decoration: BoxDecoration(
// //         color: type.color,
// //         borderRadius: BorderRadius.circular(10),
// //         border: isActive
// //             ? Border.all(
// //                 color: Colors.white,
// //                 width: 3,
// //               )
// //             : null,
// //       ),
// //       child: Row(
// //         children: [
// //           Icon(
// //             type.icon,
// //             color: Colors.white,
// //             size: 22,
// //           ),
// //           const SizedBox(width: 8),
// //           Expanded(
// //             child: Text(
// //               type.title,
// //               style: const TextStyle(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 13,
// //               ),
// //             ),
// //           ),
// //           if (showSecondsPicker) ...[
// //             const Text(
// //               'Delay',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 11,
// //                 fontWeight: FontWeight.w600,
// //               ),
// //             ),
// //             const SizedBox(width: 5),
// //             buildSecondsPicker(
// //               value: seconds,
// //               onChanged: onSecondsChanged,
// //             ),
// //             const SizedBox(width: 4),
// //             const Text(
// //               'sec',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 11,
// //               ),
// //             ),
// //           ],
// //           if (showDelete) ...[
// //             const SizedBox(width: 6),
// //             InkWell(
// //               onTap: isExecuting ? null : onDelete,
// //               borderRadius: BorderRadius.circular(20),
// //               child: const Padding(
// //                 padding: EdgeInsets.all(4),
// //                 child: Icon(
// //                   Icons.close,
// //                   color: Colors.white,
// //                   size: 19,
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ],
// //       ),
// //     );
// //   }

// //   // ===========================================================================
// //   // SECONDS PICKER: 0 TO 15
// //   // ===========================================================================

// //   Widget buildSecondsPicker({
// //     required int value,
// //     required ValueChanged<int>? onChanged,
// //   }) {
// //     return Container(
// //       height: 32,
// //       padding: const EdgeInsets.symmetric(horizontal: 4),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(6),
// //       ),
// //       child: DropdownButtonHideUnderline(
// //         child: DropdownButton<int>(
// //           value: value.clamp(0, 15).toInt(),
// //           isDense: true,
// //           icon: const Icon(
// //             Icons.arrow_drop_down,
// //             size: 18,
// //           ),
// //           items: List.generate(
// //             16,
// //             (index) {
// //               return DropdownMenuItem<int>(
// //                 value: index,
// //                 child: Text(
// //                   '$index',
// //                   style: const TextStyle(
// //                     fontSize: 12,
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //           onChanged: isExecuting
// //               ? null
// //               : (newValue) {
// //                   if (newValue == null) return;
// //                   onChanged?.call(newValue);
// //                 },
// //         ),
// //       ),
// //     );
// //   }

// //   // ===========================================================================
// //   // BOTTOM BAR
// //   // ===========================================================================

// //   Widget buildWorkspaceBottomBar() {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         color: Colors.grey.shade100,
// //         border: Border(
// //           top: BorderSide(
// //             color: Colors.grey.shade300,
// //           ),
// //         ),
// //       ),
// //       child: Column(
// //         children: [
// //           Container(
// //             width: double.infinity,
// //             padding: const EdgeInsets.all(10),
// //             decoration: BoxDecoration(
// //               color: Colors.white,
// //               borderRadius: BorderRadius.circular(8),
// //             ),
// //             child: Text(
// //               status,
// //               style: const TextStyle(
// //                 fontSize: 12,
// //                 fontWeight: FontWeight.w500,
// //               ),
// //             ),
// //           ),
// //           const SizedBox(height: 10),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: ElevatedButton.icon(
// //                   onPressed:
// //                       isExecuting ? null : executeProgram,
// //                   icon: const Icon(Icons.play_arrow),
// //                   label: const Text('Execute'),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: ElevatedButton.icon(
// //                   onPressed:
// //                       isExecuting ? stopProgram : null,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.red,
// //                     foregroundColor: Colors.white,
// //                   ),
// //                   icon: const Icon(Icons.stop),
// //                   label: const Text('Stop'),
// //                 ),
// //               ),
// //               const SizedBox(width: 8),
// //               Expanded(
// //                 child: OutlinedButton.icon(
// //                   onPressed:
// //                       isExecuting ? null : clearProgram,
// //                   icon: const Icon(Icons.delete_outline),
// //                   label: const Text('Clear'),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// import 'package:esp32/scratchprogramm.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:wifi_iot/wifi_iot.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const KnowliBotApp());
// }

// class KnowliBotApp extends StatelessWidget {
//   const KnowliBotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Knowli Bot',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xfff5f5fa),
//       ),
//       home: const SetupPage(),
//       // home: const ScratchProgramPage(selectedClass: 3,),
//     );
//   }
// }

// // =============================================================================
// // SETUP PAGE
// // =============================================================================

// class SetupPage extends StatefulWidget {
//   const SetupPage({super.key});

//   @override
//   State<SetupPage> createState() => _SetupPageState();
// }

// class _SetupPageState extends State<SetupPage> with WidgetsBindingObserver {

//   static const String baseUrl = 'http://192.168.4.1';
//   static const String otaUrl = '$baseUrl/update';

//   // Must match the token in your ESP32 firmware.
//   static const String otaToken = 'change-me-to-something-long-and-random';

//   // ===========================================================================
//   // CLASS FIRMWARE FILES
//   // ===========================================================================

//   final Map<int, String> classFirmwareFiles = {
//     3: 'assets/firmware/Shapes_Modified_3.ino.bin',
//     4: 'assets/firmware/class_4.bin',
//     5: 'assets/firmware/class_5.bin',
//     6: 'assets/firmware/class_6.bin',
//     7: 'assets/firmware/class_7.bin',
//     8: 'assets/firmware/class_8.bin',
//     9: 'assets/firmware/class_9.bin',
//     10: 'assets/firmware/class_10.bin',
//   };

//   int selectedClass = 3;

//   // ===========================================================================
//   // STATE
//   // ===========================================================================

//   bool isWifiEnabled = false;

//   bool get isEsp32Connected => isWifiEnabled;

//   bool isCheckingConnection = false;
//   bool isUploadingFirmware = false;

//   double uploadProgress = 0;

//   String wifiStatus = 'Checking Wi-Fi...';

//   String status = 'Connect your phone to the ESP32 hotspot.';

//   // ===========================================================================
//   // INIT
//   // ===========================================================================

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addObserver(this);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       checkWifiStatus();
//     });
//   }

//   // ===========================================================================
//   // APP LIFECYCLE
//   // ===========================================================================

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);

//     if (state == AppLifecycleState.resumed) {
//       checkWifiStatus();
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   // ===========================================================================
//   // WIFI STATUS
//   // ===========================================================================

//   Future<void> checkWifiStatus() async {
//     try {
//       final enabled = await WiFiForIoTPlugin.isEnabled();

//       if (!mounted) return;

//       setState(() {
//         isWifiEnabled = enabled;

//         if (enabled) {
//           wifiStatus = 'Wi-Fi is enabled';

//           status =
//               'Wi-Fi is ON ✓\n\n'
//               'Connect your phone to the ESP32 hotspot.\n\n'
//               'ESP32 IP:\n'
//               '192.168.4.1';
//         } else {
//           wifiStatus = 'Please enable Wi-Fi';

//           status =
//               'Wi-Fi is OFF.\n\n'
//               'Please enable Wi-Fi and connect to '
//               'the ESP32 hotspot.';
//         }

//         uploadProgress = 0;
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         isWifiEnabled = false;
//         wifiStatus = 'Unable to check Wi-Fi';
//         status = 'Unable to check Wi-Fi.\n\n$e';
//       });
//     }
//   }

//   // ===========================================================================
//   // CONNECT TO ESP32
//   // ===========================================================================

//   Future<void> connectToEsp32() async {
//     if (isCheckingConnection) return;

//     setState(() {
//       isCheckingConnection = true;
//       status = 'Checking Wi-Fi connection...';
//     });

//     try {
//       final enabled = await WiFiForIoTPlugin.isEnabled();

//       if (!mounted) return;

//       setState(() {
//         isWifiEnabled = enabled;

//         if (enabled) {
//           wifiStatus = 'Connected to ESP32 hotspot';

//           status =
//               'ESP32 Connected ✓\n\n'
//               'Wi-Fi is ready.\n\n'
//               'You can choose a class and send '
//               'the BIN file.';
//         } else {
//           wifiStatus = 'ESP32 not connected';

//           status =
//               'Wi-Fi is OFF.\n\n'
//               'Please enable Wi-Fi and connect to '
//               'the ESP32 hotspot.';
//         }
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         isWifiEnabled = false;
//         wifiStatus = 'ESP32 not connected';
//         status = 'Unable to check Wi-Fi.\n\n$e';
//       });
//     } finally {
//       // ignore: control_flow_in_finally
//       if (!mounted) return;

//       setState(() {
//         isCheckingConnection = false;
//       });
//     }
//   }

//   // ===========================================================================
//   // CLASS SELECTION
//   // ===========================================================================

//   void selectClass(int? classNumber) {
//     if (classNumber == null || isUploadingFirmware || !isEsp32Connected) {
//       return;
//     }

//     setState(() {
//       selectedClass = classNumber;
//       uploadProgress = 0;

//       status =
//           'Class $classNumber selected.\n\n'
//           'Press Send BIN to continue.';
//     });
//   }

//   // ===========================================================================
//   // LOAD FIRMWARE
//   // ===========================================================================

//   Future<Uint8List> loadSelectedFirmware() async {
//     final assetPath = classFirmwareFiles[selectedClass];

//     if (assetPath == null) {
//       throw Exception('No BIN file found for Class $selectedClass.');
//     }

//     final ByteData data = await rootBundle.load(assetPath);

//     final Uint8List firmwareBytes = data.buffer.asUint8List(
//       data.offsetInBytes,
//       data.lengthInBytes,
//     );

//     if (firmwareBytes.isEmpty) {
//       throw Exception('Firmware file is empty.');
//     }

//     return firmwareBytes;
//   }

//   // ===========================================================================
//   // UPLOAD SELECTED CLASS FIRMWARE
//   // ===========================================================================

//   Future<void> uploadSelectedClassFirmware() async {
//     if (isUploadingFirmware) return;

//     if (!isEsp32Connected) {
//       setState(() {
//         status =
//             'Please connect your phone to the '
//             'ESP32 hotspot first.';
//       });
//       return;
//     }

//     final String? assetPath = classFirmwareFiles[selectedClass];

//     if (assetPath == null) {
//       setState(() {
//         status = 'No BIN file found for Class $selectedClass.';
//       });
//       return;
//     }

//     try {
//       setState(() {
//         isUploadingFirmware = true;
//         uploadProgress = 0;

//         status =
//             'Loading Class $selectedClass BIN file...\n\n'
//             '$assetPath';
//       });

//       final firmwareBytes = await loadSelectedFirmware();

//       if (!mounted) return;

//       setState(() {
//         uploadProgress = 0.2;

//         status =
//             'Firmware loaded successfully ✓\n\n'
//             'Class: $selectedClass\n'
//             'File: $assetPath\n'
//             'Size: ${firmwareBytes.length} bytes\n\n'
//             'Sending BIN to ESP32...';
//       });

//       final request = http.MultipartRequest('POST', Uri.parse(otaUrl));

//       request.headers['X-OTA-Token'] = otaToken;

//       request.files.add(
//         http.MultipartFile.fromBytes(
//           'file',
//           firmwareBytes,
//           filename: 'class_$selectedClass.bin',
//         ),
//       );

//       final streamedResponse = await request.send().timeout(
//         const Duration(minutes: 5),
//       );

//       if (!mounted) return;

//       setState(() {
//         uploadProgress = 0.85;
//         status = 'Waiting for ESP32 response...';
//       });

//       final responseBody = await streamedResponse.stream.bytesToString();

//       if (!mounted) return;

//       if (streamedResponse.statusCode >= 200 &&
//           streamedResponse.statusCode < 300) {
//         setState(() {
//           uploadProgress = 1;

//           status =
//               'Class $selectedClass BIN sent successfully ✓\n\n'
//               'HTTP: ${streamedResponse.statusCode}\n\n'
//               'ESP32 response:\n'
//               '$responseBody';
//         });

//         await Future.delayed(const Duration(milliseconds: 500));

//         if (!mounted) return;

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ScratchProgramPage(selectedClass: selectedClass),
//           ),
//         );
//       } else {
//         setState(() {
//           uploadProgress = 0;

//           status =
//               'BIN upload failed ✗\n\n'
//               'HTTP Status: '
//               '${streamedResponse.statusCode}\n\n'
//               '$responseBody';
//         });
//       }
//     } on FlutterError catch (e) {
//       if (!mounted) return;

//       setState(() {
//         uploadProgress = 0;

//         status =
//             'Asset loading failed.\n\n'
//             'Check this path in pubspec.yaml:\n'
//             '$assetPath\n\n'
//             '$e';
//       });
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         uploadProgress = 0;
//         status = 'BIN upload error:\n\n$e';
//       });
//     } finally {
//       // ignore: control_flow_in_finally
//       if (!mounted) return;

//       setState(() {
//         isUploadingFirmware = false;
//       });
//     }
//   }

//   // ===========================================================================
//   // UI
//   // ===========================================================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Knowli Bot Setup',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 500),
//               child: Column(
//                 children: [
//                   buildHeader(),
//                   const SizedBox(height: 20),
//                   buildConnectionCard(),
//                   const SizedBox(height: 16),
//                   buildClassCard(),
//                   const SizedBox(height: 16),
//                   buildStatusCard(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildHeader() {
//     return Column(
//       children: [
//         Container(
//           height: 90,
//           width: 90,
//           decoration: BoxDecoration(
//             color: Colors.deepPurple.withValues(alpha: 0.1),
//             shape: BoxShape.circle,
//           ),
//           child: const Icon(
//             Icons.smart_toy,
//             size: 52,
//             color: Colors.deepPurple,
//           ),
//         ),
//         const SizedBox(height: 14),
//         const Text(
//           'Welcome to Knowli Bot',
//           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           'Connect your ESP32 and select a class',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//         ),
//       ],
//     );
//   }

//   Widget buildConnectionCard() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.wifi, color: Colors.deepPurple),
//                 SizedBox(width: 8),
//                 Text(
//                   'ESP32 Connection',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Icon(
//                   isEsp32Connected ? Icons.check_circle : Icons.cancel,
//                   color: isEsp32Connected ? Colors.green : Colors.red,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     isEsp32Connected
//                         ? 'ESP32 Connected'
//                         : 'ESP32 Not Connected',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: isEsp32Connected ? Colors.green : Colors.red,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(wifiStatus, style: TextStyle(color: Colors.grey.shade700)),
//             const SizedBox(height: 14),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: isCheckingConnection ? null : connectToEsp32,
//                 icon: isCheckingConnection
//                     ? const SizedBox(
//                         height: 18,
//                         width: 18,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Icon(Icons.link),
//                 label: Text(
//                   isCheckingConnection
//                       ? 'Checking...'
//                       : 'Check ESP32 Connection',
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildClassCard() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Row(
//               children: [
//                 Icon(Icons.school, color: Colors.deepPurple),
//                 SizedBox(width: 8),
//                 Text(
//                   'Choose Class',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             DropdownButtonFormField<int>(
//               initialValue: selectedClass,
//               decoration: const InputDecoration(
//                 labelText: 'Select Class',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.class_),
//               ),
//               items: List.generate(8, (index) {
//                 final classNumber = index + 3;

//                 return DropdownMenuItem<int>(
//                   value: classNumber,
//                   child: Text('Class $classNumber'),
//                 );
//               }),
//               onChanged: (!isEsp32Connected || isUploadingFirmware)
//                   ? null
//                   : selectClass,
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Selected BIN file:',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               classFirmwareFiles[selectedClass] ?? 'No BIN file found',
//               style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 16),
//             if (isUploadingFirmware)
//               Column(
//                 children: [
//                   LinearProgressIndicator(
//                     value: uploadProgress == 0 ? null : uploadProgress,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${(uploadProgress * 100).toInt()}%',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 12),
//                 ],
//               ),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: (!isEsp32Connected || isUploadingFirmware)
//                     ? null
//                     : uploadSelectedClassFirmware,
//                 icon: isUploadingFirmware
//                     ? const SizedBox(
//                         height: 18,
//                         width: 18,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Icon(Icons.upload_file),
//                 label: Text(
//                   isUploadingFirmware
//                       ? 'Sending BIN...'
//                       : 'Send BIN & Continue',
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildStatusCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Icon(Icons.info_outline, color: Colors.deepPurple),
//           const SizedBox(width: 10),
//           Expanded(child: Text(status, style: const TextStyle(fontSize: 13))),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:knowlibot/application/view/setup_page.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   runApp(const KnowliBotApp());
// }

// class KnowliBotApp extends StatelessWidget {
//   const KnowliBotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Knowli Bot',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xfff5f5fa),
//       ),
//       home: const SetupPage(),
//     );
//   }
// }

// import 'package:esp32/application/view/setup_page.dart';
// import 'package:flutter/material.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const KnowliBotApp());
// }

// class KnowliBotApp extends StatelessWidget {
//   const KnowliBotApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Knowli Bot',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.deepPurple,
//         scaffoldBackgroundColor: const Color(0xfff5f5fa),
//       ),
//       home: const SetupPage(),
//     );
//   }
// }

import 'package:esp32/application/view/setup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esp32/application/view_model/setup_viewmodel.dart';
import 'package:esp32/application/view_model/scratch_program_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SetupViewModel()),
        ChangeNotifierProvider(create: (_) => ScratchProgramViewModel(selectedClass: 3)), // Default class
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knowli Bot',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SetupPage(),
    );
  }
}
