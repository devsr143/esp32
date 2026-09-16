import 'package:esp32/application/model/program_block.dart';
import 'package:esp32/application/view_model/scratch_program_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'command_block_widget.dart';

class CommandPalette extends StatelessWidget {
  const CommandPalette({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ScratchProgramViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

        for (final type in vm.paletteBlocks)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: _buildPaletteBlock(context, type),
          ),
      ],
    );
  }

  Widget _buildPaletteBlock(
    BuildContext context,
    CommandType type,
  ) {
    final vm = context.read<ScratchProgramViewModel>();

    return Draggable<CommandType>(
      data: type,

      maxSimultaneousDrags: vm.isExecuting ? 0 : 1,

      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.88,
          child: CommandBlockWidget(
            type: type,
            showBottomConnector: true,
          ),
        ),
      ),

      childWhenDragging: Opacity(
        opacity: 0.35,
        child: CommandBlockWidget(
          type: type,
          showBottomConnector: true,
        ),
      ),

      child: CommandBlockWidget(
        type: type,
        showBottomConnector: true,
      ),
    );
  }
}