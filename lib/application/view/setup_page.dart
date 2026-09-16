import 'package:esp32/application/view/scratch/scratch_program_page.dart';
import 'package:esp32/application/view_model/setup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    // SetupViewModel is registered globally in main.dart.
    return const _SetupView();
  }
}

class _SetupView extends StatefulWidget {
  const _SetupView();

  @override
  State<_SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<_SetupView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SetupViewModel>().checkWifiStatus();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Knowli Bot Setup',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Column(
                children: [
                  buildHeader(),

                  const SizedBox(height: 20),

                  buildConnectionCard(),

                  const SizedBox(height: 16),

                  buildClassCard(),

                  const SizedBox(height: 16),

                  buildStatusCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget buildHeader() {
    return Column(
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.smart_toy,
            size: 52,
            color: Colors.deepPurple,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'Welcome to Knowli Bot',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Connect your ESP32 and select a class',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // CONNECTION CARD
  // ===========================================================================

  Widget buildConnectionCard() {
    return Consumer<SetupViewModel>(
      builder: (context, vm, child) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.wifi,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ESP32 Connection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Icon(
                      vm.isEsp32Connected
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: vm.isEsp32Connected
                          ? Colors.green
                          : Colors.red,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        vm.isEsp32Connected
                            ? 'ESP32 Connected'
                            : 'ESP32 Not Connected',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: vm.isEsp32Connected
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  vm.wifiStatus,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 14),

                // Show Enable Wi-Fi when Wi-Fi is OFF.
                if (!vm.isWifiEnabled)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: vm.isCheckingConnection
                          ? null
                          : () async {
                              await vm.openWifiSettings();
                            },
                      icon: const Icon(Icons.settings),
                      label: const Text('Enable Wi-Fi'),
                    ),
                  ),

                if (!vm.isWifiEnabled)
                  const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: vm.isCheckingConnection
                        ? null
                        : vm.connectToEsp32,
                    icon: vm.isCheckingConnection
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.link),
                    label: Text(
                      vm.isCheckingConnection
                          ? 'Checking...'
                          : 'Check ESP32 Connection',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // CLASS CARD
  // ===========================================================================

  Widget buildClassCard() {
    return Consumer<SetupViewModel>(
      builder: (context, vm, child) {
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Choose Class',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<int>(
                  initialValue: vm.selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Select Class',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.class_),
                  ),
                  items: List.generate(
                    8,
                    (index) {
                      final classNumber = index + 3;

                      return DropdownMenuItem<int>(
                        value: classNumber,
                        child: Text('Class $classNumber'),
                      );
                    },
                  ),
                  onChanged:
                      (!vm.isEsp32Connected ||
                              vm.isUploadingFirmware)
                          ? null
                          : vm.selectClass,
                ),

                const SizedBox(height: 12),

                Text(
                  'Selected BIN file:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  vm.selectedFirmwarePath ??
                      'No BIN file found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 16),

                if (vm.isUploadingFirmware)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: vm.uploadProgress == 0
                            ? null
                            : vm.uploadProgress,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${(vm.uploadProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        (!vm.isEsp32Connected ||
                                vm.isUploadingFirmware)
                            ? null
                            : () => _sendBin(context),
                    icon: vm.isUploadingFirmware
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.upload_file),
                    label: Text(
                      vm.isUploadingFirmware
                          ? 'Sending BIN...'
                          : 'Send BIN & Continue',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================================
  // SEND BIN
  // ===========================================================================

  Future<void> _sendBin(BuildContext context) async {
    final vm = context.read<SetupViewModel>();

    final success = await vm.uploadSelectedClassFirmware();

    if (!context.mounted || !success) return;

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScratchProgramPage(
          selectedClass: vm.selectedClass,
        ),
      ),
    );
  }

  // ===========================================================================
  // STATUS CARD
  // ===========================================================================

  Widget buildStatusCard() {
    return Consumer<SetupViewModel>(
      builder: (context, vm, child) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.deepPurple,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  vm.status,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}