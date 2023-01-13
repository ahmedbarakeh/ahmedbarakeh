import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsBinding implements Bindings {
  @override
  void dependencies() {
    var x = 1;
    Get.lazyPut(() => SettingsController());
  }
}