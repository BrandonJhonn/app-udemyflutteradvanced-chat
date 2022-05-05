import 'package:flutter/material.dart';

class CustomInputWidget extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController ctrTextInput;
  final TextInputType keyBoardType;
  final bool isPassword;
  
  const CustomInputWidget({ 
    Key? key,
    required this.icon,
    required this.placeholder,
    required this.ctrTextInput,
    this.keyBoardType = TextInputType.emailAddress,
    this.isPassword = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20,),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5
          )
        ]
      ),
      child: TextField(
        controller: ctrTextInput,
        autocorrect: false,
        keyboardType: keyBoardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: placeholder
        ),
      ),
    );
  }
}