import 'package:fitgym/Pages/Accounts/SignIn.dart';
import 'package:fitgym/utility/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Authentication/authentication.dart';
import '../../Controller/global_controller.dart';
import '../../utility/custom_widget.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final LocalController _localController =
      Get.put(LocalController(), tag: "localSignUp", permanent: false);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<LocalController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = Get.height;
    final checkedHeight = height*0.0178;
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
            top: height * 0.2,
            child: Container(
              width: width,
              height: height * 0.65,
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
                        "Create Account",
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
                          GestureDetector(
                              onTap: () {
                                Get.offNamed("signIn");
                              },
                              child: Text(
                                "Sign In",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          Text(
                            "|",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
            top: height * 0.37,
            child: Container(
              width: width,
              height: height * 0.63,
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
                child: ListView(
                  padding:const  EdgeInsets.only(top: 8),
                  scrollDirection: Axis.vertical,
                  children: [
                    CustomTextField1(
                      controller: _nameController,
                      hintText: "name",
                      prefix: Icons.person_outline,
                      textInputType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        } else if (!RegExp(r"""^[a-zA-Z\s]+$""")
                            .hasMatch(value)) {
                          return 'Name can contain only letters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: checkedHeight,),
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
                    CustomTextField1(
                      controller: _numberController,
                      hintText: "phone number",
                      prefix: Icons.phone,
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        } else if (!RegExp(r'^[0-9]{10}$')
                            .hasMatch(value)) {
                          return 'Enter a valid 10-digit number';
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
                            prefixIcon:const Icon(
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
                      ],
                    ),
                    SizedBox(height: checkedHeight,),
                    InkWell(
                      onTap: () async {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          final email = _emailController.text;
                          final password = _passwordController.text;
                          final name = _nameController.text;
                          final phone = _numberController.text;

                          bool result = await AuthMethods()
                              .registerWithEmail(
                              email: email,
                              password: password,
                              phone: phone,
                              name: name);
                          if (result) {
                            final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            prefs.setBool("preserveLoggedState",
                                _localController.loggedState.value);
                            Get.offAllNamed("/");
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
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: checkedHeight,),
                    Center(
                      child:const Text(
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
                            child:Image.asset(
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
