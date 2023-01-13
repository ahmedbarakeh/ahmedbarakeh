import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/utils/constants.dart';
import 'package:task_app/widgets/custom_text.dart';
import 'package:get/get.dart';

import '../utils/routes.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  Widget menuItem({required String menu,required IconData icon,required VoidCallback onPressed}){
    return  InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon,color: kColorsGrey600,),
            const SizedBox(width: 16,),
            CustomText(text: menu,color: kColorsGrey600,weight: FontWeight.bold,),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: Get.height*0.2,
            color: secondaryColor,
            child:const Center(
              child: CustomText(
                text: 'Task app!',
                fontFamily: 'Fruit',
                color: kColorsRed800,
                size: 30.0,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          menuItem(menu:'Settings'.tr,icon:Icons.settings ,onPressed:  (){
            Get.back();
            Get.toNamed(Routes.settingsRoute);

          }),
          const Divider(),
          menuItem(menu:'Account'.tr,icon:Icons.account_circle ,onPressed:  (){
            Get.back();
            Get.toNamed(Routes.accountRoute);
          }),
          const Divider(),
          menuItem(menu:'About us'.tr,icon:Icons.menu_book_sharp ,onPressed:  (){}),
          const Divider(),
          menuItem(menu:'Log out'.tr,icon:Icons.logout ,onPressed:  ()async{
            await GetStorage().erase();
            Get.offAllNamed(Routes.splashRoute);
          })


    ],
      ),
    );
  }
}
