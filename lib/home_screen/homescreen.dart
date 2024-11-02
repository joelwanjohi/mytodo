import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadget_mtaa/common_widget/featurebtn.dart';
import 'package:gadget_mtaa/consts/colors.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:gadget_mtaa/consts/iconlist.dart';
import 'package:gadget_mtaa/controller/homecontroller.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';
import 'package:gadget_mtaa/views/category_screen/itemdetail.dart';
import 'package:gadget_mtaa/views/home_screen/search_screen.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/productcontroller.dart';
import '../whishlist_screen/whishlist_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProductController());
    var hcontroller = Get.put(HomeController());

    return Container(
      padding: EdgeInsets.all(12),
      color: whiteColor,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(children: [
          10.heightBox,
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Discover".text.fontWeight(FontWeight.w900).size(27).make(),
                ],
              ),
              Spacer(),
              15.widthBox,
              Icon(Icons.favorite_outlined, color: Colors.teal).onTap(() {
                Get.to(() => WhishlistScreen());
              }),
            ],
          ),
          10.heightBox,
          Container(
            alignment: Alignment.center,
            height: 60,
            color: whiteColor,
            child: Container(
              height: 40,
              child: TextFormField(
                controller: hcontroller.searchcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green, width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  suffixIcon: Icon(Icons.search_sharp).onTap(() {
                    if (hcontroller.searchcontroller.text.isNotEmpty) {
                      Get.to(() => SearchScreen(
                          title: hcontroller.searchcontroller.text));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchhint,
                  hintStyle: TextStyle(color: textfieldGrey),
                  isDense: false,
                ),
              ),
            ),
          ),
          10.heightBox,
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  VxSwiper.builder(
                    aspectRatio: 16 / 9,
                    autoPlay: true,
                    height: 150,
                    enlargeCenterPage: true,
                    itemCount: sliderlist.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        sliderlist[index],
                        fit: BoxFit.fill,
                      )
                          .box
                          .rounded
                          .clip(Clip.antiAlias)
                          .margin(EdgeInsets.symmetric(horizontal: 8))
                          .make();
                    },
                  ),
                  20.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: featurecategory.text
                        .color(darkFontGrey)
                        .size(18)
                        .fontFamily(semibold)
                        .make(),
                  ),
                  20.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(4),
                          height: 51,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: featurebtn(
                            icon: featureimage1[index],
                            title: featuretitle1[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                  20.heightBox,
                  Container(
                    padding: EdgeInsets.all(12),
                    width: double.infinity,
                    color: const Color.fromARGB(255, 3, 76, 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Featured Products"
                            .text
                            .black
                            .fontFamily(bold)
                            .size(18)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                            future: FirestoreServices.getfeatureproduct(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return Row(
                                  children: List.generate(
                                    9,
                                    (index) => Shimmer.fromColors(
                                      baseColor: Colors.white.withOpacity(0.4),
                                      highlightColor:
                                          Colors.white.withOpacity(0.2),
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                // Shuffle the featured products
                                var featuredata = snapshot.data!.docs;
                                featuredata.shuffle();

                                return Row(
                                  children: List.generate(
                                    featuredata.length,
                                    (index) => GestureDetector(
                                      onTap: () {
                                        Get.to(() => ItemDetail(
                                              title:
                                                  "${featuredata[index]['title']}",
                                              data: featuredata[index],
                                            ));
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white,
                                              ),
                                              child: ClipOval(
                                                child: SizedBox(
                                                  width: 120,
                                                  height: 120,
                                                  child: Image.network(
                                                    featuredata[index]['image'],
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Center(
                                                          child: Icon(
                                                              Icons.error));
                                                    },
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              left: 0,
                                              right: 0,
                                              child: Container(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 2),
                                                child: Column(
                                                  children: [
                                                    "${featuredata[index]['title']}"
                                                        .text
                                                        .white
                                                        .fontFamily(semibold)
                                                        .maxLines(1)
                                                        .overflow(TextOverflow
                                                            .ellipsis)
                                                        .size(12)
                                                        .make(),
                                                    "${featuredata[index]['price']}"
                                                        .numCurrency
                                                        .text
                                                        .white
                                                        .fontFamily(bold)
                                                        .size(14)
                                                        .make(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: "All Products"
                        .text
                        .size(18)
                        .fontFamily(bold)
                        .color(darkFontGrey)
                        .make(),
                  ),
                  20.heightBox,
                  StreamBuilder(
                    stream: FirestoreServices.allproduct(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 6,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                color: Colors.white,
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
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: "No Products Available"
                              .text
                              .color(darkFontGrey)
                              .makeCentered(),
                        );
                      } else {
                        // Shuffle the all products data
                        var allproductdata = snapshot.data!.docs;
                        allproductdata.shuffle();

                        return GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allproductdata.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            mainAxisExtent: 300,
                          ),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    allproductdata[index]['image'],
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Spacer(),
                                "${allproductdata[index]['title']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                10.heightBox,
                                "${allproductdata[index]['price']}"
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
                              Get.to(() => ItemDetail(
                                  title: "${allproductdata[index]['title']}",
                                  data: allproductdata[index]));
                            });
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
