import 'package:flutter/material.dart';
import 'package:gadget_mtaa/consts/colors.dart';
import 'package:gadget_mtaa/consts/consts.dart';
import 'package:gadget_mtaa/views/order_screen/components/order_status.dart';
import 'package:gadget_mtaa/views/order_screen/components/orderplace_detail.dart';
import 'package:intl/intl.dart' as intl;

class OrderDetail extends StatelessWidget {
  final dynamic data;
  const OrderDetail({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Detail".text.fontFamily(semibold).make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              orderstatus(
                  color: redColor,
                  icon: Icons.done,
                  showdone: data['order_place'],
                  title: "Placed"),
              orderstatus(
                  color: Colors.blue,
                  icon: Icons.thumb_up,
                  showdone: data['order_confirm'],
                  title: "Confirm"),
              orderstatus(
                  color: Colors.yellow,
                  icon: Icons.car_crash,
                  showdone: data['order_on_delivery'],
                  title: "On Delivery"),
              orderstatus(
                  color: Colors.purple,
                  icon: Icons.done_all_rounded,
                  showdone: data['order_delivered'],
                  title: "Delivered"),
              Divider(),
              10.heightBox,
              Column(
                children: [
                  orderplacedetail(
                      data: data,
                      title1: "Order Code",
                      title2: "Shipping Method",
                      d1: data['order_code'],
                      d2: data['shipping_method']),
                  orderplacedetail(
                      data: data,
                      title1: "Order Date",
                      title2: "Payment Method",
                      d1: intl.DateFormat()
                          .add_yMd()
                          .format(data['order_date'].toDate()),
                      d2: data['payment_method']),
                  orderplacedetail(
                      data: data,
                      title1: "Payment Status",
                      title2: "Delivery Status",
                      d1: "unPaid",
                      d2: "order placed"),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontFamily(semibold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 130,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontFamily(semibold).make(),
                              "${data['total_amount']}"
                                  .text
                                  .color(redColor)
                                  .fontFamily(bold)
                                  .make(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ).box.white.shadowMd.make(),
              Divider(),
              10.heightBox,
              "Ordered Product"
                  .text
                  .size(16)
                  .color(darkFontGrey)
                  .fontFamily(semibold)
                  .makeCentered(),
              10.heightBox,
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderplacedetail(
                          title1: data['orders'][index]['title'],
                          title2: data['orders'][index]['tprice'],
                          d1: "${data['orders'][index]['qty']}x",
                          d2: "Refundable"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 30,
                          height: 20,
                          color: Color(data['orders'][index]['color']),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList(),
              ).box.white.shadowMd.margin(EdgeInsets.only(bottom: 4)).make(),
              20.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
