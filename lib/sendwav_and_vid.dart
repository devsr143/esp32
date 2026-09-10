// // // // // // import 'package:flutter/material.dart';
// // // // // // import 'views/home_screen.dart';

// // // // // // void main() {
// // // // // //   WidgetsFlutterBinding.ensureInitialized();

// // // // // //   runApp(const ESP32App());
// // // // // // }

// // // // // // class ESP32App extends StatelessWidget {
// // // // // //   const ESP32App({super.key});

// // // // // //   @override
// // // // // //   Widget build(BuildContext context) {
// // // // // //     return MaterialApp(
// // // // // //       debugShowCheckedModeBanner: false,

// // // // // //       title: 'KNOWLIBOT',

// // // // // //       theme: ThemeData(
// // // // // //         colorScheme: ColorScheme.fromSeed(
// // // // // //           seedColor: Colors.blue,
// // // // // //         ),
// // // // // //         useMaterial3: true,
// // // // // //       ),

// // // // // //       home: const HomeScreen(),
// // // // // //     );
// // // // // //   }
// // // // // // }

// // // // // import 'dart:typed_data';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter/services.dart';
// // // // // import 'package:http/http.dart' as http;

// // // // // void main() {
// // // // //   WidgetsFlutterBinding.ensureInitialized();
// // // // //   runApp(const ESP32App());
// // // // // }

// // // // // class ESP32App extends StatelessWidget {
// // // // //   const ESP32App({super.key});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MaterialApp(
// // // // //       debugShowCheckedModeBanner: false,
// // // // //       title: 'KNOWLIBOT',
// // // // //       theme: ThemeData(
// // // // //         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
// // // // //         useMaterial3: true,
// // // // //       ),
// // // // //       home: const HomeScreen(),
// // // // //     );
// // // // //   }
// // // // // }

// // // // // class HomeScreen extends StatefulWidget {
// // // // //   const HomeScreen({super.key});

// // // // //   @override
// // // // //   State<HomeScreen> createState() => _HomeScreenState();
// // // // // }

// // // // // class _HomeScreenState extends State<HomeScreen> {
// // // // //   static const String baseUrl = 'http://192.168.4.1';
// // // // //   static const String testUrl = '$baseUrl/';
// // // // //   static const String streamUrl = '$baseUrl/stream';
// // // // //   static const String wavAssetPath = 'assets/audio/harvard.wav';

// // // // //   bool isTesting = false;
// // // // //   bool isUploading = false;
// // // // //   String status = 'Not connected';
// // // // //   double uploadProgress = 0.0;

// // // // //   Future<void> testConnection() async {
// // // // //     if (isTesting || isUploading) {
// // // // //       return;
// // // // //     }

// // // // //     setState(() {
// // // // //       isTesting = true;
// // // // //       status = 'Connecting to KNOWLIBOT...';
// // // // //     });

// // // // //     try {
// // // // //       final uri = Uri.parse(testUrl);

// // // // //       final response = await http.get(uri).timeout(const Duration(seconds: 10));

// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // // //         setState(() {
// // // // //           status =
// // // // //               'CONNECTED TO KNOWLIBOT\n\n'
// // // // //               'URL:\n'
// // // // //               '$testUrl\n\n'
// // // // //               'HTTP Status:\n'
// // // // //               '${response.statusCode}\n\n'
// // // // //               'ESP32 Response:\n'
// // // // //               '${response.body}';
// // // // //         });

// // // // //         showMessage('KNOWLIBOT connected successfully.');
// // // // //       } else {
// // // // //         setState(() {
// // // // //           status =
// // // // //               'ESP32 RESPONDED\n\n'
// // // // //               'HTTP Status:\n'
// // // // //               '${response.statusCode}\n\n'
// // // // //               'ESP32 Response:\n'
// // // // //               '${response.body}';
// // // // //         });

// // // // //         showMessage('ESP32 responded with an error.');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       setState(() {
// // // // //         status =
// // // // //             'CONNECTION FAILED\n\n'
// // // // //             '${e.toString()}';
// // // // //       });

// // // // //       showMessage('Could not connect to KNOWLIBOT.');
// // // // //     } finally {
// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       setState(() {
// // // // //         isTesting = false;
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   Future<void> uploadWavFile() async {
// // // // //     if (isUploading || isTesting) {
// // // // //       return;
// // // // //     }

// // // // //     setState(() {
// // // // //       isUploading = true;
// // // // //       uploadProgress = 0.0;
// // // // //       status = 'Loading WAV file...';
// // // // //     });

// // // // //     try {

// // // // //       final ByteData data = await rootBundle.load(wavAssetPath);

// // // // //       final Uint8List wavBytes = data.buffer.asUint8List(
// // // // //         data.offsetInBytes,
// // // // //         data.lengthInBytes,
// // // // //       );

// // // // //       if (wavBytes.isEmpty) {
// // // // //         throw Exception('WAV file is empty.');
// // // // //       }

// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       setState(() {
// // // // //         uploadProgress = 0.1;

// // // // //         status =
// // // // //             'WAV FILE LOADED\n\n'
// // // // //             'Asset:\n'
// // // // //             '$wavAssetPath\n\n'
// // // // //             'Size:\n'
// // // // //             '${wavBytes.length} bytes\n\n'
// // // // //             'Preparing request...';
// // // // //       });

// // // // //       final uri = Uri.parse(streamUrl);

// // // // //       final Map<String, String> headers = {
// // // // //         'Content-Type': 'audio/wav',
// // // // //         'Content-Length': wavBytes.length.toString(),
// // // // //         'Accept': '*/*',
// // // // //       };

// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       setState(() {
// // // // //         uploadProgress = 0.2;

// // // // //         status =
// // // // //             'PREPARING WAV REQUEST\n\n'
// // // // //             'URL:\n'
// // // // //             '$streamUrl\n\n'
// // // // //             'Method:\n'
// // // // //             'POST\n\n'
// // // // //             'Content-Type:\n'
// // // // //             'audio/wav\n\n'
// // // // //             'Content-Length:\n'
// // // // //             '${wavBytes.length} bytes';
// // // // //       });

// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       setState(() {
// // // // //         uploadProgress = 0.3;

// // // // //         status =
// // // // //             'SENDING WAV TO ESP32...\n\n'
// // // // //             'Headers sent:\n'
// // // // //             'Content-Type: audio/wav\n'
// // // // //             'Content-Length: ${wavBytes.length}\n'
// // // // //             'Accept: */*\n\n'
// // // // //             'Sending audio data...';
// // // // //       });

// // // // //       final response = await http
// // // // //           .post(uri, headers: headers, body: wavBytes)
// // // // //           .timeout(const Duration(seconds: 60));

// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // // // //         setState(() {
// // // // //           uploadProgress = 1.0;

// // // // //           status =
// // // // //               'UPLOAD SUCCESSFUL\n\n'
// // // // //               'File:\n'
// // // // //               'wav.wav\n\n'
// // // // //               'Size:\n'
// // // // //               '${wavBytes.length} bytes\n\n'
// // // // //               'URL:\n'
// // // // //               '$streamUrl\n\n'
// // // // //               'HTTP Status:\n'
// // // // //               '${response.statusCode}\n\n'
// // // // //               'ESP32 Response:\n'
// // // // //               '${response.body}';
// // // // //         });

// // // // //         showMessage('WAV file sent successfully.');
// // // // //       } else {
// // // // //         setState(() {
// // // // //           uploadProgress = 0.0;

// // // // //           status =
// // // // //               'UPLOAD FAILED\n\n'
// // // // //               'HTTP Status:\n'
// // // // //               '${response.statusCode}\n\n'
// // // // //               'ESP32 Response:\n'
// // // // //               '${response.body}';
// // // // //         });

// // // // //         showMessage('ESP32 rejected the WAV request.');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       setState(() {
// // // // //         uploadProgress = 0.0;

// // // // //         status =
// // // // //             'UPLOAD ERROR\n\n'
// // // // //             '${e.toString()}';
// // // // //       });

// // // // //       showMessage('WAV upload failed.');
// // // // //     } finally {
// // // // //       if (!mounted) {
// // // // //         return;
// // // // //       }

// // // // //       setState(() {
// // // // //         isUploading = false;
// // // // //       });
// // // // //     }
// // // // //   }

// // // // //   void showMessage(String message) {
// // // // //     ScaffoldMessenger.of(
// // // // //       context,
// // // // //     ).showSnackBar(SnackBar(content: Text(message)));
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return Scaffold(
// // // // //       appBar: AppBar(
// // // // //         title: const Text(
// // // // //           'KNOWLIBOT',
// // // // //           style: TextStyle(fontWeight: FontWeight.bold),
// // // // //         ),
// // // // //       ),

// // // // //       body: SingleChildScrollView(
// // // // //         padding: const EdgeInsets.all(20),
// // // // //         child: Column(
// // // // //           crossAxisAlignment: CrossAxisAlignment.stretch,
// // // // //           children: [
// // // // //             Card(
// // // // //               child: Padding(
// // // // //                 padding: const EdgeInsets.all(20),
// // // // //                 child: Column(
// // // // //                   children: [
// // // // //                     const Icon(Icons.memory, size: 80),

// // // // //                     const SizedBox(height: 15),

// // // // //                     const Text(
// // // // //                       'KNOWLIBOT',
// // // // //                       style: TextStyle(
// // // // //                         fontSize: 24,
// // // // //                         fontWeight: FontWeight.bold,
// // // // //                       ),
// // // // //                     ),

// // // // //                     const SizedBox(height: 10),

// // // // //                     const Text(
// // // // //                       'Connect your phone to the '
// // // // //                       'ESP32 Wi-Fi hotspot manually.',
// // // // //                       textAlign: TextAlign.center,
// // // // //                     ),

// // // // //                     const SizedBox(height: 20),

// // // // //                     // Container(
// // // // //                     //   width: double.infinity,
// // // // //                     //   padding: const EdgeInsets.all(15),
// // // // //                     //   decoration: BoxDecoration(
// // // // //                     //     color: Colors.grey.shade100,
// // // // //                     //     borderRadius: BorderRadius.circular(12),
// // // // //                     //   ),
// // // // //                     //   child: const Column(
// // // // //                     //     children: [
// // // // //                     //       Text(
// // // // //                     //         'ESP32 IP',
// // // // //                     //         style: TextStyle(fontWeight: FontWeight.bold),
// // // // //                     //       ),

// // // // //                     //       SizedBox(height: 5),

// // // // //                     //       Text(baseUrl, textAlign: TextAlign.center),
// // // // //                     //     ],
// // // // //                     //   ),
// // // // //                     // ),

// // // // //                     // const SizedBox(height: 10),

// // // // //                     // Container(
// // // // //                     //   width: double.infinity,
// // // // //                     //   padding: const EdgeInsets.all(15),
// // // // //                     //   decoration: BoxDecoration(
// // // // //                     //     color: Colors.grey.shade100,
// // // // //                     //     borderRadius: BorderRadius.circular(12),
// // // // //                     //   ),
// // // // //                     //   child: const Column(
// // // // //                     //     children: [
// // // // //                     //       Text(
// // // // //                     //         'STREAM API',
// // // // //                     //         style: TextStyle(fontWeight: FontWeight.bold),
// // // // //                     //       ),

// // // // //                     //       SizedBox(height: 5),

// // // // //                     //       Text(streamUrl, textAlign: TextAlign.center),
// // // // //                     //     ],
// // // // //                     //   ),
// // // // //                     // ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ),

// // // // //             const SizedBox(height: 20),

// // // // //             SizedBox(
// // // // //               height: 55,
// // // // //               child: ElevatedButton.icon(
// // // // //                 onPressed: isTesting || isUploading ? null : testConnection,

// // // // //                 icon: isTesting
// // // // //                     ? const SizedBox(
// // // // //                         width: 22,
// // // // //                         height: 22,
// // // // //                         child: CircularProgressIndicator(strokeWidth: 2),
// // // // //                       )
// // // // //                     : const Icon(Icons.wifi),

// // // // //                 label: Text(isTesting ? 'Testing...' : 'Test Connection'),
// // // // //               ),
// // // // //             ),

// // // // //             const SizedBox(height: 15),

// // // // //             SizedBox(
// // // // //               height: 60,
// // // // //               child: ElevatedButton.icon(
// // // // //                 onPressed: isUploading || isTesting ? null : uploadWavFile,

// // // // //                 icon: isUploading
// // // // //                     ? const SizedBox(
// // // // //                         width: 24,
// // // // //                         height: 24,
// // // // //                         child: CircularProgressIndicator(
// // // // //                           strokeWidth: 2,
// // // // //                           color: Colors.white,
// // // // //                         ),
// // // // //                       )
// // // // //                     : const Icon(Icons.upload_file),

// // // // //                 label: Text(
// // // // //                   isUploading ? 'Sending WAV...' : 'Send WAV File',

// // // // //                   style: const TextStyle(
// // // // //                     fontSize: 16,
// // // // //                     fontWeight: FontWeight.bold,
// // // // //                   ),
// // // // //                 ),
// // // // //               ),
// // // // //             ),

// // // // //             const SizedBox(height: 20),

// // // // //             if (isUploading || uploadProgress > 0)
// // // // //               Column(
// // // // //                 children: [
// // // // //                   LinearProgressIndicator(
// // // // //                     value: uploadProgress == 0 ? null : uploadProgress,
// // // // //                   ),

// // // // //                   const SizedBox(height: 10),

// // // // //                   Text(
// // // // //                     '${(uploadProgress * 100).toInt()}%',
// // // // //                     textAlign: TextAlign.center,
// // // // //                   ),
// // // // //                 ],
// // // // //               ),

// // // // //             const SizedBox(height: 10),

// // // // //             Card(
// // // // //               child: Padding(
// // // // //                 padding: const EdgeInsets.all(18),
// // // // //                 child: Column(
// // // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                   children: [
// // // // //                     const Text(
// // // // //                       'Status',
// // // // //                       style: TextStyle(
// // // // //                         fontSize: 18,
// // // // //                         fontWeight: FontWeight.bold,
// // // // //                       ),
// // // // //                     ),

// // // // //                     const SizedBox(height: 12),

// // // // //                     Container(
// // // // //                       width: double.infinity,
// // // // //                       padding: const EdgeInsets.all(15),
// // // // //                       decoration: BoxDecoration(
// // // // //                         color: Colors.grey.shade100,
// // // // //                         borderRadius: BorderRadius.circular(10),
// // // // //                       ),
// // // // //                       child: SelectableText(
// // // // //                         status,
// // // // //                         style: const TextStyle(fontSize: 14, height: 1.5),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ],
// // // // //                 ),
// // // // //               ),
// // // // //             ),
// // // // //           ],
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'dart:typed_data';

// // // // import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// // // // import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter/services.dart';
// // // // import 'package:http/http.dart' as http;

// // // // void main() {
// // // //   WidgetsFlutterBinding.ensureInitialized();
// // // //   runApp(const KNOWLIBOTApp());
// // // // }

// // // // // ============================================================
// // // // // KNOWLIBOT APP
// // // // // ============================================================

// // // // class KNOWLIBOTApp extends StatelessWidget {
// // // //   const KNOWLIBOTApp({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       debugShowCheckedModeBanner: false,
// // // //       title: 'KNOWLIBOT',
// // // //       theme: ThemeData(
// // // //         useMaterial3: true,
// // // //         colorSchemeSeed: Colors.blue,
// // // //       ),
// // // //       home: const HomePage(),
// // // //     );
// // // //   }
// // // // }

// // // // // ============================================================
// // // // // HOME PAGE
// // // // // ============================================================

// // // // class HomePage extends StatefulWidget {
// // // //   const HomePage({super.key});

// // // //   @override
// // // //   State<HomePage> createState() => _HomePageState();
// // // // }

// // // // // ============================================================
// // // // // HOME PAGE STATE
// // // // // ============================================================

// // // // class _HomePageState extends State<HomePage> {
// // // //   // ==========================================================
// // // //   // ESP32
// // // //   // ==========================================================

// // // //   static const String baseUrl = 'http://192.168.4.1';

// // // //   // Existing endpoints
// // // //   static const String testUrl = '$baseUrl/';
// // // //   static const String wavUrl = '$baseUrl/stream';
// // // //   static const String videoUrl = '$baseUrl/videostream';

// // // //   // ==========================================================
// // // //   // ASSETS
// // // //   // ==========================================================

// // // //   static const String wavAsset =
// // // //       'assets/audio/Ring09.wav';

// // // //   static const String videoAsset =
// // // //       'assets/videos/videoplayback.mp4';

// // // //   // ==========================================================
// // // //   // VIDEO SETTINGS
// // // //   // ==========================================================

// // // //   static const int videoWidth = 480;
// // // //   static const int videoHeight = 320;
// // // //   static const int videoFps = 15;

// // // //   // JPEG quality.
// // // //   // Smaller value = smaller JPEG.
// // // //   static const int jpegQuality = 8;

// // // //   // ==========================================================
// // // //   // AUDIO SETTINGS
// // // //   // ==========================================================

// // // //   static const int audioSampleRate = 16000;
// // // //   static const int audioChannels = 1;
// // // //   static const int audioBits = 16;

// // // //   // ==========================================================
// // // //   // APP STATE
// // // //   // ==========================================================

// // // //   bool isConnected = false;
// // // //   bool isBusy = false;

// // // //   double progress = 0.0;

// // // //   String status = 'ESP32 not connected';

// // // //   // ==========================================================
// // // //   // UPDATE STATUS
// // // //   // ==========================================================

// // // //   void updateStatus(String value) {
// // // //     if (!mounted) return;

// // // //     setState(() {
// // // //       status = value;
// // // //     });
// // // //   }

// // // //   // ==========================================================
// // // //   // UPDATE PROGRESS
// // // //   // ==========================================================

// // // //   void updateProgress(double value) {
// // // //     if (!mounted) return;

// // // //     setState(() {
// // // //       progress = value.clamp(0.0, 1.0);
// // // //     });
// // // //   }

// // // //   // ==========================================================
// // // //   // TEST CONNECTION
// // // //   // ==========================================================

// // // //   Future<void> testConnection() async {
// // // //     if (isBusy) return;

// // // //     setState(() {
// // // //       isBusy = true;
// // // //       isConnected = false;
// // // //       progress = 0.0;
// // // //       status = 'Testing ESP32 connection...';
// // // //     });

// // // //     try {
// // // //       final response = await http
// // // //           .get(
// // // //             Uri.parse(testUrl),
// // // //           )
// // // //           .timeout(
// // // //             const Duration(seconds: 5),
// // // //           );

// // // //       if (response.statusCode == 200) {
// // // //         setState(() {
// // // //           isConnected = true;
// // // //           status =
// // // //               'ESP32 connected successfully ✓\n'
// // // //               '${response.body}';
// // // //         });
// // // //       } else {
// // // //         setState(() {
// // // //           isConnected = false;
// // // //           status =
// // // //               'ESP32 connection failed ✗\n'
// // // //               'HTTP ${response.statusCode}';
// // // //         });
// // // //       }
// // // //     } catch (e) {
// // // //       setState(() {
// // // //         isConnected = false;
// // // //         status =
// // // //             'ESP32 connection failed ✗\n'
// // // //             '$e';
// // // //       });
// // // //     } finally {
// // // //       if (mounted) {
// // // //         setState(() {
// // // //           isBusy = false;
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // SEND WAV
// // // //   // ==========================================================

// // // //   Future<void> sendWav() async {
// // // //     // Safety check
// // // //     if (!isConnected) {
// // // //       updateStatus(
// // // //         'Please test the connection first.',
// // // //       );
// // // //       return;
// // // //     }

// // // //     if (isBusy) return;

// // // //     setState(() {
// // // //       isBusy = true;
// // // //       progress = 0.0;
// // // //       status = 'Loading WAV file...';
// // // //     });

// // // //     try {
// // // //       // ------------------------------------------------------
// // // //       // Load WAV asset
// // // //       // ------------------------------------------------------

// // // //       final ByteData data =
// // // //           await rootBundle.load(wavAsset);

// // // //       final Uint8List wavBytes =
// // // //           data.buffer.asUint8List(
// // // //         data.offsetInBytes,
// // // //         data.lengthInBytes,
// // // //       );

// // // //       updateStatus(
// // // //         'Sending WAV file...\n'
// // // //         '${wavBytes.length} bytes',
// // // //       );

// // // //       // ------------------------------------------------------
// // // //       // Create HTTP request
// // // //       // ------------------------------------------------------

// // // //       final request = http.Request(
// // // //         'POST',
// // // //         Uri.parse(wavUrl),
// // // //       );

// // // //       request.headers['Content-Type'] =
// // // //           'audio/wav';

// // // //       request.headers['X-Audio-Format'] =
// // // //           'wav';

// // // //       request.headers['X-Audio-Sample-Rate'] =
// // // //           audioSampleRate.toString();

// // // //       request.headers['X-Audio-Channels'] =
// // // //           audioChannels.toString();

// // // //       request.headers['X-Audio-Bits'] =
// // // //           audioBits.toString();

// // // //       request.headers['Content-Length'] =
// // // //           wavBytes.length.toString();

// // // //       request.bodyBytes = wavBytes;

// // // //       // ------------------------------------------------------
// // // //       // Send
// // // //       // ------------------------------------------------------

// // // //       final response =
// // // //           await request.send();

// // // //       final responseBody =
// // // //           await response.stream.bytesToString();

// // // //       if (response.statusCode >= 200 &&
// // // //           response.statusCode < 300) {
// // // //         updateProgress(1.0);

// // // //         updateStatus(
// // // //           'WAV sent successfully ✓\n'
// // // //           'HTTP ${response.statusCode}\n'
// // // //           '$responseBody',
// // // //         );
// // // //       } else {
// // // //         updateStatus(
// // // //           'WAV sending failed ✗\n'
// // // //           'HTTP ${response.statusCode}\n'
// // // //           '$responseBody',
// // // //         );
// // // //       }
// // // //     } catch (e) {
// // // //       updateStatus(
// // // //         'WAV sending failed ✗\n'
// // // //         '$e',
// // // //       );
// // // //     } finally {
// // // //       if (mounted) {
// // // //         setState(() {
// // // //           isBusy = false;
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // PREPARE VIDEO
// // // //   // ==========================================================

// // // //   Future<String> prepareVideo(
// // // //     Directory directory,
// // // //   ) async {
// // // //     final videoFile = File(
// // // //       '${directory.path}/input.mp4',
// // // //     );

// // // //     final ByteData data =
// // // //         await rootBundle.load(videoAsset);

// // // //     final Uint8List bytes =
// // // //         data.buffer.asUint8List(
// // // //       data.offsetInBytes,
// // // //       data.lengthInBytes,
// // // //     );

// // // //     await videoFile.writeAsBytes(bytes);

// // // //     return videoFile.path;
// // // //   }

// // // //   // ==========================================================
// // // //   // GET VIDEO DURATION
// // // //   // ==========================================================

// // // //   Future<double> getVideoDuration(
// // // //     String videoPath,
// // // //   ) async {
// // // //     double duration = 10.0;

// // // //     try {
// // // //       final session =
// // // //           await FFmpegKit.execute(
// // // //         '-i "$videoPath" -f null -',
// // // //       );

// // // //       final output =
// // // //           await session.getOutput();

// // // //       if (output != null) {
// // // //         final regex = RegExp(
// // // //           r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)',
// // // //         );

// // // //         final match =
// // // //             regex.firstMatch(output);

// // // //         if (match != null) {
// // // //           final hours =
// // // //               int.parse(match.group(1)!);

// // // //           final minutes =
// // // //               int.parse(match.group(2)!);

// // // //           final seconds =
// // // //               double.parse(match.group(3)!);

// // // //           duration =
// // // //               (hours * 3600) +
// // // //               (minutes * 60) +
// // // //               seconds;
// // // //         }
// // // //       }
// // // //     } catch (_) {
// // // //       // Use default duration
// // // //     }

// // // //     return duration;
// // // //   }

// // // //   // ==========================================================
// // // //   // CONVERT VIDEO AUDIO TO WAV
// // // //   // ==========================================================

// // // //   Future<String> convertVideoAudioToWav(
// // // //     String videoPath,
// // // //     String outputDirectory,
// // // //   ) async {
// // // //     final wavPath =
// // // //         '$outputDirectory/video_audio.wav';

// // // //     updateStatus(
// // // //       'Converting video audio to WAV...',
// // // //     );

// // // //     final session =
// // // //         await FFmpegKit.execute(
// // // //       '-y '
// // // //       '-i "$videoPath" '
// // // //       '-vn '
// // // //       '-ac $audioChannels '
// // // //       '-ar $audioSampleRate '
// // // //       '-c:a pcm_s16le '
// // // //       '"$wavPath"',
// // // //     );

// // // //     final returnCode =
// // // //         await session.getReturnCode();

// // // //     if (!ReturnCode.isSuccess(returnCode)) {
// // // //       throw Exception(
// // // //         'Video audio conversion failed.',
// // // //       );
// // // //     }

// // // //     return wavPath;
// // // //   }

// // // //   // ==========================================================
// // // //   // SEND VIDEO HEADER
// // // //   // ==========================================================

// // // //   Future<void> sendVideoHeader({
// // // //     required double duration,
// // // //     required int totalFrames,
// // // //   }) async {
// // // //     final header = {
// // // //       'type': 'video_header',

// // // //       'width': videoWidth,
// // // //       'height': videoHeight,

// // // //       'fps': videoFps,

// // // //       'format': 'jpeg',
// // // //       'video_codec': 'jpeg',

// // // //       'duration': duration,
// // // //       'total_frames': totalFrames,

// // // //       'audio': true,
// // // //       'audio_format': 'wav',
// // // //       'audio_codec': 'pcm_s16le',

// // // //       'audio_sample_rate':
// // // //           audioSampleRate,

// // // //       'audio_channels':
// // // //           audioChannels,

// // // //       'audio_bits':
// // // //           audioBits,
// // // //     };

// // // //     final response =
// // // //         await http.post(
// // // //       Uri.parse(videoUrl),
// // // //       headers: {
// // // //         'Content-Type':
// // // //             'application/json',

// // // //         'X-Video-Part':
// // // //             'header',
// // // //       },
// // // //       body: jsonEncode(header),
// // // //     ).timeout(
// // // //       const Duration(seconds: 10),
// // // //     );

// // // //     if (response.statusCode < 200 ||
// // // //         response.statusCode >= 300) {
// // // //       throw Exception(
// // // //         'Video header failed.\n'
// // // //         'HTTP ${response.statusCode}\n'
// // // //         '${response.body}',
// // // //       );
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // SEND VIDEO FRAME
// // // //   // ==========================================================

// // // //   Future<void> sendVideoFrame({
// // // //     required Uint8List frameBytes,
// // // //     required int frameNumber,
// // // //   }) async {
// // // //     final response =
// // // //         await http.post(
// // // //       Uri.parse(videoUrl),
// // // //       headers: {
// // // //         'Content-Type':
// // // //             'image/jpeg',

// // // //         'X-Video-Part':
// // // //             'frame',

// // // //         'X-Frame-Number':
// // // //             frameNumber.toString(),

// // // //         'X-Video-Width':
// // // //             videoWidth.toString(),

// // // //         'X-Video-Height':
// // // //             videoHeight.toString(),

// // // //         'X-Video-FPS':
// // // //             videoFps.toString(),

// // // //         'X-Frame-Format':
// // // //             'jpeg',

// // // //         'Content-Length':
// // // //             frameBytes.length.toString(),
// // // //       },
// // // //       body: frameBytes,
// // // //     ).timeout(
// // // //       const Duration(seconds: 10),
// // // //     );

// // // //     if (response.statusCode < 200 ||
// // // //         response.statusCode >= 300) {
// // // //       throw Exception(
// // // //         'Frame $frameNumber failed.\n'
// // // //         'HTTP ${response.statusCode}\n'
// // // //         '${response.body}',
// // // //       );
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // SEND VIDEO AUDIO
// // // //   // ==========================================================

// // // //   Future<void> sendVideoAudio(
// // // //     String wavPath,
// // // //   ) async {
// // // //     final wavFile =
// // // //         File(wavPath);

// // // //     if (!await wavFile.exists()) {
// // // //       throw Exception(
// // // //         'Converted WAV file not found.',
// // // //       );
// // // //     }

// // // //     final wavBytes =
// // // //         await wavFile.readAsBytes();

// // // //     updateStatus(
// // // //       'Sending video WAV audio...\n'
// // // //       '${wavBytes.length} bytes',
// // // //     );

// // // //     final response =
// // // //         await http.post(
// // // //       Uri.parse(videoUrl),
// // // //       headers: {
// // // //         'Content-Type':
// // // //             'audio/wav',

// // // //         'X-Video-Part':
// // // //             'audio',

// // // //         'X-Audio-Format':
// // // //             'wav',

// // // //         'X-Audio-Codec':
// // // //             'pcm_s16le',

// // // //         'X-Audio-Sample-Rate':
// // // //             audioSampleRate.toString(),

// // // //         'X-Audio-Channels':
// // // //             audioChannels.toString(),

// // // //         'X-Audio-Bits':
// // // //             audioBits.toString(),

// // // //         'Content-Length':
// // // //             wavBytes.length.toString(),
// // // //       },
// // // //       body: wavBytes,
// // // //     ).timeout(
// // // //       const Duration(minutes: 2),
// // // //     );

// // // //     if (response.statusCode < 200 ||
// // // //         response.statusCode >= 300) {
// // // //       throw Exception(
// // // //         'Video audio failed.\n'
// // // //         'HTTP ${response.statusCode}\n'
// // // //         '${response.body}',
// // // //       );
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // SEND VIDEO END
// // // //   // ==========================================================

// // // //   Future<void> sendVideoEnd({
// // // //     required int framesSent,
// // // //   }) async {
// // // //     final endData = {
// // // //       'type': 'video_end',

// // // //       'frames_sent':
// // // //           framesSent,

// // // //       'width':
// // // //           videoWidth,

// // // //       'height':
// // // //           videoHeight,

// // // //       'fps':
// // // //           videoFps,

// // // //       'format':
// // // //           'jpeg',

// // // //       'audio':
// // // //           true,

// // // //       'audio_format':
// // // //           'wav',
// // // //     };

// // // //     final response =
// // // //         await http.post(
// // // //       Uri.parse(videoUrl),
// // // //       headers: {
// // // //         'Content-Type':
// // // //             'application/json',

// // // //         'X-Video-Part':
// // // //             'end',
// // // //       },
// // // //       body: jsonEncode(endData),
// // // //     ).timeout(
// // // //       const Duration(seconds: 10),
// // // //     );

// // // //     if (response.statusCode < 200 ||
// // // //         response.statusCode >= 300) {
// // // //       throw Exception(
// // // //         'Video end failed.\n'
// // // //         'HTTP ${response.statusCode}\n'
// // // //         '${response.body}',
// // // //       );
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // STREAM VIDEO + AUDIO
// // // //   // ==========================================================

// // // //   Future<void> streamVideo() async {
// // // //     // --------------------------------------------------------
// // // //     // CONNECTION CHECK
// // // //     // --------------------------------------------------------

// // // //     if (!isConnected) {
// // // //       updateStatus(
// // // //         'Please test the connection first.',
// // // //       );
// // // //       return;
// // // //     }

// // // //     if (isBusy) return;

// // // //     setState(() {
// // // //       isBusy = true;
// // // //       progress = 0.0;
// // // //       status = 'Preparing video...';
// // // //     });

// // // //     Directory? tempDirectory;

// // // //     try {
// // // //       // ------------------------------------------------------
// // // //       // Check video asset
// // // //       // ------------------------------------------------------

// // // //       try {
// // // //         await rootBundle.load(
// // // //           videoAsset,
// // // //         );
// // // //       } catch (_) {
// // // //         throw Exception(
// // // //           'Video file not found.\n\n'
// // // //           'Add this file:\n'
// // // //           'assets/videos/knowlibot.mp4\n\n'
// // // //           'Then add it to pubspec.yaml.',
// // // //         );
// // // //       }

// // // //       // ------------------------------------------------------
// // // //       // Create temporary directory
// // // //       // ------------------------------------------------------

// // // //       tempDirectory =
// // // //           await Directory.systemTemp
// // // //               .createTemp(
// // // //         'knowlibot_video',
// // // //       );

// // // //       // ------------------------------------------------------
// // // //       // Copy MP4 to temporary storage
// // // //       // ------------------------------------------------------

// // // //       final videoPath =
// // // //           await prepareVideo(
// // // //         tempDirectory,
// // // //       );

// // // //       // ------------------------------------------------------
// // // //       // Get duration
// // // //       // ------------------------------------------------------

// // // //       updateStatus(
// // // //         'Reading video information...',
// // // //       );

// // // //       final duration =
// // // //           await getVideoDuration(
// // // //         videoPath,
// // // //       );

// // // //       final totalFrames =
// // // //           (duration * videoFps).ceil();

// // // //       updateStatus(
// // // //         'Video information\n'
// // // //         'Resolution: '
// // // //         '$videoWidth × $videoHeight\n'
// // // //         'FPS: $videoFps\n'
// // // //         'Duration: '
// // // //         '${duration.toStringAsFixed(2)} sec\n'
// // // //         'Frames: $totalFrames',
// // // //       );

// // // //       // ------------------------------------------------------
// // // //       // Convert video audio to WAV
// // // //       // ------------------------------------------------------

// // // //       final wavPath =
// // // //           await convertVideoAudioToWav(
// // // //         videoPath,
// // // //         tempDirectory.path,
// // // //       );

// // // //       // ------------------------------------------------------
// // // //       // SEND HEADER FIRST
// // // //       // ------------------------------------------------------

// // // //       updateStatus(
// // // //         'Sending video header...',
// // // //       );

// // // //       await sendVideoHeader(
// // // //         duration: duration,
// // // //         totalFrames: totalFrames,
// // // //       );

// // // //       // ------------------------------------------------------
// // // //       // SEND AUDIO
// // // //       // ------------------------------------------------------

// // // //       await sendVideoAudio(
// // // //         wavPath,
// // // //       );

// // // //       // ------------------------------------------------------
// // // //       // VIDEO FRAME GENERATION
// // // //       // ------------------------------------------------------

// // // //       int frameNumber = 0;

// // // //       const double batchDuration = 2.0;

// // // //       double currentTime = 0.0;

// // // //       while (currentTime < duration) {
// // // //         final remaining =
// // // //             duration - currentTime;

// // // //         final currentBatchDuration =
// // // //             remaining < batchDuration
// // // //                 ? remaining
// // // //                 : batchDuration;

// // // //         // ----------------------------------------------------
// // // //         // Delete old JPEG frames
// // // //         // ----------------------------------------------------

// // // //         final oldFiles =
// // // //             tempDirectory
// // // //                 .listSync()
// // // //                 .where(
// // // //                   (file) =>
// // // //                       file.path.endsWith(
// // // //                     '.jpg',
// // // //                   ),
// // // //                 )
// // // //                 .toList();

// // // //         for (final file in oldFiles) {
// // // //           try {
// // // //             await File(
// // // //               file.path,
// // // //             ).delete();
// // // //           } catch (_) {}
// // // //         }

// // // //         // ----------------------------------------------------
// // // //         // Extract JPEG frames
// // // //         // ----------------------------------------------------

// // // //         updateStatus(
// // // //           'Extracting video frames...\n'
// // // //           'Time: '
// // // //           '${currentTime.toStringAsFixed(2)} / '
// // // //           '${duration.toStringAsFixed(2)} sec',
// // // //         );

// // // //         final framePattern =
// // // //             '${tempDirectory.path}/frame_%06d.jpg';

// // // //         final command =
// // // //             '-y '
// // // //             '-ss $currentTime '
// // // //             '-t $currentBatchDuration '
// // // //             '-i "$videoPath" '
// // // //             '-vf "scale=$videoWidth:$videoHeight,fps=$videoFps" '
// // // //             '-q:v $jpegQuality '
// // // //             '"$framePattern"';

// // // //         final session =
// // // //             await FFmpegKit.execute(
// // // //           command,
// // // //         );

// // // //         final returnCode =
// // // //             await session.getReturnCode();

// // // //         if (!ReturnCode.isSuccess(
// // // //           returnCode,
// // // //         )) {
// // // //           throw Exception(
// // // //             'Failed to extract video frames.',
// // // //           );
// // // //         }

// // // //         // ----------------------------------------------------
// // // //         // Get JPEG frames
// // // //         // ----------------------------------------------------

// // // //         final frameFiles =
// // // //             tempDirectory
// // // //                 .listSync()
// // // //                 .where(
// // // //                   (file) =>
// // // //                       file.path.endsWith(
// // // //                     '.jpg',
// // // //                   ),
// // // //                 )
// // // //                 .map(
// // // //                   (file) => File(
// // // //                     file.path,
// // // //                   ),
// // // //                 )
// // // //                 .toList()
// // // //               ..sort(
// // // //                 (a, b) =>
// // // //                     a.path.compareTo(
// // // //                   b.path,
// // // //                 ),
// // // //               );

// // // //         // ----------------------------------------------------
// // // //         // Send JPEG frames
// // // //         // ----------------------------------------------------

// // // //         for (final frameFile
// // // //             in frameFiles) {
// // // //           final frameBytes =
// // // //               await frameFile.readAsBytes();

// // // //           await sendVideoFrame(
// // // //             frameBytes: frameBytes,
// // // //             frameNumber: frameNumber,
// // // //           );

// // // //           frameNumber++;

// // // //           final percentage =
// // // //               frameNumber /
// // // //                   totalFrames;

// // // //           updateProgress(
// // // //             percentage,
// // // //           );

// // // //           updateStatus(
// // // //             'Streaming video...\n'
// // // //             'Frame: '
// // // //             '$frameNumber / '
// // // //             '$totalFrames\n'
// // // //             '${(percentage * 100).toStringAsFixed(1)}%',
// // // //           );

// // // //           // 15 FPS ≈ 66.67 milliseconds
// // // //           await Future.delayed(
// // // //             const Duration(
// // // //               milliseconds: 67,
// // // //             ),
// // // //           );
// // // //         }

// // // //         currentTime +=
// // // //             currentBatchDuration;
// // // //       }

// // // //       // ------------------------------------------------------
// // // //       // SEND END
// // // //       // ------------------------------------------------------

// // // //       updateStatus(
// // // //         'Sending video end...',
// // // //       );

// // // //       await sendVideoEnd(
// // // //         framesSent: frameNumber,
// // // //       );

// // // //       updateProgress(1.0);

// // // //       updateStatus(
// // // //         'Video + audio completed ✓\n'
// // // //         'Frames sent: $frameNumber',
// // // //       );
// // // //     } catch (e) {
// // // //       updateStatus(
// // // //         'Video streaming failed ✗\n'
// // // //         '$e',
// // // //       );
// // // //     } finally {
// // // //       // ------------------------------------------------------
// // // //       // Cleanup
// // // //       // ------------------------------------------------------

// // // //       if (tempDirectory != null) {
// // // //         try {
// // // //           await tempDirectory.delete(
// // // //             recursive: true,
// // // //           );
// // // //         } catch (_) {}
// // // //       }

// // // //       if (mounted) {
// // // //         setState(() {
// // // //           isBusy = false;
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   // ==========================================================
// // // //   // UI
// // // //   // ==========================================================

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Scaffold(
// // // //       appBar: AppBar(
// // // //         title: const Text(
// // // //           'KNOWLIBOT',
// // // //           style: TextStyle(
// // // //             fontWeight: FontWeight.bold,
// // // //           ),
// // // //         ),
// // // //         centerTitle: true,
// // // //       ),

// // // //       body: SafeArea(
// // // //         child: SingleChildScrollView(
// // // //           padding:
// // // //               const EdgeInsets.all(20),
// // // //           child: Column(
// // // //             crossAxisAlignment:
// // // //                 CrossAxisAlignment.stretch,
// // // //             children: [
// // // //               // =================================================
// // // //               // DEVICE CARD
// // // //               // =================================================

// // // //               Card(
// // // //                 child: Padding(
// // // //                   padding:
// // // //                       const EdgeInsets.all(18),
// // // //                   child: Column(
// // // //                     crossAxisAlignment:
// // // //                         CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       const Text(
// // // //                         'ESP32-S3 Device',
// // // //                         style: TextStyle(
// // // //                           fontSize: 20,
// // // //                           fontWeight:
// // // //                               FontWeight.bold,
// // // //                         ),
// // // //                       ),

// // // //                       const SizedBox(
// // // //                         height: 10,
// // // //                       ),

// // // //                       Text(
// // // //                         'IP Address: '
// // // //                         '192.168.4.1',
// // // //                         style: TextStyle(
// // // //                           color: Colors
// // // //                               .grey.shade700,
// // // //                         ),
// // // //                       ),

// // // //                       const SizedBox(
// // // //                         height: 8,
// // // //                       ),

// // // //                       Row(
// // // //                         children: [
// // // //                           Icon(
// // // //                             isConnected
// // // //                                 ? Icons
// // // //                                     .check_circle
// // // //                                 : Icons
// // // //                                     .cancel,
// // // //                             size: 20,
// // // //                             color: isConnected
// // // //                                 ? Colors.green
// // // //                                 : Colors.red,
// // // //                           ),

// // // //                           const SizedBox(
// // // //                             width: 8,
// // // //                           ),

// // // //                           Text(
// // // //                             isConnected
// // // //                                 ? 'Connected'
// // // //                                 : 'Disconnected',
// // // //                             style:
// // // //                                 TextStyle(
// // // //                               fontWeight:
// // // //                                   FontWeight
// // // //                                       .w600,
// // // //                               color:
// // // //                                   isConnected
// // // //                                       ? Colors
// // // //                                           .green
// // // //                                       : Colors
// // // //                                           .red,
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //               const SizedBox(
// // // //                 height: 20,
// // // //               ),

// // // //               // =================================================
// // // //               // TEST CONNECTION
// // // //               // =================================================

// // // //               SizedBox(
// // // //                 height: 52,
// // // //                 child:
// // // //                     ElevatedButton.icon(
// // // //                   onPressed:
// // // //                       isBusy
// // // //                           ? null
// // // //                           : testConnection,
// // // //                   icon: const Icon(
// // // //                     Icons.wifi,
// // // //                   ),
// // // //                   label: const Text(
// // // //                     'Test Connection',
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //               const SizedBox(
// // // //                 height: 12,
// // // //               ),

// // // //               // =================================================
// // // //               // SEND WAV
// // // //               // =================================================

// // // //               SizedBox(
// // // //                 height: 52,
// // // //                 child:
// // // //                     OutlinedButton.icon(
// // // //                   onPressed:
// // // //                       (!isConnected ||
// // // //                               isBusy)
// // // //                           ? null
// // // //                           : sendWav,
// // // //                   icon: const Icon(
// // // //                     Icons.audio_file,
// // // //                   ),
// // // //                   label: const Text(
// // // //                     'Send WAV File',
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //               const SizedBox(
// // // //                 height: 12,
// // // //               ),

// // // //               // =================================================
// // // //               // STREAM VIDEO
// // // //               // =================================================

// // // //               SizedBox(
// // // //                 height: 52,
// // // //                 child:
// // // //                     ElevatedButton.icon(
// // // //                   onPressed:
// // // //                       (!isConnected ||
// // // //                               isBusy)
// // // //                           ? null
// // // //                           : streamVideo,
// // // //                   icon: const Icon(
// // // //                     Icons.video_file,
// // // //                   ),
// // // //                   label: const Text(
// // // //                     'Stream Video + Audio',
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //               const SizedBox(
// // // //                 height: 25,
// // // //               ),

// // // //               // =================================================
// // // //               // PROGRESS
// // // //               // =================================================

// // // //               if (isBusy) ...[
// // // //                 LinearProgressIndicator(
// // // //                   value: progress,
// // // //                 ),

// // // //                 const SizedBox(
// // // //                   height: 10,
// // // //                 ),

// // // //                 Text(
// // // //                   '${(progress * 100).toStringAsFixed(1)}%',
// // // //                   textAlign:
// // // //                       TextAlign.center,
// // // //                 ),

// // // //                 const SizedBox(
// // // //                   height: 15,
// // // //                 ),
// // // //               ],

// // // //               // =================================================
// // // //               // STATUS
// // // //               // =================================================

// // // //               Card(
// // // //                 child: Padding(
// // // //                   padding:
// // // //                       const EdgeInsets.all(18),
// // // //                   child: Column(
// // // //                     crossAxisAlignment:
// // // //                         CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       const Text(
// // // //                         'Status',
// // // //                         style: TextStyle(
// // // //                           fontSize: 18,
// // // //                           fontWeight:
// // // //                               FontWeight.bold,
// // // //                         ),
// // // //                       ),

// // // //                       const SizedBox(
// // // //                         height: 10,
// // // //                       ),

// // // //                       Text(
// // // //                         status,
// // // //                         style:
// // // //                             const TextStyle(
// // // //                           fontSize: 15,
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),

// // // //               const SizedBox(
// // // //                 height: 20,
// // // //               ),

// // // //               // =================================================
// // // //               // API CARD
// // // //               // =================================================

// // // //               Card(
// // // //                 child: Padding(
// // // //                   padding:
// // // //                       const EdgeInsets.all(18),
// // // //                   child: Column(
// // // //                     crossAxisAlignment:
// // // //                         CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       const Text(
// // // //                         'ESP32 API',
// // // //                         style: TextStyle(
// // // //                           fontSize: 18,
// // // //                           fontWeight:
// // // //                               FontWeight.bold,
// // // //                         ),
// // // //                       ),

// // // //                       const SizedBox(
// // // //                         height: 12,
// // // //                       ),

// // // //                       _apiRow(
// // // //                         'Connection',
// // // //                         'GET /',
// // // //                       ),

// // // //                       _apiRow(
// // // //                         'WAV',
// // // //                         'POST /stream',
// // // //                       ),

// // // //                       _apiRow(
// // // //                         'Video',
// // // //                         'POST /video',
// // // //                       ),

// // // //                       const SizedBox(
// // // //                         height: 15,
// // // //                       ),

// // // //                       const Text(
// // // //                         'Video configuration',
// // // //                         style: TextStyle(
// // // //                           fontWeight:
// // // //                               FontWeight.bold,
// // // //                         ),
// // // //                       ),

// // // //                       const SizedBox(
// // // //                         height: 6,
// // // //                       ),

// // // //                       const Text(
// // // //                         'Resolution: 480 × 320\n'
// // // //                         'FPS: 15\n'
// // // //                         'Video: JPEG frames\n'
// // // //                         'Audio: WAV\n'
// // // //                         'Sample rate: 16 kHz\n'
// // // //                         'Channels: Mono\n'
// // // //                         'Bits: 16-bit',
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // ==========================================================
// // // //   // API ROW
// // // //   // ==========================================================

// // // //   Widget _apiRow(
// // // //     String title,
// // // //     String endpoint,
// // // //   ) {
// // // //     return Padding(
// // // //       padding:
// // // //           const EdgeInsets.only(
// // // //         bottom: 8,
// // // //       ),
// // // //       child: Row(
// // // //         children: [
// // // //           SizedBox(
// // // //             width: 110,
// // // //             child: Text(
// // // //               title,
// // // //               style: const TextStyle(
// // // //                 fontWeight:
// // // //                     FontWeight.w600,
// // // //               ),
// // // //             ),
// // // //           ),

// // // //           Expanded(
// // // //             child: Text(
// // // //               endpoint,
// // // //               style: TextStyle(
// // // //                 color:
// // // //                     Colors.grey.shade700,
// // // //               ),
// // // //             ),
// // // //           ),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'dart:typed_data';

// // // import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// // // import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:wifi_iot/wifi_iot.dart';

// // // void main() {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   runApp(const KNOWLIBOTApp());
// // // }

// // // // ============================================================
// // // // KNOWLIBOT APP
// // // // ============================================================

// // // class KNOWLIBOTApp extends StatelessWidget {
// // //   const KNOWLIBOTApp({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       title: 'KNOWLIBOT',
// // //       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
// // //       home: const HomePage(),
// // //     );
// // //   }
// // // }

// // // // ============================================================
// // // // HOME PAGE
// // // // ============================================================

// // // class HomePage extends StatefulWidget {
// // //   const HomePage({super.key});

// // //   @override
// // //   State<HomePage> createState() => _HomePageState();
// // // }

// // // // ============================================================
// // // // HOME PAGE STATE
// // // // ============================================================

// // // class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
// // //   // ==========================================================
// // //   // ESP32
// // //   // ==========================================================

// // //   static const String baseUrl = 'http://192.168.4.1';

// // //   // Connection test
// // //   static const String testUrl = '$baseUrl/';

// // //   // WAV endpoint
// // //   static const String wavUrl = '$baseUrl/stream';

// // //   // Video endpoint
// // //   static const String videoUrl = '$baseUrl/videostream';

// // //   // ==========================================================
// // //   // ASSETS
// // //   // ==========================================================

// // //   static const String wavAsset = 'assets/audio/Ring09.wav';

// // //   // Add your video later.
// // //   // Example:
// // //   static const String videoAsset = 'assets/videos/videoplayback.mp4';

// // //   // ==========================================================
// // //   // VIDEO SETTINGS
// // //   // ==========================================================

// // //   static const int videoWidth = 480;
// // //   static const int videoHeight = 320;
// // //   static const int videoFps = 15;

// // //   static const int jpegQuality = 8;

// // //   // ==========================================================
// // //   // AUDIO SETTINGS
// // //   // ==========================================================

// // //   static const int audioSampleRate = 16000;
// // //   static const int audioChannels = 1;
// // //   static const int audioBits = 16;

// // //   // ==========================================================
// // //   // APP STATE
// // //   // ==========================================================

// // //   bool wifiEnabled = false;

// // //   bool isConnected = false;
// // //   bool isBusy = false;

// // //   double progress = 0.0;

// // //   String status = 'ESP32 not connected';

// // //   // ==========================================================
// // //   // INIT
// // //   // ==========================================================

// // //   @override
// // //   void initState() {
// // //     super.initState();

// // //     WidgetsBinding.instance.addObserver(this);

// // //     checkWifiStatus();
// // //   }

// // //   @override
// // //   void dispose() {
// // //     WidgetsBinding.instance.removeObserver(this);

// // //     super.dispose();
// // //   }

// // //   // ==========================================================
// // //   // APP RESUME
// // //   // ==========================================================

// // //   @override
// // //   void didChangeAppLifecycleState(AppLifecycleState state) {
// // //     if (state == AppLifecycleState.resumed) {
// // //       checkWifiStatus();
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // CHECK WIFI
// // //   // ==========================================================

// // //   Future<void> checkWifiStatus() async {
// // //     try {
// // //       final enabled = await WiFiForIoTPlugin.isEnabled();

// // //       if (!mounted) return;

// // //       setState(() {
// // //         wifiEnabled = enabled;
// // //       });

// // //       if (!enabled) {
// // //         isConnected = false;

// // //         showWifiSnackbar();
// // //       }
// // //     } catch (e) {
// // //       if (!mounted) return;

// // //       setState(() {
// // //         wifiEnabled = false;
// // //         isConnected = false;
// // //       });
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // WIFI SNACKBAR
// // //   // ==========================================================

// // //   void showWifiSnackbar() {
// // //     if (!mounted) return;

// // //     ScaffoldMessenger.of(context).hideCurrentSnackBar();

// // //     ScaffoldMessenger.of(context).showSnackBar(
// // //       SnackBar(
// // //         content: const Text('Wi-Fi is OFF. Please enable Wi-Fi.'),
// // //         duration: const Duration(seconds: 6),
// // //         action: SnackBarAction(
// // //           label: 'ENABLE',
// // //           onPressed: showEnableWifiDialog,
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // ==========================================================
// // //   // ENABLE WIFI DIALOG
// // //   // ==========================================================

// // //   void showEnableWifiDialog() {
// // //     if (!mounted) return;

// // //     showDialog(
// // //       context: context,
// // //       builder: (context) {
// // //         return AlertDialog(
// // //           title: const Text('Enable Wi-Fi?'),
// // //           content: const Text(
// // //             'KNOWLIBOT needs Wi-Fi to communicate '
// // //             'with the ESP32 device.\n\n'
// // //             'Android will open Wi-Fi settings so '
// // //             'you can enable it.',
// // //           ),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () {
// // //                 Navigator.pop(context);
// // //               },
// // //               child: const Text('CANCEL'),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: () async {
// // //                 Navigator.pop(context);

// // //                 try {
// // //                   await WiFiForIoTPlugin.setEnabled(
// // //                     true,
// // //                     shouldOpenSettings: true,
// // //                   );
// // //                 } catch (e) {
// // //                   if (!mounted) return;

// // //                   showMessage('Could not open Wi-Fi settings.');
// // //                 }
// // //               },
// // //               child: const Text('ENABLE'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }

// // //   // ==========================================================
// // //   // SHOW MESSAGE
// // //   // ==========================================================

// // //   void showMessage(String message) {
// // //     if (!mounted) return;

// // //     ScaffoldMessenger.of(context).hideCurrentSnackBar();

// // //     ScaffoldMessenger.of(
// // //       context,
// // //     ).showSnackBar(SnackBar(content: Text(message)));
// // //   }

// // //   // ==========================================================
// // //   // UPDATE STATUS
// // //   // ==========================================================

// // //   void updateStatus(String value) {
// // //     if (!mounted) return;

// // //     setState(() {
// // //       status = value;
// // //     });
// // //   }

// // //   // ==========================================================
// // //   // UPDATE PROGRESS
// // //   // ==========================================================

// // //   void updateProgress(double value) {
// // //     if (!mounted) return;

// // //     setState(() {
// // //       progress = value.clamp(0.0, 1.0);
// // //     });
// // //   }

// // //   // ==========================================================
// // //   // TEST ESP32 CONNECTION
// // //   // ==========================================================

// // //   Future<void> testConnection() async {
// // //     if (isBusy) return;

// // //     // Make sure Wi-Fi is enabled.
// // //     try {
// // //       final enabled = await WiFiForIoTPlugin.isEnabled();

// // //       if (!enabled) {
// // //         if (!mounted) return;

// // //         setState(() {
// // //           wifiEnabled = false;
// // //           isConnected = false;
// // //         });

// // //         showWifiSnackbar();

// // //         return;
// // //       }

// // //       if (mounted) {
// // //         setState(() {
// // //           wifiEnabled = true;
// // //         });
// // //       }
// // //     } catch (e) {
// // //       if (!mounted) return;

// // //       setState(() {
// // //         wifiEnabled = false;
// // //         isConnected = false;
// // //       });

// // //       showWifiSnackbar();

// // //       return;
// // //     }

// // //     // ========================================================
// // //     // START TEST
// // //     // ========================================================

// // //     setState(() {
// // //       isBusy = true;
// // //       isConnected = false;
// // //       progress = 0.0;
// // //       status = 'Testing ESP32 connection...';
// // //     });

// // //     try {
// // //       final response = await http
// // //           .get(Uri.parse(testUrl))
// // //           .timeout(const Duration(seconds: 5));

// // //       if (!mounted) return;

// // //       // ONLY HTTP 200 = connected
// // //       if (response.statusCode == 200) {
// // //         setState(() {
// // //           isConnected = true;

// // //           status =
// // //               'ESP32 CONNECTED ✓\n\n'
// // //               'URL:\n'
// // //               '$testUrl\n\n'
// // //               'HTTP Status:\n'
// // //               '${response.statusCode}\n\n'
// // //               'ESP32 Response:\n'
// // //               '${response.body}';
// // //         });

// // //         showMessage('KNOWLIBOT connected successfully.');
// // //       } else {
// // //         setState(() {
// // //           isConnected = false;

// // //           status =
// // //               'ESP32 CONNECTION FAILED ✗\n\n'
// // //               'HTTP Status:\n'
// // //               '${response.statusCode}\n\n'
// // //               'ESP32 Response:\n'
// // //               '${response.body}';
// // //         });

// // //         showMessage('ESP32 responded with an error.');
// // //       }
// // //     } catch (e) {
// // //       if (!mounted) return;

// // //       setState(() {
// // //         isConnected = false;

// // //         status =
// // //             'ESP32 CONNECTION FAILED ✗\n\n'
// // //             '$e';
// // //       });

// // //       showMessage('Could not connect to ESP32.');
// // //     } finally {
// // //       if (!mounted) return;

// // //       setState(() {
// // //         isBusy = false;
// // //       });
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // SEND WAV
// // //   // ==========================================================

// // //   Future<void> sendWav() async {
// // //     if (!isConnected) {
// // //       updateStatus('Please test the ESP32 connection first.');

// // //       showMessage('Test the connection first.');

// // //       return;
// // //     }

// // //     if (isBusy) return;

// // //     setState(() {
// // //       isBusy = true;
// // //       progress = 0.0;
// // //       status = 'Loading WAV file...';
// // //     });

// // //     try {
// // //       // ======================================================
// // //       // LOAD WAV
// // //       // ======================================================

// // //       final ByteData data = await rootBundle.load(wavAsset);

// // //       final Uint8List wavBytes = data.buffer.asUint8List(
// // //         data.offsetInBytes,
// // //         data.lengthInBytes,
// // //       );

// // //       if (wavBytes.isEmpty) {
// // //         throw Exception('WAV file is empty.');
// // //       }

// // //       updateProgress(0.1);

// // //       updateStatus(
// // //         'WAV FILE LOADED ✓\n\n'
// // //         'Asset:\n'
// // //         '$wavAsset\n\n'
// // //         'Size:\n'
// // //         '${wavBytes.length} bytes\n\n'
// // //         'Preparing request...',
// // //       );

// // //       // ======================================================
// // //       // CREATE REQUEST
// // //       // ======================================================

// // //       final request = http.Request('POST', Uri.parse(wavUrl));

// // //       request.headers['Content-Type'] = 'audio/wav';

// // //       request.headers['X-Audio-Format'] = 'wav';

// // //       request.headers['X-Audio-Sample-Rate'] = audioSampleRate.toString();

// // //       request.headers['X-Audio-Channels'] = audioChannels.toString();

// // //       request.headers['X-Audio-Bits'] = audioBits.toString();

// // //       request.headers['Content-Length'] = wavBytes.length.toString();

// // //       request.headers['Accept'] = '*/*';

// // //       request.bodyBytes = wavBytes;

// // //       updateProgress(0.2);

// // //       updateStatus(
// // //         'SENDING WAV TO ESP32...\n\n'
// // //         'URL:\n'
// // //         '$wavUrl\n\n'
// // //         'Method:\n'
// // //         'POST\n\n'
// // //         'Content-Type:\n'
// // //         'audio/wav\n\n'
// // //         'Size:\n'
// // //         '${wavBytes.length} bytes',
// // //       );

// // //       // ======================================================
// // //       // SEND WAV
// // //       // ======================================================

// // //       final response = await request.send().timeout(
// // //         const Duration(seconds: 60),
// // //       );

// // //       final responseBody = await response.stream.bytesToString();

// // //       if (!mounted) return;

// // //       if (response.statusCode >= 200 && response.statusCode < 300) {
// // //         updateProgress(1.0);

// // //         updateStatus(
// // //           'WAV SENT SUCCESSFULLY ✓\n\n'
// // //           'HTTP Status:\n'
// // //           '${response.statusCode}\n\n'
// // //           'Response:\n'
// // //           '$responseBody',
// // //         );

// // //         showMessage('WAV file sent successfully.');
// // //       } else {
// // //         updateStatus(
// // //           'WAV SENDING FAILED ✗\n\n'
// // //           'HTTP Status:\n'
// // //           '${response.statusCode}\n\n'
// // //           'Response:\n'
// // //           '$responseBody',
// // //         );

// // //         showMessage('ESP32 rejected the WAV request.');
// // //       }
// // //     } catch (e) {
// // //       updateStatus(
// // //         'WAV SENDING ERROR ✗\n\n'
// // //         '$e',
// // //       );

// // //       showMessage('WAV upload failed.');
// // //     } finally {
// // //       if (!mounted) return;

// // //       setState(() {
// // //         isBusy = false;
// // //       });
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // PREPARE VIDEO
// // //   // ==========================================================

// // //   Future<String> prepareVideo(Directory directory, String videoAsset) async {
// // //     final videoFile = File('${directory.path}/input.mp4');

// // //     final ByteData data = await rootBundle.load(videoAsset);

// // //     final Uint8List bytes = data.buffer.asUint8List(
// // //       data.offsetInBytes,
// // //       data.lengthInBytes,
// // //     );

// // //     await videoFile.writeAsBytes(bytes);

// // //     return videoFile.path;
// // //   }

// // //   // ==========================================================
// // //   // GET VIDEO DURATION
// // //   // ==========================================================

// // //   Future<double> getVideoDuration(String videoPath) async {
// // //     double duration = 10.0;

// // //     try {
// // //       final session = await FFmpegKit.execute('-i "$videoPath" -f null -');

// // //       final output = await session.getOutput();

// // //       if (output != null) {
// // //         final regex = RegExp(r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)');

// // //         final match = regex.firstMatch(output);

// // //         if (match != null) {
// // //           final hours = int.parse(match.group(1)!);

// // //           final minutes = int.parse(match.group(2)!);

// // //           final seconds = double.parse(match.group(3)!);

// // //           duration = (hours * 3600) + (minutes * 60) + seconds;
// // //         }
// // //       }
// // //     } catch (_) {
// // //       // Keep default duration.
// // //     }

// // //     return duration;
// // //   }

// // //   // ==========================================================
// // //   // CONVERT VIDEO AUDIO TO WAV
// // //   // ==========================================================

// // //   Future<String> convertVideoAudioToWav(
// // //     String videoPath,
// // //     String outputDirectory,
// // //   ) async {
// // //     final wavPath = '$outputDirectory/video_audio.wav';

// // //     updateStatus('Converting video audio to WAV...');

// // //     final session = await FFmpegKit.execute(
// // //       '-y '
// // //       '-i "$videoPath" '
// // //       '-vn '
// // //       '-ac $audioChannels '
// // //       '-ar $audioSampleRate '
// // //       '-c:a pcm_s16le '
// // //       '"$wavPath"',
// // //     );

// // //     final returnCode = await session.getReturnCode();

// // //     if (!ReturnCode.isSuccess(returnCode)) {
// // //       throw Exception('Video audio conversion failed.');
// // //     }

// // //     return wavPath;
// // //   }

// // //   // ==========================================================
// // //   // EXTRACT VIDEO FRAMES
// // //   // ==========================================================

// // //   Future<String> extractVideoFrames(
// // //     String videoPath,
// // //     String outputDirectory,
// // //   ) async {
// // //     final framesDirectory = Directory('$outputDirectory/frames');

// // //     if (!await framesDirectory.exists()) {
// // //       await framesDirectory.create(recursive: true);
// // //     }

// // //     updateStatus('Extracting video frames...');

// // //     final outputPattern = '${framesDirectory.path}/frame_%06d.jpg';

// // //     final command =
// // //         '-y '
// // //         '-i "$videoPath" '
// // //         '-vf "scale=$videoWidth:$videoHeight,fps=$videoFps" '
// // //         '-q:v $jpegQuality '
// // //         '"$outputPattern"';

// // //     final session = await FFmpegKit.execute(command);

// // //     final returnCode = await session.getReturnCode();

// // //     if (!ReturnCode.isSuccess(returnCode)) {
// // //       throw Exception('Video frame extraction failed.');
// // //     }

// // //     return framesDirectory.path;
// // //   }

// // //   // ==========================================================
// // //   // SEND VIDEO HEADER
// // //   // ==========================================================

// // //   Future<void> sendVideoHeader({
// // //     required double duration,
// // //     required int totalFrames,
// // //   }) async {
// // //     final header = {
// // //       'type': 'video_header',

// // //       'width': videoWidth,
// // //       'height': videoHeight,

// // //       'fps': videoFps,

// // //       'format': 'jpeg',
// // //       'video_codec': 'jpeg',

// // //       'duration': duration,
// // //       'total_frames': totalFrames,

// // //       'audio': true,
// // //       'audio_format': 'wav',
// // //       'audio_codec': 'pcm_s16le',

// // //       'audio_sample_rate': audioSampleRate,

// // //       'audio_channels': audioChannels,

// // //       'audio_bits': audioBits,
// // //     };

// // //     final response = await http
// // //         .post(
// // //           Uri.parse(videoUrl),
// // //           headers: {
// // //             'Content-Type': 'application/json',

// // //             'X-Video-Part': 'header',
// // //           },
// // //           body: jsonEncode(header),
// // //         )
// // //         .timeout(const Duration(seconds: 10));

// // //     if (response.statusCode < 200 || response.statusCode >= 300) {
// // //       throw Exception(
// // //         'Video header failed.\n'
// // //         'HTTP ${response.statusCode}\n'
// // //         '${response.body}',
// // //       );
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // SEND VIDEO AUDIO
// // //   // ==========================================================

// // //   Future<void> sendVideoAudio(Uint8List wavBytes) async {
// // //     final response = await http
// // //         .post(
// // //           Uri.parse(videoUrl),
// // //           headers: {
// // //             'Content-Type': 'audio/wav',

// // //             'X-Video-Part': 'audio',

// // //             'X-Audio-Format': 'wav',

// // //             'X-Audio-Sample-Rate': audioSampleRate.toString(),

// // //             'X-Audio-Channels': audioChannels.toString(),

// // //             'X-Audio-Bits': audioBits.toString(),

// // //             'Content-Length': wavBytes.length.toString(),
// // //           },
// // //           body: wavBytes,
// // //         )
// // //         .timeout(const Duration(seconds: 60));

// // //     if (response.statusCode < 200 || response.statusCode >= 300) {
// // //       throw Exception(
// // //         'Video audio failed.\n'
// // //         'HTTP ${response.statusCode}\n'
// // //         '${response.body}',
// // //       );
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // SEND VIDEO FRAME
// // //   // ==========================================================

// // //   Future<void> sendVideoFrame({
// // //     required Uint8List frameBytes,
// // //     required int frameNumber,
// // //   }) async {
// // //     final response = await http
// // //         .post(
// // //           Uri.parse(videoUrl),
// // //           headers: {
// // //             'Content-Type': 'image/jpeg',

// // //             'X-Video-Part': 'frame',

// // //             'X-Frame-Number': frameNumber.toString(),

// // //             'X-Video-Width': videoWidth.toString(),

// // //             'X-Video-Height': videoHeight.toString(),

// // //             'X-Video-FPS': videoFps.toString(),

// // //             'X-Frame-Format': 'jpeg',

// // //             'Content-Length': frameBytes.length.toString(),
// // //           },
// // //           body: frameBytes,
// // //         )
// // //         .timeout(const Duration(seconds: 10));

// // //     if (response.statusCode < 200 || response.statusCode >= 300) {
// // //       throw Exception(
// // //         'Frame $frameNumber failed.\n'
// // //         'HTTP ${response.statusCode}\n'
// // //         '${response.body}',
// // //       );
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // SEND VIDEO END
// // //   // ==========================================================

// // //   Future<void> sendVideoEnd() async {
// // //     final response = await http
// // //         .post(
// // //           Uri.parse(videoUrl),
// // //           headers: {'Content-Type': 'application/json', 'X-Video-Part': 'end'},
// // //           body: jsonEncode({'type': 'video_end'}),
// // //         )
// // //         .timeout(const Duration(seconds: 10));

// // //     if (response.statusCode < 200 || response.statusCode >= 300) {
// // //       throw Exception(
// // //         'Video end failed.\n'
// // //         'HTTP ${response.statusCode}\n'
// // //         '${response.body}',
// // //       );
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // SEND VIDEO
// // //   // ==========================================================

// // //   Future<void> sendVideo() async {
// // //     if (!isConnected) {
// // //       updateStatus('Please test the ESP32 connection first.');

// // //       showMessage('Test the connection first.');

// // //       return;
// // //     }

// // //     if (isBusy) return;

// // //     // const String videoAsset = 'assets/videos/videoplayback.mp4';

// // //     setState(() {
// // //       isBusy = true;
// // //       progress = 0.0;
// // //       status = 'Preparing video...';
// // //     });

// // //     Directory? tempDirectory;

// // //     try {
// // //       // ======================================================
// // //       // CREATE TEMP DIRECTORY
// // //       // ======================================================

// // //       tempDirectory = await Directory.systemTemp.createTemp('knowlibot_video_');

// // //       // ======================================================
// // //       // COPY VIDEO ASSET
// // //       // ======================================================

// // //       updateStatus('Loading video...');

// // //       final videoPath = await prepareVideo(tempDirectory, videoAsset);

// // //       updateProgress(0.05);

// // //       // ======================================================
// // //       // GET DURATION
// // //       // ======================================================

// // //       final duration = await getVideoDuration(videoPath);

// // //       // ======================================================
// // //       // EXTRACT FRAMES
// // //       // ======================================================

// // //       final framesDirectory = await extractVideoFrames(
// // //         videoPath,
// // //         tempDirectory.path,
// // //       );

// // //       // ======================================================
// // //       // FIND FRAMES
// // //       // ======================================================

// // //       final frameDirectory = Directory(framesDirectory);

// // //       final frameFiles = frameDirectory
// // //           .listSync()
// // //           .whereType<File>()
// // //           .where((file) => file.path.toLowerCase().endsWith('.jpg'))
// // //           .toList();

// // //       frameFiles.sort((a, b) => a.path.compareTo(b.path));

// // //       if (frameFiles.isEmpty) {
// // //         throw Exception('No video frames were generated.');
// // //       }

// // //       // ======================================================
// // //       // SEND HEADER
// // //       // ======================================================

// // //       updateStatus(
// // //         'Sending video header...\n'
// // //         '${frameFiles.length} frames',
// // //       );

// // //       await sendVideoHeader(duration: duration, totalFrames: frameFiles.length);

// // //       updateProgress(0.10);

// // //       // ======================================================
// // //       // CONVERT AUDIO
// // //       // ======================================================

// // //       final wavPath = await convertVideoAudioToWav(
// // //         videoPath,
// // //         tempDirectory.path,
// // //       );

// // //       final wavFile = File(wavPath);

// // //       final wavBytes = await wavFile.readAsBytes();

// // //       // ======================================================
// // //       // SEND AUDIO
// // //       // ======================================================

// // //       updateStatus(
// // //         'Sending video audio...\n'
// // //         '${wavBytes.length} bytes',
// // //       );

// // //       await sendVideoAudio(wavBytes);

// // //       updateProgress(0.20);

// // //       // ======================================================
// // //       // SEND FRAMES
// // //       // ======================================================

// // //       for (int i = 0; i < frameFiles.length; i++) {
// // //         final frameFile = frameFiles[i];

// // //         final frameBytes = await frameFile.readAsBytes();

// // //         await sendVideoFrame(frameBytes: frameBytes, frameNumber: i);

// // //         final frameProgress = 0.20 + (0.75 * ((i + 1) / frameFiles.length));

// // //         updateProgress(frameProgress);

// // //         updateStatus(
// // //           'Sending video frames...\n\n'
// // //           'Frame: ${i + 1} / '
// // //           '${frameFiles.length}\n'
// // //           'Size: ${frameBytes.length} bytes',
// // //         );
// // //       }

// // //       // ======================================================
// // //       // SEND END
// // //       // ======================================================

// // //       await sendVideoEnd();

// // //       updateProgress(1.0);

// // //       updateStatus(
// // //         'VIDEO SENT SUCCESSFULLY ✓\n\n'
// // //         'Frames:\n'
// // //         '${frameFiles.length}\n\n'
// // //         'Resolution:\n'
// // //         '${videoWidth} × $videoHeight\n\n'
// // //         'FPS:\n'
// // //         '$videoFps\n\n'
// // //         'Audio:\n'
// // //         '16-bit PCM WAV\n'
// // //         '16 kHz Mono',
// // //       );

// // //       showMessage('Video sent successfully.');
// // //     } catch (e) {
// // //       updateStatus(
// // //         'VIDEO SENDING FAILED ✗\n\n'
// // //         '$e',
// // //       );

// // //       showMessage('Video sending failed.');
// // //     } finally {
// // //       // ======================================================
// // //       // CLEAN TEMP FILES
// // //       // ======================================================

// // //       try {
// // //         if (tempDirectory != null && await tempDirectory.exists()) {
// // //           await tempDirectory.delete(recursive: true);
// // //         }
// // //       } catch (_) {}

// // //       if (!mounted) return;

// // //       setState(() {
// // //         isBusy = false;
// // //       });
// // //     }
// // //   }

// // //   // ==========================================================
// // //   // BUILD UI
// // //   // ==========================================================

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text(
// // //           'KNOWLIBOT',
// // //           style: TextStyle(fontWeight: FontWeight.bold),
// // //         ),
// // //         centerTitle: true,
// // //       ),

// // //       body: SingleChildScrollView(
// // //         padding: const EdgeInsets.all(20),

// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.stretch,

// // //           children: [
// // //             // ==================================================
// // //             // MAIN CARD
// // //             // ==================================================
// // //             Card(
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(20),

// // //                 child: Column(
// // //                   children: [
// // //                     const Icon(Icons.memory, size: 80),

// // //                     const SizedBox(height: 15),

// // //                     const Text(
// // //                       'KNOWLIBOT',
// // //                       style: TextStyle(
// // //                         fontSize: 24,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 10),

// // //                     const Text(
// // //                       'Connect your phone to the '
// // //                       'ESP32 Wi-Fi hotspot manually '
// // //                       'from Android Wi-Fi settings.',
// // //                       textAlign: TextAlign.center,
// // //                     ),

// // //                     const SizedBox(height: 20),

// // //                     // ==========================================
// // //                     // WIFI STATUS
// // //                     // ==========================================
// // //                     Container(
// // //                       width: double.infinity,

// // //                       padding: const EdgeInsets.all(15),

// // //                       decoration: BoxDecoration(
// // //                         color: wifiEnabled
// // //                             ? Colors.green.withValues(alpha: 0.1)
// // //                             : Colors.red.withValues(alpha: 0.1),

// // //                         borderRadius: BorderRadius.circular(12),
// // //                       ),

// // //                       child: Row(
// // //                         children: [
// // //                           Icon(
// // //                             wifiEnabled ? Icons.wifi : Icons.wifi_off,

// // //                             color: wifiEnabled ? Colors.green : Colors.red,
// // //                           ),

// // //                           const SizedBox(width: 12),

// // //                           Expanded(
// // //                             child: Text(
// // //                               wifiEnabled ? 'Wi-Fi is ON' : 'Wi-Fi is OFF',
// // //                               style: const TextStyle(
// // //                                 fontWeight: FontWeight.bold,
// // //                               ),
// // //                             ),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 15),

// // //                     // ==========================================
// // //                     // ESP32 IP
// // //                     // ==========================================
// // //                     Container(
// // //                       width: double.infinity,

// // //                       padding: const EdgeInsets.all(15),

// // //                       decoration: BoxDecoration(
// // //                         color: Colors.grey.shade100,

// // //                         borderRadius: BorderRadius.circular(12),
// // //                       ),

// // //                       child: const Column(
// // //                         children: [
// // //                           Text(
// // //                             'ESP32 IP Address',
// // //                             style: TextStyle(fontWeight: FontWeight.bold),
// // //                           ),

// // //                           SizedBox(height: 5),

// // //                           Text('192.168.4.1', style: TextStyle(fontSize: 16)),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),

// // //             const SizedBox(height: 20),

// // //             // ==================================================
// // //             // TEST CONNECTION BUTTON
// // //             // ==================================================
// // //             SizedBox(
// // //               height: 55,

// // //               child: ElevatedButton.icon(
// // //                 onPressed: (!wifiEnabled || isBusy) ? null : testConnection,

// // //                 icon: isBusy
// // //                     ? const SizedBox(
// // //                         width: 22,
// // //                         height: 22,
// // //                         child: CircularProgressIndicator(
// // //                           strokeWidth: 2,
// // //                           color: Colors.white,
// // //                         ),
// // //                       )
// // //                     : const Icon(Icons.wifi_find),

// // //                 label: Text(isBusy ? 'Testing...' : 'Test Connection'),
// // //               ),
// // //             ),

// // //             const SizedBox(height: 15),

// // //             // ==================================================
// // //             // SEND WAV BUTTON
// // //             // ==================================================
// // //             SizedBox(
// // //               height: 60,

// // //               child: ElevatedButton.icon(
// // //                 onPressed: (!isConnected || isBusy) ? null : sendWav,

// // //                 icon: const Icon(Icons.audio_file),

// // //                 label: const Text(
// // //                   'Send WAV File',
// // //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //                 ),
// // //               ),
// // //             ),

// // //             const SizedBox(height: 15),

// // //             // ==================================================
// // //             // SEND VIDEO BUTTON
// // //             // ==================================================
// // //             SizedBox(
// // //               height: 60,

// // //               child: ElevatedButton.icon(
// // //                 onPressed: (!isConnected || isBusy) ? null : sendVideo,

// // //                 icon: const Icon(Icons.video_file),

// // //                 label: const Text(
// // //                   'Send Video',
// // //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //                 ),
// // //               ),
// // //             ),

// // //             const SizedBox(height: 20),

// // //             // ==================================================
// // //             // PROGRESS
// // //             // ==================================================
// // //             if (isBusy || progress > 0)
// // //               Column(
// // //                 children: [
// // //                   LinearProgressIndicator(
// // //                     value: progress == 0 ? null : progress,
// // //                   ),

// // //                   const SizedBox(height: 10),

// // //                   Text(
// // //                     '${(progress * 100).toInt()}%',
// // //                     textAlign: TextAlign.center,
// // //                   ),

// // //                   const SizedBox(height: 10),
// // //                 ],
// // //               ),

// // //             // ==================================================
// // //             // STATUS CARD
// // //             // ==================================================
// // //             Card(
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(18),

// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,

// // //                   children: [
// // //                     const Text(
// // //                       'Status',
// // //                       style: TextStyle(
// // //                         fontSize: 18,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),

// // //                     const SizedBox(height: 12),

// // //                     Container(
// // //                       width: double.infinity,

// // //                       padding: const EdgeInsets.all(15),

// // //                       decoration: BoxDecoration(
// // //                         color: Colors.grey.shade100,

// // //                         borderRadius: BorderRadius.circular(10),
// // //                       ),

// // //                       child: SelectableText(
// // //                         status,
// // //                         style: const TextStyle(fontSize: 14, height: 1.5),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),

// // //             const SizedBox(height: 20),

// // //             // ==================================================
// // //             // INFORMATION
// // //             // ==================================================
// // //             Card(
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(18),

// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,

// // //                   children: const [
// // //                     Text(
// // //                       'How it works',
// // //                       style: TextStyle(
// // //                         fontSize: 18,
// // //                         fontWeight: FontWeight.bold,
// // //                       ),
// // //                     ),

// // //                     SizedBox(height: 12),

// // //                     Text(
// // //                       '1. Turn ON Wi-Fi.\n'
// // //                       '2. Connect your phone manually '
// // //                       'to the ESP32 hotspot.\n'
// // //                       '3. Return to KNOWLIBOT.\n'
// // //                       '4. Press Test Connection.\n'
// // //                       '5. After a successful test, '
// // //                       'send WAV or Video.',
// // //                       style: TextStyle(height: 1.6),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'dart:convert';
// // import 'dart:io';
// // import 'dart:typed_data';

// // import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// // import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:wifi_iot/wifi_iot.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(const KnowlibotApp());
// // }

// // class KnowlibotApp extends StatelessWidget {
// //   const KnowlibotApp({super.key});

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

// // class HomePage extends StatefulWidget {
// //   const HomePage({super.key});

// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   // ============================================================
// //   // ESP32
// //   // ============================================================

// //   static const String baseUrl = 'http://192.168.4.1';

// //   static const String testUrl = '$baseUrl/';
// //   static const String wavUrl = '$baseUrl/stream';
// //   static const String videoUrl = '$baseUrl/video';

// //   // ============================================================
// //   // AUDIO
// //   // ============================================================

// //   static const String wavAsset = 'assets/audio/Ring09.wav';

// //   // ============================================================
// //   // VIDEO
// //   // ============================================================

// //   static const String videoAsset = 'assets/videos/knowlibot.mp4';

// //   // ESP32-friendly settings
// //   static const int videoWidth = 480;
// //   static const int videoHeight = 320;

// //   // Reduced from 15 FPS to 10 FPS
// //   static const int videoFps = 10;

// //   // Higher number = smaller JPEG
// //   static const int jpegQuality = 12;

// //   // ============================================================
// //   // AUDIO FORMAT
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
// //   // INIT
// //   // ============================================================

// //   @override
// //   void initState() {
// //     super.initState();

// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       checkWifi();
// //     });
// //   }

// //   // ============================================================
// //   // STATUS
// //   // ============================================================

// //   void updateStatus(String value) {
// //     if (!mounted) return;

// //     setState(() {
// //       status = value;
// //     });
// //   }

// //   void updateProgress(double value) {
// //     if (!mounted) return;

// //     setState(() {
// //       progress = value.clamp(0.0, 1.0);
// //     });
// //   }

// //   void showMessage(String message) {
// //     if (!mounted) return;

// //     ScaffoldMessenger.of(context).hideCurrentSnackBar();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         duration: const Duration(seconds: 3),
// //       ),
// //     );
// //   }

// //   // ============================================================
// //   // CHECK WIFI
// //   // ============================================================

// //   Future<void> checkWifi() async {
// //     try {
// //       final enabled = await WiFiForIoTPlugin.isEnabled();

// //       if (!mounted) return;

// //       setState(() {
// //         isWifiEnabled = enabled;
// //       });

// //       if (!enabled) {
// //         showWifiEnableMessage();
// //       }
// //     } catch (e) {
// //       updateStatus('Unable to check Wi-Fi.');
// //     }
// //   }

// //   // ============================================================
// //   // WIFI ENABLE MESSAGE
// //   // ============================================================

// //   void showWifiEnableMessage() {
// //     if (!mounted) return;

// //     ScaffoldMessenger.of(context).hideCurrentSnackBar();

// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: const Text(
// //           'Wi-Fi is OFF. Please enable Wi-Fi.',
// //         ),
// //         duration: const Duration(seconds: 8),
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
// //           title: const Text('Enable Wi-Fi'),
// //           content: const Text(
// //             'Wi-Fi is currently disabled.\n\n'
// //             'The Android Wi-Fi settings will open so you can enable it manually.',
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context, false);
// //               },
// //               child: const Text('CANCEL'),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.pop(context, true);
// //               },
// //               child: const Text('OPEN SETTINGS'),
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
// //         showMessage('Could not open Wi-Fi settings.');
// //       }
// //     }
// //   }

// //   // ============================================================
// //   // TEST ESP32 CONNECTION
// //   // ============================================================

// //   Future<void> testConnection() async {
// //     if (isBusy) return;

// //     setState(() {
// //       isBusy = true;
// //       isConnected = false;
// //       progress = 0.0;
// //       status = 'Testing ESP32 connection...';
// //     });

// //     try {
// //       final response = await http
// //           .get(Uri.parse(testUrl))
// //           .timeout(const Duration(seconds: 10));

// //       if (response.statusCode == 200) {
// //         setState(() {
// //           isConnected = true;
// //           status = 'ESP32 connected ✓';
// //           progress = 1.0;
// //         });

// //         showMessage('ESP32 connection successful.');
// //       } else {
// //         setState(() {
// //           isConnected = false;
// //           status =
// //               'ESP32 connection failed.\n'
// //               'HTTP ${response.statusCode}\n'
// //               '${response.body}';
// //         });

// //         showMessage('ESP32 connection failed.');
// //       }
// //     } catch (e) {
// //       setState(() {
// //         isConnected = false;
// //         status = 'Connection error:\n$e';
// //       });

// //       showMessage('Could not connect to ESP32.');
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           isBusy = false;
// //         });
// //       }
// //     }
// //   }

// //   // ============================================================
// //   // SEND WAV
// //   // ============================================================

// //   Future<void> sendWav() async {
// //     if (!isConnected) {
// //       showMessage('Test the ESP32 connection first.');
// //       return;
// //     }

// //     if (isBusy) return;

// //     setState(() {
// //       isBusy = true;
// //       progress = 0.0;
// //       status = 'Preparing WAV...';
// //     });

// //     try {
// //       final byteData = await rootBundle.load(wavAsset);

// //       final wavBytes = byteData.buffer.asUint8List(
// //         byteData.offsetInBytes,
// //         byteData.lengthInBytes,
// //       );

// //       updateStatus(
// //         'Sending WAV...\n'
// //         '${wavBytes.length} bytes',
// //       );

// //       final response = await http
// //           .post(
// //             Uri.parse(wavUrl),
// //             headers: {
// //               'Content-Type': 'audio/wav',
// //               'Content-Length': wavBytes.length.toString(),
// //             },
// //             body: wavBytes,
// //           )
// //           .timeout(const Duration(minutes: 2));

// //       if (response.statusCode < 200 ||
// //           response.statusCode >= 300) {
// //         throw Exception(
// //           'WAV sending failed.\n'
// //           'HTTP ${response.statusCode}\n'
// //           '${response.body}',
// //         );
// //       }

// //       updateProgress(1.0);

// //       updateStatus(
// //         'WAV SENT SUCCESSFULLY ✓\n\n'
// //         '${wavBytes.length} bytes',
// //       );

// //       showMessage('WAV sent successfully.');
// //     } catch (e) {
// //       updateStatus(
// //         'WAV SENDING FAILED ✗\n\n$e',
// //       );

// //       showMessage('WAV sending failed.');
// //     } finally {
// //       if (mounted) {
// //         setState(() {
// //           isBusy = false;
// //         });
// //       }
// //     }
// //   }

// //   // ============================================================
// //   // PREPARE VIDEO
// //   // ============================================================

// //   Future<String> prepareVideo(
// //     Directory directory,
// //     String assetPath,
// //   ) async {
// //     final outputPath =
// //         '${directory.path}/input_video.mp4';

// //     final byteData =
// //         await rootBundle.load(assetPath);

// //     final bytes = byteData.buffer.asUint8List(
// //       byteData.offsetInBytes,
// //       byteData.lengthInBytes,
// //     );

// //     final file = File(outputPath);

// //     await file.writeAsBytes(
// //       bytes,
// //       flush: true,
// //     );

// //     return outputPath;
// //   }

// //   // ============================================================
// //   // GET VIDEO DURATION
// //   // ============================================================

// //   Future<double> getVideoDuration(
// //     String videoPath,
// //   ) async {
// //     double duration = 0.0;

// //     final session = await FFmpegKit.execute(
// //       '-i "$videoPath"',
// //     );

// //     final output = await session.getOutput();

// //     if (output == null) {
// //       return duration;
// //     }

// //     final regex = RegExp(
// //       r'Duration:\s*(\d+):(\d+):([\d.]+)',
// //     );

// //     final match = regex.firstMatch(output);

// //     if (match != null) {
// //       final hours =
// //           int.tryParse(match.group(1) ?? '0') ?? 0;

// //       final minutes =
// //           int.tryParse(match.group(2) ?? '0') ?? 0;

// //       final seconds =
// //           double.tryParse(match.group(3) ?? '0') ?? 0;

// //       duration =
// //           (hours * 3600) +
// //           (minutes * 60) +
// //           seconds;
// //     }

// //     return duration;
// //   }

// //   // ============================================================
// //   // CONVERT VIDEO AUDIO TO WAV
// //   // ============================================================

// //   Future<String> convertVideoAudioToWav(
// //     String videoPath,
// //     String outputDirectory,
// //   ) async {
// //     final wavPath =
// //         '$outputDirectory/video_audio.wav';

// //     updateStatus(
// //       'Converting video audio to WAV...',
// //     );

// //     final session = await FFmpegKit.execute(
// //       '-y '
// //       '-i "$videoPath" '
// //       '-vn '
// //       '-ac $audioChannels '
// //       '-ar $audioSampleRate '
// //       '-c:a pcm_s16le '
// //       '"$wavPath"',
// //     );

// //     final returnCode =
// //         await session.getReturnCode();

// //     if (!ReturnCode.isSuccess(returnCode)) {
// //       throw Exception(
// //         'Video audio conversion failed.',
// //       );
// //     }

// //     return wavPath;
// //   }

// //   // ============================================================
// //   // EXTRACT VIDEO FRAMES
// //   // ============================================================

// //   Future<String> extractVideoFrames(
// //     String videoPath,
// //     String outputDirectory,
// //   ) async {
// //     final framesDirectory =
// //         Directory('$outputDirectory/frames');

// //     if (await framesDirectory.exists()) {
// //       await framesDirectory.delete(
// //         recursive: true,
// //       );
// //     }

// //     await framesDirectory.create(
// //       recursive: true,
// //     );

// //     updateStatus(
// //       'Extracting JPEG frames...\n'
// //       'Resolution: $videoWidth × $videoHeight\n'
// //       'FPS: $videoFps',
// //     );

// //     final outputPattern =
// //         '${framesDirectory.path}/frame_%06d.jpg';

// //     /*
// //      * IMPORTANT:
// //      *
// //      * force_original_aspect_ratio=disable
// //      * guarantees exactly 480x320.
// //      *
// //      * format=yuvj420p makes a standard JPEG-compatible
// //      * YUV pixel format.
// //      */

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
// //         await FFmpegKit.execute(command);

// //     final returnCode =
// //         await session.getReturnCode();

// //     if (!ReturnCode.isSuccess(returnCode)) {
// //       final output =
// //           await session.getOutput();

// //       throw Exception(
// //         'Video frame extraction failed.\n'
// //         '$output',
// //       );
// //     }

// //     return framesDirectory.path;
// //   }

// //   // ============================================================
// //   // SEND VIDEO HEADER
// //   // ============================================================

// //   Future<void> sendVideoHeader({
// //     required double duration,
// //     required int totalFrames,
// //   }) async {
// //     /*
// //      * Keep this header compatible with the previous
// //      * ESP32 protocol.
// //      */

// //     final header = {
// //       'type': 'video_header',
// //       'width': videoWidth,
// //       'height': videoHeight,
// //       'fps': videoFps,
// //       'duration': duration,
// //       'format': 'jpeg',
// //       'audio': 'wav',
// //       'sample_rate': audioSampleRate,
// //       'channels': audioChannels,
// //       'bits_per_sample': audioBits,
// //     };

// //     final response = await http
// //         .post(
// //           Uri.parse(videoUrl),
// //           headers: {
// //             'Content-Type': 'application/json',
// //             'X-Video-Part': 'header',
// //           },
// //           body: jsonEncode(header),
// //         )
// //         .timeout(
// //           const Duration(seconds: 15),
// //         );

// //     if (response.statusCode < 200 ||
// //         response.statusCode >= 300) {
// //       throw Exception(
// //         'Video header failed.\n'
// //         'HTTP ${response.statusCode}\n'
// //         '${response.body}',
// //       );
// //     }
// //   }

// //   // ============================================================
// //   // SEND VIDEO AUDIO
// //   // ============================================================

// //   Future<void> sendVideoAudio(
// //     Uint8List wavBytes,
// //   ) async {
// //     updateStatus(
// //       'Sending video audio...\n'
// //       '${wavBytes.length} bytes',
// //     );

// //     final response = await http
// //         .post(
// //           Uri.parse(videoUrl),
// //           headers: {
// //             'Content-Type': 'audio/wav',
// //             'X-Video-Part': 'audio',
// //             'X-Audio-Format': 'wav',
// //             'X-Audio-Codec': 'pcm_s16le',
// //             'X-Audio-Sample-Rate':
// //                 audioSampleRate.toString(),
// //             'X-Audio-Channels':
// //                 audioChannels.toString(),
// //             'X-Audio-Bits':
// //                 audioBits.toString(),
// //             'Content-Length':
// //                 wavBytes.length.toString(),
// //           },
// //           body: wavBytes,
// //         )
// //         .timeout(
// //           const Duration(minutes: 2),
// //         );

// //     if (response.statusCode < 200 ||
// //         response.statusCode >= 300) {
// //       throw Exception(
// //         'Video audio failed.\n'
// //         'HTTP ${response.statusCode}\n'
// //         '${response.body}',
// //       );
// //     }
// //   }

// //   // ============================================================
// //   // SEND ONE JPEG FRAME
// //   // ============================================================

// //   Future<void> sendVideoFrame({
// //     required Uint8List frameBytes,
// //     required int frameNumber,
// //   }) async {
// //     /*
// //      * Every frame is sent as RAW BINARY JPEG data.
// //      *
// //      * Do NOT convert frameBytes to Base64.
// //      */

// //     final response = await http
// //         .post(
// //           Uri.parse(videoUrl),
// //           headers: {
// //             'Content-Type': 'image/jpeg',

// //             'X-Video-Part': 'frame',

// //             'X-Frame-Number':
// //                 frameNumber.toString(),

// //             'X-Video-Width':
// //                 videoWidth.toString(),

// //             'X-Video-Height':
// //                 videoHeight.toString(),

// //             'X-Video-FPS':
// //                 videoFps.toString(),

// //             'X-Frame-Format':
// //                 'jpeg',

// //             'Content-Length':
// //                 frameBytes.length.toString(),
// //           },

// //           // RAW JPEG BYTES
// //           body: frameBytes,
// //         )
// //         .timeout(
// //           const Duration(seconds: 30),
// //         );

// //     if (response.statusCode < 200 ||
// //         response.statusCode >= 300) {
// //       throw Exception(
// //         'Bad frame $frameNumber.\n'
// //         'Size: ${frameBytes.length} bytes\n'
// //         'HTTP ${response.statusCode}\n'
// //         '${response.body}',
// //       );
// //     }
// //   }

// //   // ============================================================
// //   // SEND VIDEO END
// //   // ============================================================

// //   Future<void> sendVideoEnd({
// //     required int framesSent,
// //   }) async {
// //     final endData = {
// //       'type': 'video_end',
// //       'frames_sent': framesSent,
// //       'width': videoWidth,
// //       'height': videoHeight,
// //       'fps': videoFps,
// //       'format': 'jpeg',
// //       'audio': true,
// //       'audio_format': 'wav',
// //     };

// //     final response = await http
// //         .post(
// //           Uri.parse(videoUrl),
// //           headers: {
// //             'Content-Type':
// //                 'application/json',
// //             'X-Video-Part': 'end',
// //           },
// //           body: jsonEncode(endData),
// //         )
// //         .timeout(
// //           const Duration(seconds: 15),
// //         );

// //     if (response.statusCode < 200 ||
// //         response.statusCode >= 300) {
// //       throw Exception(
// //         'Video end failed.\n'
// //         'HTTP ${response.statusCode}\n'
// //         '${response.body}',
// //       );
// //     }
// //   }

// //   // ============================================================
// //   // SEND VIDEO
// //   // ============================================================

// //   Future<void> sendVideo() async {
// //     if (!isConnected) {
// //       showMessage(
// //         'Test the ESP32 connection first.',
// //       );
// //       return;
// //     }

// //     if (isBusy) return;

// //     setState(() {
// //       isBusy = true;
// //       progress = 0.0;
// //       status = 'Preparing video...';
// //     });

// //     Directory? tempDirectory;

// //     try {
// //       // --------------------------------------------------------
// //       // CHECK VIDEO FILE
// //       // --------------------------------------------------------

// //       try {
// //         await rootBundle.load(videoAsset);
// //       } catch (_) {
// //         throw Exception(
// //           'Video file not found.\n\n'
// //           'Add:\n'
// //           '$videoAsset\n\n'
// //           'and add it to pubspec.yaml.',
// //         );
// //       }

// //       // --------------------------------------------------------
// //       // CREATE TEMP DIRECTORY
// //       // --------------------------------------------------------

// //       tempDirectory =
// //           await Directory.systemTemp.createTemp(
// //         'knowlibot_video_',
// //       );

// //       // --------------------------------------------------------
// //       // COPY VIDEO
// //       // --------------------------------------------------------

// //       updateStatus('Loading video...');

// //       final videoPath =
// //           await prepareVideo(
// //         tempDirectory,
// //         videoAsset,
// //       );

// //       updateProgress(0.05);

// //       // --------------------------------------------------------
// //       // GET DURATION
// //       // --------------------------------------------------------

// //       final duration =
// //           await getVideoDuration(videoPath);

// //       // --------------------------------------------------------
// //       // EXTRACT JPEG FRAMES
// //       // --------------------------------------------------------

// //       final framesDirectory =
// //           await extractVideoFrames(
// //         videoPath,
// //         tempDirectory.path,
// //       );

// //       // --------------------------------------------------------
// //       // FIND JPEG FILES
// //       // --------------------------------------------------------

// //       final frameDirectory =
// //           Directory(framesDirectory);

// //       final frameFiles = frameDirectory
// //           .listSync()
// //           .whereType<File>()
// //           .where(
// //             (file) => file.path
// //                 .toLowerCase()
// //                 .endsWith('.jpg'),
// //           )
// //           .toList();

// //       frameFiles.sort(
// //         (a, b) => a.path.compareTo(b.path),
// //       );

// //       if (frameFiles.isEmpty) {
// //         throw Exception(
// //           'No JPEG video frames were generated.',
// //         );
// //       }

// //       // --------------------------------------------------------
// //       // SEND HEADER
// //       // --------------------------------------------------------

// //       updateStatus(
// //         'Sending video header...\n'
// //         'Frames: ${frameFiles.length}\n'
// //         'Resolution: $videoWidth × $videoHeight\n'
// //         'FPS: $videoFps',
// //       );

// //       await sendVideoHeader(
// //         duration: duration,
// //         totalFrames: frameFiles.length,
// //       );

// //       updateProgress(0.10);

// //       // --------------------------------------------------------
// //       // CONVERT AUDIO
// //       // --------------------------------------------------------

// //       final wavPath =
// //           await convertVideoAudioToWav(
// //         videoPath,
// //         tempDirectory.path,
// //       );

// //       final wavFile = File(wavPath);

// //       final wavBytes =
// //           await wavFile.readAsBytes();

// //       // --------------------------------------------------------
// //       // SEND AUDIO
// //       // --------------------------------------------------------

// //       await sendVideoAudio(wavBytes);

// //       updateProgress(0.20);

// //       // --------------------------------------------------------
// //       // SEND FRAMES ONE BY ONE
// //       // --------------------------------------------------------

// //       for (int i = 0;
// //           i < frameFiles.length;
// //           i++) {
// //         final frameFile =
// //             frameFiles[i];

// //         final frameBytes =
// //             await frameFile.readAsBytes();

// //         /*
// //          * Basic JPEG validation.
// //          *
// //          * JPEG normally starts with FF D8
// //          * and ends with FF D9.
// //          */

// //         if (frameBytes.length < 4 ||
// //             frameBytes[0] != 0xFF ||
// //             frameBytes[1] != 0xD8 ||
// //             frameBytes[frameBytes.length - 2] !=
// //                 0xFF ||
// //             frameBytes[frameBytes.length - 1] !=
// //                 0xD9) {
// //           throw Exception(
// //             'Invalid JPEG frame $i.\n'
// //             'Size: ${frameBytes.length} bytes',
// //           );
// //         }

// //         updateStatus(
// //           'Sending video frames...\n\n'
// //           'Frame: ${i + 1} / ${frameFiles.length}\n'
// //           'Frame number: $i\n'
// //           'JPEG size: ${frameBytes.length} bytes',
// //         );

// //         await sendVideoFrame(
// //           frameBytes: frameBytes,
// //           frameNumber: i,
// //         );

// //         final frameProgress =
// //             0.20 +
// //             (0.75 *
// //                 ((i + 1) /
// //                     frameFiles.length));

// //         updateProgress(frameProgress);
// //       }

// //       // --------------------------------------------------------
// //       // SEND END
// //       // --------------------------------------------------------

// //       await sendVideoEnd(
// //         framesSent: frameFiles.length,
// //       );

// //       updateProgress(1.0);

// //       updateStatus(
// //         'VIDEO SENT SUCCESSFULLY ✓\n\n'
// //         'Frames: ${frameFiles.length}\n'
// //         'Resolution: '
// //         '$videoWidth × $videoHeight\n'
// //         'FPS: $videoFps\n'
// //         'Audio: 16-bit PCM WAV\n'
// //         'Audio: 16 kHz Mono',
// //       );

// //       showMessage(
// //         'Video sent successfully.',
// //       );
// //     } catch (e) {
// //       updateStatus(
// //         'VIDEO SENDING FAILED ✗\n\n$e',
// //       );

// //       showMessage(
// //         'Video sending failed.',
// //       );
// //     } finally {
// //       // --------------------------------------------------------
// //       // DELETE TEMP FILES
// //       // --------------------------------------------------------

// //       if (tempDirectory != null) {
// //         try {
// //           if (await tempDirectory.exists()) {
// //             await tempDirectory.delete(
// //               recursive: true,
// //             );
// //           }
// //         } catch (_) {}
// //       }

// //       if (mounted) {
// //         setState(() {
// //           isBusy = false;
// //         });
// //       }
// //     }
// //   }

// //   // ============================================================
// //   // UI
// //   // ============================================================

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('KNOWLIBOT'),
// //         centerTitle: true,
// //       ),

// //       body: SafeArea(
// //         child: SingleChildScrollView(
// //           padding: const EdgeInsets.all(20),
// //           child: Column(
// //             crossAxisAlignment:
// //                 CrossAxisAlignment.stretch,
// //             children: [
// //               // --------------------------------------------------
// //               // WIFI STATUS
// //               // --------------------------------------------------

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
// //                         size: 32,
// //                       ),
// //                       const SizedBox(width: 12),
// //                       Expanded(
// //                         child: Text(
// //                           isWifiEnabled
// //                               ? 'Wi-Fi is ON'
// //                               : 'Wi-Fi is OFF',
// //                           style: const TextStyle(
// //                             fontSize: 18,
// //                             fontWeight:
// //                                 FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 16),

// //               // --------------------------------------------------
// //               // CONNECTION STATUS
// //               // --------------------------------------------------

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
// //                                 ? Icons.check_circle
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

// //                       const SizedBox(height: 12),

// //                       Text(
// //                         'ESP32 IP: 192.168.4.1',
// //                         style: TextStyle(
// //                           color: Colors.grey[700],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 20),

// //               // --------------------------------------------------
// //               // TEST CONNECTION
// //               // --------------------------------------------------

// //               ElevatedButton.icon(
// //                 onPressed:
// //                     isBusy ? null : testConnection,
// //                 icon:
// //                     const Icon(Icons.link),
// //                 label:
// //                     const Text('TEST CONNECTION'),
// //               ),

// //               const SizedBox(height: 12),

// //               // --------------------------------------------------
// //               // SEND WAV
// //               // --------------------------------------------------

// //               ElevatedButton.icon(
// //                 onPressed:
// //                     (!isConnected || isBusy)
// //                         ? null
// //                         : sendWav,
// //                 icon:
// //                     const Icon(Icons.audiotrack),
// //                 label:
// //                     const Text('SEND WAV'),
// //               ),

// //               const SizedBox(height: 12),

// //               // --------------------------------------------------
// //               // SEND VIDEO
// //               // --------------------------------------------------

// //               ElevatedButton.icon(
// //                 onPressed:
// //                     (!isConnected || isBusy)
// //                         ? null
// //                         : sendVideo,
// //                 icon:
// //                     const Icon(Icons.videocam),
// //                 label:
// //                     const Text('SEND VIDEO'),
// //               ),

// //               const SizedBox(height: 24),

// //               // --------------------------------------------------
// //               // PROGRESS
// //               // --------------------------------------------------

// //               if (isBusy) ...[
// //                 LinearProgressIndicator(
// //                   value: progress,
// //                 ),
// //                 const SizedBox(height: 12),
// //               ],

// //               // --------------------------------------------------
// //               // STATUS
// //               // --------------------------------------------------

// //               Card(
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets.all(16),
// //                   child: Text(
// //                     status,
// //                     style: const TextStyle(
// //                       fontSize: 14,
// //                     ),
// //                   ),
// //                 ),
// //               ),

// //               const SizedBox(height: 20),

// //               // --------------------------------------------------
// //               // VIDEO SETTINGS
// //               // --------------------------------------------------

// //               Card(
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets.all(16),
// //                   child: Column(
// //                     crossAxisAlignment:
// //                         CrossAxisAlignment.start,
// //                     children: [
// //                       const Text(
// //                         'Video settings',
// //                         style: TextStyle(
// //                           fontSize: 17,
// //                           fontWeight:
// //                               FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         'Resolution: '
// //                         '$videoWidth × $videoHeight',
// //                       ),
// //                       Text(
// //                         'FPS: $videoFps',
// //                       ),
// //                       Text(
// //                         'JPEG quality: '
// //                         '$jpegQuality',
// //                       ),
// //                       Text(
// //                         'Audio: '
// //                         '16 kHz / Mono / 16-bit',
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
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
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
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

// class _HomePageState extends State<HomePage> {
//   static const String baseUrl = 'http://192.168.4.1';
//   static const String testUrl = '$baseUrl/';
//   static const String wavUrl = '$baseUrl/stream';
//   static const String videoUrl = '$baseUrl/videostream';

//   static const String wavAsset = 'assets/audio/Ring09.wav';
//   static const String videoAsset = 'assets/videos/thum.mp4';

//   // ==========================================================
//   // VIDEO SETTINGS
//   // ==========================================================

//   static const int videoWidth = 480;
//   static const int videoHeight = 320;

//   // Keep 15 FPS for now.
//   static const int videoFps = 15;

//   // Higher number = smaller JPEG = faster transfer.
//   static const int jpegQuality = 15;

//   // Must be <= ESP32:
//   // #define MAX_JPEG_FRAME_SIZE (80 * 1024)
//   static const int maxJpegFrameSize = 80 * 1024;

//   // ==========================================================
//   // AUDIO
//   // ==========================================================

//   static const int audioSampleRate = 16000;
//   static const int audioChannels = 1;
//   static const int audioBits = 16;

//   // ==========================================================
//   // STATE
//   // ==========================================================

//   bool isConnected = false;
//   bool isBusy = false;

//   double progress = 0.0;

//   String status = 'ESP32 not connected';

//   // ==========================================================
//   // STATUS UPDATE
//   // ==========================================================

//   void updateStatus(String value) {
//     if (!mounted) return;

//     setState(() {
//       status = value;
//     });
//   }

//   // ==========================================================
//   // PROGRESS UPDATE
//   // ==========================================================

//   void updateProgress(double value) {
//     if (!mounted) return;

//     setState(() {
//       progress = value.clamp(0.0, 1.0);
//     });
//   }

//   // ==========================================================
//   // SNACKBAR
//   // ==========================================================

//   void showMessage(String message) {
//     if (!mounted) return;

//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }

//   // ==========================================================
//   // TEST ESP32
//   // ==========================================================

//   Future<void> testConnection() async {
//     if (isBusy) return;

//     setState(() {
//       isBusy = true;
//       isConnected = false;
//       progress = 0.0;
//       status = 'Testing ESP32 connection...';
//     });

//     try {
//       final response = await http
//           .get(Uri.parse(testUrl))
//           .timeout(const Duration(seconds: 5));

//       if (!mounted) return;

//       if (response.statusCode == 200) {
//         setState(() {
//           isConnected = true;

//           status =
//               'ESP32 CONNECTED ✓\n\n'
//               'URL:\n'
//               '$testUrl\n\n'
//               'HTTP: ${response.statusCode}\n\n'
//               'Response:\n'
//               '${response.body}';
//         });

//         showMessage('ESP32 connected successfully.');
//       } else {
//         setState(() {
//           isConnected = false;

//           status =
//               'ESP32 CONNECTION FAILED ✗\n\n'
//               'HTTP ${response.statusCode}\n\n'
//               '${response.body}';
//         });
//       }
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         isConnected = false;

//         status =
//             'ESP32 CONNECTION ERROR ✗\n\n'
//             '$e';
//       });

//       showMessage('Could not connect to ESP32.');
//     } finally {
//       if (!mounted) return;

//       setState(() {
//         isBusy = false;
//       });
//     }
//   }

//   // ==========================================================
//   // SEND WAV
//   // ==========================================================

//   Future<void> sendWav() async {
//     if (!isConnected) {
//       showMessage('Connect to ESP32 first.');
//       return;
//     }

//     if (isBusy) return;

//     setState(() {
//       isBusy = true;
//       progress = 0.0;
//       status = 'Loading WAV file...';
//     });

//     try {
//       final data = await rootBundle.load(wavAsset);

//       final wavBytes = data.buffer.asUint8List(
//         data.offsetInBytes,
//         data.lengthInBytes,
//       );

//       if (wavBytes.isEmpty) {
//         throw Exception('WAV file is empty.');
//       }

//       updateProgress(0.2);

//       final request = http.Request('POST', Uri.parse(wavUrl));

//       request.headers['Content-Type'] = 'audio/wav';

//       request.headers['X-Audio-Format'] = 'wav';

//       request.headers['X-Audio-Sample-Rate'] = audioSampleRate.toString();

//       request.headers['X-Audio-Channels'] = audioChannels.toString();

//       request.headers['X-Audio-Bits'] = audioBits.toString();

//       request.contentLength = wavBytes.length;

//       request.bodyBytes = wavBytes;

//       updateStatus(
//         'Sending WAV...\n\n'
//         'Size: ${wavBytes.length} bytes',
//       );

//       final response = await request.send().timeout(
//         const Duration(seconds: 60),
//       );

//       final responseBody = await response.stream.bytesToString();

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         updateProgress(1.0);

//         updateStatus(
//           'WAV SENT ✓\n\n'
//           'HTTP ${response.statusCode}\n\n'
//           '$responseBody',
//         );
//       } else {
//         throw Exception(
//           'HTTP ${response.statusCode}\n'
//           '$responseBody',
//         );
//       }
//     } catch (e) {
//       updateStatus('WAV SEND FAILED ✗\n\n$e');
//     } finally {
//       if (!mounted) return;

//       setState(() {
//         isBusy = false;
//       });
//     }
//   }

//   // ==========================================================
//   // PREPARE VIDEO
//   // ==========================================================

//   Future<String> prepareVideo(Directory directory) async {
//     final videoFile = File('${directory.path}/input.mp4');

//     final data = await rootBundle.load(videoAsset);

//     final bytes = data.buffer.asUint8List(
//       data.offsetInBytes,
//       data.lengthInBytes,
//     );

//     await videoFile.writeAsBytes(bytes, flush: true);

//     return videoFile.path;
//   }

//   // ==========================================================
//   // GET VIDEO DURATION
//   // ==========================================================

//   Future<double> getVideoDuration(String videoPath) async {
//     double duration = 10.0;

//     try {
//       final session = await FFmpegKit.execute('-i "$videoPath" -f null -');

//       final output = await session.getOutput();

//       if (output != null) {
//         final regex = RegExp(r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)');

//         final match = regex.firstMatch(output);

//         if (match != null) {
//           final hours = int.parse(match.group(1)!);

//           final minutes = int.parse(match.group(2)!);

//           final seconds = double.parse(match.group(3)!);

//           duration = hours * 3600 + minutes * 60 + seconds;
//         }
//       }
//     } catch (_) {}

//     return duration;
//   }

//   // ==========================================================
//   // EXTRACT VIDEO → JPEG
//   // ==========================================================

//   Future<Directory> extractVideoFrames(
//     String videoPath,
//     String outputDirectory,
//   ) async {
//     final framesDirectory = Directory('$outputDirectory/frames');

//     if (await framesDirectory.exists()) {
//       await framesDirectory.delete(recursive: true);
//     }

//     await framesDirectory.create(recursive: true);

//     updateStatus(
//       'Converting video to JPEG...\n\n'
//       '$videoWidth × $videoHeight\n'
//       '$videoFps FPS',
//     );

//     final outputPattern = '${framesDirectory.path}/frame_%06d.jpg';

//     final command =
//         '-y '
//         '-i "$videoPath" '
//         '-vf "scale=$videoWidth:$videoHeight:'
//         'force_original_aspect_ratio=disable,'
//         'fps=$videoFps,format=yuvj420p" '
//         '-q:v $jpegQuality '
//         '"$outputPattern"';

//     final session = await FFmpegKit.execute(command);

//     final returnCode = await session.getReturnCode();

//     if (!ReturnCode.isSuccess(returnCode)) {
//       final output = await session.getOutput();

//       throw Exception(
//         'Video conversion failed.\n\n'
//         '$output',
//       );
//     }

//     return framesDirectory;
//   }

//   // ==========================================================
//   // JPEG VALIDATION
//   // ==========================================================

//   bool isValidJpeg(Uint8List bytes) {
//     if (bytes.length < 4) {
//       return false;
//     }

//     final start = bytes[0] == 0xFF && bytes[1] == 0xD8;

//     final last = bytes.length - 1;

//     final end = bytes[last - 1] == 0xFF && bytes[last] == 0xD9;

//     return start && end;
//   }

//   // ==========================================================
//   // CREATE 4-BYTE LITTLE-ENDIAN LENGTH
//   // ==========================================================

//   Uint8List createLengthHeader(int length) {
//     final data = ByteData(4);

//     data.setUint32(0, length, Endian.little);

//     return data.buffer.asUint8List();
//   }

//   // ==========================================================
//   // CALCULATE TOTAL STREAM SIZE
//   //
//   // ESP32 protocol:
//   //
//   // [4 byte length][JPEG]
//   //
//   // Therefore:
//   //
//   // total = 4 + jpeg size
//   // ==========================================================

//   Future<int> calculateTotalStreamSize(List<File> frameFiles) async {
//     int total = 0;

//     for (final file in frameFiles) {
//       final size = await file.length();

//       if (size <= 0) {
//         throw Exception('Empty JPEG file:\n${file.path}');
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

//   // ==========================================================
//   // SEND VIDEO STREAM
//   //
//   // ONE HTTP POST
//   //
//   // ESP32 receives:
//   //
//   // [4-byte JPEG size]
//   // [JPEG]
//   //
//   // [4-byte JPEG size]
//   // [JPEG]
//   //
//   // ...
//   // ==========================================================

//   Future<void> sendVideoStream(List<File> frameFiles) async {
//     if (frameFiles.isEmpty) {
//       throw Exception('No JPEG frames found.');
//     }

//     // --------------------------------------------------------
//     // CALCULATE EXACT CONTENT LENGTH
//     // --------------------------------------------------------

//     updateStatus('Calculating video size...');

//     final totalBytes = await calculateTotalStreamSize(frameFiles);

//     updateStatus(
//       'Video ready.\n\n'
//       'Frames: ${frameFiles.length}\n'
//       'Total: '
//       '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
//       'Starting upload...',
//     );

//     // --------------------------------------------------------
//     // CREATE STREAMED REQUEST
//     // --------------------------------------------------------

//     final request = http.StreamedRequest('POST', Uri.parse(videoUrl));

//     request.headers['Content-Type'] = 'application/octet-stream';

//     request.headers['Accept'] = '*/*';

//     // VERY IMPORTANT:
//     //
//     // Tell ESP32 / HTTP stack the exact body size.
//     //
//     // This prevents the previous chunked/unknown-length
//     // streaming problem.
//     //
//     request.contentLength = totalBytes;

//     // --------------------------------------------------------
//     // START HTTP REQUEST FIRST
//     // --------------------------------------------------------

//     final responseFuture = request.send().timeout(const Duration(minutes: 10));

//     int sentBytes = 0;

//     // --------------------------------------------------------
//     // SEND FRAMES
//     // --------------------------------------------------------

//     for (int i = 0; i < frameFiles.length; i++) {
//       final file = frameFiles[i];

//       // ------------------------------------------------------
//       // READ JPEG
//       // ------------------------------------------------------

//       final frameBytes = await file.readAsBytes();

//       // ------------------------------------------------------
//       // VALIDATE
//       // ------------------------------------------------------

//       if (!isValidJpeg(frameBytes)) {
//         throw Exception('Invalid JPEG frame: ${i + 1}');
//       }

//       // ------------------------------------------------------
//       // ESP32 MAX SIZE
//       // ------------------------------------------------------

//       if (frameBytes.length > maxJpegFrameSize) {
//         throw Exception(
//           'Frame ${i + 1} is too large.\n'
//           'Size: ${frameBytes.length}\n'
//           'Maximum: '
//           '$maxJpegFrameSize',
//         );
//       }

//       // ------------------------------------------------------
//       // CREATE LENGTH
//       // ------------------------------------------------------

//       final lengthHeader = createLengthHeader(frameBytes.length);

//       // ------------------------------------------------------
//       // SEND LENGTH
//       // ------------------------------------------------------

//       request.sink.add(lengthHeader);

//       sentBytes += 4;

//       // ------------------------------------------------------
//       // SEND JPEG
//       // ------------------------------------------------------

//       request.sink.add(frameBytes);

//       sentBytes += frameBytes.length;

//       // ------------------------------------------------------
//       // REAL UPLOAD PROGRESS
//       //
//       // Upload portion = 20% → 95%
//       // ------------------------------------------------------

//       final uploadRatio = sentBytes / totalBytes;

//       final uiProgress = 0.20 + uploadRatio * 0.75;

//       updateProgress(uiProgress);

//       // ------------------------------------------------------
//       // UPDATE UI EVERY 10 FRAMES
//       // ------------------------------------------------------

//       if (i % 10 == 0 || i == frameFiles.length - 1) {
//         final percent = (uploadRatio * 100).toInt();

//         final mb = sentBytes / 1024 / 1024;

//         updateStatus(
//           'UPLOADING VIDEO...\n\n'
//           'Frame: ${i + 1} / '
//           '${frameFiles.length}\n'
//           'Upload: $percent%\n'
//           'Data: '
//           '${mb.toStringAsFixed(2)} MB / '
//           '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
//           'ESP32 protocol:\n'
//           '[length][JPEG]',
//         );
//       }
//     }

//     // --------------------------------------------------------
//     // CLOSE BODY
//     // --------------------------------------------------------

//     await request.sink.close();

//     // At this point Flutter has finished putting all data
//     // into the HTTP request.
//     //
//     // But ESP32 still has to finish receiving/processing it.
//     // --------------------------------------------------------

//     updateProgress(0.95);

//     updateStatus(
//       'UPLOAD COMPLETE ✓\n\n'
//       '100% of video data sent from Flutter.\n\n'
//       'Waiting for ESP32...\n\n'
//       'ESP32 is receiving/processing frames.',
//     );

//     // --------------------------------------------------------
//     // WAIT FOR ESP32 HTTP RESPONSE
//     // --------------------------------------------------------

//     final response = await responseFuture;

//     final responseBody = await response.stream.bytesToString();

//     // --------------------------------------------------------
//     // SUCCESS
//     // --------------------------------------------------------

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       updateProgress(1.0);

//       updateStatus(
//         'VIDEO RECEIVED BY ESP32 ✓\n\n'
//         'Frames: ${frameFiles.length}\n'
//         'HTTP: ${response.statusCode}\n\n'
//         'ESP32 response:\n'
//         '$responseBody',
//       );

//       showMessage('ESP32 received the video.');
//     } else {
//       throw Exception(
//         'ESP32 returned HTTP '
//         '${response.statusCode}\n\n'
//         '$responseBody',
//       );
//     }
//   }

//   // ==========================================================
//   // SEND VIDEO
//   // ==========================================================

//   Future<void> sendVideo() async {
//     if (!isConnected) {
//       showMessage('Connect to ESP32 first.');
//       return;
//     }

//     if (isBusy) return;

//     setState(() {
//       isBusy = true;
//       progress = 0.0;
//       status = 'Preparing video...';
//     });

//     Directory? workDirectory;

//     try {
//       // ------------------------------------------------------
//       // CREATE TEMP DIRECTORY
//       // ------------------------------------------------------

//       workDirectory = Directory('${Directory.systemTemp.path}/knowlibot_video');

//       if (await workDirectory.exists()) {
//         await workDirectory.delete(recursive: true);
//       }

//       await workDirectory.create(recursive: true);

//       // ------------------------------------------------------
//       // LOAD VIDEO
//       // ------------------------------------------------------

//       updateStatus('Loading video asset...');

//       final videoPath = await prepareVideo(workDirectory);

//       updateProgress(0.05);

//       // ------------------------------------------------------
//       // DURATION
//       // ------------------------------------------------------

//       final duration = await getVideoDuration(videoPath);

//       // ------------------------------------------------------
//       // EXTRACT FRAMES
//       // ------------------------------------------------------

//       final framesDirectory = await extractVideoFrames(
//         videoPath,
//         workDirectory.path,
//       );

//       updateProgress(0.20);

//       // ------------------------------------------------------
//       // FIND JPEG FILES
//       // ------------------------------------------------------

//       final files = await framesDirectory
//           .list()
//           .where(
//             (entity) =>
//                 entity is File && entity.path.toLowerCase().endsWith('.jpg'),
//           )
//           .cast<File>()
//           .toList();

//       // ------------------------------------------------------
//       // SORT FRAMES
//       // ------------------------------------------------------

//       files.sort((a, b) => a.path.compareTo(b.path));

//       if (files.isEmpty) {
//         throw Exception('No JPEG frames were generated.');
//       }

//       final expectedFrames = (duration * videoFps).ceil();

//       updateStatus(
//         'VIDEO CONVERSION COMPLETE ✓\n\n'
//         'Frames: ${files.length}\n'
//         'Expected: ~$expectedFrames\n\n'
//         'Resolution:\n'
//         '$videoWidth × $videoHeight\n\n'
//         'FPS:\n'
//         '$videoFps\n\n'
//         'Preparing upload...',
//       );

//       // ------------------------------------------------------
//       // SEND VIDEO
//       // ------------------------------------------------------

//       await sendVideoStream(files);
//     } catch (e) {
//       updateStatus('VIDEO FAILED ✗\n\n$e');

//       showMessage('Video sending failed.');
//     } finally {
//       // ------------------------------------------------------
//       // CLEAN TEMP FILES
//       // ------------------------------------------------------

//       if (workDirectory != null) {
//         try {
//           if (await workDirectory.exists()) {
//             await workDirectory.delete(recursive: true);
//           }
//         } catch (_) {}
//       }

//       if (!mounted) return;

//       setState(() {
//         isBusy = false;
//       });
//     }
//   }

//   // ==========================================================
//   // ESP32 STATUS
//   // ==========================================================

//   Future<void> getEsp32Status() async {
//     if (!isConnected || isBusy) {
//       return;
//     }

//     try {
//       final response = await http
//           .get(Uri.parse('$baseUrl/status'))
//           .timeout(const Duration(seconds: 5));

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
//       updateStatus('STATUS ERROR\n\n$e');
//     }
//   }

//   // ==========================================================
//   // UI
//   // ==========================================================

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'KNOWLIBOT',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),

//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,

//           children: [
//             // ==================================================
//             // HEADER
//             // ==================================================
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),

//                 child: Column(
//                   children: [
//                     const Icon(Icons.memory, size: 70),

//                     const SizedBox(height: 12),

//                     const Text(
//                       'KNOWLIBOT',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 8),

//                     const Text('ESP32-S3 Video & Audio'),

//                     const SizedBox(height: 8),

//                     Text(
//                       baseUrl,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ==================================================
//             // CONNECTION BUTTON
//             // ==================================================
//             SizedBox(
//               height: 55,

//               child: ElevatedButton.icon(
//                 onPressed: isBusy ? null : testConnection,

//                 icon: const Icon(Icons.wifi),

//                 label: Text(isBusy ? 'Working...' : 'Test ESP32 Connection'),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // ==================================================
//             // WAV BUTTON
//             // ==================================================
//             SizedBox(
//               height: 58,

//               child: ElevatedButton.icon(
//                 onPressed: !isConnected || isBusy ? null : sendWav,

//                 icon: const Icon(Icons.audio_file),

//                 label: const Text(
//                   'Send WAV',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // ==================================================
//             // VIDEO BUTTON
//             // ==================================================
//             SizedBox(
//               height: 58,

//               child: ElevatedButton.icon(
//                 onPressed: !isConnected || isBusy ? null : sendVideo,

//                 icon: isBusy
//                     ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Icon(Icons.video_file),

//                 label: Text(
//                   isBusy ? 'Sending Video...' : 'Send Video',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // ==================================================
//             // ESP32 STATUS
//             // ==================================================
//             OutlinedButton.icon(
//               onPressed: !isConnected || isBusy ? null : getEsp32Status,

//               icon: const Icon(Icons.info_outline),

//               label: const Text('Get ESP32 Status'),
//             ),

//             const SizedBox(height: 20),

//             // ==================================================
//             // PROGRESS
//             // ==================================================
//             if (isBusy || progress > 0)
//               Column(
//                 children: [
//                   LinearProgressIndicator(
//                     value: progress == 0 ? null : progress,
//                     minHeight: 8,
//                   ),

//                   const SizedBox(height: 8),

//                   Text(
//                     '${(progress * 100).toInt()}%',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),

//             // ==================================================
//             // STATUS CARD
//             // ==================================================
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(18),

//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,

//                   children: [
//                     const Text(
//                       'Status',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     Container(
//                       width: double.infinity,

//                       padding: const EdgeInsets.all(15),

//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(10),
//                       ),

//                       child: SelectableText(
//                         status,
//                         style: const TextStyle(fontSize: 14, height: 1.5),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KNOWLIBOTApp());
}

class KNOWLIBOTApp extends StatelessWidget {
  const KNOWLIBOTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KNOWLIBOT',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with WidgetsBindingObserver {
  // ============================================================
  // ESP32
  // ============================================================

  static const String baseUrl = 'http://192.168.4.1';

  static const String testUrl = '$baseUrl/';
  static const String wavUrl = '$baseUrl/stream';
  static const String videoUrl = '$baseUrl/videostream';

  // ============================================================
  // ASSETS
  // ============================================================

  static const String wavAsset =
      'assets/audio/Ring09.wav';

  static const String videoAsset =
      'assets/videos/thum.mp4';

  // ============================================================
  // VIDEO SETTINGS
  // ============================================================

  static const int videoWidth = 480;
  static const int videoHeight = 320;

  static const int videoFps = 15;

  static const int jpegQuality = 15;

  // Must be <= ESP32:
  // #define MAX_JPEG_FRAME_SIZE (80 * 1024)
  static const int maxJpegFrameSize =
      80 * 1024;

  // ============================================================
  // AUDIO
  // ============================================================

  static const int audioSampleRate = 16000;
  static const int audioChannels = 1;
  static const int audioBits = 16;

  // ============================================================
  // STATE
  // ============================================================

  bool isWifiEnabled = false;
  bool isConnected = false;
  bool isBusy = false;

  double progress = 0.0;

  String status = 'Ready';

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkWifi();
    });
  }

  // ============================================================
  // APP LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    super.didChangeAppLifecycleState(state);

    // When user comes back from Android Wi-Fi settings,
    // check Wi-Fi status again.
    if (state == AppLifecycleState.resumed) {
      checkWifi();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ============================================================
  // STATUS UPDATE
  // ============================================================

  void updateStatus(String value) {
    if (!mounted) return;

    setState(() {
      status = value;
    });
  }

  // ============================================================
  // PROGRESS UPDATE
  // ============================================================

  void updateProgress(double value) {
    if (!mounted) return;

    setState(() {
      progress = value.clamp(0.0, 1.0);
    });
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
            const Duration(seconds: 3),
      ),
    );
  }

  // ============================================================
  // CHECK WIFI
  // ============================================================

  Future<void> checkWifi() async {
    try {
      final enabled =
          await WiFiForIoTPlugin.isEnabled();

      if (!mounted) return;

      setState(() {
        isWifiEnabled = enabled;
      });

      if (!enabled) {
        showWifiEnableMessage();
      }
    } catch (e) {
      updateStatus(
        'Unable to check Wi-Fi.\n\n$e',
      );
    }
  }

  // ============================================================
  // WIFI ENABLE MESSAGE
  // ============================================================

  void showWifiEnableMessage() {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Wi-Fi is OFF. Please enable Wi-Fi.',
        ),
        duration:
            const Duration(seconds: 8),
        action: SnackBarAction(
          label: 'ENABLE',
          onPressed: () {
            showWifiConfirmation();
          },
        ),
      ),
    );
  }

  // ============================================================
  // WIFI CONFIRMATION
  // ============================================================

  Future<void> showWifiConfirmation() async {
    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Enable Wi-Fi',
          ),
          content: const Text(
            'Wi-Fi is currently disabled.\n\n'
            'Android Wi-Fi settings will open '
            'so you can enable Wi-Fi manually.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'CANCEL',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'OPEN SETTINGS',
              ),
            ),
          ],
        );
      },
    );

    if (result == true) {
      try {
        await WiFiForIoTPlugin.setEnabled(
          true,
          shouldOpenSettings: true,
        );
      } catch (e) {
        showMessage(
          'Could not open Wi-Fi settings.',
        );
      }
    }
  }

  // ============================================================
  // TEST ESP32 CONNECTION
  // ============================================================

  Future<void> testConnection() async {
    if (isBusy) return;

    // Check Wi-Fi first.
    final wifiEnabled =
        await WiFiForIoTPlugin.isEnabled();

    if (!wifiEnabled) {
      if (mounted) {
        setState(() {
          isWifiEnabled = false;
        });
      }

      showWifiEnableMessage();
      return;
    }

    setState(() {
      isBusy = true;
      isConnected = false;
      progress = 0.0;
      status =
          'Testing ESP32 connection...';
    });

    try {
      final response = await http
          .get(Uri.parse(testUrl))
          .timeout(
            const Duration(seconds: 10),
          );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          isConnected = true;

          status =
              'ESP32 CONNECTED ✓\n\n'
              'URL:\n'
              '$testUrl\n\n'
              'HTTP: ${response.statusCode}\n\n'
              'Response:\n'
              '${response.body}';

          progress = 1.0;
        });

        showMessage(
          'ESP32 connected successfully.',
        );
      } else {
        setState(() {
          isConnected = false;

          status =
              'ESP32 CONNECTION FAILED ✗\n\n'
              'HTTP ${response.statusCode}\n\n'
              '${response.body}';
        });

        showMessage(
          'ESP32 connection failed.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isConnected = false;

        status =
            'ESP32 CONNECTION ERROR ✗\n\n'
            '$e';
      });

      showMessage(
        'Could not connect to ESP32.',
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isBusy = false;
      });
    }
  }

  // ============================================================
  // SEND WAV
  // ============================================================

  Future<void> sendWav() async {
    if (!isWifiEnabled) {
      showWifiEnableMessage();
      return;
    }

    if (!isConnected) {
      showMessage(
        'Connect to ESP32 first.',
      );
      return;
    }

    if (isBusy) return;

    setState(() {
      isBusy = true;
      progress = 0.0;
      status = 'Loading WAV file...';
    });

    try {
      final data =
          await rootBundle.load(wavAsset);

      final wavBytes =
          data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      if (wavBytes.isEmpty) {
        throw Exception(
          'WAV file is empty.',
        );
      }

      updateProgress(0.2);

      final request = http.Request(
        'POST',
        Uri.parse(wavUrl),
      );

      request.headers['Content-Type'] =
          'audio/wav';

      request.headers['X-Audio-Format'] =
          'wav';

      request.headers[
              'X-Audio-Sample-Rate'] =
          audioSampleRate.toString();

      request.headers['X-Audio-Channels'] =
          audioChannels.toString();

      request.headers['X-Audio-Bits'] =
          audioBits.toString();

      request.contentLength =
          wavBytes.length;

      request.bodyBytes = wavBytes;

      updateStatus(
        'Sending WAV...\n\n'
        'Size: ${wavBytes.length} bytes',
      );

      final response = await request
          .send()
          .timeout(
            const Duration(seconds: 60),
          );

      final responseBody =
          await response.stream
              .bytesToString();

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        updateProgress(1.0);

        updateStatus(
          'WAV SENT ✓\n\n'
          'HTTP ${response.statusCode}\n\n'
          '$responseBody',
        );

        showMessage(
          'WAV sent successfully.',
        );
      } else {
        throw Exception(
          'HTTP ${response.statusCode}\n'
          '$responseBody',
        );
      }
    } catch (e) {
      updateStatus(
        'WAV SEND FAILED ✗\n\n$e',
      );
    } finally {
      if (!mounted) return;

      setState(() {
        isBusy = false;
      });
    }
  }

  // ============================================================
  // PREPARE VIDEO
  // ============================================================

  Future<String> prepareVideo(
    Directory directory,
  ) async {
    final videoFile = File(
      '${directory.path}/input.mp4',
    );

    final data =
        await rootBundle.load(videoAsset);

    final bytes =
        data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );

    await videoFile.writeAsBytes(
      bytes,
      flush: true,
    );

    return videoFile.path;
  }

  // ============================================================
  // GET VIDEO DURATION
  // ============================================================

  Future<double> getVideoDuration(
    String videoPath,
  ) async {
    double duration = 10.0;

    try {
      final session =
          await FFmpegKit.execute(
        '-i "$videoPath" -f null -',
      );

      final output =
          await session.getOutput();

      if (output != null) {
        final regex = RegExp(
          r'Duration:\s*(\d+):(\d+):(\d+(?:\.\d+)?)',
        );

        final match =
            regex.firstMatch(output);

        if (match != null) {
          final hours =
              int.parse(match.group(1)!);

          final minutes =
              int.parse(match.group(2)!);

          final seconds =
              double.parse(
            match.group(3)!,
          );

          duration =
              hours * 3600 +
              minutes * 60 +
              seconds;
        }
      }
    } catch (_) {}

    return duration;
  }

  // ============================================================
  // EXTRACT VIDEO → JPEG
  // ============================================================

  Future<Directory> extractVideoFrames(
    String videoPath,
    String outputDirectory,
  ) async {
    final framesDirectory =
        Directory(
      '$outputDirectory/frames',
    );

    if (await framesDirectory.exists()) {
      await framesDirectory.delete(
        recursive: true,
      );
    }

    await framesDirectory.create(
      recursive: true,
    );

    updateStatus(
      'Converting video to JPEG...\n\n'
      '$videoWidth × $videoHeight\n'
      '$videoFps FPS\n\n'
      'No rotation applied.',
    );

    final outputPattern =
        '${framesDirectory.path}/frame_%06d.jpg';

    // ========================================================
    // IMPORTANT
    //
    // NO ROTATION
    // NO TRANSPOSE
    //
    // The video is not rotated.
    //
    // The output is exactly 480 x 320.
    // ========================================================

    final command =
        '-y '
        '-i "$videoPath" '
        '-vf "scale=$videoWidth:$videoHeight:'
        'force_original_aspect_ratio=disable,'
        'fps=$videoFps,'
        'format=yuvj420p" '
        '-q:v $jpegQuality '
        '"$outputPattern"';

    final session =
        await FFmpegKit.execute(
      command,
    );

    final returnCode =
        await session.getReturnCode();

    if (!ReturnCode.isSuccess(
      returnCode,
    )) {
      final output =
          await session.getOutput();

      throw Exception(
        'Video conversion failed.\n\n'
        '$output',
      );
    }

    return framesDirectory;
  }

  // ============================================================
  // JPEG VALIDATION
  // ============================================================

  bool isValidJpeg(
    Uint8List bytes,
  ) {
    if (bytes.length < 4) {
      return false;
    }

    final start =
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8;

    final last =
        bytes.length - 1;

    final end =
        bytes[last - 1] == 0xFF &&
        bytes[last] == 0xD9;

    return start && end;
  }

  // ============================================================
  // CREATE 4-BYTE LITTLE-ENDIAN LENGTH
  // ============================================================

  Uint8List createLengthHeader(
    int length,
  ) {
    final data = ByteData(4);

    data.setUint32(
      0,
      length,
      Endian.little,
    );

    return data.buffer.asUint8List();
  }

  // ============================================================
  // CALCULATE TOTAL STREAM SIZE
  // ============================================================

  Future<int> calculateTotalStreamSize(
    List<File> frameFiles,
  ) async {
    int total = 0;

    for (final file in frameFiles) {
      final size =
          await file.length();

      if (size <= 0) {
        throw Exception(
          'Empty JPEG file:\n'
          '${file.path}',
        );
      }

      if (size > maxJpegFrameSize) {
        throw Exception(
          'JPEG too large:\n'
          '${file.path}\n\n'
          'Size: $size bytes\n'
          'Maximum: '
          '$maxJpegFrameSize bytes',
        );
      }

      // 4 bytes for frame length.
      total += 4;

      // JPEG bytes.
      total += size;
    }

    return total;
  }

  // ============================================================
  // SEND VIDEO STREAM
  // ============================================================

  Future<void> sendVideoStream(
    List<File> frameFiles,
  ) async {
    if (frameFiles.isEmpty) {
      throw Exception(
        'No JPEG frames found.',
      );
    }

    updateStatus(
      'Calculating video size...',
    );

    final totalBytes =
        await calculateTotalStreamSize(
      frameFiles,
    );

    updateStatus(
      'Video ready.\n\n'
      'Frames: ${frameFiles.length}\n'
      'Total: '
      '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
      'Starting upload...',
    );

    // ========================================================
    // ONE HTTP POST
    // ========================================================

    final request =
        http.StreamedRequest(
      'POST',
      Uri.parse(videoUrl),
    );

    request.headers[
            'Content-Type'] =
        'application/octet-stream';

    request.headers['Accept'] =
        '*/*';

    // Tell ESP32 exact body length.
    request.contentLength =
        totalBytes;

    // Start HTTP request first.
    final responseFuture =
        request.send().timeout(
      const Duration(minutes: 10),
    );

    int sentBytes = 0;

    // ========================================================
    // SEND EVERY FRAME
    // ========================================================

    for (int i = 0;
        i < frameFiles.length;
        i++) {
      final file = frameFiles[i];

      final frameBytes =
          await file.readAsBytes();

      // ------------------------------------------------------
      // VALIDATE JPEG
      // ------------------------------------------------------

      if (!isValidJpeg(
        frameBytes,
      )) {
        throw Exception(
          'Invalid JPEG frame: '
          '${i + 1}',
        );
      }

      // ------------------------------------------------------
      // CHECK SIZE
      // ------------------------------------------------------

      if (frameBytes.length >
          maxJpegFrameSize) {
        throw Exception(
          'Frame ${i + 1} is too large.\n'
          'Size: ${frameBytes.length}\n'
          'Maximum: '
          '$maxJpegFrameSize',
        );
      }

      // ------------------------------------------------------
      // CREATE 4 BYTE LENGTH
      // ------------------------------------------------------

      final lengthHeader =
          createLengthHeader(
        frameBytes.length,
      );

      // ------------------------------------------------------
      // SEND LENGTH
      // ------------------------------------------------------

      request.sink.add(
        lengthHeader,
      );

      sentBytes += 4;

      // ------------------------------------------------------
      // SEND JPEG
      // ------------------------------------------------------

      request.sink.add(
        frameBytes,
      );

      sentBytes +=
          frameBytes.length;

      // ------------------------------------------------------
      // PROGRESS
      //
      // 20% → 95%
      // 5% reserved for ESP32 response.
      // ------------------------------------------------------

      final uploadRatio =
          sentBytes / totalBytes;

      final uiProgress =
          0.20 +
          uploadRatio * 0.75;

      updateProgress(
        uiProgress,
      );

      if (i % 10 == 0 ||
          i == frameFiles.length - 1) {
        final percent =
            (uploadRatio * 100).toInt();

        final mb =
            sentBytes /
            1024 /
            1024;

        updateStatus(
          'UPLOADING VIDEO...\n\n'
          'Frame: ${i + 1} / '
          '${frameFiles.length}\n'
          'Upload: $percent%\n'
          'Data: '
          '${mb.toStringAsFixed(2)} MB / '
          '${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB\n\n'
          'ESP32 protocol:\n'
          '[4-byte length][JPEG]',
        );
      }
    }

    // ========================================================
    // CLOSE REQUEST
    // ========================================================

    await request.sink.close();

    updateProgress(0.95);

    updateStatus(
      'UPLOAD COMPLETE ✓\n\n'
      'All video data sent from Flutter.\n\n'
      'Waiting for ESP32 response...',
    );

    // ========================================================
    // WAIT FOR ESP32
    // ========================================================

    final response =
        await responseFuture;

    final responseBody =
        await response.stream
            .bytesToString();

    // ========================================================
    // SUCCESS
    // ========================================================

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      updateProgress(1.0);

      updateStatus(
        'VIDEO RECEIVED BY ESP32 ✓\n\n'
        'Frames: ${frameFiles.length}\n'
        'HTTP: ${response.statusCode}\n\n'
        'ESP32 response:\n'
        '$responseBody',
      );

      showMessage(
        'ESP32 received the video.',
      );
    } else {
      throw Exception(
        'ESP32 returned HTTP '
        '${response.statusCode}\n\n'
        '$responseBody',
      );
    }
  }

  // ============================================================
  // SEND VIDEO
  // ============================================================

  Future<void> sendVideo() async {
    if (!isWifiEnabled) {
      showWifiEnableMessage();
      return;
    }

    if (!isConnected) {
      showMessage(
        'Connect to ESP32 first.',
      );
      return;
    }

    if (isBusy) return;

    setState(() {
      isBusy = true;
      progress = 0.0;
      status =
          'Preparing video...';
    });

    Directory? workDirectory;

    try {
      // --------------------------------------------------------
      // CHECK VIDEO ASSET
      // --------------------------------------------------------

      try {
        await rootBundle.load(
          videoAsset,
        );
      } catch (_) {
        throw Exception(
          'Video file not found.\n\n'
          'Add:\n'
          '$videoAsset\n\n'
          'to pubspec.yaml.',
        );
      }

      // --------------------------------------------------------
      // CREATE TEMP DIRECTORY
      // --------------------------------------------------------

      workDirectory =
          await Directory.systemTemp
              .createTemp(
        'knowlibot_video_',
      );

      // --------------------------------------------------------
      // COPY VIDEO
      // --------------------------------------------------------

      updateStatus(
        'Loading video...',
      );

      final videoPath =
          await prepareVideo(
        workDirectory,
      );

      updateProgress(0.05);

      // --------------------------------------------------------
      // GET VIDEO DURATION
      // --------------------------------------------------------

      final duration =
          await getVideoDuration(
        videoPath,
      );

      updateStatus(
        'Original video duration:\n'
        '${duration.toStringAsFixed(2)} seconds',
      );

      // --------------------------------------------------------
      // EXTRACT JPEG FRAMES
      // --------------------------------------------------------

      final framesDirectory =
          await extractVideoFrames(
        videoPath,
        workDirectory.path,
      );

      updateProgress(0.20);

      // --------------------------------------------------------
      // FIND JPEG FILES
      // --------------------------------------------------------

      final frameFiles =
          framesDirectory
              .listSync()
              .whereType<File>()
              .where(
                (file) =>
                    file.path
                        .toLowerCase()
                        .endsWith('.jpg'),
              )
              .toList();

      // --------------------------------------------------------
      // SORT FRAMES
      // --------------------------------------------------------

      frameFiles.sort(
        (a, b) =>
            a.path.compareTo(b.path),
      );

      if (frameFiles.isEmpty) {
        throw Exception(
          'No JPEG video frames were generated.',
        );
      }

      // --------------------------------------------------------
      // EXPECTED FRAMES
      // --------------------------------------------------------

      final expectedFrames =
          (duration * videoFps).round();

      updateStatus(
        'VIDEO CONVERSION COMPLETE ✓\n\n'
        'Original duration: '
        '${duration.toStringAsFixed(2)} sec\n\n'
        'Generated frames: '
        '${frameFiles.length}\n'
        'Expected frames: '
        '$expectedFrames\n\n'
        'Resolution: '
        '$videoWidth × $videoHeight\n\n'
        'FPS: $videoFps\n\n'
        'Rotation: NONE\n\n'
        'Preparing upload...',
      );

      // --------------------------------------------------------
      // SEND VIDEO
      // --------------------------------------------------------

      await sendVideoStream(
        frameFiles,
      );
    } catch (e) {
      updateStatus(
        'VIDEO FAILED ✗\n\n$e',
      );

      showMessage(
        'Video sending failed.',
      );
    } finally {
      // --------------------------------------------------------
      // DELETE TEMP FILES
      // --------------------------------------------------------

      if (workDirectory != null) {
        try {
          if (await workDirectory
              .exists()) {
            await workDirectory.delete(
              recursive: true,
            );
          }
        } catch (_) {}
      }

      if (!mounted) return;

      setState(() {
        isBusy = false;
      });
    }
  }

  // ============================================================
  // ESP32 STATUS
  // ============================================================

  Future<void> getEsp32Status() async {
    if (!isWifiEnabled) {
      showWifiEnableMessage();
      return;
    }

    if (!isConnected || isBusy) {
      return;
    }

    try {
      final response = await http
          .get(
            Uri.parse(
              '$baseUrl/status',
            ),
          )
          .timeout(
            const Duration(seconds: 5),
          );

      if (response.statusCode == 200) {
        updateStatus(
          'ESP32 STATUS\n\n'
          '${response.body}',
        );
      } else {
        updateStatus(
          'STATUS ERROR\n\n'
          'HTTP ${response.statusCode}\n\n'
          '${response.body}',
        );
      }
    } catch (e) {
      updateStatus(
        'STATUS ERROR\n\n$e',
      );
    }
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KNOWLIBOT',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,

            children: [
              // ==================================================
              // WIFI STATUS CARD
              // ==================================================

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Row(
                    children: [
                      Icon(
                        isWifiEnabled
                            ? Icons.wifi
                            : Icons.wifi_off,
                        size: 35,
                      ),

                      const SizedBox(
                        width: 12,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isWifiEnabled
                                  ? 'Wi-Fi is ON'
                                  : 'Wi-Fi is OFF',
                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              isWifiEnabled
                                  ? 'Connect to the ESP32 hotspot manually.'
                                  : 'Wi-Fi must be enabled.',
                              style:
                                  TextStyle(
                                color:
                                    Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (!isWifiEnabled)
                        ElevatedButton(
                          onPressed:
                              isBusy
                                  ? null
                                  : showWifiConfirmation,
                          child:
                              const Text(
                            'ENABLE',
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              // ==================================================
              // ESP32 CONNECTION STATUS
              // ==================================================

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Icon(
                            isConnected
                                ? Icons
                                    .check_circle
                                : Icons
                                    .cancel,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Text(
                            isConnected
                                ? 'ESP32 Connected'
                                : 'ESP32 Not Connected',
                            style:
                                const TextStyle(
                              fontSize: 17,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        'ESP32 IP: 192.168.4.1',
                        style:
                            TextStyle(
                          color:
                              Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ==================================================
              // TEST CONNECTION
              // ==================================================

              SizedBox(
                height: 52,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      isBusy
                          ? null
                          : testConnection,

                  icon: const Icon(
                    Icons.link,
                  ),

                  label: const Text(
                    'TEST CONNECTION',
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================================
              // SEND WAV
              // ==================================================

              SizedBox(
                height: 52,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      (!isWifiEnabled ||
                              !isConnected ||
                              isBusy)
                          ? null
                          : sendWav,

                  icon: const Icon(
                    Icons.audiotrack,
                  ),

                  label: const Text(
                    'SEND WAV',
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================================
              // SEND VIDEO
              // ==================================================

              SizedBox(
                height: 58,

                child:
                    ElevatedButton.icon(
                  onPressed:
                      (!isWifiEnabled ||
                              !isConnected ||
                              isBusy)
                          ? null
                          : sendVideo,

                  icon: isBusy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.videocam,
                        ),

                  label: Text(
                    isBusy
                        ? 'SENDING VIDEO...'
                        : 'SEND VIDEO',
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              // ==================================================
              // ESP32 STATUS
              // ==================================================

              // OutlinedButton.icon(
              //   onPressed:
              //       (!isWifiEnabled ||
              //               !isConnected ||
              //               isBusy)
              //           ? null
              //           : getEsp32Status,

              //   icon: const Icon(
              //     Icons.info_outline,
              //   ),

              //   label: const Text(
              //     'GET ESP32 STATUS',
              //   ),
              // ),

              const SizedBox(
                height: 24,
              ),

              // ==================================================
              // PROGRESS
              // ==================================================

              if (isBusy ||
                  progress > 0) ...[
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  '${(progress * 100).toInt()}%',
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
              ],

              // ==================================================
              // STATUS CARD
              // ==================================================

              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'Status',
                        style:
                            TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets.all(
                          15,
                        ),

                        decoration:
                            BoxDecoration(
                          color: Colors
                              .grey
                              .shade100,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),

                        child:
                            SelectableText(
                          status,
                          style:
                              const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ==================================================
              // VIDEO SETTINGS
              // ==================================================

              // Card(
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.all(16),

              //     child: Column(
              //       crossAxisAlignment:
              //           CrossAxisAlignment.start,

              //       children: [
              //         const Text(
              //           'Video Settings',
              //           style:
              //               TextStyle(
              //             fontSize: 17,
              //             fontWeight:
              //                 FontWeight.bold,
              //           ),
              //         ),

              //         const SizedBox(
              //           height: 10,
              //         ),

              //         Text(
              //           'Resolution: '
              //           '$videoWidth × '
              //           '$videoHeight',
              //         ),

              //         Text(
              //           'FPS: $videoFps',
              //         ),

              //         Text(
              //           'JPEG quality: '
              //           '$jpegQuality',
              //         ),

              //         const Text(
              //           'Rotation: None',
              //         ),

              //         const Text(
              //           'Audio: 16 kHz / Mono / 16-bit',
              //         ),

              //         const SizedBox(
              //           height: 8,
              //         ),

              //         const Text(
              //           'ESP32 protocol:',
              //           style:
              //               TextStyle(
              //             fontWeight:
              //                 FontWeight.bold,
              //           ),
              //         ),

              //         const Text(
              //           '[4-byte length] + [JPEG]',
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}