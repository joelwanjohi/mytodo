import 'package:gadget_mtaa/consts/consts.dart';

Widget orderstatus({icon, color, title, showdone}) {
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ).box.padding(EdgeInsets.all(4)).roundedSM.border(color: color).make(),
    trailing: SizedBox(
      height: 100,
      width: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          "${title}".text.color(darkFontGrey).make(),
          showdone
              ? const Icon(
                  Icons.done,
                  color: redColor,
                )
              : Container(),
        ],
      ),
    ),
  );
}
