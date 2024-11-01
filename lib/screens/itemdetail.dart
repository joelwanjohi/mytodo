import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadget_mtaa/common_widget/button.dart';
import 'package:gadget_mtaa/consts/colors.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:gadget_mtaa/controller/productcontroller.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:universal_html/html.dart' as html;
import 'package:flutter/services.dart';

class ItemDetail extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ItemDetail({Key? key, required this.title, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    // Calculate total price initially based on price and quantity
    controller.setSingleItemPrice(data['price']);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            controller.resetvalue();
            Get.back();
          },
          icon: const Icon(Icons.arrow_back,color: Colors.black,),
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: title!.text.color(darkFontGrey).fontFamily(semibold).make(),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              print("Share button pressed");

              try {
                final RenderBox? box = context.findRenderObject() as RenderBox?;

                if (foundation.kIsWeb) {
                  // Web-specific logic
                  final shareUrl = 'Check out this amazing product: $title\n'
                      'Price: ${controller.formatPrice(data['price'])}\n'
                      'Description: ${data['description'] ?? "No description available"}\n'
                      'Available Mtaa Store!';

                  // Option 1: Copy to clipboard
                  Clipboard.setData(ClipboardData(text: shareUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Link copied to clipboard!')),
                  );

                  // Option 2: Open a new tab with a shareable link (like a website or product page)
                  html.window.open(
                      'https://gadgetmtaa.com/share?title=$title', '_blank');
                } else {
                  // Native mobile share
                  await Share.share(
                    'Check out this amazing product: $title\n'
                    'Price: ${controller.formatPrice(data['price'])}\n'
                    'Description: ${data['description'] ?? "No description available"}\n'
                    'Available at StoreMtaa!',
                    subject: 'Check out this product!',
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size,
                  );
                }

                print("Share dialog presented"); // Debug print
              } catch (e) {
                print("Error sharing: $e"); // Debug print
                // Show an error message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Unable to share: $e')),
                );
              }
            },
            icon: const Icon(
              Icons.share,
              color: Colors.black,
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: () {
                if (controller.isfav.value) {
                  controller.removefromwhishlist(data.id);
                } else {
                  controller.addtowhishlist(data.id);
                }
              },
              icon: Icon(
                Icons.favorite_outlined,
                color: controller.isfav.value ? redColor : tealColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    data['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Text('Image not available'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: title!.text
                    .size(22)
                    .color(darkFontGrey)
                    .fontFamily(bold)
                    .make(),
              ),
              SizedBox(height: 10),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: golden,
                    size: 25,
                  );
                }),
              ),
              SizedBox(height: 10),
              // Displaying the price
              controller
                  .formatPrice(data['price'])
                  .text
                  .color(redColor)
                  .fontFamily(bold)
                  .size(22)
                  .make(),
              SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    onPressed: () => controller.descquantity(),
                    icon: const Icon(Icons.remove),
                  ),
                  Obx(
                    () => controller.quantity.value.text
                        .size(16)
                        .color(darkFontGrey)
                        .fontFamily(bold)
                        .make(),
                  ),
                  IconButton(
                    onPressed: () => controller.incquantity(data['stock']),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Display total price that updates dynamically
              Obx(
                () =>
                    "Total: ${controller.formatPrice(controller.totalPrice.value)}"
                        .text
                        .color(redColor)
                        .size(18)
                        .fontFamily(semibold)
                        .make(),
              ),
              SizedBox(height: 20),
              Visibility(
                visible: data['description'] != null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Description"
                        .text
                        .color(darkFontGrey)
                        .fontFamily(semibold)
                        .make(),
                    SizedBox(height: 10),
                    Text(
                      data['description'] ?? "No description available",
                      style: TextStyle(
                        color: darkFontGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              "You may also like:"
                  .text
                  .fontFamily('sans_bold')
                  .size(20)
                  .color(darkFontGrey)
                  .make(),
              SizedBox(height: 15),
              StreamBuilder(
                stream: FirestoreServices.allproduct(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          6,
                          (index) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 120,
                              height: 200,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: "No Products Available"
                          .text
                          .color(darkFontGrey)
                          .makeCentered(),
                    );
                  } else {
                    var allproductdata = snapshot.data!.docs;
                    allproductdata.shuffle();

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          allproductdata.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ItemDetail(
                                      title:
                                          "${allproductdata[index]['title']}",
                                      data: allproductdata[index],
                                    ));
                              },
                              child: Container(
                                  width: 150,
                                  height: 265,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 10,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          allproductdata[index]['image'],
                                          width: 135,
                                          height: 155,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              width: 120,
                                              height: 130,
                                              color: Colors.grey,
                                              child: Center(
                                                  child: Text(
                                                      'Image not available')),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      "${allproductdata[index]['title']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      const SizedBox(height: 4),
                                      "${allproductdata[index]['price']}"
                                          .text
                                          .color(redColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make(),
                                    ],
                                  )),
                            );
                          },
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: Obx(
            () => btn(
              color: redColor,
              onPress: () async {
                if (controller.quantity.value > 0) {
                  try {
                    await FirestoreServices.addToCart(
                      currentuser!.uid,
                      {
                        'title': title,
                        'image': data['image'],
                        'qty': controller.quantity.value,
                        'tprice': controller.totalPrice.value,
                        'added_at': FieldValue.serverTimestamp(),
                      },
                    );
                    VxToast.show(context, msg: "Added to cart");
                    // Optionally, you can navigate to the cart screen here
                    // Get.to(() => CartScreen());
                  } catch (e) {
                    VxToast.show(context, msg: "Error adding to cart: $e");
                  }
                } else {
                  VxToast.show(context, msg: "Please select quantity");
                }
              },
              textColor: whiteColor,
              title:
                  "Add to cart (${controller.formatPrice(controller.totalPrice.value)})",
            ),
          ),
        ),
      ),
    );
  }
}
