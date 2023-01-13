import 'package:get/get.dart';
import 'package:task_app/controllers/account_controller.dart';
import 'package:task_app/controllers/add_task_controller.dart';

class AccountBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountController());
  }
}