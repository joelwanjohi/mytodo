import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';
import 'package:gadget_mtaa/views/order_screen/order_detail.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getallorders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No order yet!".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: "${index + 1}"
                          .text
                          .color(darkFontGrey)
                          .xl
                          .fontFamily(bold)
                          .make(),
                      title: data[index]['order_code']
                          .toString()
                          .text
                          .color(redColor)
                          .fontFamily(semibold)
                          .make(),
                      subtitle: data[index]['total_amount']
                          .toString()
                          .numCurrency
                          .text
                          .fontFamily(bold)
                          .make(),
                      trailing: IconButton(
                        onPressed: () {
                          Get.to(() => OrderDetail(
                                data: data[index],
                              ));
                        },
                        icon: Icon(Icons.arrow_forward_ios_rounded),
                        color: darkFontGrey,
                      ),
                    );
                  });
            }
          }),
    );
  }
}
