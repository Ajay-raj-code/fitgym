import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../Controller/global_controller.dart';
import '../utility/color.dart';

class UpdateApp extends StatefulWidget{
  const UpdateApp({super.key});

  @override
  State<UpdateApp> createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {
  final GlobalDataManagementController controller = Get.put(GlobalDataManagementController());

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(

          backgroundColor: customColor.light_red_shed1,
          title: const Text(
            "FitGym",
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,width: double.infinity,),
            Text("Update Information", textAlign: TextAlign.justify,),
              const SizedBox(height: 30,),
            GestureDetector(
              onTap: () async{

                final String uri =controller.appSettings["update_url"] ?? "https://google.com/";
                try{
                  await launchUrlString(uri, mode: LaunchMode.platformDefault);
                }
                catch (e){
                  print(e);
                }

              },
              child: Container(
              color: customColor.light_red_shed1,
              width: 150,
              height: 50,
              child:const Text("Update App", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,),),
            ),)
          ],),
        ),
      );

  }
}