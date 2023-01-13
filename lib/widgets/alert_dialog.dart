import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_app/widgets/custom_text.dart';

class CustomAlertDialog extends StatelessWidget {

  final  String title;
  final String message;
  final VoidCallback onSubmit;
  Widget? content;
  String? submit='Okay'.tr;


  CustomAlertDialog({Key? key,this.submit,  required this.title,required this.message,required this.onSubmit,this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      height: Get.height*0.35,
      width: Get.width*0.75,

      child: AlertDialog(
        contentPadding:  EdgeInsets.all(Get.height*0.03),
        actionsPadding: const EdgeInsets.all(16),
        title: Text(title),content:content ?? Text(message ,),
      actions: [
        GestureDetector(
            onTap: onSubmit,
            child: CustomText(text: submit??'' ,weight: FontWeight.bold,color: Colors.black,size: 16.0,),
        ),
         SizedBox(width: Get.width*0.02,),
        GestureDetector(
          child: CustomText(text: 'Close'.tr,weight: FontWeight.bold,color: Colors.black,size: 16.0,),
          onTap: (){
            Get.back();
          },
        )
      ],
      ),
    );
  }
}
