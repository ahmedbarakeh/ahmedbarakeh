import 'package:flutter/material.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/utils/constants.dart';
import 'package:task_app/widgets/custom_button.dart';
import 'package:task_app/widgets/custom_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/routes.dart';

class TaskDetailsScreen extends StatelessWidget {

   //TaskModel? taskModel;
  final   taskMap=Get.arguments[TASK_DETAIL_ARGS] as Map<String,dynamic>;
  
  String? getRemainingTime(TaskModel taskModel){

    if(taskModel.toDate !=null&&taskModel.toDate!.isNotEmpty){


      final toDat=DateTime.parse(taskModel.toDate!);
      final nowDat=DateTime.now();
     if(toDat.isBefore(nowDat)){
       return 'Time is over';
     }
     else{
       final  difDate=DateTime.parse(taskModel.toDate!).difference(DateTime.now());
       final days=difDate.inDays;
       final minutes=difDate.inMinutes;

       if(days>365) return '${days/365} Years';
       else if(days>=30) return '${days/30} Months';
       else if(days>1) return '$days Days';
       else if(minutes>=60) return '${(minutes/60).round()} Hours';
       else return '$minutes Minutes';
     }

    }
    else if(taskModel.time!.isNotEmpty) return '${taskModel.time} Hours';
    return null;
    
  }

  @override
  Widget build(BuildContext context) {
    final taskModel=TaskModel.fromJson(taskMap);

    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColor,
        body: Container(
          padding:  EdgeInsets.only(top: Get.height*0.01,left: 12,right: 12,bottom: Get.height*0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,)),
                ],
              ),
              SizedBox(height: Get.height*0.07,),
              //name
              CustomText(text:taskModel.taskName,weight: FontWeight.bold,fontFamily: 'Fruit',size: 40.0,color: Colors.white, ),
              const SizedBox(height: 10,),
              const Divider(color: Colors.white),
              SizedBox(height: Get.height*0.15,),
             //description
              taskDetailRow(Icons.description_outlined, taskModel.description!),
              const SizedBox(height: 16,),
              taskDetailRow(Icons.date_range_outlined, taskModel.taskDate!),
              const SizedBox(height: 16,),
              taskDetailRow(Icons.refresh, taskModel.status!),
              const SizedBox(height: 16,),
              taskDetailRow(Icons.refresh, taskModel.status!),
              const SizedBox(height: 16,),

              Row(
                children: [
                  const Icon(Icons.task,color: Colors.white,),
                  const SizedBox(width: 9,),
                  CustomText(text: 'End date :   '.tr,color: Colors.white,),
                  CustomText(text: taskModel.toDate!.isNotEmpty
                      ?taskModel.toDate
                      :taskModel.time!.isNotEmpty?taskModel.time:'You have to set end date!'
                    ,color: Colors.white,maxLines:2,),

                ],
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  const Icon(Icons.lock_clock,color: Colors.white,),
                  const SizedBox(width: 9,),
                  CustomText(text: 'Remaining time :  '.tr,color: Colors.white,),
                  CustomText(text: getRemainingTime(taskModel) !=null?getRemainingTime(taskModel):'You have to set end date!'
                    ,color: Colors.white,),

                ],
              ),
              const Spacer(),
              CustomButton(child:
                  Row(
                    children: [
                      const Icon(Icons.edit,color: mainColor,),
                      const SizedBox(width: 12,),
                      CustomText(text: 'Edit task'.tr,color: mainColor,weight: FontWeight.bold,),
                    ],
                  )
                  , onPressed: (){
                  Get.toNamed(Routes.addTaskRoute,arguments: {TASK_DETAIL_ARGS:taskModel.toJson()},);
                },backgroundColor: secondaryColor,width: Get.width*0.45,),
              SizedBox(height: Get.height*0.05,),

            ],
          ),
        ),
      ),
    );
  }
  Widget taskDetailRow(IconData icon,String text)
  {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         Icon(icon,color: Colors.white),
        const SizedBox(width: 16,),
        SizedBox(width: Get.width*0.7,child: CustomText(text: text,color: Colors.white,textAlign: TextAlign.start,)),
      ],
    );
  }
}

