import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/bindings/account_binding.dart';
import 'package:task_app/bindings/add_task_binding.dart';
import 'package:task_app/bindings/auth_binding.dart';
import 'package:task_app/bindings/home_binding.dart';
import 'package:task_app/bindings/settings_binding.dart';
import 'package:task_app/bindings/splash_binding.dart';
import 'package:task_app/language/locale.dart';
import 'package:task_app/screens/account_screen.dart';
import 'package:task_app/screens/add_task_screen.dart';
import 'package:task_app/screens/auth_screen.dart';
import 'package:task_app/screens/settings_screen.dart';
import 'package:task_app/screens/splash_screen.dart';
import 'package:task_app/screens/task_detail_screen.dart';
import 'package:task_app/utils/constants.dart';
import 'package:task_app/utils/routes.dart';
import './screens/home_screen.dart';
import 'package:get/get.dart';

void main()async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var lang='en';
    if(GetStorage().read(CURRENT_LANG)!=null){
      lang =  GetStorage().read(CURRENT_LANG)==ARABIC?'ar':'en';
    }
    return GetMaterialApp(
      title: 'Task App',
      locale:Locale( lang),
      translations: TaskLocale(),
      theme: ThemeData(

        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.amber),
      ),
      initialRoute:Routes.splashRoute,
      initialBinding:SplashBinding(),
      getPages: [
        GetPage(name: Routes.authRoute, page:()=> AuthScreen(),binding: AuthBinding()),
        GetPage(name: Routes.homeRoute, page:()=> HomeScreen(),binding: HomeBinding()),
        GetPage(name: Routes.splashRoute, page:()=> SplashScreen(),binding: SplashBinding()),
        GetPage(name: Routes.settingsRoute, page:()=> SettingsScreen(),binding: SettingsBinding()),
        GetPage(name: Routes.accountRoute, page:()=> AccountScreen(),binding: AccountBinding()),
        GetPage(name: Routes.taskDetailRoute, page:()=> TaskDetailsScreen()),
        GetPage(name: Routes.addTaskRoute, page:()=> AddTaskScreen(),binding: AddTaskBinding())

      ],
      debugShowCheckedModeBanner: false,
      //home: HomeScreen(),

    );
  }
}

