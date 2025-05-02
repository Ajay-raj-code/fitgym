import 'dart:io';

import 'package:fitgym/Pages/ExerciseCreation/AddCustomExercise.dart';
import 'package:fitgym/Pages/ExerciseView/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../Controller/global_controller.dart';
import '../../utility/color.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  final GlobalDataManagementController _globalDataManagementController= Get.put(GlobalDataManagementController());

  final  CustomListner _customListner = Get.put(CustomListner());
  List<Map<String, dynamic>> _exerciseList = [];
  List<Map<String, dynamic>> _customExercise = [];
  int index = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var args = Get.arguments ?? {};

    index = args["index"];


    print(_customExercise);
  }
 Map<String, dynamic>? finding(int id, List<Map<String,dynamic>> list){
    for(var element in list){
      if(element["id_exercise"] == id){
        return element;

      }
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon:const Icon(Icons.arrow_back, color: Colors.white, size: 28,)),
        backgroundColor: customColor.light_red_shed1,
        title: Text(
          _globalDataManagementController.exerciseCategory[index]["name"].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [

          Obx(() => ElevatedButton(onPressed: () {
            _customListner.changeStatus();

          }, child: Text(_customListner.status.value? "Custom" : "Exercise"),)),
          const SizedBox(width: 10,),
        ],
      ),
      body: Container(
        child: Obx(() {
          _exerciseList = _globalDataManagementController.exerciseList.where((element) => element["custom"] ==0 && element["id_type"] == index+1 ,).toList();
          _customExercise =  _globalDataManagementController.exerciseList.where((element) => element["custom"] ==1 && element["id_type"] == index+1 ,).toList();
          return _customListner.status.value ? ListView.builder(
            itemBuilder: (context, index) {
              var image = finding(_exerciseList[index]["id_exercise"], _globalDataManagementController.image);
              return ListTile(
                tileColor: Colors.white,
                hoverColor: Colors.grey.shade200,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/${image!["name"]}1.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade100,
                          width: 1.0,
                        ),),
                      width: 100, // Set desired width
                      height: 100, // Set desired height

                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _exerciseList[index]["name"].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
                onTap: () {


                  Map<String, dynamic> exercise_detail =  _exerciseList[index];

                  Get.toNamed("exercise", arguments: {"exerciseDetail": exercise_detail, "imageDetail":image, "custom":false, });
                },
              );
            },
            itemCount: _exerciseList.length - 1,
          ):  ListView.builder(
            itemBuilder: (context, index) {
              var image = finding(_customExercise[index]["id_exercise"], _globalDataManagementController.extraImage);
              print(image);
              print(_customExercise);
              return ListTile(
                tileColor: Colors.white,
                hoverColor: Colors.grey.shade200,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File("${_globalDataManagementController.appDirectory!.path}/assets/ExtraImages/${image!["name"]}1.png")),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade100,
                          width: 1.0,
                        ),),
                      width: 100, // Set desired width
                      height: 100, // Set desired height

                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        _customExercise[index]["name"].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
                onTap: () {


                  Map<String, dynamic> exercise_detail =  _customExercise[index];

                  Get.toNamed("exercise", arguments: {"exerciseDetail": exercise_detail, "imageDetail": image, "custom":true});
                },
              );
            },
            itemCount: _customExercise.length ,
          );
        },),
      ),
      floatingActionButton: Obx(() => Visibility(
        visible:!_customListner.status.value,
        child: SizedBox(width: 130,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              FloatingActionButton(onPressed: () {

              }, child: Icon(Icons.edit_calendar_outlined, color: Colors.white, size: 30,), backgroundColor:customColor.light_red_shed1 , heroTag: "tag1",),

              FloatingActionButton(onPressed: () {
                Get.toNamed("createCustomExercise", arguments: { "index" : _exerciseList[0]["id_type"]});
              }, child:const Icon(Icons.add_circle_outline_outlined, color: Colors.white, size: 30,), backgroundColor: customColor.light_red_shed1, heroTag: "tag2",),
            ],),
        ),
      ),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


}

class CustomListner extends GetxController{
  RxBool status = true.obs;
  void changeStatus(){
    status.value = !status.value;
  }

}