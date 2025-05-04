import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitgym/Authentication/authentication.dart';
import 'package:fitgym/Pages/Accounts/SignIn.dart';
import 'package:fitgym/Pages/Accounts/SignUp.dart';
import 'package:fitgym/Pages/ExerciseView/Exercise.dart';
import 'package:fitgym/Pages/ExerciseView/ExerciseList.dart';
import 'package:fitgym/Pages/ExerciseView/ExplainExercise.dart';
import 'package:fitgym/Pages/More/PrivacyPolicy.dart';
import 'package:fitgym/Pages/InitialPage.dart';
import 'package:fitgym/Pages/update_screen.dart';
import 'package:fitgym/utility/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Controller/global_controller.dart';
import 'Pages/ExerciseCreation/AddCustomExercise.dart';
import 'Pages/Logs/ExerciseHistory.dart';
import 'Pages/PlansView/CustomWorkout.dart';
import 'Pages/PlansView/SelectDaysScreen.dart';
import 'Pages/PlansView/SelectExercise.dart';
import 'Pages/PlansView/SelectedDaysWorkout.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final bool loggedState= preferences.getBool("preserveLoggedState") ?? false;
  String route = await getInitialRoute();
  if(!loggedState){
    await AuthMethods().signOut();
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]).then((value) {
    runApp(MyApp(route: route,));
  },);

}
Future<String> getPackageInfo() async{
  try {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  } catch (e) {
    print('Failed to get package info: $e');
    return 'Unknown';
  }
}
Future<String> getInitialRoute() async{
  var appSettings = await getAppSettings();
  bool logged = false;
  String version = await getPackageInfo();
  final GlobalDataManagementController controller = Get.put(GlobalDataManagementController());
  controller.appSettings.addAll(appSettings);
  if(AuthMethods().user!=null){
    logged = true;
  }

  print("$appSettings,package info:  $version");
  if(HelperFunctions.compareVersions(version, appSettings["version"]!) != 0){
    return "/updateApp";
  }else{
    return logged? "/": "/signIn";
  };
}

class MyApp extends StatefulWidget {
  final route;
  const MyApp({super.key, required this.route});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fitgym',
      initialRoute: widget.route,
      getPages: [
        GetPage(name: "/updateApp", page: () => UpdateApp(),),
        GetPage(name: "/", page: () => InitialPage(),),
        GetPage(name: "/signIn", page: () => SignIn(),),
        GetPage(name: "/signUp", page: () => SignUp(),),
        GetPage(name: "/exerciseCategory", page: () => ExerciseList()),
        GetPage(name: "/exercise", page: () => Exercise(),),
        GetPage(name: "/detailExercise", page: () => ExplainExercise(),),
        GetPage(name: "/createCustomExercise", page: () => CreateExercise(),),
        GetPage(name: "/detailedLogs", page: () => ExerciseHistory(),),
        GetPage(name: "/privacyPolicy", page: () => PrivacyPolicy(),),
        GetPage(name: "/customWorkout", page: () => CustomWorkout(),),
        GetPage(name: "/selectExercise", page: () => SelectExercise(),),
        GetPage(name: "/selectDaysScreen", page: () => SelectDaysScreen(),),
        GetPage(name: "/selectedDaysWorkout", page: () => SelectedDaysWorkout(),),

      ],

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),


    );
  }
}

