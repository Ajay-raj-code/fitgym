import 'package:fitgym/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Authentication/authentication.dart';
import 'Accounts/SignIn.dart';

class MoreScreen extends StatefulWidget{
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      itemExtent: 70,
      children: [
        if(AuthMethods().user != null)
        ListTile(
          onTap: () {
              AuthMethods().signOut();
              Get.offAllNamed("signIn");
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: customColor.light_red_shed1,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.logout_outlined,color: Colors.white,),
          ),
          title: Text("Logout", style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700,),),
        ),
        ListTile(
          onTap: () {
            Get.toNamed("privacyPolicy");
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: customColor.light_red_shed1,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.privacy_tip_outlined, color: Colors.white,),
          ),

          title: Text("Privacy Policy",  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
        ),
        ListTile(
          onTap: () {
            if(AuthMethods().user != null){
              print("User is logged : ${AuthMethods().user}");
            }
            else{
              print("user is not logged in");
            }
            Get.to(SignIn());
          },
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: customColor.light_red_shed1,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.privacy_tip_outlined, color: Colors.white,),
          ),

          title: Text("Auth checking",  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
        ),

      ],
    );
  }
}