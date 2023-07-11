import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    this.isNumber,
    this.autoFocus,
    this.onSubmitted,
    this.label,
  });
  final TextEditingController controller;
  final bool? isNumber;
  final bool? autoFocus;
  final String? label;
  final Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
        autofocus: autoFocus ?? false,
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onSubmitted: onSubmitted,
        inputFormatters: isNumber == null || isNumber == false
            ? null
            : [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll('.', ','),
                  ),
                ),
              ],
        decoration: InputDecoration(
          constraints: const BoxConstraints(maxHeight: 40),
          fillColor: Colors.blueGrey.withOpacity(0.1),
          filled: true,
          label: Center(child: Text(label ?? '')),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
        ));
  }
}
