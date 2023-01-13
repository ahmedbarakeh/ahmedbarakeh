
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/models/http_exception.dart';
import 'package:task_app/models/task_model.dart';
import 'package:task_app/utils/constants.dart';

import '../data/remote/api.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    print('HomeController: onInit..');
    // TODO: implement onInit
    super.onInit();
    fetchAndSetTasks();

  }
  var currentDayIndex = 0.obs;
  var showTasksAsGrid = false.obs;
  var currentStatus = ''.obs;
  var deletingTask=false.obs;
  final token=GetStorage().read(ID_TOKEN).toString();
  final userId=GetStorage().read(USER_ID).toString();

  // fetch tasks process
  var tasksList = [].obs;
  var tasksIsLoading = true.obs;
  var completionValue=0.0.obs;

  final dio = Dio(BaseOptions(
    baseUrl: API.baseUrl,
    connectTimeout: 60000,
    receiveTimeout: 60000,
  ));
  final headers = {
    'Content-Type': 'application/json',
  };
  int getDayIndexOfDate(TaskModel taskModel){
    final dt = DateTime.parse(taskModel.taskDate.toString());
    return dt.weekday;
  }
  void calcPercentOfCompletionTasks(){
    int completedTaskCount=0;
    if(tasksList.isEmpty){
      completionValue(0.0);
      return;
    }
    for(int i=0;i<tasksList.length;i++){
      if(tasksList[i].status.toString()==COMPLETED){
        completedTaskCount++;
      }
    }
    final dCom=completedTaskCount/tasksList.length;
     completionValue(dCom);
  }
  Future<void> setTaskStatus(String status, String id) async {
    print('setTaskStatus...');

    try {
      await dio.patch(
          '/users/$userId/tasks/$id.json?auth=$token',
          data: {'status': status});

      for(int i =0;i<tasksList.length;i++){
        if(id==tasksList[i].id){
          tasksList[i].status=status;
          break;
        }
        //tasksList(tasksList);
      }
      update();
      calcPercentOfCompletionTasks();
    } catch (e) {
      throw(e);
    }
  }
  Future<void> removeTask(String taskId)async{
    deletingTask(true);
    try{
      final response=await dio.delete('/users/$userId/tasks/$taskId.json?auth=$token',);
      deletingTask(false);

     final  existingIndex = tasksList.indexWhere((element) => element.id==taskId);
     tasksList.removeAt(existingIndex);
     update();
     calcPercentOfCompletionTasks();

    }
    catch(e){
      throw(HttpException('error'));
    }
  }
  Future<void> removeAllTasks()async{
    try{
      final response=await dio.delete('/users/$userId/tasks.json?auth=$token',);
      fetchAndSetTasks();
    }
    catch(e){
      throw(HttpException('error'));
    }
  }
  Future<void> fetchAndSetTasks() async {
    print('fetchAndSetTasks...');
    tasksIsLoading(true);
    final  tasksUrl = '/users/${GetStorage().read(USER_ID).toString()}/tasks.json?auth=${ GetStorage().read(ID_TOKEN).toString()}';
    
    try {
      final response = await dio.get(
        tasksUrl,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      if (response.statusCode! >= 400)
        throw (HttpException('Bad data, could not fetch tasks!'));
      final tasks = [];
      if(response.data!=null){
        response.data.forEach((id, data) {
          final t = TaskModel.fromJson(data);
          t.setId(id);
          tasks.add(t);
        });
      }

      tasksIsLoading(false);
      tasksList(tasks);
      calcPercentOfCompletionTasks();
    } catch (e) {
      throw (e);
    }
  }

  final old=[];
  List<TaskModel> filterTask(String weekDay){
    print(userId);
    print(GetStorage().read(EMAIL));
    final List<TaskModel>newTasks=[];

   for(int i = 0 ; i<tasksList.length;i++){
     final taskDay = weekDays[getDayIndexOfDate(tasksList[i])];
     if(taskDay.contains(weekDay)){
       newTasks.add(tasksList[i]);
     }
   }
  return newTasks;

  }

}
