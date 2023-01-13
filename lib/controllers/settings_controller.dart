import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/controllers/home_controller.dart';
import 'package:task_app/utils/constants.dart';

class SettingsController extends GetxController{

  final HomeController _homeController = Get.find();
  var resetIsLoading=false.obs;

  void setLang(String lang)async{
   await GetStorage().write(CURRENT_LANG, lang);
   await  Get.updateLocale(Locale(lang));

  }
  Future<void> resetAll()async{
    resetIsLoading(true);
    try{
      await _homeController.removeAllTasks();
      await resetSettings();
      resetIsLoading(false);
    }catch(e){}

  }
  Future<void> resetSettings()async{
    setLang('English');
  }
  String? getCurrentLang(){
    final currLang =GetStorage().read(CURRENT_LANG);
    if(currLang==null) {
      return 'English' ;
    } else {
      return currLang;
    }
  }

}