import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  TextFieldInput(
      {super.key,
      this.textEditingController,
      this.hintText,
      this.isPassword = false,
      this.textInputType = TextInputType.text,
      this.inputBorder,
      this.focusedBorderColor = Colors.grey});
  final TextEditingController? textEditingController;
  final String? hintText;
  final bool? isPassword;
  final TextInputType? textInputType;
  Color focusedBorderColor;
  InputBorder? inputBorder;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.0),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        hintText: hintText,
      ),
      keyboardType: textInputType,
      obscureText: isPassword ?? false,
    );
  }
}
