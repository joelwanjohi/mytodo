import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadget_mtaa/common_widget/bg.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:gadget_mtaa/controller/productcontroller.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';
import 'package:gadget_mtaa/views/category_screen/itemdetail.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class CategoryDetsail extends StatefulWidget {
  CategoryDetsail({Key? key, required this.title}) : super(key: key);
  final String? title;

  @override
  State<CategoryDetsail> createState() => _CategoryDetsailState();
}

class _CategoryDetsailState extends State<CategoryDetsail> {
  var controller = Get.find<ProductController>();
  dynamic productmethod;
  Future? _delay;

  @override
  void initState() {
    super.initState();
    switchcategory(widget.title);
    _delay = Future.delayed(Duration(seconds: 3));
  }

  switchcategory(title) {
    if (controller.subcat.contains(title)) {
      productmethod = FirestoreServices.getsubcategoryproduct(title);
    } else {
      productmethod = FirestoreServices.allproduct();
    }
    setState(() {
      _delay = Future.delayed(Duration(seconds: 3));
    });
  }

  String getImageUrl(dynamic productData) {
    if (productData['image'] is List) {
      return productData['image'][0];
    } else if (productData['image'] is String) {
      return productData['image'];
    }
    return '';
  }

  Widget buildShimmerGrid() {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 300,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  color: Colors.white,
                ),
                const Spacer(),
                Container(
                  height: 20,
                  width: double.infinity,
                  color: Colors.white,
                ),
                10.heightBox,
                Container(
                  height: 20,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          )
              .box
              .white
              .margin(EdgeInsets.symmetric(horizontal: 4))
              .roundedSM
              .shadowSm
              .padding(EdgeInsets.all(12))
              .make(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return bg(
      child: Scaffold(
        appBar: AppBar(
          title: widget.title!.text.black.fontFamily(bold).make(),
          foregroundColor: whiteColor,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.subcat.length,
                  (index) => controller.subcat[index]
                      .toString()
                      .text
                      .size(12)
                      .fontFamily(semibold)
                      .color(darkFontGrey)
                      .makeCentered()
                      .box
                      .white
                      .rounded
                      .size(120, 60)
                      .margin(EdgeInsets.symmetric(horizontal: 4))
                      .make()
                      .onTap(() {
                    switchcategory("${controller.subcat[index]}");
                    setState(() {});
                  }),
                ),
              ),
            ),
            20.heightBox,
            StreamBuilder(
              stream: productmethod,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return FutureBuilder(
                  future: _delay,
                  builder: (context, delaySnapshot) {
                    if (delaySnapshot.connectionState != ConnectionState.done) {
                      return Expanded(child: buildShimmerGrid());
                    } else {
                      if (!snapshot.hasData) {
                        return Expanded(child: buildShimmerGrid());
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Expanded(
                          child: Center(
                            child: "No products found"
                                .text
                                .color(darkFontGrey)
                                .make(),
                          ),
                        );
                      } else {
                        // Convert QuerySnapshot to List and shuffle
                        List<QueryDocumentSnapshot> shuffledData =
                            snapshot.data!.docs.toList()..shuffle();

                        return Expanded(
                          child: Container(
                            color: whiteColor,
                            child: GridView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: shuffledData.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 300,
                              ),
                              itemBuilder: (context, index) {
                                String imageUrl =
                                    getImageUrl(shuffledData[index]);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        imageUrl,
                                        width: double.infinity,
                                        height: 180,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.error),
                                          );
                                        },
                                      ),
                                    ),
                                    const Spacer(),
                                    "${shuffledData[index]['title']}"
                                        .text
                                        .fontFamily(semibold)
                                        .color(darkFontGrey)
                                        .make(),
                                    10.heightBox,
                                    "${shuffledData[index]['price']}"
                                        .numCurrency
                                        .text
                                        .color(redColor)
                                        .fontFamily(bold)
                                        .size(16)
                                        .make(),
                                  ],
                                )
                                    .box
                                    .white
                                    .margin(EdgeInsets.symmetric(horizontal: 4))
                                    .roundedSM
                                    .shadowSm
                                    .padding(EdgeInsets.all(12))
                                    .make()
                                    .onTap(() {
                                  controller.checkfav(shuffledData[index]);
                                  Get.to(() => ItemDetail(
                                        title:
                                            "${shuffledData[index]['title']}",
                                        data: shuffledData[index],
                                      ));
                                });
                              },
                            ).box.margin(EdgeInsets.all(9)).make(),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
