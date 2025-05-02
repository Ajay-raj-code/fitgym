
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField2 extends StatefulWidget {
  TextEditingController controller;
  bool hide;
  VoidCallback onTap;
  CustomTextField2({super.key, required this.controller, required this.hide, required this.onTap});

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  late TextEditingController controller;
  bool _hide = true;
  String? error;
  late VoidCallback onTap;
  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    // _hide = widget.hide;
    onTap= widget.onTap;
    print("printing internal value : $_hide");
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      controller: controller,
      style:const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      cursorColor: Colors.black,
      validator: (value) {
        if (value == null || value.isEmpty) {
          error = 'Please enter your password';
          return error ;
        } else if (value.length < 8) {
          error= 'Password must be at least 8 characters long';
          return error;
        } else if (!RegExp(r"""^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$""").hasMatch(value)) {
          error = 'Password must include letters and numbers';
          return error;
        }
        return null;
      },
      obscureText: _hide,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          hintText: "password",
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
          border: OutlineInputBorder(

            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          focusedBorder: OutlineInputBorder(

            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey,
          ),
          suffixIcon: GestureDetector(
            child: Icon(
              _hide
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onTap:() {
              setState(() {
                _hide = !_hide;
                String currentText = controller.text;
                controller
                ..text = ""
                ..text= currentText
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: currentText.length),
                );
              });
            },
          )),
    )
       ;
  }
}
Widget CustomTextField1(
    {required String hintText,
      FormFieldValidator<String>? validator,
      required IconData prefix, TextInputType? textInputType,List<TextInputFormatter>? inputFormatters, required TextEditingController controller}) {
  return TextFormField(
    
    controller: controller,
    keyboardType: textInputType,
    inputFormatters: [],
    style:const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
    cursorColor: Colors.black,
    validator: validator,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(

        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      enabledBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      focusedBorder: OutlineInputBorder(

        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide(color: Colors.transparent, width: 0),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),

      prefixIcon: Icon(
        prefix,
        color: Colors.grey,
      ),
    ),
  );
}