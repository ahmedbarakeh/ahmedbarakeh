import 'package:flutter/material.dart';
import 'package:task_app/utils/constants.dart';
import '../widgets/custom_text.dart';

class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final VoidCallback onPressed;
  final Color? borderColor;
  final double? width;

  const CustomButton(
      {Key? key,
    //  required this.text,
      required this.child,
      required this.onPressed,
      this.backgroundColor,
      //this.textColor = Colors.white,
      //  this.textSize=16.0,
        this.width,
        this.borderColor}

      )
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width??50,
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(backgroundColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: borderColor??backgroundColor!)
                  ),
              )
          ),
          onPressed: onPressed,
          child: child)
    );
  }
}
