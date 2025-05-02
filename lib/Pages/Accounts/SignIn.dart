import 'package:fitgym/Authentication/authentication.dart';
import 'package:fitgym/Controller/global_controller.dart';
import 'package:fitgym/Pages/Accounts/SignUp.dart';
import 'package:fitgym/utility/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utility/custom_widget.dart';
import '../InitialPage.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final LocalController _localController =
      Get.put(LocalController(), tag: "localSignIn", permanent: false);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<LocalController>();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void retainCursorPosition(TextEditingController controller) {
    final cursorPos = controller.selection;
    controller.selection = cursorPos; // Retain the cursor position
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final checkedHeight = height*0.02;
    final width = Get.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: width,
              height: height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/others/loginBackground.jpeg"),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            top: height * 0.30,
            child: Container(
              width: width,
              height: height * 0.70,
              decoration: BoxDecoration(
                color: customColor.light_red_shed1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Text(
                        "Welcome To Fitgym",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 29,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.055,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Sign In",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "|",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Get.offNamed("signUp");
                              },
                              child: Text(
                                "Sign Up",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 0.45,
            child: Container(
              width: width,
              height: height * 0.55,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Form(
                key: _formKey,
                child:ListView(
                  scrollDirection: Axis.vertical,
                  padding:const  EdgeInsets.only(top: 8),
                  children: [
                    CustomTextField1(
                      controller: _emailController,
                      hintText: "email",
                      prefix: Icons.email_outlined,
                      textInputType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                            r"""^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$""")
                            .hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: checkedHeight,),
                    Obx(() {
                      return TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          } else if (!RegExp(
                              r"""^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$""")
                              .hasMatch(value)) {
                            return 'Password must include letters and numbers';
                          }
                          return null;
                        },
                        obscureText: _localController.state.value,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            hintText: "password",
                            hintStyle: const TextStyle(
                                color: Colors.grey, fontSize: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0),
                            ),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _localController.changeState,
                              child: Icon(
                                _localController.state.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            )),
                      );
                    }),
                    SizedBox(height: checkedHeight,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 35,
                              child: Obx(
                                    () => Checkbox(
                                  value: _localController.loggedState.value,
                                  activeColor: customColor.light_red_shed1,
                                  onChanged: (value) {
                                    _localController
                                        .changeLoggedState(value!);
                                  },
                                ),
                              ),
                            ),
                            const Text("Remember me"),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: customColor.light_red_shed1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: checkedHeight,),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          print("email : $email, password : $password");
                          bool result = await AuthMethods()
                              .loginWithEmail(email, password);
                          if (result) {
                            final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setBool("preserveLoggedState",
                                _localController.loggedState.value);

                            Get.offAllNamed("/");
                          } else {
                            Get.snackbar(
                              "Message",
                              "Check your username and password",
                              titleText: Text(
                                "Message",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: customColor.light_red_shed1,
                                ),
                              ),
                              messageText: Text(
                                "Check your username and password!",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: customColor.light_red_shed1,
                                ),
                              ),
                              colorText: customColor.light_red_shed1,
                              backgroundColor: Colors.white.withAlpha(200),
                              duration: Duration(seconds: 4),
                            );
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            color: customColor.light_red_shed1,
                            borderRadius: BorderRadius.circular(25)),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: checkedHeight,),
                    const Center(
                      child: Text(
                        "Continue With",
                      ),
                    ),
                    SizedBox(height: checkedHeight,),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          bool result = await AuthMethods().signInWithGoogle();
                          if (result) {
                            final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setBool("preserveLoggedState",
                                _localController.loggedState.value);
                            Get.offAllNamed("/");
                          }
                        },
                        child: Card(
                          elevation: 10,
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Image.asset(
                              "assets/others/google.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
