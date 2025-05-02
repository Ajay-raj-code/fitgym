

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/global_controller.dart';
import '../../utility/color.dart';

class ExplainExercise extends StatefulWidget{
  const ExplainExercise({super.key});

  @override
  State<ExplainExercise> createState() => _ExplainExerciseState();
}

class _ExplainExerciseState extends State<ExplainExercise> {
  final GlobalDataManagementController _globalDataManagementController= Get.put(GlobalDataManagementController());
  late Map<String, dynamic> _exerciseDetail;
  late Map<String, dynamic> _imageDetail;
  bool custom = false;
  @override
  void initState() {
    super.initState();
    var args = Get.arguments ?? {};
    _exerciseDetail = args["exerciseDetail"];
    _imageDetail = args["imageDetail"];
    custom = args["custom"];

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customColor.light_red_shed1,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon:const Icon(Icons.arrow_back, color: Colors.white, size: 28,)),
        backgroundColor: customColor.light_red_shed1,
        title: Text(
          _exerciseDetail["name"].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        padding:const EdgeInsets.all(10),
        color:customColor.light_red_shed1 ,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,

          child: Column(
            children: [
              Container(

                height: 150,
                padding:const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),

                ), child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for(int i = 1; i<= _imageDetail["number"]; i++)
                      Padding(padding: EdgeInsets.all(8), child: !custom ? Image.asset("assets/images/${_imageDetail["name"].toString()}${i.toString()}.png", height: 140,): Image(height: 140,image: FileImage(File("${_globalDataManagementController.appDirectory!.path}/assets/ExtraImages/${_imageDetail["name"]}${i.toString()}.png"))),),

                  ],
                ),
              ),),
              Text(_exerciseDetail["text"], style: const TextStyle(color: Colors.white, fontSize: 19,),),
            ],
          ),
        ),
      ),
    );
  }
}