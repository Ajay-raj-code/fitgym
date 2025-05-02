import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/global_controller.dart';
import '../../utility/color.dart';

class SelectedDaysWorkout extends StatefulWidget {
  const SelectedDaysWorkout({super.key});

  @override
  State<SelectedDaysWorkout> createState() => _SelectedDaysWorkoutState();
}

class _SelectedDaysWorkoutState extends State<SelectedDaysWorkout> {
  final GlobalDataManagementController _controller = Get.put(GlobalDataManagementController());
  Map<String, List<Map<String, dynamic>>> data= {};

  @override
  void initState() {
    super.initState();
    data.addAll(groupByDays(_controller.exercisePlanList));
    print(data);
  }
  Map<String, List<Map<String, dynamic>>> groupByDays(List<Map<String, dynamic>> data) {
    Map<String, List<Map<String, dynamic>>> result = {};

    for (var item in data) {
      final String dayKey = item['day'].toString();

      if (!result.containsKey(dayKey)) {
        result[dayKey] = [];
      }
      result[dayKey]!.add(item);
    }

    return result;
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
        title: Text(
          "",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(

          children: data.entries.map((entry) {
            int day = int.parse(entry.key);
            List<Map<String, dynamic>> exercises = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: customColor.light_red_shed1,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Day $day',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),

                ...exercises.asMap().entries.map((entry) {
                  int index = entry.key;
                  var ex = entry.value;
                  var exercise = _controller.exerciseList.firstWhere((element) => element["id_exercise"] == ex["id_exercise"],);
                  var image = finding(ex["id_exercise"], _controller.image) ;
                  return Padding(

                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      onTap: () {
                        Get.toNamed("exercise", arguments: {"exerciseDetail": exercise, "imageDetail": image, "custom":false});
                      },
                      style: ListTileStyle.list,
                      leading: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade200,  // Border color
                            width: 1.0,         // Border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            "assets/images/${image!["name"]}1.png",
                          ) ,),
                      ),
                      title: Text(exercise["name"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                    ),
                  );
                },),
              ],
            );
          },).toList(),
        ),
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
}
