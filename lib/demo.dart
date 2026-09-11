// // import 'dart:io';
// // import 'dart:typed_data';

// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:wifi_iot/wifi_iot.dart';
// // import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// // import 'package:ffmpeg_kit_flutter_new/return_code.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(const KNOWLIBOTApp());
// // }

// // class KNOWLIBOTApp extends StatelessWidget {
// //   const KNOWLIBOTApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'KNOWLIBOT',
// //       theme: ThemeData(
// //         useMaterial3: true,
// //         colorSchemeSeed: Colors.blue,
// //       ),
// //       home: const HomePage(),
// //     );
// //   }
// // }

// // // ============================================================
// // // HOME PAGE
// // // ============================================================

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage>
// //     with WidgetsBindingObserver {
// //   // ============================================================
// //   // ESP32
// //   // ============================================================

// //   static const String baseUrl = 'http://192.168.4.1';

// //   static const String testUrl = '$baseUrl/';
// //   static const String wavUrl = '$baseUrl/stream';
// //   static const String videoUrl = '$baseUrl/videostream';

// //   // ============================================================
// //   // ASSETS
// //   // ============================================================

// //   static const String wavAsset =
// //       'assets/audio/Ring09.wav';

// //   static const String videoAsset =
// //       'assets/videos/thum.mp4';

// //   // ============================================================
// //   // VIDEO SETTINGS
// //   // ============================================================

// //   static const int videoWidth = 480;
// //   static const int videoHeight = 320;

// //   static const int videoFps = 15;

// //   static const int jpegQuality = 15;

// //   // Must be <= ESP32:
// //   // #define MAX_JPEG_FRAME_SIZE (80 * 1024)
// //   static const int maxJpegFrameSize =
// //       80 * 1024;

// //   // ============================================================
// //   // AUDIO
// //   // ============================================================

// //   static const int audioSampleRate = 16000;
// //   static const int audioChannels = 1;
// //   static const int audioBits = 16;

// //   // ============================================================
// //   // STATE
// //   // ============================================================

// //   bool isWifiEnabled = false;
// //   bool isConnected = false;
// //   bool isBusy = false;

// //   double progress = 0.0;

// //   String status = 'Ready';

// //   // ============================================================
// //   // INIT STATE
// //   // ============================================================

// //   @override
// //   void initState() {
// //     super.initState();

// //     WidgetsBinding.instance.addObserver(this);

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       checkWifi();
// //     });
// //   }

// //   // ============================================================
// //   // APP LIFECYCLE
// //   // ============================================================

// //   @override
// //   void didChangeAppLifecycleState(
// //     AppLifecycleState state,
// //   ) {
// //     super.didChangeAppLifecycleState(state);

// //     // When user comes back from Android Wi-Fi settings,
// //     // check Wi-Fi status again.
// //     if (state == AppLifecycleState.resumed) {
// //       checkWifi();
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     WidgetsBinding.instance.removeObserver(this);
// //     super.dispose();
// //   }

// //   // ============================================================
// //   // STATUS UPDATE
// //   // ============================================================

// //   void updateStatus(String value) {
// //     if (!mounted) return;

// //     setState(() {
// //       status = value;
// //     });
// //   }

// //   // ============================================================
// //   // PROGRESS UPDATE
// //   // ============================================================

// //   void updateProgress(double value) {
// //     if (!mounted) return;

// //     setState(() {
// //       progress = value.clamp(0.0, 1.0);
// //     });
// //   }

// //   // ============================================================
// //   // SNACKBAR
// //   // ============================================================

// //   void showMessage(String message) {
// //     if (!mounted) return;

// //     ScaffoldMessenger.of(context)
// //         .hideCurrentSnackBar();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         duration:
// //             const Duration(seconds: 3),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // CHECK WIFI
// //   // ============================================================

// //   Future<void> checkWifi() async {
// //     try {
// //       final enabled =
// //           await WiFiForIoTPlugin.isEnabled();

// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = enabled;
// //       });

// //       if (!enabled) {
// //         showWifiEnableMessage();
// //       }
// //     } catch (e) {
// //       updateStatus(
// //         'Unable to check Wi-Fi.\n\n$e',
// //       );
// //     }
// //   }

// //   // ============================================================
// //   // WIFI ENABLE MESSAGE
// //   // ============================================================

// //   void showWifiEnableMessage() {
// //     if (!mounted) return;

// //     ScaffoldMessenger.of(context)
// //         .hideCurrentSnackBar();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: const Text(
// //           'Wi-Fi is OFF. Please enable Wi-Fi.',
// //         ),
// //         duration:
// //             const Duration(seconds: 8),
// //         action: SnackBarAction(
// //           label: 'ENABLE',
// //           onPressed: () {
// //             showWifiConfirmation();
// //           },
// //         ),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // WIFI CONFIRMATION
// //   // ============================================================

// //   Future<void> showWifiConfirmation() async {
// //     if (!mounted) return;

// //     final result = await showDialog<bool>(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: const Text(
// //             'Enable Wi-Fi',
// //           ),
// //           content: const Text(
// //             'Wi-Fi is currently disabled.\n\n'
// //             'Android Wi-Fi settings will open '
// //             'so you can enable Wi-Fi manually.',
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(
// //                   context,
// //                   false,
// //                 );
// //               },
// //               child: const Text(
// //                 'CANCEL',
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.pop(
// //                   context,
// //                   true,
// //                 );
// //               },
// //               child: const Text(
// //                 'OPEN SETTINGS',
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     );

// //     if (result == true) {
// //       try {
// //         await WiFiForIoTPlugin.setEnabled(
// //           true,
// //           shouldOpenSettings: true,
// //         );
// //       } catch (e) {
// //         showMessage(
// //           'Could not open Wi-Fi settings.',
// //         );
// //       }
// //     }
// //   }

// //   // ============================================================
// //   // TEST ESP32 CONNECTION
// //   // ============================================================

// //   Future<void> testConnection() async {
// //     if (isBusy) return;

// //     // Check Wi-Fi first.
// //     final wifiEnabled =
// //         await WiFiForIoTPlugin.isEnabled();

// //     if (!wifiEnabled) {
// //       if (mounted) {
// //         setState(() {
// //           isWifiEnabled = false;
// //         });
// //       }

// //       showWifiEnableMessage();
// //       return;
// //     }

// //     setState(() {
// //       isBusy = true;
// //       isConnected = false;
// //       progress = 0.0;
// //       status =
// //           'Testing ESP32 connection...';
// //     });

// //     try {
// //       final response = await http
// //           .get(Uri.parse(testUrl))
// //           .timeout(
// //             const Duration(seconds: 10),
// //           );

// //       if (!mounted) return;

// //       if (response.statusCode == 200) {
// //         setState(() {
// //           isConnected = true;

// //           status =
// //               'ESP32 CONNECTED ✓\n\n'
// //               'URL:\n'
// //               '$testUrl\n\n'
// //               'HTTP: ${response.statusCode}\n\n'
// //               'Response:\n'
// //               '${response.body}';

// //           progress = 1.0;
// //         });

// //         showMessage(
// //           'ESP32 connected successfully.',
// //         );
// //       } else {
// //         setState(() {
// //           isConnected = false;

// //           status =
// //               'ESP32 CONNECTION FAILED ✗\n\n'
// //               'HTTP ${response.statusCode}\n\n'
// //               '${response.body}';
// //         });

// //         showMessage(
// //           'ESP32 connection failed.',
// //         );
// //       }
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         isConnected = false;

// //         status =
// //             'ESP32 CONNECTION ERROR ✗\n\n'
// //             '$e';
// //       });

// //       showMessage(
// //         'Could not connect to ESP32.',
// //       );
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isBusy = false;
// //       });
// //     }
// //   }

// //   // ============================================================
// //   // SEND WAV
// //   // ============================================================

// //   Future<void> sendWav() async {
// //     if (!isWifiEnabled) {
// //       showWifiEnableMessage();
// //       return;
// //     }

// //     if (!isConnected) {
// //       showMessage(
// //         'Connect to ESP32 first.',
// //       );
// //       return;
// //     }

// //     if (isBusy) return;

// //     setState(() {
// //       isBusy = true;
// //       progress = 0.0;
// //       status = 'Loading WAV file...';
// //     });

// //     try {
// //       final data =
// //           await rootBundle.load(wavAsset);

// //       final wavBytes =
// //           data.buffer.asUint8List(
// //         data.offsetInBytes,
// //         data.lengthInBytes,
// //       );

// //       if (wavBytes.isEmpty) {
// //         throw Exception(
// //           'WAV file is empty.',
// //         );
// //       }

// //       updateProgress(0.2);

// //       final request = http.Request(
// //         'POST',
// //         Uri.parse(wavUrl),
// //       );

// //       request.headers['Content-Type'] =
// //           'audio/wav';

// //       request.headers['X-Audio-Format'] =
// //           'wav';

// //       request.headers[
// //               'X-Audio-Sample-Rate'] =
// //           audioSampleRate.toString();

// //       request.headers['X-Audio-Channels'] =
// //           audioChannels.toString();

// //       request.headers['X-Audio-Bits'] =
// //           audioBits.toString();

// //       request.contentLength =
// //           wavBytes.length;

// //       request.bodyBytes = wavBytes;

// //       updateStatus(
// //         'Sending WAV...\n\n'
// //         'Size: ${wavBytes.length} bytes',
// //       );

// //       final response = await request
// //           .send()
// //           .timeout(
// //             const Duration(seconds: 60),
// //           );

// //       final responseBody =
// //           await response.stream
// //               .bytesToString();

// //       if (response.statusCode >= 200 &&
// //           response.statusCode < 300) {
// //         updateProgress(1.0);

// //         updateStatus(
// //           'WAV SENT ✓\n\n'
// //           'HTTP ${response.statusCode}\n\n'
// //           '$responseBody',
// //         );

// //         showMessage(
// //           'WAV sent successfully.',
// //         );
// //       } else {
// //         throw Exception(
// //           'HTTP ${response.statusCode}\n'
// //           '$responseBody',
// //         );
// //       }
// //     } catch (e) {
// //       updateStatus(
// //         'WAV SEND FAILED ✗\n\n$e',
// //       );
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isBusy = false;
// //       });
// //     }
// //   }

// //   // ============================================================
// //   // PREPARE VIDEO
// //   // ============================================================

// //   Future<String> prepareVideo(
// //     Directory directory,
// //   ) async {
// //     final videoFile = File(
// //       '${directory.path}/input.mp4',
// //     );

// //     final data =
// //         await rootBundle.load(videoAsset);

// //     final bytes =
// //         data.buffer.asUint8List(
// //       data.offsetInBytes,
// //       data.lengthInBytes,
// //     );

// //     await videoFile.writeAsBytes(
// //       bytes,
// //       flush: true,
// //     );

// //     return videoFile.path;
// //   }

// //   // ============================================================
// //   // GET VIDEO DURATION
// //   // ============================================================

// //   Future<double> getVideoDuration(
// //     String videoPath,
// //   ) async {
// //     double duration = 10.0;

// //     try {
// //       final session =
// //           await FFmpegKit.execute(
// //         '-i "$videoPath" -f null -',
// //       );

// //       final output =
// //           await session.getOutput();

// //       if (output != null) {
// //         final regex = RegExp(
// //           r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)',
// //         );

// //         final match =
// //             regex.firstMatch(output);

// //         if (match != null) {
// //           final hours =
// //               int.parse(match.group(1)!);

// //           final minutes =
// //               int.parse(match.group(2)!);

// //           final seconds =
// //               double.parse(
// //             match.group(3)!,
// //           );

// //           duration =
// //               hours * 3600 +
// //               minutes * 60 +
// //               seconds;
// //         }
// //       }
// //     } catch (_) {}

// //     return duration;
// //   }

// //   // ============================================================
// //   // EXTRACT VIDEO → JPEG
// //   // ============================================================

// //   Future<Directory> extractVideoFrames(
// //     String videoPath,
// //     String outputDirectory,
// //   ) async {
// //     final framesDirectory =
// //         Directory(
// //       '$outputDirectory/frames',
// //     );

// //     if (await framesDirectory.exists()) {
// //       await framesDirectory.delete(
// //         recursive: true,
// //       );
// //     }

// //     await framesDirectory.create(
// //       recursive: true,
// //     );

// //     updateStatus(
// //       'Converting video to JPEG...\n\n'
// //       '$videoWidth × $videoHeight\n'
// //       '$videoFps FPS\n\n'
// //       'No rotation applied.',
// //     );

// //     final outputPattern =
// //         '${framesDirectory.path}/frame_%06d.jpg';

// //     // ========================================================
// //     // IMPORTANT
// //     //
// //     // NO ROTATION
// //     // NO TRANSPOSE
// //     //
// //     // The video is not rotated.
// //     //
// //     // The output is exactly 480 x 320.
// //     // ========================================================

// //     final command =
// //         '-y '
// //         '-i "$videoPath" '
// //         '-vf "scale=$videoWidth:$videoHeight:'
// //         'force_original_aspect_ratio=disable,'
// //         'fps=$videoFps,'
// //         'format=yuvj420p" '
// //         '-q:v $jpegQuality '
// //         '"$outputPattern"';

// //     final session =
// //         await FFmpegKit.execute(
// //       command,
// //     );

// //     final returnCode =
// //         await session.getReturnCode();

// //     if (!ReturnCode.isSuccess(
// //       returnCode,
// //     )) {
// //       final output =
// //           await session.getOutput();

// //       throw Exception(
// //         'Video conversion failed.\n\n'
// //         '$output',
// //       );
// //     }

// //     return framesDirectory;
// //   }

// //   // ============================================================
// //   // JPEG VALIDATION
// //   // ============================================================

// //   bool isValidJpeg(
// //     Uint8List bytes,
// //   ) {
// //     if (bytes.length < 4) {
// //       return false;
// //     }

// //     final start =
// //         bytes[0] == 0xFF &&
// //         bytes[1] == 0xD8;

// //     final last =
// //         bytes.length - 1;

// //     final end =
// //         bytes[last - 1] == 0xFF &&
// //         bytes[last] == 0xD9;

// //     return start && end;
// //   }

// //   // ============================================================
// //   // CREATE 4-BYTE LITTLE-ENDIAN LENGTH
// //   // ============================================================

// //   Uint8List createLengthHeader(
// //     int length,
// //   ) {
// //     final data = ByteData(4);

// //     data.setUint32(
// //       0,
// //       length,
// //       Endian.little,
// //     );

// //     return data.buffer.asUint8List();
// //   }

// //   // ============================================================
// //   // CALCULATE TOTAL STREAM SIZE
// //   // ============================================================

// //   Future<int> calculateTotalStreamSize(
// //     List<File> frameFiles,
// //   ) async {
// //     int total = 0;

// //     for (final file in frameFiles) {
// //       final size =
// //           await file.length();

// //       if (size <= 0) {
// //         throw Exception(
// //           'Empty JPEG file:\n'
// //           '${file.path}',
// //         );
// //       }

// //       if (size > maxJpegFrameSize) {
// //         throw Exception(
// //           'JPEG too large:\n'
// //           '${file.path}\n\n'
// //           'Size: $size bytes\n'
// //           'Maximum: '
// //           '$maxJpegFrameSize bytes',
// //         );
// //       }

// //       // 4 bytes for frame length.
// //       total += 4;

// //       // JPEG bytes.
// //       total += size;
// //     }

// //     return total;
// //   }

// //   // ============================================================
// //   // SEND VIDEO STREAM
// //   // ============================================================

// //   Future<void> sendVideoStream(
// //     List<File> frameFiles,
// //   ) async {
// //     if (frameFiles.isEmpty) {
// //       throw Exception(
// //         'No JPEG frames found.',
// //       );
// //     }

// //     updateStatus(
// //       'Calculating video size...',
// //     );

// //     final totalBytes =
// //         await calculateTotalStreamSize(
// //       frameFiles,
// //     );

// //     updateStatus(
// //       'Video ready.\n\n'
// //       'Frames: ${frameFiles.length}\n'
// //       'Total: '
// //       '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
// //       'Starting upload...',
// //     );

// //     // ========================================================
// //     // ONE HTTP POST
// //     // ========================================================

// //     final request =
// //         http.StreamedRequest(
// //       'POST',
// //       Uri.parse(videoUrl),
// //     );

// //     request.headers[
// //             'Content-Type'] =
// //         'application/octet-stream';

// //     request.headers['Accept'] =
// //         '*/*';

// //     // Tell ESP32 exact body length.
// //     request.contentLength =
// //         totalBytes;

// //     // Start HTTP request first.
// //     final responseFuture =
// //         request.send().timeout(
// //       const Duration(minutes: 10),
// //     );

// //     int sentBytes = 0;

// //     // ========================================================
// //     // SEND EVERY FRAME
// //     // ========================================================

// //     for (int i = 0;
// //         i < frameFiles.length;
// //         i++) {
// //       final file = frameFiles[i];

// //       final frameBytes =
// //           await file.readAsBytes();

// //       // ------------------------------------------------------
// //       // VALIDATE JPEG
// //       // ------------------------------------------------------

// //       if (!isValidJpeg(
// //         frameBytes,
// //       )) {
// //         throw Exception(
// //           'Invalid JPEG frame: '
// //           '${i + 1}',
// //         );
// //       }

// //       // ------------------------------------------------------
// //       // CHECK SIZE
// //       // ------------------------------------------------------

// //       if (frameBytes.length >
// //           maxJpegFrameSize) {
// //         throw Exception(
// //           'Frame ${i + 1} is too large.\n'
// //           'Size: ${frameBytes.length}\n'
// //           'Maximum: '
// //           '$maxJpegFrameSize',
// //         );
// //       }

// //       // ------------------------------------------------------
// //       // CREATE 4 BYTE LENGTH
// //       // ------------------------------------------------------

// //       final lengthHeader =
// //           createLengthHeader(
// //         frameBytes.length,
// //       );

// //       // ------------------------------------------------------
// //       // SEND LENGTH
// //       // ------------------------------------------------------

// //       request.sink.add(
// //         lengthHeader,
// //       );

// //       sentBytes += 4;

// //       // ------------------------------------------------------
// //       // SEND JPEG
// //       // ------------------------------------------------------

// //       request.sink.add(
// //         frameBytes,
// //       );

// //       sentBytes +=
// //           frameBytes.length;

// //       // ------------------------------------------------------
// //       // PROGRESS
// //       //
// //       // 20% → 95%
// //       // 5% reserved for ESP32 response.
// //       // ------------------------------------------------------

// //       final uploadRatio =
// //           sentBytes / totalBytes;

// //       final uiProgress =
// //           0.20 +
// //           uploadRatio * 0.75;

// //       updateProgress(
// //         uiProgress,
// //       );

// //       if (i % 10 == 0 ||
// //           i == frameFiles.length - 1) {
// //         final percent =
// //             (uploadRatio * 100).toInt();

// //         final mb =
// //             sentBytes /
// //             1024 /
// //             1024;

// //         updateStatus(
// //           'UPLOADING VIDEO...\n\n'
// //           'Frame: ${i + 1} / '
// //           '${frameFiles.length}\n'
// //           'Upload: $percent%\n'
// //           'Data: '
// //           '${mb.toStringAsFixed(2)} MB / '
// //           '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
// //           'ESP32 protocol:\n'
// //           '[4-byte length][JPEG]',
// //         );
// //       }
// //     }

// //     // ========================================================
// //     // CLOSE REQUEST
// //     // ========================================================

// //     await request.sink.close();

// //     updateProgress(0.95);

// //     updateStatus(
// //       'UPLOAD COMPLETE ✓\n\n'
// //       'All video data sent from Flutter.\n\n'
// //       'Waiting for ESP32 response...',
// //     );

// //     // ========================================================
// //     // WAIT FOR ESP32
// //     // ========================================================

// //     final response =
// //         await responseFuture;

// //     final responseBody =
// //         await response.stream
// //             .bytesToString();

// //     // ========================================================
// //     // SUCCESS
// //     // ========================================================

// //     if (response.statusCode >= 200 &&
// //         response.statusCode < 300) {
// //       updateProgress(1.0);

// //       updateStatus(
// //         'VIDEO RECEIVED BY ESP32 ✓\n\n'
// //         'Frames: ${frameFiles.length}\n'
// //         'HTTP: ${response.statusCode}\n\n'
// //         'ESP32 response:\n'
// //         '$responseBody',
// //       );

// //       showMessage(
// //         'ESP32 received the video.',
// //       );
// //     } else {
// //       throw Exception(
// //         'ESP32 returned HTTP '
// //         '${response.statusCode}\n\n'
// //         '$responseBody',
// //       );
// //     }
// //   }

// //   // ============================================================
// //   // SEND VIDEO
// //   // ============================================================

// //   Future<void> sendVideo() async {
// //     if (!isWifiEnabled) {
// //       showWifiEnableMessage();
// //       return;
// //     }

// //     if (!isConnected) {
// //       showMessage(
// //         'Connect to ESP32 first.',
// //       );
// //       return;
// //     }

// //     if (isBusy) return;

// //     setState(() {
// //       isBusy = true;
// //       progress = 0.0;
// //       status =
// //           'Preparing video...';
// //     });

// //     Directory? workDirectory;

// //     try {
// //       // --------------------------------------------------------
// //       // CHECK VIDEO ASSET
// //       // --------------------------------------------------------

// //       try {
// //         await rootBundle.load(
// //           videoAsset,
// //         );
// //       } catch (_) {
// //         throw Exception(
// //           'Video file not found.\n\n'
// //           'Add:\n'
// //           '$videoAsset\n\n'
// //           'to pubspec.yaml.',
// //         );
// //       }

// //       // --------------------------------------------------------
// //       // CREATE TEMP DIRECTORY
// //       // --------------------------------------------------------

// //       workDirectory =
// //           await Directory.systemTemp
// //               .createTemp(
// //         'knowlibot_video_',
// //       );

// //       // --------------------------------------------------------
// //       // COPY VIDEO
// //       // --------------------------------------------------------

// //       updateStatus(
// //         'Loading video...',
// //       );

// //       final videoPath =
// //           await prepareVideo(
// //         workDirectory,
// //       );

// //       updateProgress(0.05);

// //       // --------------------------------------------------------
// //       // GET VIDEO DURATION
// //       // --------------------------------------------------------

// //       final duration =
// //           await getVideoDuration(
// //         videoPath,
// //       );

// //       updateStatus(
// //         'Original video duration:\n'
// //         '${duration.toStringAsFixed(2)} seconds',
// //       );

// //       // --------------------------------------------------------
// //       // EXTRACT JPEG FRAMES
// //       // --------------------------------------------------------

// //       final framesDirectory =
// //           await extractVideoFrames(
// //         videoPath,
// //         workDirectory.path,
// //       );

// //       updateProgress(0.20);

// //       // --------------------------------------------------------
// //       // FIND JPEG FILES
// //       // --------------------------------------------------------

// //       final frameFiles =
// //           framesDirectory
// //               .listSync()
// //               .whereType<File>()
// //               .where(
// //                 (file) =>
// //                     file.path
// //                         .toLowerCase()
// //                         .endsWith('.jpg'),
// //               )
// //               .toList();

// //       // --------------------------------------------------------
// //       // SORT FRAMES
// //       // --------------------------------------------------------

// //       frameFiles.sort(
// //         (a, b) =>
// //             a.path.compareTo(b.path),
// //       );

// //       if (frameFiles.isEmpty) {
// //         throw Exception(
// //           'No JPEG video frames were generated.',
// //         );
// //       }

// //       // --------------------------------------------------------
// //       // EXPECTED FRAMES
// //       // --------------------------------------------------------

// //       final expectedFrames =
// //           (duration * videoFps).round();

// //       updateStatus(
// //         'VIDEO CONVERSION COMPLETE ✓\n\n'
// //         'Original duration: '
// //         '${duration.toStringAsFixed(2)} sec\n\n'
// //         'Generated frames: '
// //         '${frameFiles.length}\n'
// //         'Expected frames: '
// //         '$expectedFrames\n\n'
// //         'Resolution: '
// //         '$videoWidth × $videoHeight\n\n'
// //         'FPS: $videoFps\n\n'
// //         'Rotation: NONE\n\n'
// //         'Preparing upload...',
// //       );

// //       // --------------------------------------------------------
// //       // SEND VIDEO
// //       // --------------------------------------------------------

// //       await sendVideoStream(
// //         frameFiles,
// //       );
// //     } catch (e) {
// //       updateStatus(
// //         'VIDEO FAILED ✗\n\n$e',
// //       );

// //       showMessage(
// //         'Video sending failed.',
// //       );
// //     } finally {
// //       // --------------------------------------------------------
// //       // DELETE TEMP FILES
// //       // --------------------------------------------------------

// //       if (workDirectory != null) {
// //         try {
// //           if (await workDirectory
// //               .exists()) {
// //             await workDirectory.delete(
// //               recursive: true,
// //             );
// //           }
// //         } catch (_) {}
// //       }

// //       if (!mounted) return;

// //       setState(() {
// //         isBusy = false;
// //       });
// //     }
// //   }

// //   // ============================================================
// //   // ESP32 STATUS
// //   // ============================================================

// //   Future<void> getEsp32Status() async {
// //     if (!isWifiEnabled) {
// //       showWifiEnableMessage();
// //       return;
// //     }

// //     if (!isConnected || isBusy) {
// //       return;
// //     }

// //     try {
// //       final response = await http
// //           .get(
// //             Uri.parse(
// //               '$baseUrl/status',
// //             ),
// //           )
// //           .timeout(
// //             const Duration(seconds: 5),
// //           );

// //       if (response.statusCode == 200) {
// //         updateStatus(
// //           'ESP32 STATUS\n\n'
// //           '${response.body}',
// //         );
// //       } else {
// //         updateStatus(
// //           'STATUS ERROR\n\n'
// //           'HTTP ${response.statusCode}\n\n'
// //           '${response.body}',
// //         );
// //       }
// //     } catch (e) {
// //       updateStatus(
// //         'STATUS ERROR\n\n$e',
// //       );
// //     }
// //   }

// //   // ============================================================
// //   // UI
// //   // ============================================================

// //   @override
// //   Widget build(
// //     BuildContext context,
// //   ) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'KNOWLIBOT',
// //           style: TextStyle(
// //             fontWeight:
// //                 FontWeight.bold,
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),

// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding:
// //               const EdgeInsets.all(20),

// //           child: Column(
// //             crossAxisAlignment:
// //                 CrossAxisAlignment.stretch,

// //             children: [
// //               // ==================================================
// //               // WIFI STATUS CARD
// //               // ==================================================

// //               Card(
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets.all(16),

// //                   child: Row(
// //                     children: [
// //                       Icon(
// //                         isWifiEnabled
// //                             ? Icons.wifi
// //                             : Icons.wifi_off,
// //                         size: 35,
// //                       ),

// //                       const SizedBox(
// //                         width: 12,
// //                       ),

// //                       Expanded(
// //                         child: Column(
// //                           crossAxisAlignment:
// //                               CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               isWifiEnabled
// //                                   ? 'Wi-Fi is ON'
// //                                   : 'Wi-Fi is OFF',
// //                               style:
// //                                   const TextStyle(
// //                                 fontSize: 18,
// //                                 fontWeight:
// //                                     FontWeight.bold,
// //                               ),
// //                             ),

// //                             const SizedBox(
// //                               height: 4,
// //                             ),

// //                             Text(
// //                               isWifiEnabled
// //                                   ? 'Connect to the ESP32 hotspot manually.'
// //                                   : 'Wi-Fi must be enabled.',
// //                               style:
// //                                   TextStyle(
// //                                 color:
// //                                     Colors.grey[700],
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),

// //                       if (!isWifiEnabled)
// //                         ElevatedButton(
// //                           onPressed:
// //                               isBusy
// //                                   ? null
// //                                   : showWifiConfirmation,
// //                           child:
// //                               const Text(
// //                             'ENABLE',
// //                           ),
// //                         ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(
// //                 height: 16,
// //               ),

// //               // ==================================================
// //               // ESP32 CONNECTION STATUS
// //               // ==================================================

// //               Card(
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets.all(16),

// //                   child: Column(
// //                     crossAxisAlignment:
// //                         CrossAxisAlignment.start,

// //                     children: [
// //                       Row(
// //                         children: [
// //                           Icon(
// //                             isConnected
// //                                 ? Icons
// //                                     .check_circle
// //                                 : Icons
// //                                     .cancel,
// //                           ),

// //                           const SizedBox(
// //                             width: 10,
// //                           ),

// //                           Text(
// //                             isConnected
// //                                 ? 'ESP32 Connected'
// //                                 : 'ESP32 Not Connected',
// //                             style:
// //                                 const TextStyle(
// //                               fontSize: 17,
// //                               fontWeight:
// //                                   FontWeight.bold,
// //                             ),
// //                           ),
// //                         ],
// //                       ),

// //                       const SizedBox(
// //                         height: 12,
// //                       ),

// //                       Text(
// //                         'ESP32 IP: 192.168.4.1',
// //                         style:
// //                             TextStyle(
// //                           color:
// //                               Colors.grey[700],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(
// //                 height: 20,
// //               ),

// //               // ==================================================
// //               // TEST CONNECTION
// //               // ==================================================

// //               SizedBox(
// //                 height: 52,

// //                 child:
// //                     ElevatedButton.icon(
// //                   onPressed:
// //                       isBusy
// //                           ? null
// //                           : testConnection,

// //                   icon: const Icon(
// //                     Icons.link,
// //                   ),

// //                   label: const Text(
// //                     'TEST CONNECTION',
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(
// //                 height: 12,
// //               ),

// //               // ==================================================
// //               // SEND WAV
// //               // ==================================================

// //               SizedBox(
// //                 height: 52,

// //                 child:
// //                     ElevatedButton.icon(
// //                   onPressed:
// //                       (!isWifiEnabled ||
// //                               !isConnected ||
// //                               isBusy)
// //                           ? null
// //                           : sendWav,

// //                   icon: const Icon(
// //                     Icons.audiotrack,
// //                   ),

// //                   label: const Text(
// //                     'SEND WAV',
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(
// //                 height: 12,
// //               ),

// //               // ==================================================
// //               // SEND VIDEO
// //               // ==================================================

// //               SizedBox(
// //                 height: 58,

// //                 child:
// //                     ElevatedButton.icon(
// //                   onPressed:
// //                       (!isWifiEnabled ||
// //                               !isConnected ||
// //                               isBusy)
// //                           ? null
// //                           : sendVideo,

// //                   icon: isBusy
// //                       ? const SizedBox(
// //                           width: 22,
// //                           height: 22,
// //                           child:
// //                               CircularProgressIndicator(
// //                             strokeWidth: 2,
// //                             color:
// //                                 Colors.white,
// //                           ),
// //                         )
// //                       : const Icon(
// //                           Icons.videocam,
// //                         ),

// //                   label: Text(
// //                     isBusy
// //                         ? 'SENDING VIDEO...'
// //                         : 'SEND VIDEO',
// //                     style:
// //                         const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight:
// //                           FontWeight.bold,
// //                     ),
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(
// //                 height: 12,
// //               ),

// //               // ==================================================
// //               // ESP32 STATUS
// //               // ==================================================

// //               // OutlinedButton.icon(
// //               //   onPressed:
// //               //       (!isWifiEnabled ||
// //               //               !isConnected ||
// //               //               isBusy)
// //               //           ? null
// //               //           : getEsp32Status,

// //               //   icon: const Icon(
// //               //     Icons.info_outline,
// //               //   ),

// //               //   label: const Text(
// //               //     'GET ESP32 STATUS',
// //               //   ),
// //               // ),

// //               const SizedBox(
// //                 height: 24,
// //               ),

// //               // ==================================================
// //               // PROGRESS
// //               // ==================================================

// //               if (isBusy ||
// //                   progress > 0) ...[
// //                 LinearProgressIndicator(
// //                   value: progress,
// //                   minHeight: 8,
// //                 ),

// //                 const SizedBox(
// //                   height: 10,
// //                 ),

// //                 Text(
// //                   '${(progress * 100).toInt()}%',
// //                   textAlign:
// //                       TextAlign.center,
// //                   style:
// //                       const TextStyle(
// //                     fontWeight:
// //                         FontWeight.bold,
// //                   ),
// //                 ),

// //                 const SizedBox(
// //                   height: 20,
// //                 ),
// //               ],

// //               // ==================================================
// //               // STATUS CARD
// //               // ==================================================

// //               Card(
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets.all(16),

// //                   child: Column(
// //                     crossAxisAlignment:
// //                         CrossAxisAlignment.start,

// //                     children: [
// //                       const Text(
// //                         'Status',
// //                         style:
// //                             TextStyle(
// //                           fontSize: 18,
// //                           fontWeight:
// //                               FontWeight.bold,
// //                         ),
// //                       ),

// //                       const SizedBox(
// //                         height: 12,
// //                       ),

// //                       Container(
// //                         width:
// //                             double.infinity,

// //                         padding:
// //                             const EdgeInsets.all(
// //                           15,
// //                         ),

// //                         decoration:
// //                             BoxDecoration(
// //                           color: Colors
// //                               .grey
// //                               .shade100,
// //                           borderRadius:
// //                               BorderRadius
// //                                   .circular(
// //                             10,
// //                           ),
// //                         ),

// //                         child:
// //                             SelectableText(
// //                           status,
// //                           style:
// //                               const TextStyle(
// //                             fontSize: 14,
// //                             height: 1.5,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(
// //                 height: 20,
// //               ),

// //               // ==================================================
// //               // VIDEO SETTINGS
// //               // ==================================================

// //               // Card(
// //               //   child: Padding(
// //               //     padding:
// //               //         const EdgeInsets.all(16),

// //               //     child: Column(
// //               //       crossAxisAlignment:
// //               //           CrossAxisAlignment.start,

// //               //       children: [
// //               //         const Text(
// //               //           'Video Settings',
// //               //           style:
// //               //               TextStyle(
// //               //             fontSize: 17,
// //               //             fontWeight:
// //               //                 FontWeight.bold,
// //               //           ),
// //               //         ),

// //               //         const SizedBox(
// //               //           height: 10,
// //               //         ),

// //               //         Text(
// //               //           'Resolution: '
// //               //           '$videoWidth × '
// //               //           '$videoHeight',
// //               //         ),

// //               //         Text(
// //               //           'FPS: $videoFps',
// //               //         ),

// //               //         Text(
// //               //           'JPEG quality: '
// //               //           '$jpegQuality',
// //               //         ),

// //               //         const Text(
// //               //           'Rotation: None',
// //               //         ),

// //               //         const Text(
// //               //           'Audio: 16 kHz / Mono / 16-bit',
// //               //         ),

// //               //         const SizedBox(
// //               //           height: 8,
// //               //         ),

// //               //         const Text(
// //               //           'ESP32 protocol:',
// //               //           style:
// //               //               TextStyle(
// //               //             fontWeight:
// //               //                 FontWeight.bold,
// //               //           ),
// //               //         ),

// //               //         const Text(
// //               //           '[4-byte length] + [JPEG]',
// //               //         ),
// //               //       ],
// //               //     ),
// //               //   ),
// //               // ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:wifi_iot/wifi_iot.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const KNOWLIBOTApp());
// }

// class KNOWLIBOTApp extends StatelessWidget {
//   const KNOWLIBOTApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'KNOWLIBOT',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// // ============================================================
// // HOME PAGE
// // ============================================================

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with WidgetsBindingObserver {

//   // ============================================================
//   // ESP32
//   // ============================================================

//   static const String baseUrl =
//       'http://192.168.4.1';

//   static const String wavUrl =
//       '$baseUrl/stream';

//   static const String videoUrl =
//       '$baseUrl/videostream';

//   static const String otaUrl =
//       '$baseUrl/update';

//   // ============================================================
//   // ASSETS
//   // ============================================================

//   static const String wavAsset =
//       'assets/audio/Ring09.wav';

//   static const String videoAsset =
//       'assets/videos/thum.mp4';

//   static const String ledFirmwareAsset =
//       'assets/led.bin';

//   // ============================================================
//   // VIDEO SETTINGS
//   // ============================================================

//   static const int videoWidth = 480;
//   static const int videoHeight = 320;

//   static const int videoFps = 15;

//   static const int jpegQuality = 15;

//   static const int maxJpegFrameSize =
//       80 * 1024;

//   // ============================================================
//   // AUDIO
//   // ============================================================

//   static const int audioSampleRate = 16000;
//   static const int audioChannels = 1;
//   static const int audioBits = 16;

//   // ============================================================
//   // STATE
//   // ============================================================

//   bool isWifiEnabled = false;

//   // IMPORTANT:
//   // We now use Wi-Fi state directly.
//   // No ESP32 HTTP connection test is required.
//   bool get isConnected => isWifiEnabled;

//   bool isBusy = false;

//   double progress = 0.0;

//   String status = 'Checking Wi-Fi...';

//   // ============================================================
//   // INIT STATE
//   // ============================================================

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addObserver(this);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       checkWifi();
//     });
//   }

//   // ============================================================
//   // APP LIFECYCLE
//   // ============================================================

//   @override
//   void didChangeAppLifecycleState(
//     AppLifecycleState state,
//   ) {
//     super.didChangeAppLifecycleState(state);

//     if (state == AppLifecycleState.resumed) {
//       checkWifi();
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   // ============================================================
//   // STATUS UPDATE
//   // ============================================================

//   void updateStatus(String value) {
//     if (!mounted) return;

//     setState(() {
//       status = value;
//     });
//   }

//   // ============================================================
//   // PROGRESS UPDATE
//   // ============================================================

//   void updateProgress(double value) {
//     if (!mounted) return;

//     setState(() {
//       progress = value.clamp(0.0, 1.0);
//     });
//   }

//   // ============================================================
//   // SNACKBAR
//   // ============================================================

//   void showMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//         .hideCurrentSnackBar();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   // ============================================================
//   // CHECK WIFI
//   // ============================================================

//   Future<void> checkWifi() async {
//     try {
//       final enabled =
//           await WiFiForIoTPlugin.isEnabled();

//       if (!mounted) return;

//       setState(() {
//         isWifiEnabled = enabled;

//         if (enabled) {
//           status =
//               'Wi-Fi is ON ✓\n\n'
//               'ESP32 is ready.\n\n'
//               'IP: 192.168.4.1';
//           progress = 1.0;
//         } else {
//           status =
//               'Wi-Fi is OFF\n\n'
//               'Please enable Wi-Fi.';
//           progress = 0.0;
//         }
//       });

//       if (!enabled) {
//         showWifiEnableMessage();
//       }
//     } catch (e) {
//       updateStatus(
//         'Unable to check Wi-Fi.\n\n$e',
//       );
//     }
//   }

//   // ============================================================
//   // WIFI ENABLE MESSAGE
//   // ============================================================

//   void showWifiEnableMessage() {
//     if (!mounted) return;

//     ScaffoldMessenger.of(context)
//         .hideCurrentSnackBar();

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text(
//           'Wi-Fi is OFF. Please enable Wi-Fi.',
//         ),
//         duration: const Duration(seconds: 8),
//         action: SnackBarAction(
//           label: 'ENABLE',
//           onPressed: () {
//             showWifiConfirmation();
//           },
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // WIFI CONFIRMATION
//   // ============================================================

//   Future<void> showWifiConfirmation() async {
//     if (!mounted) return;

//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text(
//             'Enable Wi-Fi',
//           ),
//           content: const Text(
//             'Wi-Fi is currently disabled.\n\n'
//             'Android Wi-Fi settings will open '
//             'so you can enable Wi-Fi manually.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(
//                   context,
//                   false,
//                 );
//               },
//               child: const Text(
//                 'CANCEL',
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(
//                   context,
//                   true,
//                 );
//               },
//               child: const Text(
//                 'OPEN SETTINGS',
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (result == true) {
//       try {
//         await WiFiForIoTPlugin.setEnabled(
//           true,
//           shouldOpenSettings: true,
//         );
//       } catch (e) {
//         showMessage(
//           'Could not open Wi-Fi settings.',
//         );
//       }
//     }
//   }

//   // ============================================================
//   // SEND LED FIRMWARE
//   // ============================================================

//   Future<void> sendLedFirmware() async {
//     if (!isWifiEnabled) {
//       showWifiEnableMessage();
//       return;
//     }

//     if (isBusy) return;

//     setState(() {
//       isBusy = true;
//       progress = 0.0;
//       status =
//           'Preparing LED firmware...';
//     });

//     try {
//       // ----------------------------------------------------------
//       // LOAD led.bin
//       // ----------------------------------------------------------

//       final data = await rootBundle.load(
//         ledFirmwareAsset,
//       );

//       final firmwareBytes =
//           data.buffer.asUint8List(
//         data.offsetInBytes,
//         data.lengthInBytes,
//       );

//       if (firmwareBytes.isEmpty) {
//         throw Exception(
//           'led.bin is empty.',
//         );
//       }

//       print(
//         'LED firmware size: '
//         '${firmwareBytes.length} bytes',
//       );

//       updateProgress(0.10);

//       // ----------------------------------------------------------
//       // CREATE MULTIPART REQUEST
//       // ----------------------------------------------------------

//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse(otaUrl),
//       );

//       // ----------------------------------------------------------
//       // ADD led.bin
//       // ----------------------------------------------------------

//       request.files.add(
//         http.MultipartFile.fromBytes(
//           'file',
//           firmwareBytes,
//           filename: 'led.bin',
//         ),
//       );

//       updateStatus(
//         'LED FIRMWARE READY\n\n'
//         'File: led.bin\n'
//         'Size: '
//         '${(firmwareBytes.length / 1024).toStringAsFixed(2)} KB\n\n'
//         'Uploading to ESP32...',
//       );

//       updateProgress(0.20);

//       print(
//         'Sending led.bin to ESP32...',
//       );

//       // ----------------------------------------------------------
//       // SEND OTA
//       // ----------------------------------------------------------

//       final response =
//           await request.send().timeout(
//         const Duration(minutes: 5),
//       );

//       updateProgress(0.90);

//       // ----------------------------------------------------------
//       // READ ESP32 RESPONSE
//       // ----------------------------------------------------------

//       final responseBody =
//           await response.stream
//               .bytesToString();

//       print(
//         'OTA HTTP status: '
//         '${response.statusCode}',
//       );

//       print(
//         'OTA response: '
//         '$responseBody',
//       );

//       // ----------------------------------------------------------
//       // CHECK RESULT
//       // ----------------------------------------------------------

//       if (response.statusCode >= 200 &&
//           response.statusCode < 300) {
//         updateProgress(1.0);

//         updateStatus(
//           'LED FIRMWARE UPLOADED ✓\n\n'
//           'File: led.bin\n'
//           'Size: '
//           '${(firmwareBytes.length / 1024).toStringAsFixed(2)} KB\n\n'
//           'ESP32 response:\n'
//           '$responseBody\n\n'
//           'ESP32 is restarting...',
//         );

//         showMessage(
//           'LED firmware uploaded successfully.',
//         );
//       } else {
//         throw Exception(
//           'ESP32 returned HTTP '
//           '${response.statusCode}\n\n'
//           '$responseBody',
//         );
//       }
//     } catch (e) {
//       updateStatus(
//         'LED FIRMWARE UPLOAD FAILED ✗\n\n'
//         '$e',
//       );

//       showMessage(
//         'LED firmware upload failed.',
//       );
//     } finally {
//       if (!mounted) return;

//       setState(() {
//         isBusy = false;
//       });
//     }
//   }

//   // ============================================================
//   // SEND WAV
//   // ============================================================

//   Future<void> sendWav() async {
//     if (!isWifiEnabled) {
//       showWifiEnableMessage();
//       return;
//     }

//     if (isBusy) return;

//     setState(() {
//       isBusy = true;
//       progress = 0.0;
//       status = 'Loading WAV file...';
//     });

//     try {
//       final data =
//           await rootBundle.load(wavAsset);

//       final wavBytes =
//           data.buffer.asUint8List(
//         data.offsetInBytes,
//         data.lengthInBytes,
//       );

//       if (wavBytes.isEmpty) {
//         throw Exception(
//           'WAV file is empty.',
//         );
//       }

//       updateProgress(0.2);

//       final request = http.Request(
//         'POST',
//         Uri.parse(wavUrl),
//       );

//       request.headers['Content-Type'] =
//           'audio/wav';

//       request.headers['X-Audio-Format'] =
//           'wav';

//       request.headers[
//               'X-Audio-Sample-Rate'] =
//           audioSampleRate.toString();

//       request.headers['X-Audio-Channels'] =
//           audioChannels.toString();

//       request.headers['X-Audio-Bits'] =
//           audioBits.toString();

//       request.contentLength =
//           wavBytes.length;

//       request.bodyBytes = wavBytes;

//       updateStatus(
//         'Sending WAV...\n\n'
//         'Size: ${wavBytes.length} bytes',
//       );

//       final response = await request
//           .send()
//           .timeout(
//             const Duration(seconds: 60),
//           );

//       final responseBody =
//           await response.stream
//               .bytesToString();

//       if (response.statusCode >= 200 &&
//           response.statusCode < 300) {
//         updateProgress(1.0);

//         updateStatus(
//           'WAV SENT ✓\n\n'
//           'HTTP ${response.statusCode}\n\n'
//           '$responseBody',
//         );

//         showMessage(
//           'WAV sent successfully.',
//         );
//       } else {
//         throw Exception(
//           'HTTP ${response.statusCode}\n'
//           '$responseBody',
//         );
//       }
//     } catch (e) {
//       updateStatus(
//         'WAV SEND FAILED ✗\n\n$e',
//       );
//     } finally {
//       if (!mounted) return;

//       setState(() {
//         isBusy = false;
//       });
//     }
//   }

//   // ============================================================
//   // PREPARE VIDEO
//   // ============================================================

//   Future<String> prepareVideo(
//     Directory directory,
//   ) async {
//     final videoFile = File(
//       '${directory.path}/input.mp4',
//     );

//     final data =
//         await rootBundle.load(videoAsset);

//     final bytes =
//         data.buffer.asUint8List(
//       data.offsetInBytes,
//       data.lengthInBytes,
//     );

//     await videoFile.writeAsBytes(
//       bytes,
//       flush: true,
//     );

//     return videoFile.path;
//   }

//   // ============================================================
//   // GET VIDEO DURATION
//   // ============================================================

//   Future<double> getVideoDuration(
//     String videoPath,
//   ) async {
//     double duration = 10.0;

//     try {
//       final session =
//           await FFmpegKit.execute(
//         '-i "$videoPath" -f null -',
//       );

//       final output =
//           await session.getOutput();

//       if (output != null) {
//         final regex = RegExp(
//           r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)',
//         );

//         final match =
//             regex.firstMatch(output);

//         if (match != null) {
//           final hours =
//               int.parse(match.group(1)!);

//           final minutes =
//               int.parse(match.group(2)!);

//           final seconds =
//               double.parse(
//             match.group(3)!,
//           );

//           duration =
//               hours * 3600 +
//               minutes * 60 +
//               seconds;
//         }
//       }
//     } catch (_) {}

//     return duration;
//   }

//   // ============================================================
//   // EXTRACT VIDEO → JPEG
//   // ============================================================

//   Future<Directory> extractVideoFrames(
//     String videoPath,
//     String outputDirectory,
//   ) async {
//     final framesDirectory =
//         Directory(
//       '$outputDirectory/frames',
//     );

//     if (await framesDirectory.exists()) {
//       await framesDirectory.delete(
//         recursive: true,
//       );
//     }

//     await framesDirectory.create(
//       recursive: true,
//     );

//     updateStatus(
//       'Converting video to JPEG...\n\n'
//       '$videoWidth × $videoHeight\n'
//       '$videoFps FPS\n\n'
//       'No rotation applied.',
//     );

//     final outputPattern =
//         '${framesDirectory.path}/frame_%06d.jpg';

//     final command =
//         '-y '
//         '-i "$videoPath" '
//         '-vf "scale=$videoWidth:$videoHeight:'
//         'force_original_aspect_ratio=disable,'
//         'fps=$videoFps,'
//         'format=yuvj420p" '
//         '-q:v $jpegQuality '
//         '"$outputPattern"';

//     final session =
//         await FFmpegKit.execute(
//       command,
//     );

//     final returnCode =
//         await session.getReturnCode();

//     if (!ReturnCode.isSuccess(
//       returnCode,
//     )) {
//       final output =
//           await session.getOutput();

//       throw Exception(
//         'Video conversion failed.\n\n'
//         '$output',
//       );
//     }

//     return framesDirectory;
//   }

//   // ============================================================
//   // JPEG VALIDATION
//   // ============================================================

//   bool isValidJpeg(
//     Uint8List bytes,
//   ) {
//     if (bytes.length < 4) {
//       return false;
//     }

//     final start =
//         bytes[0] == 0xFF &&
//         bytes[1] == 0xD8;

//     final last =
//         bytes.length - 1;

//     final end =
//         bytes[last - 1] == 0xFF &&
//         bytes[last] == 0xD9;

//     return start && end;
//   }

//   // ============================================================
//   // CREATE 4-BYTE LITTLE-ENDIAN LENGTH
//   // ============================================================

//   Uint8List createLengthHeader(
//     int length,
//   ) {
//     final data = ByteData(4);

//     data.setUint32(
//       0,
//       length,
//       Endian.little,
//     );

//     return data.buffer.asUint8List();
//   }

//   // ============================================================
//   // CALCULATE TOTAL STREAM SIZE
//   // ============================================================

//   Future<int> calculateTotalStreamSize(
//     List<File> frameFiles,
//   ) async {
//     int total = 0;

//     for (final file in frameFiles) {
//       final size =
//           await file.length();

//       if (size <= 0) {
//         throw Exception(
//           'Empty JPEG file:\n'
//           '${file.path}',
//         );
//       }

//       if (size > maxJpegFrameSize) {
//         throw Exception(
//           'JPEG too large:\n'
//           '${file.path}\n\n'
//           'Size: $size bytes\n'
//           'Maximum: '
//           '$maxJpegFrameSize bytes',
//         );
//       }

//       total += 4;
//       total += size;
//     }

//     return total;
//   }

//   // ============================================================
//   // SEND VIDEO STREAM
//   // ============================================================

//   Future<void> sendVideoStream(
//     List<File> frameFiles,
//   ) async {
//     if (frameFiles.isEmpty) {
//       throw Exception(
//         'No JPEG frames found.',
//       );
//     }

//     updateStatus(
//       'Calculating video size...',
//     );

//     final totalBytes =
//         await calculateTotalStreamSize(
//       frameFiles,
//     );

//     updateStatus(
//       'Video ready.\n\n'
//       'Frames: ${frameFiles.length}\n'
//       'Total: '
//       '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
//       'Starting upload...',
//     );

//     final request =
//         http.StreamedRequest(
//       'POST',
//       Uri.parse(videoUrl),
//     );

//     request.headers[
//             'Content-Type'] =
//         'application/octet-stream';

//     request.headers['Accept'] =
//         '*/*';

//     request.contentLength =
//         totalBytes;

//     final responseFuture =
//         request.send().timeout(
//       const Duration(minutes: 10),
//     );

//     int sentBytes = 0;

//     for (int i = 0;
//         i < frameFiles.length;
//         i++) {
//       final file =
//           frameFiles[i];

//       final frameBytes =
//           await file.readAsBytes();

//       if (!isValidJpeg(
//         frameBytes,
//       )) {
//         throw Exception(
//           'Invalid JPEG frame: '
//           '${i + 1}',
//         );
//       }

//       if (frameBytes.length >
//           maxJpegFrameSize) {
//         throw Exception(
//           'Frame ${i + 1} is too large.\n'
//           'Size: ${frameBytes.length}\n'
//           'Maximum: '
//           '$maxJpegFrameSize',
//         );
//       }

//       final lengthHeader =
//           createLengthHeader(
//         frameBytes.length,
//       );

//       request.sink.add(
//         lengthHeader,
//       );

//       sentBytes += 4;

//       request.sink.add(
//         frameBytes,
//       );

//       sentBytes +=
//           frameBytes.length;

//       final uploadRatio =
//           sentBytes / totalBytes;

//       final uiProgress =
//           0.20 +
//           uploadRatio * 0.75;

//       updateProgress(
//         uiProgress,
//       );

//       if (i % 10 == 0 ||
//           i == frameFiles.length - 1) {
//         final percent =
//             (uploadRatio * 100).toInt();

//         final mb =
//             sentBytes /
//             1024 /
//             1024;

//         updateStatus(
//           'UPLOADING VIDEO...\n\n'
//           'Frame: ${i + 1} / '
//           '${frameFiles.length}\n'
//           'Upload: $percent%\n'
//           'Data: '
//           '${mb.toStringAsFixed(2)} MB / '
//           '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
//           'ESP32 protocol:\n'
//           '[4-byte length][JPEG]',
//         );
//       }
//     }

//     await request.sink.close();

//     updateProgress(0.95);

//     updateStatus(
//       'UPLOAD COMPLETE ✓\n\n'
//       'All video data sent from Flutter.\n\n'
//       'Waiting for ESP32 response...',
//     );

//     final response =
//         await responseFuture;

//     final responseBody =
//         await response.stream
//             .bytesToString();

//     if (response.statusCode >= 200 &&
//         response.statusCode < 300) {
//       updateProgress(1.0);

//       updateStatus(
//         'VIDEO RECEIVED BY ESP32 ✓\n\n'
//         'Frames: ${frameFiles.length}\n'
//         'HTTP: ${response.statusCode}\n\n'
//         'ESP32 response:\n'
//         '$responseBody',
//       );

//       showMessage(
//         'ESP32 received the video.',
//       );
//     } else {
//       throw Exception(
//         'ESP32 returned HTTP '
//         '${response.statusCode}\n\n'
//         '$responseBody',
//       );
//     }
//   }

//   // ============================================================
//   // SEND VIDEO
//   // ============================================================

//   Future<void> sendVideo() async {
//     if (!isWifiEnabled) {
//       showWifiEnableMessage();
//       return;
//     }

//     if (isBusy) return;

//     setState(() {
//       isBusy = true;
//       progress = 0.0;
//       status =
//           'Preparing video...';
//     });

//     Directory? workDirectory;

//     try {
//       try {
//         await rootBundle.load(
//           videoAsset,
//         );
//       } catch (_) {
//         throw Exception(
//           'Video file not found.\n\n'
//           'Add:\n'
//           '$videoAsset\n\n'
//           'to pubspec.yaml.',
//         );
//       }

//       workDirectory =
//           await Directory.systemTemp
//               .createTemp(
//         'knowlibot_video_',
//       );

//       updateStatus(
//         'Loading video...',
//       );

//       final videoPath =
//           await prepareVideo(
//         workDirectory,
//       );

//       updateProgress(0.05);

//       final duration =
//           await getVideoDuration(
//         videoPath,
//       );

//       updateStatus(
//         'Original video duration:\n'
//         '${duration.toStringAsFixed(2)} seconds',
//       );

//       final framesDirectory =
//           await extractVideoFrames(
//         videoPath,
//         workDirectory.path,
//       );

//       updateProgress(0.20);

//       final frameFiles =
//           framesDirectory
//               .listSync()
//               .whereType<File>()
//               .where(
//                 (file) =>
//                     file.path
//                         .toLowerCase()
//                         .endsWith('.jpg'),
//               )
//               .toList();

//       frameFiles.sort(
//         (a, b) =>
//             a.path.compareTo(b.path),
//       );

//       if (frameFiles.isEmpty) {
//         throw Exception(
//           'No JPEG video frames were generated.',
//         );
//       }

//       final expectedFrames =
//           (duration * videoFps).round();

//       updateStatus(
//         'VIDEO CONVERSION COMPLETE ✓\n\n'
//         'Original duration: '
//         '${duration.toStringAsFixed(2)} sec\n\n'
//         'Generated frames: '
//         '${frameFiles.length}\n'
//         'Expected frames: '
//         '$expectedFrames\n\n'
//         'Resolution: '
//         '$videoWidth × $videoHeight\n\n'
//         'FPS: $videoFps\n\n'
//         'Rotation: NONE\n\n'
//         'Preparing upload...',
//       );

//       await sendVideoStream(
//         frameFiles,
//       );
//     } catch (e) {
//       updateStatus(
//         'VIDEO FAILED ✗\n\n$e',
//       );

//       showMessage(
//         'Video sending failed.',
//       );
//     } finally {
//       if (workDirectory != null) {
//         try {
//           if (await workDirectory.exists()) {
//             await workDirectory.delete(
//               recursive: true,
//             );
//           }
//         } catch (_) {}
//       }

//       if (!mounted) return;

//       setState(() {
//         isBusy = false;
//       });
//     }
//   }

//   // ============================================================
//   // ESP32 STATUS
//   // ============================================================

//   Future<void> getEsp32Status() async {
//     if (!isWifiEnabled) {
//       showWifiEnableMessage();
//       return;
//     }

//     if (isBusy) {
//       return;
//     }

//     try {
//       final response = await http
//           .get(
//             Uri.parse(
//               '$baseUrl/status',
//             ),
//           )
//           .timeout(
//             const Duration(seconds: 5),
//           );

//       if (response.statusCode == 200) {
//         updateStatus(
//           'ESP32 STATUS\n\n'
//           '${response.body}',
//         );
//       } else {
//         updateStatus(
//           'STATUS ERROR\n\n'
//           'HTTP ${response.statusCode}\n\n'
//           '${response.body}',
//         );
//       }
//     } catch (e) {
//       updateStatus(
//         'STATUS ERROR\n\n$e',
//       );
//     }
//   }

//   // ============================================================
//   // UI
//   // ============================================================

//   @override
//   Widget build(
//     BuildContext context,
//   ) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'KNOWLIBOT',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),

//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding:
//               const EdgeInsets.all(20),

//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.stretch,

//             children: [
//               // ==================================================
//               // WIFI STATUS CARD
//               // ==================================================

//               Card(
//                 color: isWifiEnabled
//                     ? Colors.green.shade50
//                     : Colors.red.shade50,

//                 child: Padding(
//                   padding:
//                       const EdgeInsets.all(16),

//                   child: Row(
//                     children: [
//                       Icon(
//                         isWifiEnabled
//                             ? Icons.wifi
//                             : Icons.wifi_off,
//                         size: 35,
//                         color: isWifiEnabled
//                             ? Colors.green
//                             : Colors.red,
//                       ),

//                       const SizedBox(
//                         width: 12,
//                       ),

//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment:
//                               CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               isWifiEnabled
//                                   ? 'Wi-Fi Connected'
//                                   : 'Wi-Fi is OFF',
//                               style:
//                                   const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight:
//                                     FontWeight.bold,
//                               ),
//                             ),

//                             const SizedBox(
//                               height: 4,
//                             ),

//                             Text(
//                               isWifiEnabled
//                                   ? 'Ready to communicate with ESP32.'
//                                   : 'Wi-Fi must be enabled.',
//                               style:
//                                   TextStyle(
//                                 color:
//                                     Colors.grey[700],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       if (!isWifiEnabled)
//                         ElevatedButton(
//                           onPressed:
//                               isBusy
//                                   ? null
//                                   : showWifiConfirmation,
//                           child:
//                               const Text(
//                             'ENABLE',
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 16,
//               ),

//               // ==================================================
//               // ESP32 STATUS CARD
//               // ==================================================

//               Card(
//                 color: isConnected
//                     ? Colors.green.shade50
//                     : Colors.grey.shade100,

//                 child: Padding(
//                   padding:
//                       const EdgeInsets.all(16),

//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,

//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             isConnected
//                                 ? Icons.check_circle
//                                 : Icons.cancel,
//                             color: isConnected
//                                 ? Colors.green
//                                 : Colors.grey,
//                           ),

//                           const SizedBox(
//                             width: 10,
//                           ),

//                           Text(
//                             isConnected
//                                 ? 'ESP32 Connected'
//                                 : 'ESP32 Not Connected',
//                             style:
//                                 const TextStyle(
//                               fontSize: 17,
//                               fontWeight:
//                                   FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(
//                         height: 12,
//                       ),

//                       Text(
//                         'ESP32 IP: 192.168.4.1',
//                         style:
//                             TextStyle(
//                           color:
//                               Colors.grey[700],
//                         ),
//                       ),

//                       const SizedBox(
//                         height: 6,
//                       ),

//                       Text(
//                         isConnected
//                             ? 'Wi-Fi connection detected.'
//                             : 'Enable Wi-Fi and connect to the ESP32 hotspot.',
//                         style:
//                             TextStyle(
//                           color:
//                               Colors.grey[700],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 20,
//               ),

//               // ==================================================
//               // SEND LED FIRMWARE
//               // ==================================================

//               SizedBox(
//                 height: 58,

//                 child:
//                     ElevatedButton.icon(
//                   onPressed:
//                       (!isWifiEnabled ||
//                               isBusy)
//                           ? null
//                           : sendLedFirmware,

//                   icon: isBusy
//                       ? const SizedBox(
//                           width: 22,
//                           height: 22,
//                           child:
//                               CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color:
//                                 Colors.white,
//                           ),
//                         )
//                       : const Icon(
//                           Icons.lightbulb,
//                         ),

//                   label: Text(
//                     isBusy
//                         ? 'UPLOADING...'
//                         : 'SEND LED FIRMWARE',
//                     style:
//                         const TextStyle(
//                       fontSize: 16,
//                       fontWeight:
//                           FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 12,
//               ),

//               // ==================================================
//               // SEND WAV
//               // ==================================================

//               SizedBox(
//                 height: 52,

//                 child:
//                     ElevatedButton.icon(
//                   onPressed:
//                       (!isWifiEnabled ||
//                               isBusy)
//                           ? null
//                           : sendWav,

//                   icon: const Icon(
//                     Icons.audiotrack,
//                   ),

//                   label: const Text(
//                     'SEND WAV',
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 12,
//               ),

//               // ==================================================
//               // SEND VIDEO
//               // ==================================================

//               SizedBox(
//                 height: 58,

//                 child:
//                     ElevatedButton.icon(
//                   onPressed:
//                       (!isWifiEnabled ||
//                               isBusy)
//                           ? null
//                           : sendVideo,

//                   icon: isBusy
//                       ? const SizedBox(
//                           width: 22,
//                           height: 22,
//                           child:
//                               CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color:
//                                 Colors.white,
//                           ),
//                         )
//                       : const Icon(
//                           Icons.videocam,
//                         ),

//                   label: Text(
//                     isBusy
//                         ? 'SENDING VIDEO...'
//                         : 'SEND VIDEO',
//                     style:
//                         const TextStyle(
//                       fontSize: 16,
//                       fontWeight:
//                           FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(
//                 height: 24,
//               ),

//               // ==================================================
//               // PROGRESS
//               // ==================================================

//               if (isBusy ||
//                   progress > 0) ...[
//                 LinearProgressIndicator(
//                   value: progress,
//                   minHeight: 8,
//                 ),

//                 const SizedBox(
//                   height: 10,
//                 ),

//                 Text(
//                   '${(progress * 100).toInt()}%',
//                   textAlign:
//                       TextAlign.center,
//                   style:
//                       const TextStyle(
//                     fontWeight:
//                         FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],

//               // ==================================================
//               // STATUS CARD
//               // ==================================================

//               Card(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.all(16),

//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,

//                     children: [
//                       const Text(
//                         'Status',
//                         style:
//                             TextStyle(
//                           fontSize: 18,
//                           fontWeight:
//                               FontWeight.bold,
//                         ),
//                       ),

//                       const SizedBox(
//                         height: 12,
//                       ),

//                       Container(
//                         width:
//                             double.infinity,

//                         padding:
//                             const EdgeInsets.all(
//                           15,
//                         ),

//                         decoration:
//                             BoxDecoration(
//                           color: Colors
//                               .grey
//                               .shade100,
//                           borderRadius:
//                               BorderRadius
//                                   .circular(
//                             10,
//                           ),
//                         ),

//                         child:
//                             SelectableText(
//                           status,
//                           style:
//                               const TextStyle(
//                             fontSize: 14,
//                             height: 1.5,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }