import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.backgroundColor,
      required this.text,
      required this.textColor,
      required this.borderColor,
      this.onPressed});
  final Function()? onPressed;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final Color borderColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        alignment: Alignment.center,
        width: 250,
        height: 27,
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
