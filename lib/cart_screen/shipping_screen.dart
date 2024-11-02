// import 'package:flutter/material.dart';
// import 'package:gadget_mtaa/common_widget/custom_textfield.dart';
// import 'package:gadget_mtaa/consts/colors.dart';
// import 'package:gadget_mtaa/consts/styles.dart';
// import 'package:gadget_mtaa/controller/cartcontroller.dart';
// import 'package:gadget_mtaa/views/cart_screen/payment_method.dart';
// import 'package:get/get.dart';
// import 'package:velocity_x/velocity_x.dart';

// import '../../common_widget/button.dart';

// class ShippingDetail extends StatelessWidget {
//   const ShippingDetail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<CartController>();
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(
//         title: "Shipping Info"
//             .text
//             .fontFamily(semibold)
//             .color(darkFontGrey)
//             .make(),
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 60,
//         child: btn(
//           onPress: () {
//             if (controller.addresscontroller.text.isNotEmpty) {
//               Get.to(() => PaymentMethod());
//             } else {
//               VxToast.show(context, msg: "Please fill all fields");
//             }
//           },
//           color: redColor,
//           textColor: whiteColor,
//           title: "Continue",
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             customtextfield(
//               hint: "Address",
//               ispass: false,
//               Title: "Address",
//               controller1: controller.addresscontroller,
//             ),
//             customtextfield(
//               hint: "City",
//               ispass: false,
//               Title: "City",
//               controller1: controller.citycontroller,
//             ),
//             customtextfield(
//               hint: "State",
//               ispass: false,
//               Title: "State",
//               controller1: controller.statecontroller,
//             ),
//             customtextfield(
//               hint: "Postal code",
//               ispass: false,
//               Title: "Postal code",
//               controller1: controller.postalcodecontroller,
//             ),
//             customtextfield(
//               hint: "Phone",
//               ispass: false,
//               Title: "Phone",
//               controller1: controller.phonecontroller,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
