import 'package:esp32/application/view/scratch/widgets/command_palete.dart';
import 'package:esp32/application/view/scratch/widgets/program_drop_area.dart';
import 'package:esp32/application/view_model/scratch_program_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScratchProgramPage extends StatefulWidget {
  const ScratchProgramPage({
    super.key,
    required this.selectedClass,
  });

  final int selectedClass;

  @override
  State<ScratchProgramPage> createState() => _ScratchProgramPageState();
}

class _ScratchProgramPageState extends State<ScratchProgramPage> {
  @override
  Widget build(BuildContext context) {
    return const _ScratchProgramView();
  }
}

class _ScratchProgramView extends StatelessWidget {
  const _ScratchProgramView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF7B45D6),
        foregroundColor: Colors.white,
        title: Consumer<ScratchProgramViewModel>(
          builder: (context, vm, _) {
            return Text(
              'Class ${vm.selectedClass} Robot Commands',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            );
          },
        ),
      ),

      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return _buildLandscape(context);
          }

          return _buildPortrait(context);
        },
      ),
    );
  }

  Widget _buildPortrait(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Command Blocks',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF293B4D),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'Drag blocks into the program area to build your program.',
            style: TextStyle(
              color: Color(0xFF6A7A8D),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 18),

          const CommandPalette(),

          const SizedBox(height: 28),

          const Text(
            'Program Drop Area',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF293B4D),
            ),
          ),

          const SizedBox(height: 10),

          const ProgramDropArea(),

          const SizedBox(height: 18),

          _buildActionButtons(context),

          const SizedBox(height: 14),

          _buildStatusCard(context),
        ],
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 4,
            child: CommandPalette(),
          ),

          const SizedBox(width: 18),

          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Program Drop Area',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF293B4D),
                  ),
                ),

                const SizedBox(height: 10),

                const ProgramDropArea(),

                const SizedBox(height: 14),

                _buildActionButtons(context),

                const SizedBox(height: 12),

                _buildStatusCard(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Consumer<ScratchProgramViewModel>(
      builder: (context, vm, _) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: vm.isExecuting
                    ? null
                    : vm.executeProgram,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Execute'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: const Color(0xFF2EAA56),
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 10),

            OutlinedButton.icon(
              onPressed: vm.isExecuting
                  ? vm.stopExecution
                  : vm.clearProgram,
              icon: Icon(
                vm.isExecuting
                    ? Icons.stop_rounded
                    : Icons.delete_outline_rounded,
              ),
              label: Text(
                vm.isExecuting ? 'Stop' : 'Clear',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(112, 52),
                foregroundColor: vm.isExecuting
                    ? const Color(0xFFE84B3C)
                    : const Color(0xFF536578),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Consumer<ScratchProgramViewModel>(
      builder: (context, vm, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: vm.isExecuting
                ? const Color(0xFFEAF8EF)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: vm.isExecuting
                  ? const Color(0xFF94D9A8)
                  : const Color(0xFFDDE6EE),
            ),
          ),
          child: Row(
            children: [
              Icon(
                vm.isExecuting
                    ? Icons.play_circle_fill_rounded
                    : Icons.info_outline_rounded,
                color: vm.isExecuting
                    ? const Color(0xFF2EAA56)
                    : const Color(0xFF4C97FF),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  vm.status,
                  style: const TextStyle(
                    color: Color(0xFF425467),
                    fontWeight: FontWeight.w600,
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