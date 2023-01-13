import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/widgets/custom_button.dart';
import 'package:task_app/widgets/custom_text.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorsGrey200,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(children: const [
                Icon(Icons.arrow_back, color: kColorsBlueGrey700,)
              ],),
              const Icon(
                Icons.account_circle, size: 120, color: kColorsBlueGrey400,),
              CustomText(
                text: 'Account'.tr, size: 24.0, weight: FontWeight.bold,),
              SizedBox(height: Get.height * 0.05,),
              SizedBox(
                height: Get.height * 0.25,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(leading: CustomText(
                        text: 'E-Mail'.tr, weight: FontWeight.bold,),
                        title: CustomText(text: GetStorage().read(EMAIL),),
                        trailing: const Icon(Icons.edit, color: Colors.grey,),
                      ),
                      const SizedBox(height: 16,),
                      ListTile(leading: CustomText(
                        text: 'Password'.tr, weight: FontWeight.bold,),
                        title: const CustomText(text: '*********',),
                        trailing: const Icon(Icons.edit, color: Colors.grey,),
                      ),
                    ],
                  ),
                ),

              ),
              const Spacer(),
              bottomButtons(color: Colors.blue, text: 'Log out'.tr, onPressed: (){}, icon: Icons.logout),
              const SizedBox(height: 8,),
              bottomButtons(color: Colors.red, text: 'Delete account'.tr, onPressed: (){}, icon: Icons.delete),
              SizedBox(height: Get.height * 0.1,),
            ],
          ),

        ),
      ),
    );
  }
  Widget bottomButtons({required Color color,required String text,required VoidCallback onPressed,required IconData icon}){
    return CustomButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CustomText(text: text.tr,
              weight: FontWeight.bold,
              color: Colors.white,),
            const SizedBox(width: 12,),
             Icon(icon),
          ],
        )
        ,
        backgroundColor: color,
        width: Get.width * 0.65,
        onPressed: onPressed);
  }
}
