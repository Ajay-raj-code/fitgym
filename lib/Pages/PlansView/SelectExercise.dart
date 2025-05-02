import 'dart:io';

import 'package:fitgym/Models/dbmodel.dart';
import 'package:fitgym/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SelectExercise extends StatefulWidget {
  const SelectExercise({super.key});

  @override
  _SelectExerciseState createState() => _SelectExerciseState();
}

class _SelectExerciseState extends State<SelectExercise> {
  TextEditingController searchController = TextEditingController();
  Map<String, List<Map<String, dynamic>>> muscleGroups = {};
  List<Map<String, dynamic>> _image = [];
  List<Map<String, dynamic>> _extraImage = [];
  Map<String, dynamic> _daysInfo = {};
  Map<String, dynamic> _planCategory = {};
  Directory? appDirectory;
  List<Map<String, dynamic>> selectedExercises= [];
  List<int> selectedList = [];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    var args = Get.arguments;
    _daysInfo = args["day"];
    _planCategory  = args["plan_category"];
    selectedExercises = _daysInfo["exercises"];
    selectedList = selectedExercises.where((element) => true,).map((e) => e["id_exercise"] as int,).toList();
    print(selectedList);
    print(args);
    fetchData();
  }
  Future<void> _initializeAppDirectory() async {
    appDirectory = await getApplicationDocumentsDirectory();
  }
  Future<void> fetchData() async {
    await _initializeAppDirectory();
    _image = await DatabaseHelper.instance.getData("foto");
    _extraImage = await DatabaseHelper.instance.getData("extra_image");
    final muscleGroupResults = await DatabaseHelper.instance.getData("exercices_types");
    for (var group in muscleGroupResults) {
      muscleGroups[group['name'].toString()] = [];
    }
    final exerciseResults = await DatabaseHelper.instance.getData("exercise");

    setState(() {
      for (var exercise in exerciseResults) {
        // Find the muscle group name
        final groupId = exercise['id_type'];
        final group = muscleGroupResults.firstWhere((g) => g['id_type'] == groupId, orElse: () => {});

        if (group.isNotEmpty) {
          muscleGroups[group['name']]?.add({
            'id':exercise['id_exercise'],
            'name': exercise['name'],
            'custom':exercise['custom'],
            'selected': selectedList.contains(exercise['id_exercise']),
          });
        }
      }
    });
    // print(muscleGroups);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            )),
        backgroundColor: customColor.light_red_shed1,
        title: Text("EXERCISES", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: Icon(Icons.check, color: Colors.white,), onPressed: () {
          var list = getSelectedExercises();
          List<int> ids = list.map((e) => e['id'] as int).toList();
          List<int> notSelectedList = [];
          for(var element in selectedList){
            if(ids.contains(element) == false){
              notSelectedList.add(element);
            }else{
              ids.remove(element);
            }
          }
          print("not selected list $notSelectedList");
          print("selected list $ids");
          print(_planCategory["id"]);
          for (var element in notSelectedList){
            DatabaseHelper.instance.deletePlansExerciseList(day: _daysInfo["currentDay"], id_exercise: element, id_exercise_cat: _planCategory["id"]);
          }
          print(ids);
          DatabaseHelper.instance.insertPlanList(day: _daysInfo["currentDay"], sets: 4, id_exercises: ids, id_exercise_category: _planCategory["id"]);
          Get.back(result: "refresh");
          print(list);
        })],
      ),
      body: Column(
        children: [

          // Padding(
          //   padding: EdgeInsets.all(10),
          //   child: TextField(
          //     controller: searchController,
          //     decoration: InputDecoration(
          //       prefixIcon: Icon(Icons.search, color: Colors.grey),
          //       hintText: "Search",
          //       filled: true,
          //       fillColor: Colors.white,
          //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          //     ),
          //     onChanged: (query) {
          //       setState(() {}); // Update list on search
          //     },
          //   ),
          // ),
          Expanded(
            child: ListView(
              children: muscleGroups.keys.map((muscle) {
                return Card(
                  color: customColor.light_red_shed1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    textColor: Colors.white,
                    title: Text(muscle, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    children: muscleGroups[muscle]!.isNotEmpty
                        ? muscleGroups[muscle]!.map((exercise) {
                      var image = finding(exercise["id"], _image) ;
                      var extraImage = finding(exercise["id"], _extraImage) ;
                      return ListTile(
                        leading: CircleAvatar(backgroundImage: exercise["custom"] == 0 ?AssetImage(
                          "assets/images/${image!["name"]}1.png",
                        ) : FileImage(File("${appDirectory!.path}/assets/ExtraImages/${extraImage!["name"]}1.png")),),
                        title: Text(exercise["name"]),
                        trailing: Checkbox(
                          value: exercise["selected"],
                          onChanged: (value) {
                            setState(() => exercise["selected"] = value);
                          },
                        ),
                      );
                    }).toList()
                        : [Padding(padding: EdgeInsets.all(15), child: Text("No exercises found", style: TextStyle(color: Colors.white70)))],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  Map<String, dynamic>? finding(int id, List<Map<String,dynamic>> list){
    for(var element in list){
      if(element["id_exercise"] == id){
        return element;

      }
    }

  }
  List<Map<String, dynamic>> getSelectedExercises() {
    List<Map<String, dynamic>> selected = [];

    muscleGroups.forEach((muscle, exercises) {
      for (var exercise in exercises) {
        if (exercise["selected"] == true) {
          selected.add(exercise);
        }
      }
    });

    return selected;
  }
}