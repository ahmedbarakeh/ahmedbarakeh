import 'package:flutter/material.dart';
import 'package:task_app/controllers/settings_controller.dart';
import 'package:task_app/models/language_model.dart';
import 'package:task_app/widgets/alert_dialog.dart';
import 'package:task_app/widgets/custom_text.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {

  final SettingsController _settingsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kColorsGrey200,
        body: Container(
          height: Get.height,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.settings,size: 45,),
               const SizedBox(height: 16,),
               CustomText(text: 'Settings'.tr, size: 24.0,weight: FontWeight.bold,),
               SizedBox(height: Get.height*0.075,),
              Row(
                children: [
                   CustomText(text: 'Language'.tr,size: 14.0,)
                ],
              ),
              const SizedBox(height: 2,),
              SizedBox(
                width: Get.width*0.925,
                height: Get.height*0.15,
                child: Card(
                  color:Colors.white ,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LangDropButton(),
                  ],
                ),
                ),
              ),
              const SizedBox(height: 16,),
              Row(
                children: [
                  CustomText(text: 'Reset'.tr,size: 14.0,)
                ],
              ),
              const SizedBox(height: 2,),
              SizedBox(
                width: Get.width*0.95,
                height: Get.height*0.25,
                child: Card(
                  color:Colors.white ,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.refresh,color: Colors.blue,size: 25.0,),
                            const SizedBox(width: 12,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: 'Reset settings to default'.tr,weight: FontWeight.bold,size: 16.0,),
                                CustomText(text: 'this just will reset app settings to default'.tr,maxLines: 2,size: 12.0,color: Colors.grey,),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 24,),
                        InkWell(
                          onTap: ()async{
                            showDialog(context: context, builder: (ctx){
                              return CustomAlertDialog(title: 'Reset'.tr,submit:  'Yes'.tr,message: 'Are you sure to remove all data?'.tr, onSubmit: ()async{
                                Get.back();
                                await _settingsController.resetAll();
                              });
                            });
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.restore,color: Colors.blue,size: 25.0,),
                              const SizedBox(width: 12,),
                              Obx(()=>_settingsController.resetIsLoading.value
                                  ? Row(children: [
                                    const CircularProgressIndicator(color: Colors.blue,),
                                    const SizedBox(width: 24,),
                                    CustomText(text: 'Resetting all values...'.tr)
                              ],)
                                  :Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: 'Reset all values'.tr,weight: FontWeight.bold,),
                                  CustomText(text: 'this option  will wipe all data and settings'.tr,size: 12.0,color: Colors.grey,),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
class LangDropButton extends StatefulWidget {

  @override
  State<LangDropButton> createState() => _LangDropButtonState();
}

class _LangDropButtonState extends State<LangDropButton> {

  final SettingsController _settingsController = Get.find();
  @override
  void initState() {

    currentLang=languageList.firstWhere((lang) => _settingsController.getCurrentLang()!.contains(lang.language!));
    // TODO: implement initState
    super.initState();
  }


  final languageList=[
    LanguageModel(language: 'English', imageUrl: 'assets/images/england_flag.png'),
    LanguageModel(language: 'Arabic', imageUrl: 'assets/images/egypt_flag.png'),

  ];
  var currentLang;

  @override
  Widget build(BuildContext context) {
    //
    return DropdownButton<LanguageModel>(
      elevation: 0,
      value: currentLang,
      items: languageList.map((item) => DropdownMenuItem<LanguageModel>(
        child:
        Container(
         width: Get.width*0.75,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              CustomText(text: item.language,weight: FontWeight.w900,size: 16.0,),
              const Spacer(),
              SizedBox(
                height: 40,
                  width: 40,
                  child: Image.asset(item.imageUrl)),
            ],
          ),
        )
        ,value: item, )).toList(),
      onChanged: (item)async{
       // print(item!.status);
        setState(() {
          currentLang=item!;
        });

        // set lang on controller
        _settingsController.setLang(item!.language!);

      },
    );
  }
}
