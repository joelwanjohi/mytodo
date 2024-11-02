import 'package:gadget_mtaa/common_widget/exitdialog.dart';
import 'package:gadget_mtaa/consts/colors.dart';
import 'package:gadget_mtaa/consts/images.dart';
import 'package:gadget_mtaa/consts/strings.dart';
import 'package:gadget_mtaa/consts/styles.dart';
import 'package:gadget_mtaa/controller/homecontroller.dart';
import 'package:gadget_mtaa/views/cart_screen/cartscreen.dart';
import 'package:gadget_mtaa/views/category_screen/categoryscreen.dart';
import 'package:gadget_mtaa/views/home_screen/homescreen.dart';
import 'package:gadget_mtaa/views/profile_screen/profilescreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final HomeController controller = Get.put(HomeController());

  final List<BottomNavigationBarItem> navbaritem = [
    BottomNavigationBarItem(icon: Image.asset(icHome, width: 26), label: shome),
    BottomNavigationBarItem(
        icon: Image.asset(icCategories, width: 26), label: category),
    BottomNavigationBarItem(icon: Image.asset(icCart, width: 26), label: cart),
    BottomNavigationBarItem(
        icon: Image.asset(icProfile, width: 26), label: account),
  ];

  final List<Widget> navbody = [
    HomeScreen(),
    CategoryScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => exitDialog(context),
        );
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(() => Expanded(
                child: navbody.elementAt(controller.currentNavIndex.value))),
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.currentNavIndex.value,
            backgroundColor: whiteColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: redColor,
            selectedLabelStyle: TextStyle(fontFamily: bold),
            items: navbaritem,
            onTap: (value) {
              controller.currentNavIndex.value = value;
            },
          ),
        ),
      ),
    );
  }
}
