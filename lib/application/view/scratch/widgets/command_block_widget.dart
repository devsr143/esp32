// import 'package:esp32/application/model/program_block.dart';
// import 'package:flutter/material.dart';

// class CommandBlockWidget extends StatefulWidget {
//   const CommandBlockWidget({
//     super.key,
//     required this.type,
//     this.showTopConnector = false,
//     this.showBottomConnector = false,
//     this.isActive = false,
//     this.showDelete = false,
//     this.seconds,
//     this.degrees,
//     this.onDelete,
//     this.onSecondsChanged,
//     this.onDegreesChanged,
//   });

//   final CommandType type;

//   final bool showTopConnector;
//   final bool showBottomConnector;
//   final bool isActive;
//   final bool showDelete;

//   final double? seconds;
//   final int? degrees;

//   final VoidCallback? onDelete;
//   final ValueChanged<double>? onSecondsChanged;
//   final ValueChanged<int>? onDegreesChanged;

//   @override
//   State<CommandBlockWidget> createState() => _CommandBlockWidgetState();
// }

// class _CommandBlockWidgetState extends State<CommandBlockWidget> {
//   String _label() {
//     switch (widget.type) {
//       case CommandType.forward:
//         return 'forward';
//       case CommandType.backward:
//         return 'backward';
//       case CommandType.left:
//         return 'turn left';
//       case CommandType.right:
//         return 'turn right';
//       case CommandType.circle:
//         return 'circle';
//       case CommandType.stop:
//         return 'stop';
//       case CommandType.loop:
//         return 'loop';
//       case CommandType.delay:
//         return 'delay';
//     }
//   }

//   IconData _icon() {
//     switch (widget.type) {
//       case CommandType.forward:
//         return Icons.arrow_upward_rounded;
//       case CommandType.backward:
//         return Icons.arrow_downward_rounded;
//       case CommandType.left:
//         return Icons.turn_left_rounded;
//       case CommandType.right:
//         return Icons.turn_right_rounded;
//       case CommandType.circle:
//         return Icons.circle_outlined;
//       case CommandType.stop:
//         return Icons.stop_circle_rounded;
//       case CommandType.loop:
//         return Icons.loop_rounded;
//       case CommandType.delay:
//         return Icons.timer_outlined;
//     }
//   }

//   Color _color() {
//     switch (widget.type) {
//       case CommandType.forward:
//       case CommandType.backward:
//       case CommandType.left:
//       case CommandType.right:
//       case CommandType.circle:
//         return const Color(0xFF4C97FF);

//       case CommandType.stop:
//         return const Color(0xFFE84B3C);

//       case CommandType.loop:
//       case CommandType.delay:
//         return const Color(0xFFFFAB19);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final blockColor = _color();

//     return SizedBox(
//       width: 300,
//       height: 61,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           Container(
//             height: 52,
//             width: 300,
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//             decoration: BoxDecoration(
//               color: blockColor,
//               borderRadius: BorderRadius.circular(7),
//               border: widget.isActive
//                   ? Border.all(color: Colors.white, width: 2.5)
//                   : null,
//               boxShadow: [
//                 BoxShadow(
//                   color: blockColor.withValues(alpha: 0.30),
//                   offset: const Offset(0, 3),
//                   blurRadius: 0,
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Icon(_icon(), color: Colors.white, size: 20),

//                 const SizedBox(width: 8),

//                 Text(
//                   _label(),
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),

//                 const Spacer(),

//                 if (widget.degrees != null) _buildDegreeInput(),

//                 if (widget.seconds != null) _buildSecondsInput(),

//                 if (widget.showDelete)
//                   IconButton(
//                     onPressed: widget.onDelete,
//                     icon: const Icon(
//                       Icons.close_rounded,
//                       color: Colors.white,
//                       size: 18,
//                     ),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(
//                       minWidth: 30,
//                       minHeight: 30,
//                     ),
//                   ),
//               ],
//             ),
//           ),

//           if (widget.showTopConnector)
//             Positioned(
//               top: 0,
//               left: 20,
//               child: Container(
//                 width: 38,
//                 height: 8,
//                 decoration: const BoxDecoration(
//                   color: Color(0xFFF4F7FB),
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(4),
//                     bottomRight: Radius.circular(4),
//                   ),
//                 ),
//               ),
//             ),

//           if (widget.showBottomConnector)
//             Positioned(
//               top: 51,
//               left: 20,
//               child: Container(
//                 width: 38,
//                 height: 10,
//                 decoration: BoxDecoration(
//                   color: blockColor,
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(4),
//                     bottomRight: Radius.circular(4),
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDegreeInput() {
//     return DropdownButtonHideUnderline(
//       child: DropdownButton<int>(
//         value: widget.degrees,
//         isDense: true,
//         items: const [
//           DropdownMenuItem(value: 60, child: Text('60')),
//           DropdownMenuItem(value: 90, child: Text('90')),
//           DropdownMenuItem(value: 108, child: Text('108')),
//           DropdownMenuItem(value: 120, child: Text('120')),
//         ],
//         onChanged: (value) {
//           if (value != null) {
//             widget.onDegreesChanged?.call(value);
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildSecondsInput() {
//     return SizedBox(
//       width: 65,
//       height: 30,
//       child: TextField(
//         controller: TextEditingController(text: widget.seconds!.toString()),
//         keyboardType: const TextInputType.numberWithOptions(decimal: true),
//         textAlign: TextAlign.center,
//         onSubmitted: (value) {
//           final parsed = double.tryParse(value);

//           if (parsed != null) {
//             widget.onSecondsChanged?.call(parsed.clamp(1.0, 99.0));
//           }
//         },
//       ),
//     );
//   }
// }



import 'package:esp32/application/model/program_block.dart';
import 'package:flutter/material.dart';
import 'seconds_input.dart';

class CommandBlockWidget extends StatefulWidget {
  const CommandBlockWidget({
    super.key,
    required this.type,
    this.blockId,
    this.showTopConnector = false,
    this.showBottomConnector = false,
    this.isActive = false,
    this.showDelete = false,
    this.seconds,
    this.degrees,
    this.onDelete,
    this.onSecondsChanged,
    this.onDegreesChanged,
  });

  final CommandType type;

  // Unique ID for each program block.
  final int? blockId;

  final bool showTopConnector;
  final bool showBottomConnector;
  final bool isActive;
  final bool showDelete;

  final double? seconds;
  final int? degrees;

  final VoidCallback? onDelete;
  final ValueChanged<double>? onSecondsChanged;
  final ValueChanged<int>? onDegreesChanged;

  @override
  State<CommandBlockWidget> createState() => _CommandBlockWidgetState();
}

class _CommandBlockWidgetState extends State<CommandBlockWidget> {
  String _label() {
    switch (widget.type) {
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

  IconData _icon() {
    switch (widget.type) {
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

  Color _color() {
    switch (widget.type) {
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

  @override
  Widget build(BuildContext context) {
    final blockColor = _color();

    return SizedBox(
      width: 300,
      height: 61,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 52,
            width: 300,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: blockColor,
              borderRadius: BorderRadius.circular(7),
              border: widget.isActive
                  ? Border.all(color: Colors.white, width: 2.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: blockColor.withValues(alpha: 0.30),
                  offset: const Offset(0, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(_icon(), color: Colors.white, size: 20),

                const SizedBox(width: 8),

                Text(
                  _label(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const Spacer(),

                if (widget.degrees != null) _buildDegreeInput(),

                if (widget.seconds != null) _buildSecondsInput(),

                if (widget.showDelete)
                  IconButton(
                    onPressed: widget.onDelete,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 30,
                      minHeight: 30,
                    ),
                  ),
              ],
            ),
          ),

          if (widget.showTopConnector)
            Positioned(
              top: 0,
              left: 20,
              child: Container(
                width: 38,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F7FB),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),

          if (widget.showBottomConnector)
            Positioned(
              top: 51,
              left: 20,
              child: Container(
                width: 38,
                height: 10,
                decoration: BoxDecoration(
                  color: blockColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDegreeInput() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        value: widget.degrees,
        isDense: true,
        items: const [
          DropdownMenuItem(value: 60, child: Text('60')),
          DropdownMenuItem(value: 90, child: Text('90')),
          DropdownMenuItem(value: 108, child: Text('108')),
          DropdownMenuItem(value: 120, child: Text('120')),
        ],
        onChanged: (value) {
          if (value != null) {
            widget.onDegreesChanged?.call(value);
          }
        },
      ),
    );
  }

  Widget _buildSecondsInput() {
    return SecondsInput(
      key: ValueKey('seconds_${widget.blockId}'),
      value: widget.seconds!,
      enabled: !widget.isActive,
      onChanged: widget.onSecondsChanged,
    );
  }
}