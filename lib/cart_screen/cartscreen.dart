import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadget_mtaa/consts/colors.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:gadget_mtaa/controller/productcontroller.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Your Cart'.text.fontFamily(semibold).color(darkFontGrey).make(),
        backgroundColor: whiteColor,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentuser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
                child: 'Your cart is empty.'.text.color(darkFontGrey).make());
          } else {
            var cartItems = snapshot.data!.docs;
            double totalPrice = 0;

            // Calculate total price
            for (var item in cartItems) {
              totalPrice += (item['tprice'] ?? 0) * (item['qty'] ?? 1);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      var item = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item['image'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error),
                        ),
                        title: "${item['title'] ?? 'Unknown Item'}"
                            .text
                            .fontFamily(semibold)
                            .make(),
                        subtitle: "Sh ${item['tprice'] ?? 0}"
                            .text
                            .color(redColor)
                            .make(),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if ((item['qty'] ?? 0) > 1) {
                                  FirestoreServices.updateCartQuantity(
                                      item.id, (item['qty'] ?? 0) - 1);
                                }
                              },
                            ),
                            "${item['qty'] ?? 0}"
                                .text
                                .color(darkFontGrey)
                                .make(),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                FirestoreServices.updateCartQuantity(
                                    item.id, (item['qty'] ?? 0) + 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      "Total: ${controller.formatPrice(totalPrice)}"
                          .text
                          .color(redColor)
                          .fontFamily(semibold)
                          .make(),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // Proceed to checkout functionality
                        },
                        child:
                            "Proceed to Checkout".text.color(whiteColor).make(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
