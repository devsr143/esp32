import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

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

  late final StreamSubscription<bool> _keyboardSubscription;

  bool _isEditing = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: _formatValue(widget.value));

    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);

    final keyboardController = KeyboardVisibilityController();

    _keyboardSubscription = keyboardController.onChange.listen((
      bool isKeyboardVisible,
    ) {
      // Android back button can hide the keyboard without
      // removing focus from the TextField.
      if (!isKeyboardVisible && _isEditing) {
        _submitValue();
        _isEditing = false;
      }
    });
  }

  @override
  void didUpdateWidget(covariant SecondsInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Do not overwrite the user's typed value while editing.
    if (!_isEditing && oldWidget.value != widget.value) {
      _setControllerText(widget.value);
    }
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _isEditing = true;
      return;
    }

    // User tapped outside the TextField.
    if (_isEditing) {
      _submitValue();
      _isEditing = false;
    }
  }

  String _formatValue(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  void _setControllerText(double value) {
    final text = _formatValue(value);

    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _submitValue() {
    if (_isSubmitting) return;

    _isSubmitting = true;

    final text = _controller.text.trim();
    final parsed = double.tryParse(text);

    if (parsed == null) {
      _setControllerText(widget.value);
      _isSubmitting = false;
      return;
    }

    final double clampedValue = parsed.clamp(1.0, 99.0).toDouble();

    // Update the displayed value.
    _setControllerText(clampedValue);

    // Update the ViewModel.
    widget.onChanged?.call(clampedValue);

    _isSubmitting = false;
  }

  @override
  void dispose() {
    _keyboardSubscription.cancel();

    _focusNode.removeListener(_handleFocusChange);

    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
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
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,2})?$')),
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
          hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 11),
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
            borderSide: const BorderSide(color: Color(0xFF573F0C), width: 1.5),
          ),
        ),
        onTap: () {
          _isEditing = true;
        },
        onChanged: (_) {
          _isEditing = true;
        },
        onSubmitted: (_) {
          _submitValue();
          _isEditing = false;
          _focusNode.unfocus();
        },
      ),
    );
  }
}




