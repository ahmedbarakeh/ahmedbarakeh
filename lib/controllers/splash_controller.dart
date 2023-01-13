import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:task_app/utils/constants.dart';
import 'package:dio/dio.dart';

import '../models/http_exception.dart';

class SplashController extends GetxController{

  final dio = Dio(BaseOptions(
    baseUrl:'',
    connectTimeout: 60000,
    receiveTimeout: 60000,
  ));

  Future<void> generateNewToken()async
  {
    final email=GetStorage().read(EMAIL);
    final password=GetStorage().read(PASSWORD);

    try{
      final response = await dio.post('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA_FK0U2O5HQiVkTjXKb7LutAEEa4NjplU',options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'Content-Type': 'application/json',

          }),data: {
        'email':email,
        'password':password,
        'returnSecureToken':true,
      });
      final data=response.data;
      if(data['error'] !=null){
        throw(HttpException(data['error']['message']));
      }

     await GetStorage().write(ID_TOKEN, data['idToken']);

    }catch(e){
      throw (e);
    }

  }

  Future<bool> isTokenExpired()async{
    final expiredDate=DateTime.parse(await GetStorage().read(EXPIRES_DATE));
    if(expiredDate.isBefore(DateTime.now())) return true;
    return false;
  }
}