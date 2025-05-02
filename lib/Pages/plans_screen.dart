import 'package:fitgym/Models/dbmodel.dart';
import 'package:fitgym/Pages/PlansView/SelectDaysScreen.dart';
import 'package:fitgym/utility/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'PlansView/CustomWorkout.dart';

class PlansScreen extends StatefulWidget {
  @override
  State<PlansScreen> createState() => _PlansScreenState();
}
class PlanLoadingListner extends GetxController{
  RxBool _loading = false.obs;
  void onChange(){
    _loading.value = true;
  }
}
class _PlansScreenState extends State<PlansScreen> {
  final PlanLoadingListner _planLoadingListner = Get.put(PlanLoadingListner());
  final PlansCustomListner _customListner = Get.put(PlansCustomListner());
  late List<Map<String, dynamic>> _exercise_plans_cat = [];
  late List<Map<String, dynamic>> _exercise_plans = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _planLoadingListner._loading.value = false;
    fetchData();

  }
  Future<void> fetchData() async{
    print("database ${await DatabaseHelper.instance.getData("exercise_plans_category")}");
    _exercise_plans_cat.addAll(await DatabaseHelper.instance.getData("exercise_plans_category"));
    _exercise_plans.addAll(await DatabaseHelper.instance.getData("exercise_plan_list"));
    _planLoadingListner.onChange();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() => _planLoadingListner._loading.value? Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          PhysicalModel(
            borderRadius: BorderRadius.circular(25),
            elevation: 10,
            color: Colors.white,
            child: Obx(
                  () => Stack(
                children: [
                  AnimatedAlign(
                    alignment: _customListner.status.value
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    child: Container(
                      alignment: Alignment.center,
                      width: Get.width / 2 - 11,
                      height: Get.width / 10,
                      decoration: BoxDecoration(
                        color: customColor.light_red_shed1,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width / 2 - 11,
                          height: Get.width / 10,
                          child: Text(
                            "Workouts",
                            style: TextStyle(
                              color: _customListner.status.value
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: _customListner.status.value
                            ? () {
                          _customListner.changeStatus();
                        }
                            : null,
                      ),
                      InkWell(
                        child: Container(
                          alignment: Alignment.center,
                          width: Get.width / 2 - 11,
                          height: Get.width / 10,
                          child: Text(
                            "Custom",
                            style: TextStyle(
                              color: _customListner.status.value
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: _customListner.status.value
                            ? null
                            : () {
                          _customListner.changeStatus();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Obx(
                    () =>
                _customListner.status.value ? Plans_Custom() : Plans_Workout(exercise_plans_cat: _exercise_plans_cat, exercise_plans: _exercise_plans),
              )),
        ],
      ),
    ): Center(child: CircularProgressIndicator(),),);
  }
}

Widget Plans_Workout({required List<Map<String, dynamic>> exercise_plans_cat, required List<Map<String, dynamic>> exercise_plans}){
  return Column(
    spacing: 10,
    children: [
      SizedBox(
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.to(SelectDaysScreen(), arguments: {"exercise_plans_cat": exercise_plans_cat[0], "exercise_plans":exercise_plans});
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PhysicalModel(
                    clipBehavior: Clip.hardEdge,
                    color: Colors.transparent,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                    child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/others/power_workout.png",
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  Text(
                    exercise_plans_cat[0]["name"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ],
  );
}

class Plans_Custom extends StatefulWidget {
  const Plans_Custom({super.key});
  @override
  State<Plans_Custom> createState() => _Plans_CustomState();
}

class _Plans_CustomState extends State<Plans_Custom> {
  final TextEditingController _controller = TextEditingController();
  final editPlansListner _editPlanListner = Get.put(editPlansListner());
  int selectedNumber = 3;
  List<Map<String, dynamic>> plans_category = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    var data = await DatabaseHelper.instance.getData("exercise_plans_category");
    setState(() {
      plans_category = data.where((element) => element["custom"] == 1,).toList();
    });


  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: customColor.light_red_shed1,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _editPlanListner.edit.value = !_editPlanListner.edit.value;
                    },
                    icon: Obx(() => _editPlanListner.edit.value ?const Icon(
                      Icons.edit_note,
                      color: Colors.white,
                      size: 30,
                    ):const Icon(
                      Icons.save_as,
                      color: Colors.white,
                      size: 30,
                    ),),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {

                      Get.dialog(
                          barrierDismissible: false,
                          customDialog( onTap: () async {
                            String name = _controller.text.isEmpty ? "My Workout" : _controller.text;
                            int numberOfDays = selectedNumber;
                            DatabaseHelper.instance.insertPlanCategory(name: name, custom: 1, totalDays: numberOfDays);
                            var list =  await DatabaseHelper.instance.getLastRowOfPlansCategory();
                            Get.back();
                            final result = await Get.to(CustomWorkout(), arguments: {"exercise_plans_category": list.first});
                            if(result.toString() == "refresh"){

                              fetchData();
                            }
                          },controller: _controller,selectedNumber: selectedNumber, onChanged: (value) {
                            selectedNumber= value! ;

                      },));
                    },
                    icon: Icon(
                      Icons.add_circle_outline_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            // spacing between buttons
          ],
        ),

        Expanded(
          child: ListView.builder(itemBuilder: (context, index) {
            return ListTile(
              leading: Obx(() => Visibility(
                visible: _editPlanListner.edit.value,
                maintainAnimation: false,
                maintainSize: false,
                maintainState: false,
                child: IconButton(onPressed: ()async {

                  await DatabaseHelper.instance.deletePlansCategory(id: plans_category[index]["id"]);
                  await DatabaseHelper.instance.deletePlansExercise(id: plans_category[index]["id"]);
                  fetchData();
                }, icon: Icon(Icons.delete, color: customColor.light_red_shed1,)),
              )),
              onTap: () {
                Get.to(CustomWorkout(), arguments: {"exercise_plans_category": plans_category[index]});
              },
              title: Text(plans_category[index]["name"].toString().toUpperCase(), style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              trailing: Icon(Icons.navigate_next, color: Colors.grey,),
            );
          },
          itemCount: plans_category.length,
          ),
        )
      ],
    );
  }
}

class editPlansListner extends GetxController{
  RxBool edit =false.obs;
}

class PlansCustomListner extends GetxController {


  RxBool status = false.obs;
  void changeStatus() {
    status.value = !status.value;
  }
}

Widget customDialog( {required VoidCallback onTap,required TextEditingController controller,required int? selectedNumber,
required Function(int? value) onChanged,
}) {
  return Dialog(

    backgroundColor: customColor.light_red_shed1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding:const EdgeInsets.all(
        20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Workout Name: ",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10,),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'My Workout',
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Colors.grey, width: 1), // same as enabled
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
            style:const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Text(
                "Number of Days: ",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 50, width: 60, child: DropdownButtonFormField<int>(
                value: selectedNumber,
                menuMaxHeight: 350,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:const BorderSide(color: Colors.grey),
                  ),
                ),
                items: List.generate(30, (index) {
                  int number = index + 1;
                  return DropdownMenuItem<int>(
                    value: number,
                    child: Text(number.toString()),
                  );
                }),
                onChanged: onChanged,
              ),),

            ],
          ),

          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Container(
                  width: 140,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) , color: Colors.white),
                  child:const Text("Cancel",style: TextStyle(color: Colors.black),),
                ),
                onTap: () {
                  Get.back();
                },
              ),
              InkWell(
                onTap: onTap ,
                child: Container(
                  width: 140,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10) , color: Colors.white),
                  child:const Text("Save",style: TextStyle(color: Colors.black),),
                ),


              ),
            ],
          )
        ],
      ),
    ),
  );
}
