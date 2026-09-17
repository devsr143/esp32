import 'package:esp32/application/model/program_block.dart';
import 'package:esp32/application/service/robot_command_service.dart';
import 'package:flutter/material.dart';

class ScratchProgramViewModel extends ChangeNotifier {
  ScratchProgramViewModel({
    Esp32CommandService? service,
    required this.selectedClass,
  }) : _service = service ?? Esp32CommandService();

  final Esp32CommandService _service;
  final int selectedClass;

  static const int turnDuration90Milliseconds = 1155;
  static const int actionCooldownMilliseconds = 400;


  final List<ProgramBlock> _program = [];

  List<ProgramBlock> get program => List.unmodifiable(_program);

  int _nextBlockId = 0;

  bool _isExecuting = false;
  bool get isExecuting => _isExecuting;

  bool _stopRequested = false;

  int? _activeBlockId;
  int? get activeBlockId => _activeBlockId;

  int? _dropInsertIndex;
  int? get dropInsertIndex => _dropInsertIndex;

  String _status = 'Drag blocks into the program area.';
  String get status => _status;

  final List<CommandType> paletteBlocks = const [
    CommandType.forward,
    CommandType.backward,
    CommandType.left,
    CommandType.right,
    CommandType.circle,
    CommandType.loop,
    CommandType.delay,
  ];

  String label(CommandType type) {
    switch (type) {
      case CommandType.forward:
        return 'forward';
      case CommandType.backward:
        return 'backward';
      case CommandType.left:
        return 'turn left';
      case CommandType.right:
        return 'turn right';
      case CommandType.circle:
        return 'circle';
      case CommandType.stop:
        return 'stop';
      case CommandType.loop:
        return 'loop';
      case CommandType.delay:
        return 'delay';
    }
  }

  IconData icon(CommandType type) {
    switch (type) {
      case CommandType.forward:
        return Icons.arrow_upward_rounded;
      case CommandType.backward:
        return Icons.arrow_downward_rounded;
      case CommandType.left:
        return Icons.turn_left_rounded;
      case CommandType.right:
        return Icons.turn_right_rounded;
      case CommandType.circle:
        return Icons.circle_outlined;
      case CommandType.stop:
        return Icons.stop_circle_rounded;
      case CommandType.loop:
        return Icons.loop_rounded;
      case CommandType.delay:
        return Icons.timer_outlined;
    }
  }

  Color color(CommandType type) {
    switch (type) {
      case CommandType.forward:
      case CommandType.backward:
      case CommandType.left:
      case CommandType.right:
      case CommandType.circle:
        return const Color(0xFF4C97FF);
      case CommandType.stop:
        return const Color(0xFFE84B3C);
      case CommandType.loop:
      case CommandType.delay:
        return const Color(0xFFFFAB19);
    }
  }

  bool needsSeconds(CommandType type) {
    return type == CommandType.forward ||
        type == CommandType.backward ||
        type == CommandType.delay;
  }

  bool needsDegrees(CommandType type) {
    return type == CommandType.left || type == CommandType.right;
  }

  void insertBlockAt(CommandType type, int index) {
    if (_isExecuting) return;

    final safeIndex = index.clamp(0, _program.length);

    _program.insert(
      safeIndex,
      ProgramBlock(
        id: _nextBlockId++,
        type: type,
      ),
    );

    _dropInsertIndex = null;
    _status = '${label(type)} inserted.';

    notifyListeners();
  }

  void removeBlock(int id) {
    if (_isExecuting) return;

    _program.removeWhere((block) => block.id == id);

    _status = 'Block removed.';

    notifyListeners();
  }

  void clearProgram() {
    if (_isExecuting) return;

    _program.clear();
    _activeBlockId = null;
    _dropInsertIndex = null;

    _status = 'Program cleared.';

    notifyListeners();
  }

  void setDropInsertIndex(int? index) {
    if (_isExecuting) return;

    _dropInsertIndex = index;
    notifyListeners();
  }

  void updateSeconds(ProgramBlock block, double value) {
    if (_isExecuting) return;

    block.seconds = value;
    notifyListeners();
  }

  void updateDegrees(ProgramBlock block, int value) {
    if (_isExecuting) return;

    block.degrees = value;
    notifyListeners();
  }


  Future<void> executeProgram() async {
    if (_isExecuting) return;

    if (_program.isEmpty) {
      _status = 'Please drop at least one block before executing.';
      notifyListeners();
      return;
    }

    final programSnapshot = List<ProgramBlock>.from(_program);

    final loopIndex = programSnapshot.indexWhere(
      (block) => block.type == CommandType.loop,
    );

    _isExecuting = true;
    _stopRequested = false;
    _activeBlockId = null;

    _status = 'Class $selectedClass program started.';
    notifyListeners();

    try {
      if (loopIndex == -1) {
        await _executeBlocks(programSnapshot);
        return;
      }

      final loopBlocks = programSnapshot.sublist(0, loopIndex);

      if (loopBlocks.isEmpty) {
        _finishExecution('Add at least one command before the loop.');
        return;
      }

      _status = 'Infinite loop started.';
      notifyListeners();

      while (_isExecuting && !_stopRequested) {
        for (final block in loopBlocks) {
          if (!_isExecuting || _stopRequested) return;

          final success = await _executeSingleBlock(block);

          if (!_isExecuting || _stopRequested) return;

          if (!success) {
            _finishExecution(
              'Program stopped because a command failed.',
            );
            return;
          }
        }

        if (_isExecuting && !_stopRequested) {
          _status = 'Loop repeating...';
          notifyListeners();
        }
      }
    } catch (e) {
      if (!_stopRequested) {
        _finishExecution('Execution error: $e');
      }
    }
  }

  Future<void> _executeBlocks(List<ProgramBlock> blocks) async {
    for (final block in blocks) {
      if (!_isExecuting || _stopRequested) return;

      final success = await _executeSingleBlock(block);

      if (!_isExecuting || _stopRequested) return;

      if (!success) {
        _finishExecution(
          'Program stopped because a command failed.',
        );
        return;
      }

      if (block.type == CommandType.stop) return;
    }

    if (!_isExecuting || _stopRequested) return;

    _finishExecution('Program completed.');
  }

  Future<bool> _executeSingleBlock(ProgramBlock block) async {
    if (!_isExecuting || _stopRequested) return false;

    _activeBlockId = block.id;
    _status = 'Executing: ${label(block.type)}';
    notifyListeners();

    if (block.type == CommandType.loop) {
      return true;
    }

    if (block.type == CommandType.stop) {
      _status = 'Stopping robot...';
      notifyListeners();

      final success = await _service.sendCommand(block);

      if (!_isExecuting || _stopRequested) {
        return false;
      }

      _finishExecution(
        success
            ? 'Stop block reached. Program ended.'
            : 'Stop command failed.',
      );

      return success;
    }

    _status = _executionStatus(block);
    notifyListeners();

    final success = await _service.sendCommand(block);

    if (!_isExecuting || _stopRequested) {
      return false;
    }

    if (!success) {
      _status = 'Could not connect to ESP32.';
      notifyListeners();
      return false;
    }

    await _waitForCommandCompletion(block);

    if (!_isExecuting || _stopRequested) {
      return false;
    }

    return true;
  }

  String _executionStatus(ProgramBlock block) {
    switch (block.type) {
      case CommandType.forward:
        return 'Moving forward for ${formatSeconds(block.seconds)} second'
            '${block.seconds == 1.0 ? '' : 's'}...';

      case CommandType.backward:
        return 'Moving backward for ${formatSeconds(block.seconds)} second'
            '${block.seconds == 1.0 ? '' : 's'}...';

      case CommandType.left:
        return 'Turning left ${block.degrees}°...';

      case CommandType.right:
        return 'Turning right ${block.degrees}°...';

      case CommandType.circle:
        return 'Drawing circle for ${formatSeconds(block.seconds)} second'
            '${block.seconds == 1.0 ? '' : 's'}...';

      case CommandType.delay:
        return 'Waiting ${formatSeconds(block.seconds)} second'
            '${block.seconds == 1.0 ? '' : 's'}...';

      case CommandType.stop:
      case CommandType.loop:
        return _status;
    }
  }

  Future<void> _waitForCommandCompletion(ProgramBlock block) async {
    int waitMilliseconds = 0;

    switch (block.type) {
      case CommandType.forward:
      case CommandType.backward:
      case CommandType.circle:
      case CommandType.delay:
        waitMilliseconds =
            (block.seconds * 1000).round() +
                actionCooldownMilliseconds;
        break;

      case CommandType.left:
      case CommandType.right:
        waitMilliseconds =
            getTurnDuration(block.degrees) +
                actionCooldownMilliseconds;
        break;

      case CommandType.stop:
      case CommandType.loop:
        waitMilliseconds = 0;
        break;
    }

    if (waitMilliseconds <= 0) return;

    const intervalMilliseconds = 100;
    int elapsedMilliseconds = 0;

    while (elapsedMilliseconds < waitMilliseconds) {
      if (!_isExecuting || _stopRequested) return;

      final remaining = waitMilliseconds - elapsedMilliseconds;

      final currentWait = remaining < intervalMilliseconds
          ? remaining
          : intervalMilliseconds;

      await Future.delayed(
        Duration(milliseconds: currentWait),
      );

      elapsedMilliseconds += currentWait;
    }
  }

  int getTurnDuration(int selectedInteriorAngle) {
    final physicalTurnDegrees = 180 - selectedInteriorAngle;

    return (
      turnDuration90Milliseconds *
      physicalTurnDegrees /
      90
    ).round();
  }

  Future<void> stopExecution() async {
    if (!_isExecuting) return;

    _stopRequested = true;
    _isExecuting = false;
    _activeBlockId = null;

    _status = 'Stopping robot...';
    notifyListeners();

    // Send the STOP command to ESP32.
    final stopBlock = ProgramBlock(
      id: -1,
      type: CommandType.stop,
    );

    final success = await _service.sendCommand(stopBlock);

    _status = success
        ? 'Execution stopped.'
        : 'Robot stop command failed.';

    notifyListeners();
  }

  void _finishExecution(String message) {
    _isExecuting = false;
    _stopRequested = false;
    _activeBlockId = null;
    _status = message;

    notifyListeners();
  }

  String formatSeconds(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}