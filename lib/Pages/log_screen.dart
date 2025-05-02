import 'dart:io';

import 'package:fitgym/Models/dbmodel.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'Logs/ExerciseHistory.dart';

class LogScreen extends StatefulWidget{
  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List<Map<String, dynamic>> exerciseHistory = [];
  List<Map<String, dynamic>> _exerciseList = [];
  List<Map<String, dynamic>> _image = [];
  List<Map<String, dynamic>> _extraImage = [];
  Directory? appDirectory;
  final _LogScreenlisner = Get.put(LogScreenListner());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();

  }
  Future<void> _initializeAppDirectory() async {
    appDirectory = await getApplicationDocumentsDirectory();
  }
  void fetchData() async {
    await _initializeAppDirectory();
    exerciseHistory = await DatabaseHelper.instance.getData("exercise_history");
    Set<int> exerciseIds = exerciseHistory.map((item) => item["id_exercise"] as int).toSet();
    _image = await DatabaseHelper.instance.getData("foto");
    _extraImage = await DatabaseHelper.instance.getData("extra_image");
    List<Map<String, dynamic>> exerciseList = await DatabaseHelper.instance.getData("exercise");

    setState(() {
      exerciseIds.forEach((element) {
        _exerciseList.addAll(exerciseList.where((item) => item["id_exercise"] == element).toList());
      },);
    });
    _LogScreenlisner.status.value = true;
    print("printed exercise ids${_exerciseList.last}");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Obx(() => _LogScreenlisner.status.value ?ListView.builder(
        itemBuilder: (context, index) {
          var image = finding(_exerciseList[index]["id_exercise"], _image) ;
          var extraImage = finding(_exerciseList[index]["id_exercise"], _extraImage) ;

          return ListTile(
            tileColor: Colors.white,
            hoverColor: Colors.grey.shade200,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    image:  DecorationImage(
                      image: _exerciseList[index]["custom"] == 0 ?AssetImage(
                        "assets/images/${image!["name"]}1.png",
                      ) : FileImage(File("${appDirectory!.path}/assets/ExtraImages/${extraImage!["name"]}1.png")),
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

              Get.toNamed("detailedLogs", arguments: {"exerciseDetail": _exerciseList[index],});
            },
          );
        },
        itemCount: _exerciseList.length ,
      ): CircularProgressIndicator(),),
    );
  }
  Map<String, dynamic>? finding(int id, List<Map<String,dynamic>> list){
    for(var element in list){
      if(element["id_exercise"] == id){
        return element;

      }
    }

  }
}

class LogScreenListner extends GetxController{
  RxBool status = false.obs;
}