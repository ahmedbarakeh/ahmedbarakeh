
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final text;
  final size;
  final color;
  final weight;
  final maxLines;
  final textAlign;
  final fontFamily;


  const CustomText(
      {Key? key, required this.text,
      this.textAlign=TextAlign.center,
      this.color = Colors.black,
      this.size = 16.0,
      this.weight = FontWeight.normal,
      this.maxLines = 1,
      this.fontFamily='OpenSans'
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        overflow: TextOverflow.ellipsis,
        textAlign: textAlign,
        style: TextStyle(color: color,fontFamily: fontFamily, wordSpacing: 2,fontSize: size, fontWeight: weight),
        maxLines: maxLines);
  }
}
