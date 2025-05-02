import 'dart:io';


import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../Models/dbmodel.dart';

class LocalController extends GetxController{

  RxBool state= false.obs;
  RxBool loggedState = true.obs;
  changeState() {

    state.value = !state.value;
  }
  changeLoggedState(bool value) {

    loggedState.value = value;
  }
}

class GlobalDataManagementController extends GetxController{
  List<Map<String, dynamic>> exerciseCategory= <Map<String, dynamic>>[ ].obs;
  List<Map<String, dynamic>> exerciseList= <Map<String, dynamic>>[ ].obs;
  List<Map<String, dynamic>> image=  <Map<String, dynamic>>[ ].obs;
  List<Map<String, dynamic>> extraImage=<Map<String, dynamic>>[ ].obs;
  List<Map<String, dynamic>> exercisePlanCategory = <Map<String, dynamic>>[ ].obs;
  List<Map<String, dynamic>> exercisePlanList = <Map<String, dynamic>>[ ].obs;
  Directory? appDirectory;


  fetchData() async {
    exerciseCategory =  await DatabaseHelper.instance.getData("exercices_types");
    exerciseList= await DatabaseHelper.instance.getData("exercise");
    image  = await DatabaseHelper.instance.getData("foto");
    extraImage = await DatabaseHelper.instance.getData("extra_image");
    exercisePlanCategory = await DatabaseHelper.instance.getData("exercise_plans_category");
    exercisePlanList = await DatabaseHelper.instance.getData("exercise_plan_list");
    appDirectory = await getApplicationDocumentsDirectory();
    print(exerciseCategory);
  }

  updateDataExerciseList() async{
    exerciseList =await DatabaseHelper.instance.getData("exercise");
  }
  updateDataExtraImage() async {
    extraImage = await DatabaseHelper.instance.getData("extra_image");
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
  }
}