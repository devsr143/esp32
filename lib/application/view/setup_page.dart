import 'dart:async';
import 'package:esp32/application/view_model/setup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:esp32/application/view/activity_listpage.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
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
  Timer? _connectionTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _connectionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      final vm = context.read<SetupViewModel>();
      if (!vm.isEsp32Connected && !vm.isCheckingConnection) {
        vm.checkWifiStatus();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SetupViewModel>().checkWifiStatus();
    }
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background/background.jpeg'),
          fit: BoxFit.cover)
        ),
        child: SafeArea(
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
                    const SizedBox(height: 200),
                    Consumer<SetupViewModel>(
                      builder: (context, vm, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (child, animation) {
                            final isClassCard = child.key == const ValueKey('classCard');
                            final offsetAnimation = Tween<Offset>(
                              begin: Offset(isClassCard ? 1.0 : -1.0, 0.0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeInOut,
                            ));
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: vm.isEsp32Connected
                              ? KeyedSubtree(
                                  key: const ValueKey('classCard'),
                                  child: buildClassCard(),
                                )
                              : KeyedSubtree(
                                  key: const ValueKey('connectionCard'),
                                  child: buildConnectionCard(),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      mainAxisAlignment: .start,
      crossAxisAlignment: .center,
      children: [
        Center(
          child: Container(
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Image(image: AssetImage('assets/images/Logo/Knowlibot.png'),fit: BoxFit.contain,),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          '''Welcome to Knowli Bot\n an Edu Tech Robot''',
          style: GoogleFonts.elsie(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ),
      ],
    );
  }

  Widget buildConnectionCard() {
    return Consumer<SetupViewModel>(
      builder: (context, vm, child) {
        return Card(
          color: Colors.transparent.withValues(alpha: .8),
          elevation: 10,
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
                        color: Colors.white
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
                            ? 'KNOWLIBOT Connected'
                            : 'KNOWLIBOT Not Connected',
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
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      vm.openWifiSettings();
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text(' Enable wifi to check connection'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                      (!vm.isEsp32Connected)
                          ? null
                          : vm.selectClass,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        (!vm.isEsp32Connected)
                            ? null
                            : () => _continue(context),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Continue'),
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

  void _continue(BuildContext context) {
    final vm = context.read<SetupViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ActivityListPage(
          selectedClass: vm.selectedClass,
        ),
      ),
    );
  }
}
