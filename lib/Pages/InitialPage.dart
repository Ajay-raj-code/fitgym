import 'package:fitgym/Pages/more_screen.dart';
import 'package:fitgym/Pages/plans_screen.dart';
import 'package:fitgym/utility/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'exercise_screen.dart';
import 'home_screen.dart';
import 'log_screen.dart';

class InitialPage extends StatefulWidget {
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  final customController controller = Get.put(customController());
  final List<String> _title = [
    "Home",
    "Exercises",
    "Plans",
    "Log",
    "More",
  ];
  final List<Widget> _Pages = [
    HomeScreen(),
    ExerciseScreen(),
    PlansScreen(),
    LogScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: customColor.light_red_shed1,title: Obx(() => Text(_title[controller.selectedIndex.toInt()], style:const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),),
      body: Obx(() => _Pages[controller.selectedIndex.toInt()],),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: customColor.light_red_shed1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home" ),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center_outlined), label: "Exercises"),
          BottomNavigationBarItem(icon: Icon(Icons.plagiarism), label: "Plans"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: "Log"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "More"),
        ],
        currentIndex: controller.selectedIndex.toInt(),
        selectedItemColor: Colors.white,
        unselectedItemColor: customColor.ligth_grey,
        onTap: (value) {
          controller.setSelectedIndex(value);

        },
      ),),
    );
  }
}

class customController extends GetxController {
  RxInt selectedIndex = 0.obs;
  void setSelectedIndex(int index) {
    selectedIndex.value = index;

  }
}
