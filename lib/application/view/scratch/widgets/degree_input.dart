// import 'package:flutter/material.dart';

// class DegreesInput extends StatefulWidget {
//   const DegreesInput({
//     super.key,
//     required this.initialValue,
//     required this.onChanged,
//     this.minValue = 1,
//     this.maxValue = 360,
//   });

//   final double initialValue;
//   final ValueChanged<double> onChanged;
//   final double minValue;
//   final double maxValue;

//   @override
//   State<DegreesInput> createState() => _DegreesInputState();
// }

// class _DegreesInputState extends State<DegreesInput> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     super.initState();

//     _controller = TextEditingController(
//       text: _formatValue(widget.initialValue),
//     );
//   }

//   @override
//   void didUpdateWidget(covariant DegreesInput oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     if (oldWidget.initialValue != widget.initialValue &&
//         _controller.text != _formatValue(widget.initialValue)) {
//       _controller.text = _formatValue(widget.initialValue);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _handleChanged(String text) {
//     final value = double.tryParse(text);

//     if (value == null) {
//       return;
//     }

//     final clampedValue = value.clamp(
//       widget.minValue,
//       widget.maxValue,
//     );

//     widget.onChanged(clampedValue.toDouble());
//   }

//   String _formatValue(double value) {
//     if (value == value.roundToDouble()) {
//       return value.toInt().toString();
//     }

//     return value.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 110,
//       child: TextFormField(
//         controller: _controller,
//         keyboardType: const TextInputType.numberWithOptions(
//           decimal: false,
//         ),
//         textAlign: TextAlign.center,
//         decoration: const InputDecoration(
//           labelText: 'Degrees',
//           suffixText: '°',
//           border: OutlineInputBorder(),
//           isDense: true,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: 8,
//             vertical: 12,
//           ),
//         ),
//         onChanged: _handleChanged,
//       ),
//     );
//   }
// }