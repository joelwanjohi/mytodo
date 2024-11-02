import 'package:flutter/material.dart';
import 'package:gadget_mtaa/common_widget/applogo.dart';
import 'package:gadget_mtaa/common_widget/bg.dart';
import 'package:gadget_mtaa/common_widget/button.dart';
import 'package:gadget_mtaa/common_widget/custom_textfield.dart';
import 'package:gadget_mtaa/consts/colors.dart';
import 'package:gadget_mtaa/consts/firebaseconst.dart';
import 'package:gadget_mtaa/consts/strings.dart';
import 'package:gadget_mtaa/consts/styles.dart';
import 'package:gadget_mtaa/controller/auth_controller.dart';
import 'package:gadget_mtaa/views/home_screen/home.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool? isChecked = false;
  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;

  final controller = Get.put(AuthController());
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final repassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bg(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                (context.screenHeight * 0.1).heightBox,
                applogo(),
                10.heightBox,
                "Join to $appname"
                    .text
                    .fontFamily(bold)
                    .blue900
                    .size(18)
                    .make(),
                15.heightBox,
                Column(
                  children: [
                    customtextfield(
                      Title: name,
                      hint: namehint,
                      controller1: nameController,
                      ispass: false,
                      prefixIcon: Icon(Icons.person, color: redColor),
                    ),
                    customtextfield(
                      Title: email,
                      hint: emailhint,
                      controller1: emailController,
                      ispass: false,
                      prefixIcon: Icon(Icons.email, color: redColor),
                    ),
                    customtextfield(
                      Title: pass,
                      hint: passhint,
                      controller1: passController,
                      ispass: !_isPasswordVisible,
                      prefixIcon: Icon(Icons.lock, color: redColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    customtextfield(
                      Title: repass,
                      hint: passhint,
                      controller1: repassController,
                      ispass: !_isRePasswordVisible,
                      prefixIcon: Icon(Icons.lock, color: redColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isRePasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isRePasswordVisible = !_isRePasswordVisible;
                          });
                        },
                      ),
                    ),
                    5.heightBox,
                    Row(
                      children: [
                        Checkbox(
                          activeColor: redColor,
                          checkColor: whiteColor,
                          value: isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              isChecked = newValue;
                            });
                          },
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "I agree to the ",
                                  style: TextStyle(
                                      fontFamily: regular, color: fontGrey),
                                ),
                                TextSpan(
                                  text: term,
                                  style: TextStyle(
                                      fontFamily: regular, color: redColor),
                                ),
                                TextSpan(
                                  text: " & ",
                                  style: TextStyle(
                                      fontFamily: regular, color: fontGrey),
                                ),
                                TextSpan(
                                  text: poloicy,
                                  style: TextStyle(
                                      fontFamily: regular, color: redColor),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    btn(
                      onPress: () async {
                        // Validation: Check if any field is empty
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passController.text.isEmpty ||
                            repassController.text.isEmpty) {
                          VxToast.show(context,
                              msg: "Please fill in all fields");
                          return;
                        }

                        // Validation: Check if passwords match
                        if (passController.text != repassController.text) {
                          VxToast.show(context, msg: "Passwords do not match");
                          return;
                        }

                        if (isChecked == true) {
                          try {
                            await controller
                                .signupMethod(
                              context: context,
                              email: emailController.text,
                              password: passController.text,
                            )
                                .then((value) {
                              return controller.storeUserData(
                                email: emailController.text,
                                password: passController.text,
                                name: nameController.text,
                              );
                            }).then((value) {
                              VxToast.show(context,
                                  msg: "Signed up Successfully");
                              Get.offAll(() => Home());
                            });
                          } catch (e) {
                            VxToast.show(context, msg: e.toString());
                            auth.signOut();
                          }
                        } else {
                          VxToast.show(context,
                              msg:
                                  "You need to accept the terms and conditions");
                        }
                      },
                      color: isChecked == true ? redColor : lightGrey,
                      textColor: whiteColor,
                      title: signup,
                    ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: alreadyaccount,
                              style:
                                  TextStyle(fontFamily: bold, color: fontGrey)),
                          TextSpan(
                              text: login,
                              style:
                                  TextStyle(fontFamily: bold, color: redColor))
                        ],
                      ),
                    ).onTap(() {
                      Get.back();
                    })
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
