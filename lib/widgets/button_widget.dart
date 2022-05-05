import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color color;
  final String text;
  final void Function()? onPreseed;

  const ButtonWidget({ 
    Key? key,
    required this.color,
    required this.text,
    required this.onPreseed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        primary: color,
        shape: const StadiumBorder(),
      ),
      onPressed: onPreseed, 
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(text),
        ),
      )
    );
  }
}