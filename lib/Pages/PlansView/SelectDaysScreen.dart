import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/color.dart';

class SelectDaysScreen extends StatefulWidget{
  const SelectDaysScreen({super.key});

  @override
  State<SelectDaysScreen> createState() => _SelectDaysScreenState();
}

class _SelectDaysScreenState extends State<SelectDaysScreen> {

  late Map<String, dynamic> _exercise_plans_cat = {};
  late List<Map<String, dynamic>> _exercise_plans = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var args= Get.arguments;
    _exercise_plans_cat= args["exercise_plans_cat"];
  _exercise_plans = args["exercise_plans"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon:const Icon(Icons.arrow_back, color: Colors.white, size: 28,)),
        backgroundColor: customColor.light_red_shed1,
        title: Text(
          _exercise_plans_cat["name"].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed("selectedDaysWorkout", arguments: {"days": 2});
                },
                child: Container(
                  decoration: BoxDecoration(

                    border: Border.all(color: customColor.light_red_shed1, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: Get.height/2-80,
                  width: Get.width/2-20,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(Icons.calendar_month_outlined, color: customColor.light_red_shed1,),
                      Text("2 Days", style: TextStyle(color: customColor.light_red_shed1, fontSize: 20,fontWeight: FontWeight.bold,),),
                      Text("Per Weeks", style: TextStyle(color: customColor.black, fontSize: 20,fontWeight: FontWeight.bold,),),
                    ],
                  ),

                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(

                    border: Border.all(color: customColor.light_red_shed1, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: Get.height/2-80,
                  width: Get.width/2-20,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(Icons.calendar_month_outlined, color: customColor.light_red_shed1,),
                      Text("3 Days", style: TextStyle(color: customColor.light_red_shed1, fontSize: 20,fontWeight: FontWeight.bold,),),
                      Text("Per Weeks", style: TextStyle(color: customColor.black, fontSize: 20,fontWeight: FontWeight.bold,),),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(

                    border: Border.all(color: customColor.light_red_shed1, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: Get.height/2-80,
                  width: Get.width/2-20,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_month_outlined, color: customColor.light_red_shed1,),
                      Text("4 Days", style: TextStyle(color: customColor.light_red_shed1, fontSize: 20,fontWeight: FontWeight.bold,),),
                      Text("Per Weeks", style: TextStyle(color: customColor.black, fontSize: 20,fontWeight: FontWeight.bold,),),
                    ],
                  ),

                ),
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(

                    border: Border.all(color: customColor.light_red_shed1, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: Get.height/2-80,
                  width: Get.width/2-20,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Icon(Icons.calendar_month_outlined, color: customColor.light_red_shed1,),
                      Text("5 Days", style: TextStyle(color: customColor.light_red_shed1, fontSize: 20,fontWeight: FontWeight.bold,),),
                      Text("Per Weeks", style: TextStyle(color: customColor.black, fontSize: 20,fontWeight: FontWeight.bold,),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }
}