import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/controllers/add_task_controller.dart';
import 'package:task_app/controllers/home_controller.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:task_app/widgets/custom_button.dart';
import 'package:task_app/widgets/custom_text.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({Key? key}) : super(key: key);

  final AddTaskController _addTaskController = Get.find();
  final HomeController _homeController = Get.find();
  var taskArgs;

  Future saveTask() async {
    if (_addTaskController.savingTask.value) return;
    try {
      final validate = _addTaskController.addTaskKey.currentState!.validate();
      if (validate){
        await _addTaskController.addTask(editedTask: taskModelObj);

        Get.back();
        _homeController.fetchAndSetTasks();
      }
    } catch (error) {
      const AlertDialog(
        title: Text('Adding failed!',),
        actions: [
          Text('cancel'),
        ],
      );
    }
  }
  var taskModelObj=null;



  @override
  Widget build(BuildContext context) {
    if(Get.arguments !=null) {
      {
        taskArgs= Get.arguments[TASK_DETAIL_ARGS];
        taskModelObj = TaskModel.fromJson(taskArgs);

        int hours = 0;
        int minutes= 0;

        final spltTime= taskModelObj.time!.toString().split('.');
        hours = int.parse(spltTime[0]);
        minutes = int.parse(spltTime[1])*60;

        //_addTaskController.increaseHours();
        _addTaskController.hours(hours.toString());
        _addTaskController.minutes(minutes.toString());


      }
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title:  CustomText(
          text:taskModelObj!=null?'Edit task'.tr: 'Add new task'.tr,
          color: Colors.white,
          fontFamily: 'OldStandard',
        ),
        // centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _addTaskController.addTaskKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 130,
                    width: 165,
                    child: Image.asset(
                      'assets/images/clock2.png',
                      fit: BoxFit.contain,
                    )),
                textFields(),
                const SizedBox(
                  height: 16,
                ), //
                Stack(children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:  [
                          CustomText(
                            text: 'timingPlan'.tr,
                            color: kColorsGrey700,
                            size: 12.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      dateSection(),
                      const SizedBox(
                        height: 12.0,
                      ),
                       Obx(()=>(_addTaskController.toDate.value.isEmpty|| taskModelObj !=null)? Column(
                         children: [
                           Text('OR'.tr),
                           const SizedBox(
                             height: 10,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               timingClockWidget(true),
                               const SizedBox(
                                 width: 12,
                               ),
                               const CustomText(
                                 text: ':',
                                 size: 26.0,
                                 weight: FontWeight.bold,
                                 color: Colors.black,
                               ),
                               const SizedBox(
                                 width: 12,
                               ),
                               timingClockWidget(false),
                             ],
                           ),
                         ],
                       ): SizedBox(height: Get.height*0.15,),
                       )
                    ],
                  ),
                  Obx(() => _addTaskController.showTimingMessage.value
                      ? timingMessage()
                      : const SizedBox()),
                ]),
                const SizedBox(
                  height: 16,
                ),
                saveSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget textFields() {
    if(taskModelObj!=null){
      _addTaskController.taskNameController.text=taskModelObj.taskName!;
      _addTaskController.descriptionController.text=taskModelObj.description!;
    }
    return Column(
      children: [
        TextFormField(
          maxLength: 20,
          controller: _addTaskController.taskNameController,
          decoration:  InputDecoration(
            hintText: 'taskName'.tr,
          ),
          validator: (v) {
            if (v!.isEmpty) return "this field must not be empty".tr;
            return null;
          },
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: _addTaskController.descriptionController,
          maxLines: 2,
          decoration:  InputDecoration(
            hintText: 'Task description'.tr,
          ),
          validator: (v) {
            if (v!.isEmpty) return "this field must not be empty".tr;
            return null;
          },
        )
      ],
    );
  }

  Widget dateSection() {
    if(taskModelObj!=null){
      _addTaskController.toDate(taskModelObj.toDate!);
      _addTaskController.fromDate(taskModelObj.fromDate!);
      //_addTaskController.hours=taskModelObj.tim

    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime(DateTime.now().year),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(2050));
              if (date != null) {
                _addTaskController.fromDate.update((val) {
                  _addTaskController.fromDate.value = DateFormat("yyyy-MM-dd")
                      .format(DateTime.parse(date.toString()));
                });
              }
            },
            icon: const Icon(
              Icons.play_circle,
              color: mainColor,
            ),
            label:  CustomText(
              text: 'from'.tr,
              color: mainColor,
            )),
        Obx(() {
          return CustomText(
            text: _addTaskController.fromDate.value,
            color: kColorsBlueGrey700,
            fontFamily: 'OpenSans',
            size: 15.0,
          );
        }),
        const SizedBox(
          width: 16,
        ),
        TextButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime(DateTime.now().year),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(2050));
              if (date != null) {
                _addTaskController.toDate.update((val) {
                  _addTaskController.toDate.value = DateFormat("yyyy-MM-dd")
                      .format(DateTime.parse(date.toString()));
                });
              }
            },
            icon: const Icon(
              Icons.stop_circle_outlined,
              color: mainColor,
            ),
            label:  CustomText(
              text: 'to'.tr,
              color: mainColor,
            )),
        Obx(() {
          return CustomText(
            text: _addTaskController.toDate.value,
            color: kColorsBlueGrey700,
            fontFamily: 'OpenSans',
          );
        }),
      ],
    );
  }

  Widget timingMessage() {
    var curLang = ENGLISH;
    if(GetStorage().read(CURRENT_LANG)!=null) curLang=GetStorage().read(CURRENT_LANG);
    return Positioned(
        top: 20,
       // because in arabic style is bad!!
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: curLang==ARABIC? const EdgeInsets.only(right: 20.0): const EdgeInsets.only(left: 20.0),
              child: CustomPaint(
                painter: DrawTriangle(),
                size: const Size(25, 25),
              ),
            ),
            Container(
              height: 150,
              width: Get.width * 0.55,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: kColorsOrange,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(offset: Offset(1, 1), color: Colors.grey)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Center(
                    child: CustomText(
                      weight: FontWeight.w600,
                      text: 'You will receive notification when time over !'.tr,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      _addTaskController.showTimingMessage(false);
                    },
                    child:  CustomText(
                      text: 'Close'.tr,
                      color: Colors.white,
                      weight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget timingClockWidget(bool isHour) {


    return Column(
      children: [
        InkWell(
          onTap: () {
            isHour
                ? _addTaskController.increaseHours()
                : _addTaskController.increaseMinutes();
          },
          child: const Icon(
            Icons.keyboard_arrow_up_outlined,
            size: 40,
            color: kColorsBlueGrey700,
          ),
        ),
        CustomText(
          text: isHour ? 'H' : "M",
          color: Colors.black,
          size: 12.0,
        ),
        SizedBox(
          height: Get.width * 0.15,
          width: Get.width * 0.15,
          child: Card(
            color: kColorsBlueGrey100,
            elevation: 5,
            shape: RoundedRectangleBorder(
              //<-- SEE HERE
              side: const BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Obx(
                () => CustomText(
                  text: isHour
                      ? _addTaskController.hours.value
                      : _addTaskController.minutes.value,
                  size: 26.0,
                  weight: FontWeight.bold,
                  color: kColorsBlueGrey700,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          child: const Icon(
            Icons.keyboard_arrow_down,
            size: 40,
            color: kColorsBlueGrey700,
          ),
          onTap: () {
            isHour
                ? _addTaskController.decreaseHours()
                : _addTaskController.decreaseMinutes();
          },
        ),
      ],
    );
  }

  Widget saveSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() => CustomButton(
            onPressed: saveTask,
            child: _addTaskController.savingTask.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ))
                :  CustomText(
                    text: taskModelObj !=null?'Save edition'.tr: 'Save'.tr,
                    color: mainColor,
                    weight: FontWeight.w600,
                    size: 13.0,
                  ),
            backgroundColor: kColorsBlueGrey300,
            width: Get.width * 0.35)),
        SizedBox(
          width: Get.width * 0.07,
        ),
        CustomButton(
          onPressed: () {
            Get.back();
          },
          child:  CustomText(
              text: 'Cancel'.tr,
              size: 13.0,
              weight: FontWeight.w600,
              color: secondaryColor),
          backgroundColor: mainColor,
          width: Get.width * 0.35,
          borderColor: mainColor,
        ),
      ],
    );
  }
} //

class DrawTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, Paint()..color = kColorsOrange);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
