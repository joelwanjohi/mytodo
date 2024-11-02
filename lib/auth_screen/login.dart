import 'package:flutter/material.dart';
import 'package:gadget_mtaa/common_widget/applogo.dart';
import 'package:gadget_mtaa/common_widget/bg.dart';
import 'package:gadget_mtaa/common_widget/button.dart';
import 'package:gadget_mtaa/common_widget/custom_textfield.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:gadget_mtaa/consts/iconlist.dart';
import 'package:gadget_mtaa/controller/auth_controller.dart';
import 'package:gadget_mtaa/views/auth_screen/signin.dart';
import 'package:gadget_mtaa/views/home_screen/home.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isPasswordVisible = false;

  final controller = Get.put(AuthController());
  final passController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bg(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogo(),
                10.heightBox,
                "Log in to $appname"
                    .text
                    .fontFamily(bold)
                    .blue900
                    .size(18)
                    .make(),
                15.heightBox,
                Column(
                  children: [
                    customtextfield(
                      Title: email,
                      hint: emailhint,
                      controller1: emailController,
                      ispass: false,
                      prefixIcon:
                          Icon(Icons.email, color: redColor), // Email icon
                    ),
                    customtextfield(
                      Title: pass,
                      hint: passhint,
                      controller1: passController,
                      ispass: !_isPasswordVisible, // Toggle visibility
                      prefixIcon:
                          Icon(Icons.lock, color: redColor), // Lock icon
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: redColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgetpass.text.make()),
                    ),
                    5.heightBox,
                    btn(
                      onPress: () async {
                        await controller
                            .loginMethod(
                          context: context,
                          email: emailController.text,
                          password: passController.text,
                        )
                            .then((value) {
                          if (value != null) {
                            VxToast.show(context,
                                msg: "Logged in Successfully");
                            Get.offAll(() => Home());
                          }
                        });
                      },
                      color: redColor,
                      textColor: whiteColor,
                      title: login,
                    ).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                    create.text.color(fontGrey).make(),
                    5.heightBox,
                    btn(
                      onPress: () {
                        Get.to(() => Signin());
                      },
                      color: lightgolden,
                      textColor: redColor,
                      title: signup,
                    ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    loginnwith.text.color(fontGrey).make(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: lightGrey,
                            radius: 25,
                            child: Image.asset(sociallist[index], width: 30),
                          ),
                        ),
                      ),
                    )
                  ],
                )
                    .box
                    .white
                    .rounded
                    .padding(EdgeInsets.all(16))
                    .width(context.screenWidth - 70)
                    .shadowSm
                    .make(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
