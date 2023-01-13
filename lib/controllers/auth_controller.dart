import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_app/models/http_exception.dart';
import 'package:task_app/utils/constants.dart';

import '../data/remote/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController{

  // signup
  var isLoading=true.obs;
  String? token;
  DateTime? expireDate;
  String? userId;

  final dio = Dio(BaseOptions(
    baseUrl:'',
    connectTimeout: 60000,
    receiveTimeout: 60000,
  ));

  bool isAuth(){
    return getToken()!=null;
  }
  Future<String?> getToken()async{
    if(expireDate!=null&&token!=null&&expireDate!.isAfter(DateTime.now())){
      GetStorage().write(ID_TOKEN, token);
      GetStorage().write(USER_ID, userId);
      return token;
    }
    return null;
  }

  Future <void>signup(String email,String password)async{
    isLoading(true);
    try{
       final response = await dio.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA_FK0U2O5HQiVkTjXKb7LutAEEa4NjplU',options: Options(headers: {
         'Content-Type': 'application/json',
       },
         followRedirects: false,
         validateStatus: (status) {
           return status! < 500;
         },
       ),data: {
         'email':email,
         'password':password,
         'returnSecureToken':true,
       });
       isLoading(false);
       final data=response.data;
       if(data['error']!=null){
         throw(HttpException(data['error']['message']));
       }
       token = data['idToken'];
       userId=data['localId'];
       expireDate=DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'].toString())));
    }catch(e){
      throw(e);
    }
    finally{
      isLoading(false);
    }
  }

  Future <void>signin(String email,String password)async{
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
      token = data['idToken'];
      userId=data['localId'];
      expireDate=DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'].toString())));

     await  GetStorage().write(EMAIL, email);
     await GetStorage().write(PASSWORD, password);
     await GetStorage().write(EXPIRES_DATE, expireDate.toString());
      //print('Refresh token =  ' + data['refreshToken']);

    }catch(e){
     throw (e);
    }
    finally{
      isLoading(false);
    }
  }




}