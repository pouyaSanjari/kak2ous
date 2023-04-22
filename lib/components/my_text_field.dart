import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    this.isNumber,
  });
  final TextEditingController controller;
  final bool? isNumber;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
        decoration: const InputDecoration(
            constraints: BoxConstraints(maxHeight: 30),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 5)));
  }
}
