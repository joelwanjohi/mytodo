// import 'package:gadget_mtaa/consts/consts.dart';
// import 'package:gadget_mtaa/consts/iconlist.dart';
// import 'package:gadget_mtaa/views/home_screen/home.dart';
// import 'package:get/get.dart';

// import '../../common_widget/button.dart';
// import '../../controller/cartcontroller.dart';

// class PaymentMethod extends StatelessWidget {
//   const PaymentMethod({super.key});

//   @override
//   Widget build(BuildContext context) {
//     var controller = Get.find<CartController>();
//     return Scaffold(
//       backgroundColor: whiteColor,
//       appBar: AppBar(
//         title: "Choose Payment Method"
//             .text
//             .fontFamily(semibold)
//             .color(darkFontGrey)
//             .make(),
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 60,
//         child: btn(
//           onPress: () async {
//             await controller.placemyorder(
//               orderpaymentmethod: paymentmethod[controller.paymentindex.value],
//               total: controller.totalprice.value,
//             );
//             await controller.clearcart();
//             VxToast.show(context, msg: "Order placed successfully");
//             Get.offAll(Home());
//           },
//           color: redColor,
//           textColor: whiteColor,
//           title: "Place my order",
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Obx(
//           () => Column(
//               children: List.generate(paymentmethod.length, (index) {
//             return GestureDetector(
//               onTap: () {
//                 controller.changepaymentindex(index);
//               },
//               child: Container(
//                 clipBehavior: Clip.antiAlias,
//                 margin: EdgeInsets.only(bottom: 8),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                         color: controller.paymentindex.value == index
//                             ? redColor
//                             : Colors.transparent,
//                         width: 4)),
//                 child: Stack(
//                   alignment: Alignment.topRight,
//                   children: [
//                     Image.asset(
//                       colorBlendMode: controller.paymentindex == index
//                           ? BlendMode.darken
//                           : BlendMode.color,
//                       color: controller.paymentindex == index
//                           ? Colors.black.withOpacity(0.4)
//                           : Colors.transparent,
//                       paymentmethodimgs[index],
//                       width: double.infinity,
//                       height: 120,
//                       fit: BoxFit.cover,
//                     ),
//                     controller.paymentindex.value == index
//                         ? Transform.scale(
//                             scale: 1.3,
//                             child: Checkbox(
//                               activeColor: Colors.green,
//                               value: true,
//                               onChanged: (value) {},
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(50)),
//                             ))
//                         : Container(),
//                     Positioned(
//                         bottom: 7,
//                         right: 10,
//                         child: paymentmethod[index]
//                             .text
//                             .white
//                             .size(16)
//                             .fontFamily(semibold)
//                             .make())
//                   ],
//                 ),
//               ),
//             );
//           })),
//         ),
//       ),
//     );
//   }
// }
