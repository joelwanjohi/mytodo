import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:intl/intl.dart' as intl;

Widget Senderbubble(DocumentSnapshot data) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);
  return Directionality(
    textDirection: TextDirection.ltr,
    child: Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: data['uid'] == currentuser!.uid ? redColor : darkFontGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "${data['msg']}".text.white.size(16).make(),
          10.heightBox,
          "${time}".text.color(whiteColor.withOpacity(0.5)).make()
        ],
      ),
    ),
  );
}
