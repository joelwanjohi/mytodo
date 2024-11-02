import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../category_screen/itemdetail.dart';

class SearchScreen extends StatelessWidget {
  final String? title;
  const SearchScreen({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: title!.text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: FutureBuilder(
          future: FirestoreServices.searchproduct(title),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ));
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child:
                    "No Product Found".text.color(darkFontGrey).makeCentered(),
              );
            } else {
              var data = snapshot.data!.docs;
              var fdata = data
                  .where((element) => element['title']
                      .toString()
                      .toLowerCase()
                      .contains(title!.toLowerCase()))
                  .toList();
              if (fdata.length > 0) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        mainAxisExtent: 300),
                    children: fdata.mapIndexed((currentValue, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            fdata[index]['image'][0],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const Spacer(),
                          "${fdata[index]['title']}"
                              .text
                              .fontFamily(semibold)
                              .color(darkFontGrey)
                              .make(),
                          10.heightBox,
                          "${fdata[index]['price']}"
                              .text
                              .color(redColor)
                              .fontFamily(bold)
                              .size(16)
                              .make(),
                        ],
                      )
                          .box
                          .white
                          .shadowMd
                          .margin(EdgeInsets.symmetric(horizontal: 4))
                          .roundedSM
                          .padding(EdgeInsets.all(12))
                          .make()
                          .onTap(() {
                        Get.to(() => ItemDetail(
                              title: "${fdata[index]['title']}",
                              data: fdata[index],
                            ));
                      });
                    }).toList(),
                  ),
                );
              } else {
                return Center(
                  child: "No Product Found"
                      .text
                      .color(darkFontGrey)
                      .makeCentered(),
                );
              }
            }
          }),
    );
  }
}
