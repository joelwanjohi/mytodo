import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';
import 'package:gadget_mtaa/views/chat_screen/chat_screen.dart';
import 'package:get/get.dart';

import '../../consts/consts.dart';

class MsgScreen extends StatelessWidget {
  const MsgScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title:
            "My Messages".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
          stream: FirestoreServices.getallmsg(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: "No Messages yet!".text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: ((context, index) {
                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    Get.to(
                                      () => ChatScreen(),
                                      arguments: [
                                        data[index]['friend_name'],
                                        data[index]['toid']
                                      ],
                                    );
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: redColor,
                                    child: Icon(
                                      Icons.person,
                                      color: whiteColor,
                                    ),
                                  ),
                                  title: "${data[index]['friend_name']}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  subtitle:
                                      "${data[index]['last_msg']}".text.make(),
                                ),
                              );
                            })))
                  ],
                ),
              );
            }
          }),
    );
  }
}
