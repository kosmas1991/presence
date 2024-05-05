import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  const MyFormField(
      {super.key, required this.hintText, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 2))),
    );
  }
}
