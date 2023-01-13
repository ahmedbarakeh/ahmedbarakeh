import 'package:get/get.dart';
import 'package:task_app/controllers/add_task_controller.dart';
import 'package:task_app/controllers/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}