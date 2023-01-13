import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/controllers/splash_controller.dart';
import 'package:task_app/utils/constants.dart';
import 'package:task_app/widgets/custom_text.dart';

import '../utils/routes.dart';

class SplashScreen extends StatelessWidget {
   SplashScreen({Key? key}) : super(key: key);

  final SplashController _splashController =Get.find();

  @override
  Widget build(BuildContext context) {
    print(GetStorage().read(ID_TOKEN));
    final h = Get.height;
    Future.delayed(
      const Duration(seconds: 3),
          () async{
        final userId = await GetStorage().read(USER_ID);

        if(userId==null){
          Get.offAllNamed(Routes.authRoute);
        }
        else{
          final isExpiredToken=await _splashController.isTokenExpired();
          if(isExpiredToken) await _splashController.generateNewToken();
          Get.offAllNamed(Routes.homeRoute);
        }
          },
    );
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration:const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/mytasksplash.jpg')
          )
        ),
        child: Padding(
          padding:  EdgeInsets.only(top: h*0.175),
          child:  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(strokeWidth: 5,color: mainColor),
                const SizedBox(height: 12,),
                CustomText(text: 'LOADING...'.tr,color: Colors.red ,size: 14.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
