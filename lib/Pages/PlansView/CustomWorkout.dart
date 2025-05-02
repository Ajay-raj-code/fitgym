import 'dart:io';

import 'package:fitgym/Models/dbmodel.dart';
import 'package:fitgym/Pages/ExerciseView/Exercise.dart';
import 'package:fitgym/Pages/ExerciseView/ExplainExercise.dart';
import 'package:fitgym/Pages/PlansView/SelectExercise.dart';
import 'package:fitgym/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class CustomWorkout extends StatefulWidget {
  const CustomWorkout({super.key});

  @override
  _CustomWorkoutState createState() => _CustomWorkoutState();
}

class _CustomWorkoutState extends State<CustomWorkout> {
  List<Map<String, dynamic>> workoutDays = [];
  Map<String, dynamic> planCategory ={};
  List<Map<String, dynamic>> exercisesPlanList= [];
  List<Map<String, dynamic>> _exercisesList = [];
  List<Map<String, dynamic>> _image = [];
  List<Map<String, dynamic>> _extraImage = [];
  Directory? appDirectory;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var args = Get.arguments;
    planCategory = args["exercise_plans_category"];
    fetchData();

  }
  Future<void> _initializeAppDirectory() async {
    appDirectory = await getApplicationDocumentsDirectory();
  }
  Future<void> fetchData() async {
    await _initializeAppDirectory();
    _exercisesList= await DatabaseHelper.instance.getData("exercise");
    _image = await DatabaseHelper.instance.getData("foto");
    _extraImage = await DatabaseHelper.instance.getData("extra_image");
    exercisesPlanList= await DatabaseHelper.instance.getFilteredExercisesPlanList(exerciseCat: planCategory["id"]);
    setState(() {
      workoutDays = List.generate(planCategory["total_days"], (index) {
        List<Map<String, dynamic>> selectedExercises = exercisesPlanList.where((exercise) => exercise['day'] == index+1).toList();
        return {
          "day": "Day ${index+1}",
          "currentDay": index+1,
          "exercises":selectedExercises,
        };
      },);
    });

    print(workoutDays);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back(result: "refresh");
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 28,
            )),
        backgroundColor: customColor.light_red_shed1,
        title:
        Text(planCategory["name"].toString().toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [IconButton(icon:const Icon(Icons.edit, color: Colors.white,), onPressed: () {})],
      ),
      body: ListView(
        padding:const EdgeInsets.all(10),
        children: workoutDays.map((day) {
          return WorkoutDayTile(day: day, planCategory: planCategory, exercisesList: _exercisesList, exercisesPlanList: exercisesPlanList, extraImage: _extraImage, image: _image, appDirectory: appDirectory!,onBack: () {
            fetchData();
          },);
        }).toList(),
      ),
    );
  }
}

class WorkoutDayTile extends StatelessWidget {
  final Map<String, dynamic> day;
   final Map<String, dynamic> planCategory;
  final List<Map<String, dynamic>> exercisesPlanList;
  final List<Map<String, dynamic>> exercisesList;
  final List<Map<String, dynamic>> image;
  final List<Map<String, dynamic>> extraImage;
  final Directory appDirectory;
  final VoidCallback onBack;
  WorkoutDayTile({super.key, required this.day, required this.planCategory, required this.exercisesPlanList, required this.exercisesList, required this.image, required this.extraImage, required this.appDirectory, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: customColor.light_red_shed1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        textColor: Colors.white,
        title: Center(
          child: Text(
            day["day"],
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Center(
          child: Text(
            "${day['exercises'].length} exercises",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        leading: IconButton(
            onPressed: () {
                Get.bottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    Container(
                  margin: EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _bottomSheetButton("Exercises", onTap: () async {
                        Get.back();

                        final result = await Get.toNamed("selectExercise", arguments: {"day": day, "plan_category": planCategory});
                        if(result.toString() == "refresh"){
                          print("this function is called");
                          onBack();
                        }

                      },),
                      Divider(height: 2, thickness: 2, color: Colors.grey.shade500, ),
                      _bottomSheetButton("Cancel", onTap: () {
                        Get.back();
                      },),
                    ],
                  ),
                ));
            },
            icon: Icon(Icons.add_circle, color: Colors.white)),
        children: day["exercises"].isNotEmpty
            ? day["exercises"].map<Widget>((exercise) {
                var exercise_list =  exercisesList.firstWhere((element) => element["id_exercise"] == exercise["id_exercise"],);
                var _image = exercise_list["custom"] ==0 ? image.firstWhere((element) => element["id_exercise"] == exercise_list["id_exercise"],): extraImage.firstWhere((element) => element["id_exercise"] == exercise_list["id_exercise"],);


                return ListTile(
                  //
                  leading: CircleAvatar(
                    backgroundImage: exercise_list["custom"] == 0 ?AssetImage(
                      "assets/images/${_image["name"]}1.png",
                    ): FileImage(File("${appDirectory.path}/assets/ExtraImages/${_image["name"]}1.png")) ,
                    backgroundColor: Colors.white,
                  ),
                  title: Text(exercise_list["name"]),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    print("ol");
                    Get.toNamed("exercise", arguments:  {"exerciseDetail": exercise_list, "imageDetail": _image,"custom":exercise_list["custom"] == 0? false:true, "directory": appDirectory});
                  },
                );
              }).toList()
            : [
                Padding(
                    padding: EdgeInsets.all(15),
                    child: Text("No exercises added",
                        style: TextStyle(color: Colors.white70)))
              ],
      ),
    );
  }
}

Widget _bottomSheetButton(String text, {VoidCallback? onTap}) {
  return ListTile(
    title: Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    onTap: onTap,
    tileColor: Colors.transparent,
  );
}
