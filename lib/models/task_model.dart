import 'package:task_app/utils/constants.dart';

class TaskModel {
  String? id;
  String? taskName;
  String? taskDate;
  String? status=NOT_STARTED;
  String? description;
  String? fromDate;
  String? toDate;
  String? time;
  String? userId;

  TaskModel({required this.id,required this.taskName,required this.taskDate,this.status,this.description,this.fromDate,this.toDate,this.time,required this.userId});


  TaskModel.fromJson(Map<String , dynamic> json){
    taskName=json['name']??'';
    taskDate=json['date']??'2020';
    status = json['status']??NOT_STARTED;
    description = json['description']??'';
    fromDate=json['fromDate']??'';
    toDate= json['toDate']??'';
    time=json['time']??'0';
    userId=json['userId']??'0';
    id=json['id'];

  }

  void setId(String i) {
    id = i;}

  Map<String,dynamic> toJson()=>{
    'name':taskName,
    'date':taskDate,
    'status':status,
    'description':description,
    'fromDate':fromDate,
    'toDate':toDate,
    'time':time,
    'userId':userId,
    'id':id,

  };

}


