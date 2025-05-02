import 'package:firebase_core/firebase_core.dart';
import 'package:fitgym/Authentication/authentication.dart';
import 'package:fitgym/Pages/Accounts/SignIn.dart';
import 'package:fitgym/Pages/Accounts/SignUp.dart';
import 'package:fitgym/Pages/ExerciseView/Exercise.dart';
import 'package:fitgym/Pages/ExerciseView/ExerciseList.dart';
import 'package:fitgym/Pages/ExerciseView/ExplainExercise.dart';
import 'package:fitgym/Pages/More/PrivacyPolicy.dart';
import 'package:fitgym/Pages/InitialPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Pages/ExerciseCreation/AddCustomExercise.dart';
import 'Pages/Logs/ExerciseHistory.dart';
import 'Pages/PlansView/CustomWorkout.dart';
import 'Pages/PlansView/SelectDaysScreen.dart';
import 'Pages/PlansView/SelectExercise.dart';
import 'Pages/PlansView/SelectedDaysWorkout.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final bool loggedState= preferences.getBool("preserveLoggedState") ?? false;

  if(!loggedState){
    await AuthMethods().signOut();
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]).then((value) {
    runApp(const MyApp());
  },);

}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _logged = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(AuthMethods().user!=null){
      _logged = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fitgym',
      initialRoute: _logged? "/":"signIn",
      getPages: [
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

