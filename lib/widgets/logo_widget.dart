import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {

  final String uriAsset;
  final String title;

  const LogoWidget({ 
    Key? key,
    required this.uriAsset,
    required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Image(image: AssetImage(uriAsset), width: 80, height: 80,),
          const SizedBox(height: 20,),
          Text(title, style: const TextStyle(fontSize: 25))
        ],
      ),
    );
  }
}