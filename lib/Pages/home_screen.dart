import 'package:fitgym/Controller/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ExerciseView/ExerciseList.dart';

class HomeScreen extends StatelessWidget {
  final GlobalDataManagementController controller = Get.put(GlobalDataManagementController());

  Future<void> navigateToExercise(int index) async {

    Get.toNamed("exerciseCategory", arguments: {"index":index,});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth= Get.width;
    final screenHeight = Get.height;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: SizedBox( height: 700, width: 380,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.7,
              child: Container(


                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/others/fullbody.jpeg"))),
              ),
            ),
            Positioned(
              left: screenWidth * 0.23,
              top: screenHeight * 0.155,
              width: screenWidth * 0.09,
              height: screenHeight * 0.06,
              child: GestureDetector(
                onTap: () async {
                  await navigateToExercise(7);
                  print("Shoulder");
                },

              ),
            ),
            Positioned(
              left: screenWidth * 0.22,
              top: screenHeight * 0.22,
              width: screenWidth * 0.06,
              height: screenHeight * 0.06,
              child: GestureDetector(
                onTap: ()async {
                  await navigateToExercise(2);
                  print("bicep");
                },

              ),
            ),
            Positioned(
              left: screenWidth * 0.175,
              top: screenHeight * 0.29,
              width: screenWidth * 0.06,
              height: screenHeight * 0.09,
              child: GestureDetector(
                onTap: () async{
                  await navigateToExercise(5);
                  print("forearm");
                },

              ),
            ),

            Positioned(
              left: screenWidth * 0.33,
              top: screenHeight * 0.16,
              width: screenWidth * 0.09,
              height: screenHeight * 0.06,
              child: GestureDetector(
                onTap: () async {
                  await navigateToExercise(4);
                  print("chest");
                },

              ),
            ),
            Positioned(
              left: screenWidth * 0.44,
              top: screenHeight * 0.12,
              width: screenWidth * 0.09,
              height: screenHeight * 0.14,
              child: GestureDetector(
                onTap: () async{
                  await navigateToExercise(1);
                print("back");
                },

              ),
            ),
            Positioned(
              left: screenWidth * 0.57,
              top: screenHeight * 0.22,
              width: screenWidth * 0.09,
              height: screenHeight * 0.06,
              child: GestureDetector(
                onTap: () async {
                  await navigateToExercise(8);
                  print("triceps");
                },

              ),
            ),
            Positioned(
              left: screenWidth * 0.37,
              top: screenHeight * 0.225,
              width: screenWidth * 0.06,
              height: screenHeight * 0.13,
              child: GestureDetector(
                onTap: () async {
                  await navigateToExercise(0);
                  print("abs");
                },

              ),
            ),
            Positioned(
              left: screenWidth * 0.31,
              top: screenHeight * 0.36,
              width: screenWidth * 0.10,
              height: screenHeight * 0.175,
              child: GestureDetector(
                onTap: () async{
                  await navigateToExercise(6);
                  print("leg");
                },

              ),
            ),
            Positioned(
              left: screenWidth * 0.48,
              top: screenHeight * 0.55,
              width: screenWidth * 0.09,
              height: screenHeight * 0.10,
              child: GestureDetector(
                onTap: () async{
                  await navigateToExercise(3);
                  print("calf");
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
