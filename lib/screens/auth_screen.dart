import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:task_app/models/http_exception.dart';
import 'package:task_app/utils/constants.dart';
import 'package:task_app/widgets/alert_dialog.dart';
import 'package:task_app/widgets/custom_button.dart';
import 'package:task_app/widgets/custom_text.dart';

import '../controllers/auth_controller.dart';
import '../utils/routes.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.white.withOpacity(0.2),
                 Colors.yellow.withOpacity(1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: Get.height,
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: mainColor,
                        boxShadow:const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child:const CustomText(
                        text: 'MyTask',
                        color: secondaryColor,
                        size: 40.0,
                        weight: FontWeight.bold,
                       // fontFamily: 'Fruit',
                      )
                    ),
                  ),
                  Flexible(
                    flex: Get.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  
  const AuthCard({
    Key? key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthController _authController= Get.find();


  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _submit()async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthMode.Login) {
      // Log user in
     await authUser(true);

    } else {
      // Sign up user
    await authUser(false);
     // print(_authData['email']! + "  " + _authData['password']!);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future authUser(bool signIn)async{
    try{
     signIn? await _authController.signin( _authData['email']!,  _authData['password']!)
            :await  _authController.signup( _authData['email']!,  _authData['password']!);
     if(_authController.isAuth()) {
       Get.offAllNamed(Routes.homeRoute);
     } else {
       showDialog(context: context, builder: (ctx){
       return CustomAlertDialog(title: 'Authentication failed!'.tr, message: 'Something wont wrong!'.tr, onSubmit: (){
         Navigator.of(context).pop();
       });
     });
     }
    } on HttpException catch(error){
      var errorMessage = 'Authentication failed!'.tr;
      if(error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find this E-mail!'.tr;
      } else if(error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'The password is not correct'.tr;
      }
      else if(error.toString().contains('USER_DISABLED')) {
        errorMessage = 'You are not authenticate'.tr;
      }
      else if(error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This E-mail is already registered'.tr;
      }
      else if(error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This E-mail is invalid'.tr;
      }

      showDialog(context: context, builder: (ctx){
        return CustomAlertDialog(title: 'Authentication failed!'.tr, message: errorMessage, onSubmit: (){
         Navigator.of(context).pop();
        });
      });
    }catch(error){
      showDialog(context: context, builder: (ctx){
        return CustomAlertDialog(title: 'Authentication failed!', message: 'Something wont wrong!'.tr, onSubmit: (){
        });
      });
    }

  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
   // final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: Get.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration:  InputDecoration(labelText: 'E-Mail'.tr),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!'.tr;
                    }
                    return null;
                    },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!'.tr;
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration:  InputDecoration(labelText: 'Confirm Password'.tr),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!'.tr;
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                  CustomButton(
                      child:_isLoading?const Center(child: SizedBox(height:22,width:22,child: CircularProgressIndicator(color: Colors.white,)),):  Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                      onPressed:_isLoading?(){}: _submit,
                      borderColor: mainColor,backgroundColor: mainColor,
                      width: Get.width*0.3,
                  ),
                FlatButton(
                  child: CustomText(text: '${_authMode == AuthMode.Login ? 'SIGNUP'.tr : 'LOGIN'.tr} INSTEAD'.tr,color: mainColor,),
                  onPressed: _switchAuthMode,
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
