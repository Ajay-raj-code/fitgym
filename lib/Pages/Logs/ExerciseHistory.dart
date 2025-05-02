

import 'dart:io';

import 'package:fitgym/Models/dbmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Graph/graph_screen.dart';
import '../../utility/color.dart';
import '../../utility/helper_functions.dart';

class ExerciseHistory extends StatefulWidget{
  const ExerciseHistory({super.key});

  @override
  State<ExerciseHistory> createState() => _ExerciseHistoryState();
}

class _ExerciseHistoryState extends State<ExerciseHistory> {

  final fetchDataToGraph _fetchDataToGraphController = Get.put(fetchDataToGraph());

  final DataFeched2 _dataFechedController = Get.put(DataFeched2());
  TextEditingController _controllerWeight = TextEditingController();
  TextEditingController _controllerReps = TextEditingController();
  late Map<String, dynamic> _exerciseDetail;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    var args = Get.arguments;
    _exerciseDetail = args["exerciseDetail"];


    _fetchDataToGraphController.fetchData(_exerciseDetail["id_exercise"]);

    _dataFechedController.fetchData(_exerciseDetail["id_exercise"]);
  }
  @override
  Widget build(BuildContext context) {
    final width = Get.width;
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
          "detailedPage".toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child:SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _fetchDataToGraphController.defaultSelection.value = "weights";
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 110,
                      height: 30,
                      decoration: BoxDecoration(color: _fetchDataToGraphController.defaultSelection.value == "weights"? customColor.light_red_shed1:Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Text("Weights", style: TextStyle(color: _fetchDataToGraphController.defaultSelection.value == "weights"? Colors.white:Colors.black,),),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _fetchDataToGraphController.defaultSelection.value = "repetitions";
                    },
                    child: Container(
                      alignment: Alignment.center,

                      width: 110,
                      height: 30,
                      decoration: BoxDecoration(color: _fetchDataToGraphController.defaultSelection.value == "repetitions"? customColor.light_red_shed1:Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Text("Repetitions" , style: TextStyle(color: _fetchDataToGraphController.defaultSelection.value == "repetitions"?Colors.white:Colors.black, ),),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _fetchDataToGraphController.defaultSelection.value = "performance";
                    },
                    child: Container(
                      alignment: Alignment.center,

                      width: 110,
                      height: 30,
                      decoration: BoxDecoration(color: _fetchDataToGraphController.defaultSelection.value == "performance"? customColor.light_red_shed1:Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Text("Performance" , style: TextStyle(color: _fetchDataToGraphController.defaultSelection.value == "performance"?Colors.white: Colors.black),),
                    ),
                  ),
                ],
              ),),
              const SizedBox(height: 20,),
              Obx(() {
                List<double> weights = _fetchDataToGraphController.exerciseHistory.map((item) => (item["weight"] as num).toDouble()).toList();
                List<String> date = _fetchDataToGraphController.exerciseHistory.map((item) => item["date"] as String).toList();
                List<double> reps =  _fetchDataToGraphController.exerciseHistory.map((item) => (item["reps"] as num).toDouble()).toList();
                List<double> performance= List.generate(weights.length, (index) => weights[index] * reps[index],);
                List<double> data= weights;
                if(_fetchDataToGraphController.defaultSelection.value == "weights"){
                  data= weights;
                }else if(_fetchDataToGraphController.defaultSelection.value == "repetitions"){
                  data = reps;
                }else{
                  data= performance;
                }
                return weights.isEmpty? CircularProgressIndicator() :SimpleLineGraph(data: data,labels: date,);
              },),
              const SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: customColor.light_red_shed1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFFCC563F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: width / 3 - 15,
                      height: 90,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "WEIGHT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true), // decimal keyboard
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^\d*\.?\d{0,2}')), // allows numbers like 123.45
                            ],
                            style: const TextStyle(
                                fontSize: 26, color: Colors.white),
                            controller: _controllerWeight,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            maxLength: 5,
                          )
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFFCC563F),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: width / 3 - 15,
                      height: 90,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "REPS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: const TextStyle(
                                fontSize: 26, color: Colors.white),
                            controller: _controllerReps,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            maxLength: 3,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!_controllerWeight.text.isEmpty &&
                            !_controllerReps.text.isEmpty) {
                          int id = _exerciseDetail["id_exercise"];
                          int reps =
                          int.parse(_controllerReps.text.toString());
                          double weight =
                          double.parse(_controllerWeight.text.toString());
                          String currentDate =
                          HelperFunctions.getCurrentDate();
                          print(
                              "id: $id, reps: $reps, weight: $weight, date: $currentDate");

                          await DatabaseHelper.instance.insertExerciseHistory(
                              date: currentDate,
                              id_exercise: id,
                              weight: weight,
                              reps: reps);
                          _controllerReps.clear();
                          _controllerWeight.clear();
                          _fetchDataToGraphController.fetchData(_exerciseDetail["id_exercise"]);

                          _dataFechedController.fetchData(_exerciseDetail["id_exercise"]);
                        } else {
                          print("this is empty");
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: customColor.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: width / 3 - 15,
                        height: 90,
                        child: Icon(
                          Icons.add,
                          color: customColor.light_red_shed1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _dataFechedController.groupedByDate.length,
                itemBuilder: (context, index) {
                  String dateKey =
                  _dataFechedController.groupedByDate.keys.elementAt(index);
                  List<String> parts =
                  dateKey.split('-'); // [7, 4, 2025]
                  List<Map<String, dynamic>> historyData = [];
                  historyData.addAll(_dataFechedController.groupedByDate[dateKey] ?? []);
                  String formattedDate =
                      "${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}";
                  DateTime parsedDate = DateTime.parse(
                      formattedDate // Convert dd-mm-yyyy to yyyy-mm-dd

                  );
                  print(parsedDate);
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors
                          .grey.shade100, // Just for visibility
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: customColor
                                  .light_red_shed1, // Just for visibility
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  getMonthName(parsedDate.month),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  parsedDate.day.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  parsedDate.year.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100, // Just for visibility
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "WEIGHT",
                                        style: TextStyle(
                                          color: customColor
                                              .light_red_shed1,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        "REPS",
                                        style: TextStyle(
                                          color: customColor
                                              .light_red_shed1,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ...historyData.map((data) {
                                    return InkWell(
                                      onTap: () {
                                        TextEditingController sheetControllerWeight = TextEditingController();
                                        TextEditingController sheetControllerReps = TextEditingController();
                                        sheetControllerReps.text = data["reps"].toString();
                                        sheetControllerWeight.text = data["weight"].toString();
                                        Get.bottomSheet(
                                            isDismissible: false,
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: customColor.light_red_shed1, // Just for visibility
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Icon(Icons.calendar_month_outlined, color: Colors.white,),
                                                          Text("${getMonthName(parsedDate.month)} ${parsedDate.day} ${parsedDate.year}", style:const TextStyle(color: Colors.white, fontSize: 18),),
                                                        ],
                                                      ),
                                                      IconButton(onPressed: () {
                                                        Get.back();
                                                      }, icon: Icon(Icons.cancel_outlined,),),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFCC563F),
                                                          borderRadius: BorderRadius.circular(10),
                                                        ),
                                                        width: width / 3 - 15,
                                                        height: 90,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "WEIGHT",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            TextField(
                                                              keyboardType: TextInputType.numberWithOptions(
                                                                  decimal: true), // decimal keyboard
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter.allow(RegExp(
                                                                    r'^\d*\.?\d{0,2}')), // allows numbers like 123.45
                                                              ],
                                                              style: const TextStyle(
                                                                  fontSize: 26, color: Colors.white),
                                                              controller: sheetControllerWeight,
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                counterText: "",
                                                                contentPadding: EdgeInsets.symmetric(
                                                                  horizontal: 20,
                                                                ),
                                                              ),
                                                              maxLength: 5,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFCC563F),
                                                          borderRadius: BorderRadius.circular(5),
                                                        ),
                                                        width: width / 3 - 15,
                                                        height: 90,
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "REPS",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                            TextField(
                                                              keyboardType: TextInputType.number,
                                                              inputFormatters: [
                                                                FilteringTextInputFormatter.digitsOnly,
                                                              ],
                                                              style: const TextStyle(
                                                                  fontSize: 26, color: Colors.white),
                                                              controller: sheetControllerReps,
                                                              decoration: const InputDecoration(
                                                                border: InputBorder.none,
                                                                counterText: "",
                                                                contentPadding: EdgeInsets.symmetric(
                                                                  horizontal: 20,
                                                                ),
                                                              ),
                                                              maxLength: 3,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          if (!sheetControllerWeight.text.isEmpty &&
                                                              !sheetControllerReps.text.isEmpty) {
                                                            int id = data["id"];
                                                            int reps =
                                                            int.parse(sheetControllerReps.text.toString());
                                                            double weight =
                                                            double.parse(sheetControllerWeight.text.toString());



                                                            await DatabaseHelper.instance.updateExerciseHistory(id: id, weight: weight, reps: reps);
                                                            Get.back();
                                                            _dataFechedController.fetchData(_exerciseDetail["id_exercise"]);
                                                            _fetchDataToGraphController.fetchData(_exerciseDetail["id_exercise"]);


                                                          } else {
                                                            print("this is empty");
                                                          }
                                                        },
                                                        child: Container(
                                                          alignment: Alignment.center,
                                                          padding: EdgeInsets.all(5),
                                                          decoration: BoxDecoration(
                                                            color: customColor.white,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          width: width / 3 - 15,
                                                          height: 90,
                                                          child: Icon(
                                                            Icons.check,
                                                            color: customColor.light_red_shed1,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                        );
                                        print(data);
                                      },
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceAround,
                                          children: [
                                            Text(
                                              "${data['weight']}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${data['reps']}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),),
            ],
          ),
        ),
      ),
    );
  }
  String getMonthName(int month) {
    const List<String> months = [
      '', // index 0 is empty to align with 1-based month index
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month];
  }
}
class fetchDataToGraph extends GetxController{
  var exerciseHistory = [].obs;
  RxString defaultSelection = "weights".obs;

  Future<void> fetchData(int id) async {
    exerciseHistory.clear();
    exerciseHistory.addAll(await DatabaseHelper.instance.getFilteredExercisesHistory(id));
    exerciseHistory.refresh();
    print(exerciseHistory);
  }
}
class DataFeched2 extends GetxController {
  var groupedByDate = <String, List<Map<String, dynamic>>>{}.obs;
  RxBool controller = false.obs;
  Future<void> fetchData(int id) async {
    groupedByDate.clear();
    var _exerciseHistory = await DatabaseHelper.instance.getFilteredExercisesHistory(id);


    for (var entry in _exerciseHistory) {
      String date = entry['date'];
      if (!groupedByDate.containsKey(date)) {
        groupedByDate[date] = [];
      }
      groupedByDate[date]!.add(entry);
    }
    groupedByDate.refresh();
    print("controller group data : $groupedByDate");

  }
}