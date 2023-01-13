import 'dart:ffi';

import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';

class BackgroundedText extends StatelessWidget {

  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? textSize;
  final Offset? shadowOffset;
  final Color? textColor;


   const BackgroundedText({Key? key, required this.text, this.onTap, this.backgroundColor,this.textSize=16.0,this.textColor=Colors.white,this.shadowOffset=const Offset(0,0)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding:const EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: shadowOffset!,
            )
          ],
          color: backgroundColor??Colors.grey[800],
          borderRadius: BorderRadius.circular(10),

        ),
        child: Center(child: CustomText(text: text,size: textSize,color: textColor,weight: FontWeight.w900,)),
      ),
    );
  }
}
