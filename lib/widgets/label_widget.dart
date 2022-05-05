import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {

  final String textTitle;
  final String textSubTitle;
  final String route;

  const LabelWidget({ 
    Key? key,
    required this.textTitle,
    required this.textSubTitle,
    required this.route 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          textTitle, 
          style: const TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(height: 10,),
        GestureDetector(
          child: Text(
            textSubTitle,
            style: TextStyle(color: Colors.green[600], fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushReplacementNamed(
              context, 
              route
            );
          },
        )
      ],
    );
  }
}