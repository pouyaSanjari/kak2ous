import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key, required this.onPressed, required this.text, this.icon});
  final void Function() onPressed;
  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      onPressed: onPressed,
      fillColor: const Color.fromARGB(255, 93, 90, 90),
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      elevation: 0,
      visualDensity: VisualDensity.comfortable,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon == null
              ? Container()
              : Icon(
                  icon,
                  color: Colors.white,
                ),
          icon == null ? Container() : const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
