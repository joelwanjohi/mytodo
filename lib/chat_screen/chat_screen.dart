// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:gadget_mtaa/consts/colors.dart';
import 'package:gadget_mtaa/consts/firebaseconst.dart';
import 'package:gadget_mtaa/consts/styles.dart';
import 'package:gadget_mtaa/controller/chats_controller.dart';
import 'package:gadget_mtaa/services/firestore_services.dart';
import 'package:gadget_mtaa/views/chat_screen/components/sender_bubble.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.friendname}"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Obx(
              () => controller.isloadind.value
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    ))
                  : Expanded(
                      child: StreamBuilder(
                          stream: FirestoreServices.getchatsmsg(
                              controller.chatdocid.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                  child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(redColor),
                              ));
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: "Send a message..."
                                    .text
                                    .color(darkFontGrey)
                                    .make(),
                              );
                            } else {
                              return ListView(
                                children: snapshot.data!.docs
                                    .mapIndexed((currentValue, index) {
                                  var data = snapshot.data!.docs[index];

                                  return Align(
                                      alignment: data['uid'] == currentuser!.uid
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Senderbubble(data));
                                }).toList(),
                              );
                            }
                          })),
            ),
            10.heightBox,
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.msgcontroller,
                  decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: textfieldGrey,
                      )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: textfieldGrey,
                      ))),
                )),
                IconButton(
                    onPressed: () {
                      controller.sendmsg(controller.msgcontroller.text);
                      controller.msgcontroller.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: redColor,
                    ))
              ],
            )
                .box
                .height(80)
                .margin(EdgeInsets.only(bottom: 8))
                .padding(EdgeInsets.all(12))
                .make(),
          ],
        ),
      ),
    );
  }
}
