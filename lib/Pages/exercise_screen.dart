import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/global_controller.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});
  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final GlobalDataManagementController _globalDataManagementController= Get.put(GlobalDataManagementController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("${_globalDataManagementController.appDirectory?.path}");
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.white,
            hoverColor: Colors.grey.shade100,
            title: Row(
              children: [
                SizedBox(
                  width: 100, // Set desired width
                  height: 100, // Set desired height
                  child: Image.asset(
                    "assets/cat/${_globalDataManagementController.exerciseCategory[index]["foto"].toString()}n.png",
                    fit: BoxFit.cover, // Ensures proper scaling
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _globalDataManagementController.exerciseCategory[index]["name"].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding:const EdgeInsets.only(left: 8, right: 8,),
                        decoration:BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "${_globalDataManagementController.exerciseCategory[index]["count"]} Exercises",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onTap: ()async {

              Get.toNamed("exerciseCategory", arguments: {"index":index, });
            },
          );
        },
        itemCount: _globalDataManagementController.exerciseCategory.length - 1,
      ),
    );
  }
}
