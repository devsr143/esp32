import 'package:esp32/application/model/program_block.dart';
import 'package:esp32/application/view_model/scratch_program_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'command_block_widget.dart';

class ProgramDropArea extends StatefulWidget {
  const ProgramDropArea({super.key});

  @override
  State<ProgramDropArea> createState() => _ProgramDropAreaState();
}

class _ProgramDropAreaState extends State<ProgramDropArea> {
  final GlobalKey _dropAreaKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Consumer<ScratchProgramViewModel>(
      builder: (context, vm, _) {
        return DragTarget<CommandType>(
          onWillAcceptWithDetails: (_) {
            return !vm.isExecuting;
          },

          onMove: (details) {
            if (vm.isExecuting) return;

            final renderBox = _dropAreaKey.currentContext
                ?.findRenderObject() as RenderBox?;

            if (renderBox == null) return;

            // Convert global pointer position to local position.
            final localPosition = renderBox.globalToLocal(
              details.offset,
            );

            final insertIndex = _calculateInsertIndex(
              localPosition.dy,
              vm.program.length,
            );

            vm.setDropInsertIndex(insertIndex);
          },

          onLeave: (_) {
            vm.setDropInsertIndex(null);
          },

          onAcceptWithDetails: (details) {
            final index = vm.dropInsertIndex ?? vm.program.length;

            vm.insertBlockAt(
              details.data,
              index,
            );

            vm.setDropInsertIndex(null);
          },

          builder: (
            context,
            candidateData,
            rejectedData,
          ) {
            final isHovering = candidateData.isNotEmpty;

            return Container(
              key: _dropAreaKey,
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 185,
              ),
              padding: const EdgeInsets.fromLTRB(
                14,
                18,
                14,
                22,
              ),
              decoration: BoxDecoration(
                color: isHovering
                    ? const Color(0xFFE9F4FF)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isHovering
                      ? const Color(0xFF4C97FF)
                      : const Color(0xFFC8D4E0),
                  width: isHovering ? 2.5 : 2,
                ),
              ),
              child: vm.program.isEmpty
                  ? _buildEmptyArea()
                  : Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        for (
                          int index = 0;
                          index < vm.program.length;
                          index++
                        ) ...[
                          if (vm.dropInsertIndex == index &&
                              isHovering)
                            _buildDropIndicator(),

                          _buildProgramBlock(
                            context,
                            vm,
                            vm.program[index],
                            index,
                          ),
                        ],

                        if (vm.dropInsertIndex ==
                                vm.program.length &&
                            isHovering)
                          _buildDropIndicator(),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  int _calculateInsertIndex(
    double localY,
    int blockCount,
  ) {
    const double topPadding = 18;

    const double blockHeight = 61;

    final double adjustedY = localY - topPadding;

    if (adjustedY <= 0) {
      return 0;
    }
    final int index = (adjustedY / blockHeight).round();

    return index.clamp(0, blockCount);
  }

  Widget _buildProgramBlock(
    BuildContext context,
    ScratchProgramViewModel vm,
    ProgramBlock block,
    int index,
  ) {
    final isFirst = index == 0;
    final isLast = index == vm.program.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              '${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF7C8D9F),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        Expanded(
          child: CommandBlockWidget(
            type: block.type,
            showTopConnector: !isFirst,
            showBottomConnector: !isLast,
            isActive: vm.activeBlockId == block.id,
            showDelete: !vm.isExecuting,
            seconds: vm.needsSeconds(block.type)
                ? block.seconds
                : null,
            degrees: vm.needsDegrees(block.type)
                ? block.degrees
                : null,
            onDelete: () {
              vm.removeBlock(block.id);
            },
            onSecondsChanged: (value) {
              vm.updateSeconds(block, value);
            },
            onDegreesChanged: (value) {
              vm.updateDegrees(block, value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyArea() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 18),
        Icon(
          Icons.move_down_rounded,
          size: 50,
          color: Color(0xFF4C97FF),
        ),
        SizedBox(height: 10),
        Text(
          'Drop blocks here',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF35465A),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Blocks will connect in the order you drop them.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF6D7C8E),
          ),
        ),
        SizedBox(height: 18),
      ],
    );
  }

  Widget _buildDropIndicator() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 28,
        top: 2,
        bottom: 2,
      ),
      child: Container(
        width: 300,
        height: 8,
        decoration: BoxDecoration(
          color: const Color(0xFF4C97FF),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}


