

import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController ;
  bool isPass;
  final String hintText;
  final TextInputType type;

   TextFieldInput({super.key,
   required this.textEditingController,
    this.isPass=false,
   required this.hintText
   ,required this.type}) ;

  @override
  Widget build(BuildContext context) {
    final inputBorder=OutlineInputBorder(borderSide:Divider.createBorderSide(context));
    return TextFormField(
      controller:textEditingController ,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
         filled: true,
         contentPadding: const EdgeInsets.all(8)
      ),
      keyboardType:type ,
      obscureText: isPass,
    );
  }
}