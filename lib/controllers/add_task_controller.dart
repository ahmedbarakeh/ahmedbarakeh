import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/models/http_exception.dart';
import 'package:task_app/utils/constants.dart';
import '../models/task_model.dart';
import '../data/remote/api.dart';
import 'package:intl/intl.dart';

class AddTaskController extends GetxController {
  late var addTaskKey;


  //add task process
  var savingTask=false.obs;
  final dio = Dio(BaseOptions(
    baseUrl:API.baseUrl,
    connectTimeout: 60000,
    receiveTimeout: 60000,
  ));
 late TextEditingController taskNameController;
 late TextEditingController descriptionController;

  var fromDate = "".obs;
  var toDate = "".obs;
  var showTimingMessage = false.obs;

  final addKey = GlobalKey<FormState>();

  var hours = '00'.obs;
  var minutes = '00'.obs;

  void increaseHours() {
    //116360
    int hInt = int.parse(hours.value);
    // if (hInt == 12) hInt = 0;
    hInt++;
    hours(hInt < 10 ? '0${hInt.toString()}' : hInt.toString());
    print(hours);
  }
  void decreaseHours() {
    int hInt = int.parse(hours.value);
   if(hInt>0) hInt--;

    hours(hInt < 10 ? '0${hInt.toString()}' : hInt.toString());
  }
  void increaseMinutes() {
    int mInt = int.parse(minutes.value);
    mInt++;
    minutes(mInt < 10 ? '0${mInt.toString()}' : mInt.toString());
  }
  void decreaseMinutes() {
    int mInt = int.parse(minutes.value);
    if(mInt>0) mInt--;
    minutes(mInt < 10 ? '0${mInt.toString()}' : mInt.toString());
  }

  Future<void> addTask({TaskModel? editedTask}) async {
    debugPrint('add new task...');
    savingTask(true);
    final  tasksUrl =editedTask!=null
        ? '/users/${GetStorage().read(USER_ID).toString()}/tasks/${editedTask.id}.json?auth=${ GetStorage().read(ID_TOKEN).toString()}'
        : '/users/${GetStorage().read(USER_ID).toString()}/tasks.json?auth=${ GetStorage().read(ID_TOKEN).toString()}';


    final hDouble=double.parse(hours.value);
    final mDouble=double.parse(minutes.value)/60;
    final strTime= (hDouble+mDouble).toString();

    final task = TaskModel(id:'',taskName: taskNameController.text,userId: GetStorage().read(USER_ID),
        taskDate:  DateFormat("yyyy-MM-dd").format(
            DateTime.parse(DateTime.now().toString()) ),
        status: NOT_STARTED,
      description: descriptionController.text,
      fromDate: fromDate.value,
      toDate: toDate.value,
      time: strTime,
    );

    try {
      var headers = {
        'Content-Type': 'application/json',
        //'Authorization': GetStorage().read(tokenKey).toString(),
      };

      final userId= GetStorage().read(USER_ID);
     // print('user id = ' + userId);
      if(userId==null) {
        print('user id is null');
        return;
      }
        var response = editedTask!=null
            ?await dio.patch(tasksUrl,
            options: Options(
              headers: headers,
            ),
            data: task.toJson())
            : await dio.post(tasksUrl,
            options: Options(
              headers: headers,
            ),
            data: task.toJson());

        if(response.statusCode! >=400){
          debugPrint('>=400 error');
          throw (HttpException('Could not add task!'));
        }
        savingTask(false);

    } catch (e) {
      print(e.toString());
      throw HttpException(e.toString());
    }

    //final response=await http.post(Uri.https('', 'tasks.json/create'),body: task.toJson());
    //print(response.body);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit(); //
    addTaskKey = GlobalKey<FormState>();
    Future.delayed(
      const Duration(milliseconds: 1500),
      () => showTimingMessage(true),
    );
    taskNameController = TextEditingController();
    descriptionController= TextEditingController();
  }

}
