import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController controller;

  //super.key


  const TextFieldWidget({super.key, 
    required this.labelText,
    required this.prefixIcon,
    required this.obscureText,
    required this.controller,

  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon,),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
      obscureText: obscureText,
      controller: controller,
    );
  }
}
