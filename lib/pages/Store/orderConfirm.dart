// ignore_for_file: unused_import, must_be_immutable, unused_local_variable

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:quickalert/quickalert.dart';

import 'package:http/http.dart' as http;
import '../../dB/constants.dart';
import '../../main.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:badges/badges.dart' as badges;

class OrderConfirm extends StatefulWidget {
  var total_price;
  int accepter;
  final Function refresh;
  List products;

  OrderConfirm(
      {Key? key,
      required this.total_price,
      required this.products,
      required this.accepter,
      required this.refresh})
      : super(key: key);
  @override
  State<OrderConfirm> createState() => _OrderConfirmState();
}

final noteController = TextEditingController();
final addressController = TextEditingController();
final dateinput = TextEditingController();

class _OrderConfirmState extends State<OrderConfirm> {
  @override
  Widget build(BuildContext context) {
    print(widget.products);
    showSuccessAlert() {
      QuickAlert.show(
          context: context,
          title: '',
          text: 'Siziň sargydyňyz kabul edildi!',
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColor,
          type: QuickAlertType.success,
          onConfirmBtnTap: () {
            widget.refresh();
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          });
    }

    showWarningAlert(String text) {
      QuickAlert.show(
          context: context,
          title: 'Sargyt et.',
          text: text,
          confirmBtnText: 'Dowam et',
          confirmBtnColor: CustomColors.appColor,
          type: QuickAlertType.warning);
    }

    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
            title: Text(
          "Sargyt et",
          style: TextStyle(color: CustomColors.appColorWhite),
        )),
        body: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(childCount: 1,
                  (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Card(
                color: CustomColors.appColorWhite,
                shadowColor: const Color.fromARGB(255, 200, 198, 198),
                surfaceTintColor: CustomColors.appColorWhite,
                elevation: 5,
                child: Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Center(
                                      child: TextField(
                                    controller:
                                        dateinput, //editing controller of this TextField
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelStyle: TextStyle(
                                            color: CustomColors.appColor),
                                        labelText: "Wagt saýlaň"),
                                    readOnly: true,
                                    onTap: () async {
                                      dateTimePickerWidget(context);
                                    },
                                  ))),
                              SizedBox(height: 10),
                              Text("Salgyňyz",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: CustomColors.appColor)),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 8,
                                  controller: addressController,
                                  decoration: const InputDecoration(
                                      hintText: '',
                                      border: InputBorder.none,
                                      focusColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.only(left: 10)),
                                ),
                              )
                            ])),
                    Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Text("Bellik",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: CustomColors.appColor)),
                                child: TextFormField(
                                  autocorrect: false,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 8,
                                  controller: noteController,
                                  decoration: const InputDecoration(
                                      hintText: '',
                                      border: InputBorder.none,
                                      focusColor: Colors.white,
                                      contentPadding:
                                          EdgeInsets.only(left: 10)),
                                ),
                              )
                            ])),
                    Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "JEMI: " + widget.total_price.toString() + " TMT",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.centerLeft),
                  ],
                ),
              ),
            );
          })),
        ]),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.green,
            label: const Text('Sargyt et',
                style: TextStyle(color: CustomColors.appColorWhite)),
            onPressed: () async {
              if (addressController.text == '') {
                showWarningAlert('Salgyňyz hökmany!');
                return null;
              }
              if (dateinput.text == '') {
                showWarningAlert('Sargydyň wagty hökmany!');
                return null;
              }

              List products = [];
              widget.products.forEach((element) {
                products.add(
                    {'product': element['id'], 'amount': element['amount']});
              });

              final store_id = await get_store_id();

              var formData = {
                'note': noteController.text,
                'address': addressController.text,
                'delivery_time': dateinput.text,
                'sender': store_id,
                'accepter': widget.accepter,
                'products': products
              };

              final uri = Uri.parse(orderAddUrl);

              Map<String, String> headers = {};
              for (var i in global_headers.entries) {
                headers[i.key] = i.value.toString();
              }
              headers['Token'] = await get_access_token();
              headers['Content-Type'] = "application/json";
              var req = await http.post(uri,
                  headers: headers, body: jsonEncode(formData));
              print(jsonDecode(utf8.decode(req.bodyBytes)));
              if (req.statusCode == 200) {
                showSuccessAlert();
              } else {
                showWarningAlert(
                    'Bagyşlaň ýalňyşlyk ýüze çykdy. Täzeden synanşyp görüň!');
              }
            }));
  }

  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'yyyy-MM-dd HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('yyyy-MM-dd HH:mm').format(selectdate);
        setState(() {
          dateinput.text = selIOS;
        });
      },
    );
  }
}
