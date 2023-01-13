import 'package:flutter/material.dart';
import 'package:task_app/utils/constants.dart';
import 'package:task_app/widgets/custom_button.dart';
import 'package:task_app/widgets/custom_text.dart';
import 'package:get/get.dart';

class EmptyContent extends StatelessWidget {

  final String contentTitle;
  final VoidCallback? addFunction;

  EmptyContent({required this.contentTitle,this.addFunction});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/emptylist.png'),
          const SizedBox(height: 16,),
          CustomText(
            text: 'There are no'.tr+' $contentTitle !'.tr,
            color: kColorsBlueGrey700,
            weight: FontWeight.w800,
            size: 18.0,

          ),
          SizedBox(height: Get.height*0.2,),
          CustomButton(child: Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 4,),
              CustomText(
                text: 'Add some'.tr+ '$contentTitle',
                color: Colors.white,
                weight: FontWeight.w700,
                size: 16.0,
              ),
            ],
          ),
              width: Get.width*0.5,borderColor: kColorsBlue700,onPressed: addFunction!,
          backgroundColor: kColorsBlue700,)
        ],
      ),
    );
  }
}
