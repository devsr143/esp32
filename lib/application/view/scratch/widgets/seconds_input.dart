import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondsInput extends StatefulWidget {
  const SecondsInput({
    super.key,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final double value;
  final bool enabled;
  final ValueChanged<double>? onChanged;

  @override
  State<SecondsInput> createState() => _SecondsInputState();
}

class _SecondsInputState extends State<SecondsInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: _formatValue(widget.value),
    );

    _focusNode = FocusNode();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _submitValue();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SecondsInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_focusNode.hasFocus &&
        oldWidget.value != widget.value) {
      _controller.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  void _submitValue() {
    final parsed = double.tryParse(_controller.text);

    if (parsed == null) {
      _controller.text = _formatValue(widget.value);
      return;
    }

    final clamped = parsed.clamp(1.0, 99.0);

    _controller.text = _formatValue(clamped);

    widget.onChanged?.call(clamped);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 30,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d{0,2}(\.\d{0,2})?$'),
          ),
        ],
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.done,
        style: const TextStyle(
          color: Color(0xFF573F0C),
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: '1–99',
          hintStyle: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 11,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF573F0C),
              width: 1.5,
            ),
          ),
        ),
        onSubmitted: (_) {
          _submitValue();
          _focusNode.unfocus();
        },
      ),
    );
  }
}