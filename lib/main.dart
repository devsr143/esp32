// // import 'dart:io';

// // import 'package:flutter/material.dart';
// // import 'package:wifi_iot/wifi_iot.dart';
// // import 'package:wifi_scan/wifi_scan.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(const ESP32App());
// // }

// // class ESP32App extends StatelessWidget {
// //   const ESP32App({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'ESP32 Controller',
// //       theme: ThemeData(
// //         colorScheme: ColorScheme.fromSeed(
// //           seedColor: Colors.blue,
// //         ),
// //         useMaterial3: true,
// //       ),
// //       home: const HomeScreen(),
// //     );
// //   }
// // }

// // // ============================================================
// // // DEVICE MODEL
// // // ============================================================

// // class EspDevice {
// //   final String ssid;
// //   final String bssid;
// //   final int signalLevel;
// //   final int frequency;

// //   EspDevice({
// //     required this.ssid,
// //     required this.bssid,
// //     required this.signalLevel,
// //     required this.frequency,
// //   });
// // }

// // // ============================================================
// // // HOME SCREEN
// // // ============================================================

// // class HomeScreen extends StatefulWidget {
// //   const HomeScreen({super.key});

// //   @override
// //   State<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   final List<EspDevice> devices = [];

// //   bool isScanning = false;
// //   String? errorMessage;

// //   @override
// //   void initState() {
// //     super.initState();

// //     scanDevices();
// //   }

// //   // ==========================================================
// //   // SCAN WIFI
// //   // ==========================================================

// //   Future<void> scanDevices() async {
// //     if (isScanning) return;

// //     if (!Platform.isAndroid) {
// //       setState(() {
// //         errorMessage =
// //             'Wi-Fi scanning is currently supported on Android.';
// //       });
// //       return;
// //     }

// //     setState(() {
// //       isScanning = true;
// //       errorMessage = null;
// //       devices.clear();
// //     });

// //     try {
// //       // Check if scanning is possible
// //       final canStart = await WiFiScan.instance.canStartScan(
// //         askPermissions: true,
// //       );

// //       if (canStart != CanStartScan.yes) {
// //         throw Exception(
// //           'Wi-Fi scan permission is not available.\n'
// //           'Please enable Wi-Fi and Location permission.',
// //         );
// //       }

// //       // Start scan
// //       final started = await WiFiScan.instance.startScan();

// //       if (!started) {
// //         throw Exception('Could not start Wi-Fi scan.');
// //       }

// //       // Wait for results
// //       await Future.delayed(
// //         const Duration(seconds: 2),
// //       );

// //       // Check if results can be obtained
// //       final canGet =
// //           await WiFiScan.instance.canGetScannedResults(
// //         askPermissions: true,
// //       );

// //       if (canGet != CanGetScannedResults.yes) {
// //         throw Exception(
// //           'Cannot read Wi-Fi scan results.',
// //         );
// //       }

// //       // Get networks
// //       final results =
// //           await WiFiScan.instance.getScannedResults();

// //       final List<EspDevice> foundDevices = [];

// //       // for (final network in results) {
// //       //   final ssid = network.ssid.trim();

// //       //   if (ssid.isEmpty) {
// //       //     continue;
// //       //   }

// //       //   // Only show ESP32 networks
// //       //   if (ssid.startsWith('ESP32-S3')) {
// //       //     foundDevices.add(
// //       //       EspDevice(
// //       //         ssid: ssid,
// //       //         bssid: network.bssid,
// //       //         signalLevel: network.level,
// //       //         frequency: network.frequency,
// //       //       ),
// //       //     );
// //       //   }
// //       // }

// //       // Remove duplicate SSIDs
// //       final Map<String, EspDevice> uniqueDevices = {};

// //       for (final device in foundDevices) {
// //         uniqueDevices[device.ssid] = device;
// //       }

// //       final finalDevices =
// //           uniqueDevices.values.toList();

// //       // Sort strongest signal first
// //       finalDevices.sort(
// //         (a, b) =>
// //             b.signalLevel.compareTo(a.signalLevel),
// //       );

// //       if (!mounted) return;

// //       setState(() {
// //         devices.addAll(finalDevices);
// //       });
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         errorMessage = e
// //             .toString()
// //             .replaceFirst('Exception: ', '');
// //       });
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isScanning = false;
// //       });
// //     }
// //   }

// //   // ==========================================================
// //   // SIGNAL TEXT
// //   // ==========================================================

// //   String signalText(int level) {
// //     if (level >= -50) {
// //       return 'Excellent';
// //     }

// //     if (level >= -60) {
// //       return 'Good';
// //     }

// //     if (level >= -70) {
// //       return 'Fair';
// //     }

// //     return 'Weak';
// //   }

// //   // ==========================================================
// //   // SIGNAL ICON
// //   // ==========================================================

// //   IconData signalIcon(int level) {
// //     if (level >= -50) {
// //       return Icons.signal_wifi_4_bar;
// //     }

// //     if (level >= -60) {
// //       return Icons.network_wifi_3_bar;
// //     }

// //     if (level >= -70) {
// //       return Icons.network_wifi_2_bar;
// //     }

// //     return Icons.network_wifi_1_bar;
// //   }

// //   // ==========================================================
// //   // OPEN DEVICE
// //   // ==========================================================

// //   void openDevice(EspDevice device) {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => DeviceScreen(
// //           device: device,
// //         ),
// //       ),
// //     );
// //   }

// //   // ==========================================================
// //   // BUILD
// //   // ==========================================================

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           'ESP32 Devices',
// //           style: TextStyle(
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         actions: [
// //           IconButton(
// //             onPressed:
// //                 isScanning ? null : scanDevices,
// //             icon: const Icon(Icons.refresh),
// //           ),
// //         ],
// //       ),

// //       body: RefreshIndicator(
// //         onRefresh: scanDevices,
// //         child: buildBody(),
// //       ),

// //       floatingActionButton:
// //           FloatingActionButton.extended(
// //         onPressed:
// //             isScanning ? null : scanDevices,
// //         icon: isScanning
// //             ? const SizedBox(
// //                 width: 20,
// //                 height: 20,
// //                 child:
// //                     CircularProgressIndicator(
// //                   strokeWidth: 2,
// //                   color: Colors.white,
// //                 ),
// //               )
// //             : const Icon(Icons.wifi_find),
// //         label: Text(
// //           isScanning
// //               ? 'Scanning...'
// //               : 'Scan',
// //         ),
// //       ),
// //     );
// //   }

// //   // ==========================================================
// //   // BODY
// //   // ==========================================================

// //   Widget buildBody() {
// //     // Scanning
// //     if (isScanning && devices.isEmpty) {
// //       return ListView(
// //         physics:
// //             const AlwaysScrollableScrollPhysics(),
// //         children: const [
// //           SizedBox(height: 180),
// //           Center(
// //             child: CircularProgressIndicator(),
// //           ),
// //           SizedBox(height: 20),
// //           Center(
// //             child: Text(
// //               'Searching for ESP32 devices...',
// //               style: TextStyle(
// //                 fontSize: 16,
// //               ),
// //             ),
// //           ),
// //         ],
// //       );
// //     }

// //     // Error
// //     if (errorMessage != null &&
// //         devices.isEmpty) {
// //       return ListView(
// //         physics:
// //             const AlwaysScrollableScrollPhysics(),
// //         children: [
// //           const SizedBox(height: 140),

// //           const Icon(
// //             Icons.error_outline,
// //             size: 70,
// //             color: Colors.red,
// //           ),

// //           const SizedBox(height: 20),

// //           Padding(
// //             padding:
// //                 const EdgeInsets.symmetric(
// //               horizontal: 30,
// //             ),
// //             child: Text(
// //               errorMessage!,
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(
// //                 fontSize: 15,
// //               ),
// //             ),
// //           ),

// //           const SizedBox(height: 25),

// //           Center(
// //             child: ElevatedButton.icon(
// //               onPressed: scanDevices,
// //               icon:
// //                   const Icon(Icons.refresh),
// //               label:
// //                   const Text('Try Again'),
// //             ),
// //           ),
// //         ],
// //       );
// //     }

// //     // No devices
// //     if (devices.isEmpty) {
// //       return ListView(
// //         physics:
// //             const AlwaysScrollableScrollPhysics(),
// //         children: const [
// //           SizedBox(height: 150),

// //           Center(
// //             child: Icon(
// //               Icons.wifi_find,
// //               size: 80,
// //               color: Colors.grey,
// //             ),
// //           ),

// //           SizedBox(height: 20),

// //           Center(
// //             child: Text(
// //               'No ESP32 devices found',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),

// //           SizedBox(height: 10),

// //           Center(
// //             child: Text(
// //               'Make sure your ESP32 hotspot is ON.',
// //             ),
// //           ),
// //         ],
// //       );
// //     }

// //     // Devices
// //     return ListView.builder(
// //       physics:
// //           const AlwaysScrollableScrollPhysics(),
// //       padding: const EdgeInsets.all(16),
// //       itemCount: devices.length,
// //       itemBuilder: (context, index) {
// //         final device = devices[index];

// //         return Card(
// //           margin:
// //               const EdgeInsets.only(bottom: 12),
// //           child: ListTile(
// //             contentPadding:
// //                 const EdgeInsets.all(16),

// //             leading: CircleAvatar(
// //               radius: 28,
// //               child: Icon(
// //                 signalIcon(
// //                   device.signalLevel,
// //                 ),
// //               ),
// //             ),

// //             title: Text(
// //               device.ssid,
// //               style: const TextStyle(
// //                 fontSize: 17,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),

// //             subtitle: Padding(
// //               padding:
// //                   const EdgeInsets.only(
// //                 top: 8,
// //               ),
// //               child: Text(
// //                 '${signalText(device.signalLevel)}'
// //                 ' • ${device.signalLevel} dBm\n'
// //                 'Frequency: '
// //                 '${device.frequency} MHz',
// //               ),
// //             ),

// //             trailing: const Icon(
// //               Icons.arrow_forward_ios,
// //               size: 18,
// //             ),

// //             onTap: () {
// //               openDevice(device);
// //             },
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // // ============================================================
// // // DEVICE SCREEN
// // // ============================================================

// // class DeviceScreen extends StatefulWidget {
// //   final EspDevice device;

// //   const DeviceScreen({
// //     super.key,
// //     required this.device,
// //   });

// //   @override
// //   State<DeviceScreen> createState() =>
// //       _DeviceScreenState();
// // }

// // class _DeviceScreenState
// //     extends State<DeviceScreen> {
// //   final TextEditingController
// //       passwordController =
// //       TextEditingController();

// //   bool isConnecting = false;
// //   bool connected = false;

// //   String status = 'Not connected';

// //   @override
// //   void dispose() {
// //     passwordController.dispose();
// //     super.dispose();
// //   }

// //   // ==========================================================
// //   // CONNECT
// //   // ==========================================================

// //   Future<void> connect() async {
// //     final password =
// //         passwordController.text.trim();

// //     if (password.isEmpty) {
// //       showMessage(
// //         'Please enter the Wi-Fi password.',
// //       );
// //       return;
// //     }

// //     setState(() {
// //       isConnecting = true;
// //       status = 'Connecting...';
// //     });

// //     try {
// //       final result =
// //           await WiFiForIoTPlugin.connect(
// //         widget.device.ssid,
// //         password: password,
// //         security: NetworkSecurity.WPA,
// //         joinOnce: true,
// //         withInternet: false,
// //       );

// //       if (!result) {
// //         throw Exception(
// //           'Failed to connect to device.',
// //         );
// //       }

// //       // Give Android time to switch network
// //       await Future.delayed(
// //         const Duration(seconds: 2),
// //       );

// //       if (!mounted) return;

// //       setState(() {
// //         connected = true;
// //         status = 'Connected';
// //       });

// //       showMessage(
// //         'Connected to ${widget.device.ssid}',
// //       );
// //     } catch (e) {
// //       if (!mounted) return;

// //       setState(() {
// //         connected = false;
// //         status = 'Connection failed';
// //       });

// //       showMessage(
// //         e.toString().replaceFirst(
// //           'Exception: ',
// //           '',
// //         ),
// //       );
// //     } finally {
// //       if (!mounted) return;

// //       setState(() {
// //         isConnecting = false;
// //       });
// //     }
// //   }

// //   // ==========================================================
// //   // DISCONNECT
// //   // ==========================================================

// //   Future<void> disconnect() async {
// //     try {
// //       await WiFiForIoTPlugin.disconnect();
// //     } catch (_) {}

// //     if (!mounted) return;

// //     setState(() {
// //       connected = false;
// //       status = 'Not connected';
// //     });

// //     showMessage('Disconnected');
// //   }

// //   // ==========================================================
// //   // MESSAGE
// //   // ==========================================================

// //   void showMessage(String message) {
// //     ScaffoldMessenger.of(context)
// //         .showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //       ),
// //     );
// //   }

// //   // ==========================================================
// //   // BUILD
// //   // ==========================================================

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           widget.device.ssid,
// //         ),
// //       ),

// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           children: [
// //             buildDeviceInfo(),

// //             const SizedBox(height: 20),

// //             if (!connected)
// //               buildConnectionCard(),

// //             if (connected)
// //               buildConnectedCard(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ==========================================================
// //   // DEVICE INFO
// //   // ==========================================================

// //   Widget buildDeviceInfo() {
// //     return Card(
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           children: [
// //             const CircleAvatar(
// //               radius: 42,
// //               child: Icon(
// //                 Icons.memory,
// //                 size: 42,
// //               ),
// //             ),

// //             const SizedBox(height: 15),

// //             Text(
// //               widget.device.ssid,
// //               style: const TextStyle(
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),

// //             const SizedBox(height: 8),

// //             Text(
// //               '${widget.device.signalLevel} dBm',
// //             ),

// //             const SizedBox(height: 15),

// //             Row(
// //               mainAxisAlignment:
// //                   MainAxisAlignment.center,
// //               children: [
// //                 Icon(
// //                   connected
// //                       ? Icons.check_circle
// //                       : Icons.circle,
// //                   size: 14,
// //                   color: connected
// //                       ? Colors.green
// //                       : Colors.grey,
// //                 ),

// //                 const SizedBox(width: 8),

// //                 Text(status),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ==========================================================
// //   // CONNECTION CARD
// //   // ==========================================================

// //   Widget buildConnectionCard() {
// //     return Card(
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment:
// //               CrossAxisAlignment.stretch,
// //           children: [
// //             const Text(
// //               'Connect to ESP32',
// //               style: TextStyle(
// //                 fontSize: 20,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             TextField(
// //               controller:
// //                   passwordController,
// //               obscureText: true,
// //               decoration:
// //                   const InputDecoration(
// //                 labelText: 'Wi-Fi Password',
// //                 hintText:
// //                     'Enter ESP32 password',
// //                 prefixIcon:
// //                     Icon(Icons.lock),
// //                 border:
// //                     OutlineInputBorder(),
// //               ),
// //             ),

// //             const SizedBox(height: 20),

// //             SizedBox(
// //               height: 52,
// //               child: ElevatedButton.icon(
// //                 onPressed:
// //                     isConnecting
// //                         ? null
// //                         : connect,
// //                 icon: isConnecting
// //                     ? const SizedBox(
// //                         width: 20,
// //                         height: 20,
// //                         child:
// //                             CircularProgressIndicator(
// //                           strokeWidth: 2,
// //                         ),
// //                       )
// //                     : const Icon(
// //                         Icons.wifi,
// //                       ),
// //                 label: Text(
// //                   isConnecting
// //                       ? 'Connecting...'
// //                       : 'Connect',
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ==========================================================
// //   // CONNECTED CARD
// //   // ==========================================================

// //   Widget buildConnectedCard() {
// //     return Card(
// //       child: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           crossAxisAlignment:
// //               CrossAxisAlignment.stretch,
// //           children: [
// //             const Icon(
// //               Icons.check_circle,
// //               size: 70,
// //               color: Colors.green,
// //             ),

// //             const SizedBox(height: 15),

// //             const Text(
// //               'ESP32 Connected',
// //               textAlign: TextAlign.center,
// //               style: TextStyle(
// //                 fontSize: 22,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),

// //             const SizedBox(height: 10),

// //             Text(
// //               widget.device.ssid,
// //               textAlign: TextAlign.center,
// //             ),

// //             const SizedBox(height: 25),

// //             ElevatedButton.icon(
// //               onPressed: () {
// //                 showMessage(
// //                   'Device is connected.',
// //                 );
// //               },
// //               icon: const Icon(
// //                 Icons.check,
// //               ),
// //               label: const Text(
// //                 'Test Connection',
// //               ),
// //             ),

// //             const SizedBox(height: 10),

// //             OutlinedButton.icon(
// //               onPressed: disconnect,
// //               icon: const Icon(
// //                 Icons.wifi_off,
// //               ),
// //               label: const Text(
// //                 'Disconnect',
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const ESP32App());
// }

// class ESP32App extends StatelessWidget {
//   const ESP32App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'KNOWLIBOT',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   static const String uploadUrl = 'http://192.168.4.1/stream';

//   static const String testUrl = 'http://192.168.4.1/';

//   static const String wavAssetPath =
//       'assets/audio/wav.wav';
      
//   bool isTesting = false;
//   bool isUploading = false;

//   String status = 'Not connected';

//   double uploadProgress = 0.0;

//   Future<void> testConnection() async {
//     if (isTesting) return;

//     setState(() {
//       isTesting = true;
//       status = 'Connecting to KNOWLIBOT...';
//     });

//     try {
//       final uri = Uri.parse(testUrl);

//       final response = await http.get(uri).timeout(const Duration(seconds: 10));

//       if (!mounted) return;

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         setState(() {
//           status =
//               'Connected to KNOWLIBOT\n'
//               'Status: ${response.statusCode}\n'
//               '${response.body}';
//         });

//         showMessage('KNOWLIBOT connected successfully.');
//       } else {
//         setState(() {
//           status =
//               'KNOWLIBOT responded\n'
//               'Status: ${response.statusCode}\n'
//               '${response.body}';
//         });
//       }
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         status =
//             'Connection failed\n\n'
//             '${e.toString()}';
//       });

//       showMessage('Could not connect to KNOWLIBOT.');
//     } finally {
//       if (!mounted) return;

//       setState(() {
//         isTesting = false;
//       });
//     }
//   }

//   // ==========================================================
//   // SEND WAV FILE
//   // ==========================================================

//   Future<void> uploadWavFile() async {
//     if (isUploading) return;

//     setState(() {
//       isUploading = true;
//       uploadProgress = 0;
//       status = 'Loading WAV file...';
//     });

//     try {
//       // --------------------------------------------------------
//       // LOAD WAV FROM ASSETS
//       // --------------------------------------------------------

//       final ByteData data = await rootBundle.load(wavAssetPath);

//       final Uint8List wavBytes = data.buffer.asUint8List(
//         data.offsetInBytes,
//         data.lengthInBytes,
//       );

//       if (wavBytes.isEmpty) {
//         throw Exception('WAV file is empty.');
//       }

//       if (!mounted) return;

//       setState(() {
//         uploadProgress = 0.1;

//         status =
//             'WAV loaded\n'
//             'Size: ${wavBytes.length} bytes\n\n'
//             'Preparing upload...';
//       });

//       // --------------------------------------------------------
//       // CREATE MULTIPART REQUEST
//       // --------------------------------------------------------

//       final uri = Uri.parse(uploadUrl);

//       final request = http.MultipartRequest('POST', uri);

//       // --------------------------------------------------------
//       // ADD WAV FILE
//       // --------------------------------------------------------

//       request.files.add(
//         http.MultipartFile.fromBytes('file', wavBytes, filename: 'wav.wav'),
//       );

//       request.headers.addAll({'Accept': '*/*'});

//       if (!mounted) return;

//       setState(() {
//         uploadProgress = 0.2;

//         status =
//             'Uploading WAV file...\n\n'
//             'To:\n'
//             '$uploadUrl';
//       });

//       // --------------------------------------------------------
//       // SEND REQUEST
//       // --------------------------------------------------------

//       final streamedResponse = await request.send().timeout(
//         const Duration(seconds: 60),
//       );

//       // --------------------------------------------------------
//       // READ ESP32 RESPONSE
//       // --------------------------------------------------------

//       final response = await http.Response.fromStream(streamedResponse);

//       if (!mounted) return;

//       if (response.statusCode >= 200 && response.statusCode < 300) {
//         setState(() {
//           uploadProgress = 1.0;

//           status =
//               'UPLOAD SUCCESSFUL\n\n'
//               'File: test.wav\n'
//               'Size: ${wavBytes.length} bytes\n'
//               'Status: ${response.statusCode}\n\n'
//               'ESP32 Response:\n'
//               '${response.body}';
//         });

//         showMessage('WAV file sent successfully.');
//       } else {
//         setState(() {
//           uploadProgress = 0;

//           status =
//               'UPLOAD FAILED\n\n'
//               'HTTP Status: ${response.statusCode}\n\n'
//               'ESP32 Response:\n'
//               '${response.body}';
//         });

//         showMessage('ESP32 rejected the upload.');
//       }
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         uploadProgress = 0;

//         status =
//             'UPLOAD ERROR\n\n'
//             '${e.toString()}';
//       });

//       showMessage('WAV upload failed.');
//     } finally {
//       if (!mounted) return;

//       setState(() {
//         isUploading = false;
//       });
//     }
//   }

//   // ==========================================================
//   // MESSAGE
//   // ==========================================================

//   void showMessage(String message) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text(message)));
//   }

//   // ==========================================================
//   // BUILD
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
//             // CONNECTION CARD
//             // ==================================================
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     const Icon(Icons.memory, size: 80),

//                     const SizedBox(height: 15),

//                     const Text(
//                       'KNOWLIBOT',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     const Text(
//                       'Connect your phone to the '
//                       'ESP32 Wi-Fi hotspot manually.',
//                       textAlign: TextAlign.center,
//                     ),

//                     const SizedBox(height: 20),

//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade100,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: const Column(
//                         children: [
//                           Text(
//                             'API',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),

//                           SizedBox(height: 5),

//                           Text(
//                             'http://KNOWLIBOT.local/upload',
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // ==================================================
//             // TEST CONNECTION BUTTON
//             // ==================================================
//             SizedBox(
//               height: 55,
//               child: ElevatedButton.icon(
//                 onPressed: isTesting || isUploading ? null : testConnection,
//                 icon: isTesting
//                     ? const SizedBox(
//                         width: 22,
//                         height: 22,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Icon(Icons.wifi),
//                 label: Text(isTesting ? 'Testing...' : 'Test Connection'),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // ==================================================
//             // SEND WAV BUTTON
//             // ==================================================
//             SizedBox(
//               height: 60,
//               child: ElevatedButton.icon(
//                 onPressed: isUploading || isTesting ? null : uploadWavFile,
//                 icon: isUploading
//                     ? const SizedBox(
//                         width: 24,
//                         height: 24,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Icon(Icons.upload_file),
//                 label: Text(
//                   isUploading ? 'Uploading WAV...' : 'Send WAV File',
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             if (isUploading || uploadProgress > 0)
//               Column(
//                 children: [
//                   LinearProgressIndicator(
//                     value: uploadProgress == 0 ? null : uploadProgress,
//                   ),

//                   const SizedBox(height: 10),
//                 ],
//               ),

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

//                     Text(status, style: const TextStyle(fontSize: 14)),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             // Card(
//             //   child: Padding(
//             //     padding:
//             //         const EdgeInsets.all(18),
//             //     child: Column(
//             //       crossAxisAlignment:
//             //           CrossAxisAlignment.start,
//             //       children: [
//             //         const Text(
//             //           'How to use',
//             //           style: TextStyle(
//             //             fontSize: 18,
//             //             fontWeight:
//             //                 FontWeight.bold,
//             //           ),
//             //         ),

//             //         const SizedBox(height: 12),

//             //         const Text(
//             //           '1. Open Android Wi-Fi settings.\n'
//             //           '2. Connect to the KNOWLIBOT / ESP32 Wi-Fi.\n'
//             //           '3. Return to this app.\n'
//             //           '4. Press "Test Connection".\n'
//             //           '5. Press "Send WAV File".',
//             //           style: TextStyle(
//             //             height: 1.7,
//             //           ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ESP32App());
}

class ESP32App extends StatelessWidget {
  const ESP32App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KNOWLIBOT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String baseUrl = 'http://192.168.4.1';
  static const String testUrl = '$baseUrl/';
  static const String streamUrl = '$baseUrl/stream';
  static const String wavAssetPath = 'assets/audio/Ring09.wav';

  bool isTesting = false;
  bool isUploading = false;
  String status = 'Not connected';
  double uploadProgress = 0.0;

  Future<void> testConnection() async {
    if (isTesting || isUploading) {
      return;
    }

    setState(() {
      isTesting = true;
      status = 'Connecting to KNOWLIBOT...';
    });

    try {
      final uri = Uri.parse(testUrl);

      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
          );

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        setState(() {
          status =
              'CONNECTED TO KNOWLIBOT\n\n'
              'URL:\n'
              '$testUrl\n\n'
              'HTTP Status:\n'
              '${response.statusCode}\n\n'
              'ESP32 Response:\n'
              '${response.body}';
        });

        showMessage(
          'KNOWLIBOT connected successfully.',
        );
      } else {
        setState(() {
          status =
              'ESP32 RESPONDED\n\n'
              'HTTP Status:\n'
              '${response.statusCode}\n\n'
              'ESP32 Response:\n'
              '${response.body}';
        });

        showMessage(
          'ESP32 responded with an error.',
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        status =
            'CONNECTION FAILED\n\n'
            '${e.toString()}';
      });

      showMessage(
        'Could not connect to KNOWLIBOT.',
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        isTesting = false;
      });
    }
  }

  // ==========================================================
  // SEND WAV FILE
  // ==========================================================

  Future<void> uploadWavFile() async {
    if (isUploading || isTesting) {
      return;
    }

    setState(() {
      isUploading = true;
      uploadProgress = 0.0;
      status = 'Loading WAV file...';
    });

    try {
      // ======================================================
      // LOAD WAV FROM ASSETS
      // ======================================================

      final ByteData data =
          await rootBundle.load(wavAssetPath);

      final Uint8List wavBytes =
          data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      // ======================================================
      // CHECK FILE
      // ======================================================

      if (wavBytes.isEmpty) {
        throw Exception(
          'WAV file is empty.',
        );
      }

      if (!mounted) {
        return;
      }

      setState(() {
        uploadProgress = 0.1;

        status =
            'WAV FILE LOADED\n\n'
            'Asset:\n'
            '$wavAssetPath\n\n'
            'Size:\n'
            '${wavBytes.length} bytes\n\n'
            'Preparing request...';
      });

      // ======================================================
      // CREATE URL
      // ======================================================

      final uri = Uri.parse(streamUrl);

      // ======================================================
      // HEADERS
      // ======================================================

      final Map<String, String> headers = {
        'Content-Type': 'audio/wav',
        'Content-Length': wavBytes.length.toString(),
        'Accept': '*/*',
      };

      if (!mounted) {
        return;
      }

      setState(() {
        uploadProgress = 0.2;

        status =
            'PREPARING WAV REQUEST\n\n'
            'URL:\n'
            '$streamUrl\n\n'
            'Method:\n'
            'POST\n\n'
            'Content-Type:\n'
            'audio/wav\n\n'
            'Content-Length:\n'
            '${wavBytes.length} bytes';
      });

      if (!mounted) {
        return;
      }

      setState(() {
        uploadProgress = 0.3;

        status =
            'SENDING WAV TO ESP32...\n\n'
            'Headers sent:\n'
            'Content-Type: audio/wav\n'
            'Content-Length: ${wavBytes.length}\n'
            'Accept: */*\n\n'
            'Sending audio data...';
      });

      final response = await http
          .post(
            uri,
            headers: headers,
            body: wavBytes,
          )
          .timeout(
            const Duration(seconds: 60),
          );

      // ======================================================
      // RESPONSE
      // ======================================================

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        setState(() {
          uploadProgress = 1.0;

          status =
              'UPLOAD SUCCESSFUL\n\n'
              'File:\n'
              'wav.wav\n\n'
              'Size:\n'
              '${wavBytes.length} bytes\n\n'
              'URL:\n'
              '$streamUrl\n\n'
              'HTTP Status:\n'
              '${response.statusCode}\n\n'
              'ESP32 Response:\n'
              '${response.body}';
        });

        showMessage(
          'WAV file sent successfully.',
        );
      } else {
        setState(() {
          uploadProgress = 0.0;

          status =
              'UPLOAD FAILED\n\n'
              'HTTP Status:\n'
              '${response.statusCode}\n\n'
              'ESP32 Response:\n'
              '${response.body}';
        });

        showMessage(
          'ESP32 rejected the WAV request.',
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        uploadProgress = 0.0;

        status =
            'UPLOAD ERROR\n\n'
            '${e.toString()}';
      });

      showMessage(
        'WAV upload failed.',
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        isUploading = false;
      });
    }
  }

  // ==========================================================
  // SHOW MESSAGE
  // ==========================================================

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KNOWLIBOT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [

            // ==================================================
            // DEVICE CARD
            // ==================================================

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Column(
                  children: [

                    const Icon(
                      Icons.memory,
                      size: 80,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'KNOWLIBOT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Connect your phone to the '
                      'ESP32 Wi-Fi hotspot manually.',
                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // ==========================================
                    // ESP32 IP
                    // ==========================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(15),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.grey.shade100,
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: const Column(
                        children: [

                          Text(
                            'ESP32 IP',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            baseUrl,
                            textAlign:
                                TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==========================================
                    // STREAM API
                    // ==========================================

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(15),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.grey.shade100,
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                      child: const Column(
                        children: [

                          Text(
                            'STREAM API',
                            style: TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 5),

                          Text(
                            streamUrl,
                            textAlign:
                                TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // TEST CONNECTION
            // ==================================================

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed:
                    isTesting ||
                            isUploading
                        ? null
                        : testConnection,

                icon: isTesting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.wifi,
                      ),

                label: Text(
                  isTesting
                      ? 'Testing...'
                      : 'Test Connection',
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // SEND WAV
            // ==================================================

            SizedBox(
              height: 60,
              child: ElevatedButton.icon(
                onPressed:
                    isUploading ||
                            isTesting
                        ? null
                        : uploadWavFile,

                icon: isUploading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.upload_file,
                      ),

                label: Text(
                  isUploading
                      ? 'Sending WAV...'
                      : 'Send WAV File',

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // PROGRESS
            // ==================================================

            if (isUploading ||
                uploadProgress > 0)
              Column(
                children: [

                  LinearProgressIndicator(
                    value:
                        uploadProgress == 0
                            ? null
                            : uploadProgress,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${(uploadProgress * 100).toInt()}%',
                    textAlign:
                        TextAlign.center,
                  ),
                ],
              ),

            const SizedBox(height: 10),

            // ==================================================
            // STATUS CARD
            // ==================================================

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(15),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.grey.shade100,
                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: SelectableText(
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

          ],
        ),
      ),
    );
  }
}