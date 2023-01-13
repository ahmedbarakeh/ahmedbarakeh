import 'package:flutter/material.dart';
import 'package:task_app/controllers/home_controller.dart';
import 'package:task_app/models/http_exception.dart';
import 'package:task_app/models/status_model.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:task_app/widgets/alert_dialog.dart';
import 'package:task_app/widgets/custom_text.dart';

import '../utils/routes.dart';

class TaskItem extends StatelessWidget {
  final TaskModel taskModel;
  final bool isGridView;
  final HomeController _homeController = Get.find();

  TaskItem({required this.taskModel, required this.isGridView});
  
  Widget remainingTaskTimeWidget(){
    return CustomText(text: '30 minutes left to run out');
  }


  @override
  Widget build(BuildContext context) {
    print(taskModel.id!);
    return InkWell(
        onTap: (){
          Get.toNamed(Routes.taskDetailRoute,arguments: {TASK_DETAIL_ARGS:taskModel.toJson()},);
        }
        ,
        onLongPress: (){
      showDialog(context: Get.context!, builder: (ctx){
        return Obx(()=>CustomAlertDialog(title: 'Remove task?'.tr,submit:_homeController.deletingTask.value?'Deleting ..'.tr: 'Yes'.tr, message: 'Are you sure to delete this task ?'.tr, onSubmit: ()async{
          try{
            await _homeController.removeTask(taskModel.id!);
            Navigator.of(ctx).pop();
          }on HttpException catch(e){
            Navigator.of(ctx).pop();
            showDialog(context: Get.context!, builder: (ctx){
              return CustomAlertDialog(title: 'Deleting failed!'.tr, message: 'Couldn\'t delete task'.tr , onSubmit: (){
                Navigator.of(ctx).pop();
              });
            });
          }
          catch(e){
            showDialog(context: Get.context!, builder: (ctx){
              return CustomAlertDialog(title: 'Deleting failed!'.tr, message: 'Couldn\'t delete task'.tr , onSubmit: (){
                Navigator.of(ctx).pop();
              });
            });
          }
        }));
      });
    },
    child:isGridView?gridTaskItem():taskListItem());
  }

  Widget taskListItem() {
    return  Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),

        ),
        child: Column(
          children: [
            ListTile(
              title: CustomText(text: taskModel.taskName!,color: kColorsBlueGrey800,weight: FontWeight.bold,textAlign: TextAlign.start,),
              subtitle:Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width:Get.width*0.38,
                            child: CustomText(text: taskModel.description!,size: 11.0,textAlign: TextAlign.start,color: Colors.grey,)),
                        const SizedBox(height: 6,),

                        Text( taskModel.taskDate!),
                      ],
                    ),
                  ],
                ),
              ),
              trailing: StatusDropButton(taskModel),
              leading: CircleAvatar(
                backgroundColor: mainColor,
                child: Text(weekDays[_homeController.getDayIndexOfDate(taskModel)].substring(0,3),style: const TextStyle(fontSize: 12.0),overflow: TextOverflow.ellipsis,),
              ),
            ),
            const SizedBox(height: 4,),
            const Divider()

          ],
        ),
      );
  }

  Widget gridTaskItem() {
    return Container(
      child: Stack(children: [
        Container(
          height: Get.height * 0.35,
          width: Get.width * 0.5,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 0.4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                text: taskModel.taskName,
                weight: FontWeight.bold,
                color: mainColor,
              ),
              const SizedBox(
                height: 8,
              ),
              const CustomText(
                text: 'THR',
                weight: FontWeight.w700,
                color: Colors.black,
              ),
              const SizedBox(
                height: 6,
              ),
              StatusDropButton(taskModel),

            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              width: Get.width * 0.2,
              height: 20,
              child: Center(
                child: CustomText(
                  text: taskModel.taskDate,
                  size: 12.0,
                  color: Colors.white,
                ),
              ),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(25, 25, 25, 1),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8)))),
        ),
      ]),
    );
  }
}
class StatusDropButton extends StatefulWidget {
  final TaskModel taskModel;

  StatusDropButton(this.taskModel);
  @override
  State<StatusDropButton> createState() => _StatusDropButtonState();
}

class _StatusDropButtonState extends State<StatusDropButton> {

  @override
  void initState() {
    currentStatus=widget.taskModel.status!;
    // TODO: implement initState
    super.initState();
  }
  var currentStatus='';
  final HomeController _homeController = Get.find();



  final List<StatusModel>statusList =[
    StatusModel(status: NOT_STARTED, icon: Icons.not_started),
    StatusModel(status: PROCESSING, icon: Icons.refresh,color: Colors.blue),
    StatusModel(status: CANCELLED, icon: Icons.block_outlined,color: Colors.red),
    StatusModel(status: COMPLETED, icon: Icons.done,color: Colors.green),];


  StatusModel? getStatusFromTask(String name){
    var s=statusList[0];
     for(int i=0;i<statusList.length;i++){
       if(statusList[i].status==name){
         s=statusList[i];
         break;
       }
     }
    return s;
  }


  @override
  Widget build(BuildContext context) {
    //
    return DropdownButton<StatusModel>(
      alignment: Alignment.center,
      elevation: 0,
      value: getStatusFromTask(currentStatus),
      items: statusList.map((item) => DropdownMenuItem<StatusModel>(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Icon(item.icon,size: 18.0,color: item.color,),
              const SizedBox(width: 4,),
              CustomText(text: item.status,weight: FontWeight.w900,size: 11.0,),
            ],
          ),
        ),value: item, )).toList(),
      onChanged: (item)async{
        final status= currentStatus;
        print(item!.status);
        setState(() {
          currentStatus=item.status!;
        });

          try{
            await _homeController.setTaskStatus(currentStatus, widget.taskModel.id!);
          }
          catch(e){
            showDialog(context: context, builder: (ctx)=>
            CustomAlertDialog(title: 'Failed'.tr, message: 'The process failed!'.tr, onSubmit: (){
              Navigator.of(ctx).pop();
            })
            );
           setState(() {
             currentStatus = status;
           });
          }


      },
    );
  }
}


