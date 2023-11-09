import 'package:flutter/material.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Car/car.dart';
import 'package:my_app/pages/Customer/myPages.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ArrivedOrderDetail extends StatefulWidget {
  final String order_id;
  final Function refresh;
  ArrivedOrderDetail({Key? key, required this.order_id, required this.refresh})
      : super(key: key);

  @override
  State<ArrivedOrderDetail> createState() => _ArrivedOrderDetailState();
}

class _ArrivedOrderDetailState extends State<ArrivedOrderDetail> {
  bool determinate = false;
  int item_count = 0;
  var shoping_carts = [];
  var array = [];
  var baseurl = "";
  var order = {};
  var products = [];
  int delivery_price_int = 0;
  var status;
  final newDeliveryPrice = TextEditingController();

  void set_order_status(value) {
    setState(() {
      status = value;
    });
  }

  void initState() {
    get_order_detail(widget.order_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showSuccessAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Sagydyň ýagdaýy üýtgedildi!',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColors,
          type: QuickAlertType.success,
          onConfirmBtnTap: () {
            Navigator.pop(context);
            get_order_detail(widget.order_id);
          });
    }

    showErrorAlert(String text) {
      QuickAlert.show(
          text: text,
          title: "Ýalňyşlyk!",
          confirmBtnColor: Colors.green,
          confirmBtnText: 'Dowam et',
          context: context,
          type: QuickAlertType.error);
    }

    showWorningAlert(String text, String id) {
      QuickAlert.show(
          title: 'Sebet ID: $id',
          text: text,
          context: context,
          confirmBtnText: 'Tassyklaýaryn',
          confirmBtnColor: Colors.green,
          onConfirmBtnTap: () async {
            Urls server_url = new Urls();
            String url = server_url.get_server_url() + '/mob/orders/delete/$id';
            final uri = Uri.parse(url);
            var responsess =
                Provider.of<UserInfo>(context, listen: false).update_tokenc();
            if (await responsess) {
              var token =
                  Provider.of<UserInfo>(context, listen: false).access_token;
              Map<String, String> headers = {};
              for (var i in global_headers.entries) {
                headers[i.key] = i.value.toString();
              }
              headers['token'] = token;
              final response = await http.post(uri, headers: headers);
              if (response.statusCode == 200) {
                widget.refresh();
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                Navigator.pop(context);
                showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');
              }
              setState(() {
                determinate = false;
              });
              get_order_detail(widget.order_id);
            }
          },
          type: QuickAlertType.info);
    }

    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text(
              'Sargyt: ' + widget.order_id.toString(),
              style: TextStyle(color: CustomColors.appColorWhite),
            ),
            actions: [
              PopupMenuButton<String>(
                shadowColor: CustomColors.appColorWhite,
                surfaceTintColor: CustomColors.appColorWhite,
                color: CustomColors.appColorWhite,
                itemBuilder: (context) {
                  List<PopupMenuEntry<String>> menuEntries2 = [
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () async {
                              Urls server_url = new Urls();
                              var id = widget.order_id;
                              String url = server_url.get_server_url() +
                                  '/mob/orders/$id';
                              final uri = Uri.parse(url);
                              var token =
                                  Provider.of<UserInfo>(context, listen: false)
                                      .access_token;
                              Map<String, String> headers = {};
                              for (var i in global_headers.entries) {
                                headers[i.key] = i.value.toString();
                              }
                              headers['token'] = token;
                              final response = await http.put(uri,
                                  headers: headers,
                                  body: {'status': 'accepted'});
                              if (response.statusCode == 200) {
                                showSuccessAlert();
                                widget.refresh();
                              } else {
                                Navigator.pop(context);
                                showErrorAlert(
                                    'Bagyşlaň ýalňyşlyk ýüze çykdy!');
                              }
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.check,
                                    size: 15,
                                    color: Colors.green,
                                  ),
                                  Text('  Kabul etmek',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.green))
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () async {
                              Urls server_url = new Urls();
                              var id = widget.order_id;
                              String url = server_url.get_server_url() +
                                  '/mob/orders/$id';
                              final uri = Uri.parse(url);
                              var token =
                                  Provider.of<UserInfo>(context, listen: false)
                                      .access_token;
                              Map<String, String> headers = {};
                              for (var i in global_headers.entries) {
                                headers[i.key] = i.value.toString();
                              }
                              headers['token'] = token;
                              final response = await http.put(uri,
                                  headers: headers,
                                  body: {'status': 'canceled'});
                              if (response.statusCode == 200) {
                                showSuccessAlert();
                                widget.refresh();
                              } else {
                                Navigator.pop(context);
                                showErrorAlert(
                                    'Bagyşlaň ýalňyşlyk ýüze çykdy!');
                              }
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(
                                    Icons.close,
                                    size: 15,
                                    color: Color.fromARGB(255, 201, 159, 31),
                                  ),
                                  Text('  Gaýtarmak',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              255, 201, 159, 31)))
                                ])))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () {
                              showWorningAlert('Sargydy pozmagy tassyklaň!',
                                  order['id'].toString());
                            },
                            child: Container(
                              color: Colors.white,
                              height: 40,
                              width: double.infinity,
                              child: Row(children: [
                                Icon(
                                  Icons.delete,
                                  size: 15,
                                  color: Colors.red,
                                ),
                                Text('  Pozmak',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.red))
                              ]),
                            ))),
                    PopupMenuItem<String>(
                        child: GestureDetector(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shadowColor: CustomColors.appColorWhite,
                                      surfaceTintColor:
                                          CustomColors.appColorWhite,
                                      backgroundColor:
                                          CustomColors.appColorWhite,
                                      title: Text("Eltip bermek bahasy."),
                                      content: Container(
                                        child: TextFormField(
                                          controller: newDeliveryPrice,
                                          decoration: new InputDecoration(
                                              labelText: "Täze baha"),
                                        ),
                                      ),
                                      actions: [
                                        Align(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white),
                                            onPressed: () async {
                                              var token = Provider.of<UserInfo>(
                                                      context,
                                                      listen: false)
                                                  .access_token;
                                              Urls server_url = new Urls();
                                              var id = widget.order_id;
                                              String url =
                                                  server_url.get_server_url() +
                                                      '/mob/orders/$id';
                                              final uri = Uri.parse(url);
                                              Map<String, String> headers = {};
                                              for (var i
                                                  in global_headers.entries) {
                                                headers[i.key] =
                                                    i.value.toString();
                                              }
                                              headers['token'] = token;
                                              final response = await http.put(
                                                  uri,
                                                  headers: headers,
                                                  body: {
                                                    'delivery_price':
                                                        newDeliveryPrice.text
                                                            .toString()
                                                  });
                                              if (response.statusCode == 200) {
                                                get_order_detail(
                                                    widget.order_id);
                                                Navigator.pop(context);
                                              } else {
                                                showErrorAlert(
                                                    'Bagyşlaň ýalňyşlyk ýüze çykdy!');
                                              }
                                            },
                                            child: const Text('Tassyklamak'),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                            child: Container(
                                color: Colors.white,
                                height: 40,
                                width: double.infinity,
                                child: Row(children: [
                                  Icon(Icons.edit,
                                      size: 15, color: Colors.blueAccent),
                                  Text('  Eltip bermek bahasy',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blueAccent))
                                ])))),
                  ];
                  return menuEntries2;
                },
              )
            ]),
        body: RefreshIndicator(
            color: Colors.white,
            backgroundColor: CustomColors.appColors,
            onRefresh: () async {
              setState(() {
                get_order_detail(widget.order_id);
              });
              return Future<void>.delayed(const Duration(seconds: 3));
            },
            child: determinate
                ? CustomScrollView(slivers: [
                    SliverList(
                        delegate: SliverChildBuilderDelegate(childCount: 1,
                            (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<UserInfo>(context, listen: false)
                                  .set_user_customer_name(
                                      order['customer']['name']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyPages(
                                          user_customer_id: order['customer']
                                                  ['id']
                                              .toString())));
                            },
                            child: Card(
                              color: CustomColors.appColorWhite,
                              surfaceTintColor: CustomColors.appColorWhite,
                              shadowColor: CustomColors.appColorWhite,
                              elevation: 5,
                              child: Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.only(left: 5),
                                child: Row(children: [
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                        Text(
                                            order['customer']['name']
                                                .toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 16)),
                                        Text(
                                            order['customer']['phone']
                                                .toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 16))
                                      ])),
                                  Spacer(),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.centerRight,
                                    child: FloatingActionButton.small(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(100),
                                                bottomLeft:
                                                    Radius.circular(100),
                                                bottomRight:
                                                    Radius.circular(100),
                                                topLeft: Radius.circular(100))),
                                        backgroundColor: Colors.green,
                                        onPressed: () async {
                                          final call =
                                              Uri.parse('tel:' + order['customer']['phone'].toString());
                                          if (await canLaunchUrl(call)) {
                                            launchUrl(call);
                                          } else {
                                            throw 'Could not launch $call';
                                          }
                                        },
                                        child: Icon(Icons.phone_enabled,
                                            color: Colors.white)),
                                  )),
                                ]),
                              ),
                            ),
                          ));
                    })),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(childCount: 1,
                            (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        if (order['status'] == 'accepted')
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: const Text("Kabul edilen",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 160, 121, 3)))),
                                        if (order['status'] == 'canceled')
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: 5),
                                              child: const Text("Gaýtarylan",
                                                  style: TextStyle(
                                                      color: Colors.red))),
                                        if (order['status'] == 'pending')
                                          Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: const Text("Garaşylýar",
                                                  style: TextStyle(
                                                      color: Colors.green))),
                                        Spacer(),
                                        Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: Text(
                                                order['created_at'].toString(),
                                                style: TextStyle(
                                                    color: CustomColors
                                                        .appColorWhite)))
                                      ])
                                    ]),
                                Container(
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Text("Harytlaryň bahasy:",
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15)),
                                            Spacer(),
                                            Text(
                                                order['product_total']
                                                        .toString() +
                                                    " TMT",
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15))
                                          ]),
                                          Row(children: [
                                            Text("Eltip bermek bahasy:",
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15)),
                                            Spacer(),
                                            Text(
                                                order['delivery_price']
                                                        .toString() +
                                                    " TMT",
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15))
                                          ]),
                                          Row(children: [
                                            Text("Umumy töleg:",
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15)),
                                            Spacer(),
                                            Text(
                                                order['total'].toString() +
                                                    " TMT",
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.appColors,
                                                    fontSize: 15))
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Text(
                                            "Bellik: " +
                                                order['note'].toString(),
                                            style: TextStyle(
                                                color: CustomColors.appColors,
                                                fontSize: 15)))),
                                Container(
                                    margin: EdgeInsets.only(
                                        right: 10, top: 5, bottom: 5),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        order['product_count'].toString() +
                                            " sany haryt",
                                        style: TextStyle(
                                            color: CustomColors.appColors,
                                            fontSize: 15)))
                              ]));
                    })),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: products.length,
                            (BuildContext context, int index) {
                      return Container(
                          height: 110,
                          child: Card(
                              color: CustomColors.appColorWhite,
                              shadowColor:
                                  const Color.fromARGB(255, 200, 198, 198),
                              surfaceTintColor: CustomColors.appColorWhite,
                              elevation: 4,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                child: Row(children: [
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                          child: Image.network(
                                              baseurl +
                                                  products[index]['img']
                                                      .toString(),
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: CustomColors.appColors,
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
                                      }, height: 110, fit: BoxFit.cover))),
                                  Expanded(
                                      flex: 5,
                                      child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child: Column(children: [
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        products[index]['name']
                                                            .toString(),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: CustomText
                                                            .size_16))),
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        products[index]['price']
                                                                .toString() +
                                                            ' TMT',
                                                        style: CustomText
                                                            .size_16))),
                                            Expanded(
                                                flex: 3,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        products[index]['total']
                                                                .toString() +
                                                            ' TMT',
                                                        style:
                                                            CustomText.size_16),
                                                    Spacer(),
                                                    Expanded(
                                                        flex: 3,
                                                        child: Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              if (order[
                                                                      'status'] ==
                                                                  'pending')
                                                                Expanded(
                                                                    child:
                                                                        GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    // Decrement Item count ------
                                                                    if (products[index]
                                                                            [
                                                                            'amount'] >
                                                                        1) {
                                                                      var amount =
                                                                          products[index]['amount'].toInt() -
                                                                              1;
                                                                      var id = products[
                                                                              index]
                                                                          [
                                                                          'id'];
                                                                      Urls
                                                                          server_url =
                                                                          new Urls();
                                                                      String
                                                                          url =
                                                                          server_url.get_server_url() +
                                                                              '/mob/orders/products/$id';
                                                                      final uri =
                                                                          Uri.parse(
                                                                              url);
                                                                      var token = Provider.of<UserInfo>(
                                                                              context,
                                                                              listen: false)
                                                                          .access_token;
                                                                      Map<String,
                                                                              String>
                                                                          headers =
                                                                          {};
                                                                      for (var i
                                                                          in global_headers
                                                                              .entries) {
                                                                        headers[
                                                                            i
                                                                                .key] = i
                                                                            .value
                                                                            .toString();
                                                                      }
                                                                      headers['token'] =
                                                                          token;

                                                                      final response = await http.put(
                                                                          uri,
                                                                          headers:
                                                                              headers,
                                                                          body: {
                                                                            'amount':
                                                                                amount.toString()
                                                                          });
                                                                      if (response
                                                                              .statusCode ==
                                                                          200) {
                                                                        get_order_detail(
                                                                            widget.order_id);
                                                                      } else {
                                                                        showErrorAlert(
                                                                            'Bagyşlaň ýalňyşlyk ýüze çykdy');
                                                                      }
                                                                    } else {
                                                                      showErrorAlert(
                                                                          'Harydyň sany birden az bolup bilmeýär');
                                                                    }
                                                                  },
                                                                  child: Container(
                                                                      height:
                                                                          35,
                                                                      width: 50,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              5),
                                                                          border: Border.all(
                                                                              color: Color.fromARGB(255, 155, 154,
                                                                                  154))),
                                                                      child: Icon(
                                                                          Icons
                                                                              .remove,
                                                                          color: Colors
                                                                              .green,
                                                                          size:
                                                                              20)),
                                                                )),
                                                              Expanded(
                                                                  child: Align(
                                                                      child: Text(
                                                                          products[index]['amount']
                                                                              .toString(),
                                                                          style:
                                                                              CustomText.size_16))),
                                                              if (order[
                                                                      'status'] ==
                                                                  'pending')
                                                                Expanded(
                                                                    child:
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () async {
                                                                              // Increment Item count ++++++
                                                                              var id = products[index]['id'];
                                                                              var amount = products[index]['amount'].toInt() + 1;
                                                                              Urls server_url = new Urls();
                                                                              String url = server_url.get_server_url() + '/mob/orders/products/$id';
                                                                              final uri = Uri.parse(url);
                                                                              var token = Provider.of<UserInfo>(context, listen: false).access_token;
                                                                              Map<String, String> headers = {};
                                                                              for (var i in global_headers.entries) {
                                                                                headers[i.key] = i.value.toString();
                                                                              }
                                                                              headers['token'] = token;
                                                                              final response = await http.put(uri, headers: headers, body: {
                                                                                'amount': amount.toString()
                                                                              });
                                                                              if (response.statusCode == 200) {
                                                                                get_order_detail(widget.order_id);
                                                                              } else {
                                                                                showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');
                                                                              }
                                                                            },
                                                                            child: Container(
                                                                                height: 35,
                                                                                width: 50,
                                                                                alignment: Alignment.center,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Color.fromARGB(255, 155, 154, 154))),
                                                                                child: Icon(Icons.add, color: Colors.green, size: 20))))
                                                            ],
                                                          ),
                                                        )),
                                                    if (order['status'] ==
                                                        'pending')
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                              child:
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        // Detele Item
                                                                        var id =
                                                                            products[index]['id'];
                                                                        Urls
                                                                            server_url =
                                                                            new Urls();
                                                                        String
                                                                            url =
                                                                            server_url.get_server_url() +
                                                                                '/mob/orders/products/delete/$id';
                                                                        final uri =
                                                                            Uri.parse(url);
                                                                        var token =
                                                                            Provider.of<UserInfo>(context, listen: false).access_token;
                                                                        Map<String,
                                                                                String>
                                                                            headers =
                                                                            {};
                                                                        for (var i
                                                                            in global_headers.entries) {
                                                                          headers[i.key] = i
                                                                              .value
                                                                              .toString();
                                                                        }
                                                                        headers['token'] =
                                                                            token;
                                                                        final response = await http.post(
                                                                            uri,
                                                                            headers:
                                                                                headers);
                                                                        if (response.statusCode ==
                                                                            200) {
                                                                          setState(
                                                                              () {
                                                                            determinate =
                                                                                false;
                                                                          });
                                                                          get_order_detail(
                                                                              widget.order_id);
                                                                        } else {
                                                                          showErrorAlert(
                                                                              'Bagyşlaň ýalňyşlyk ýüze çykdy');
                                                                        }
                                                                      },
                                                                      child: Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color: Colors
                                                                              .red,
                                                                          size:
                                                                              30))))
                                                  ],
                                                ))
                                          ]))),
                                ]),
                              )));
                    })),
                  ])
                : Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.appColors))));
  }

  get_order_detail(String order_id) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/orders/$order_id';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    print(json);
    setState(() {
      baseurl = server_url.get_server_url();
      order = json['data'];
      products = json['data']['products'];
      item_count = products.length;
      determinate = true;
    });
  }
}
