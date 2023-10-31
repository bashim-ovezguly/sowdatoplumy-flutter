import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/widgets/inputText.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../../main.dart';
import '../../customCheckbox.dart';
import '../../select.dart';
import '../../success.dart';
import '../loadingWidget.dart';

class RealEstateAdd extends StatefulWidget {
  RealEstateAdd(
      {Key? key, required this.customer_id, required this.refreshFunc})
      : super(key: key);
  final String customer_id;
  final Function refreshFunc;
  @override
  State<RealEstateAdd> createState() =>
      _RealEstateAddState(customer_id: customer_id);
}

class _RealEstateAddState extends State<RealEstateAdd> {
  final String customer_id;
  int _value = 1;
  bool canUpload = false;

  var data = {};
  List<dynamic> categories = [];
  List<dynamic> remont_states = [];

  callbackStatus() {
    Navigator.pop(context);
  }

  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final squareController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  final floorController = TextEditingController();
  final atFloorController = TextEditingController();
  final roomCountController = TextEditingController();

  List<dynamic> stores = [];
  var storesController = {};
  callbackStores(new_value) {
    setState(() {
      storesController = new_value;
    });
  }

  var typeFlatsController = {};
  var remontStateController = {};
  var locationsController = {};

  callbackTypeFlats(new_value) {
    setState(() {
      typeFlatsController = new_value;
    });
  }

  callbackRemontState(new_value) {
    setState(() {
      remontStateController = new_value;
    });
  }

  callbackLocation(new_value) {
    setState(() {
      locationsController = new_value;
    });
  }

  setFloor(new_value) {
    setState(() {
      floorController.text = new_value;
    });
  }

  setAtFloor(new_value) {
    setState(() {
      atFloorController.text = new_value;
    });
  }

  setRoomCount(new_value) {
    setState(() {
      roomCountController.text = new_value;
    });
  }

  setSquare(new_value) {
    setState(() {
      squareController.text = new_value;
    });
  }

  setPhone(new_value) {
    setState(() {
      phoneController.text = new_value;
    });
  }

  setPrice(new_value) {
    setState(() {
      priceController.text = new_value;
    });
  }

  setDescription(new_value) {
    setState(() {
      detailController.text = new_value;
    });
  }

  bool credit = false;
  bool swap = false;
  bool none_cash_pay = false;
  bool own = false;
  bool document = false;

  callbackCredit() {
    setState(() {
      credit = !credit;
    });
  }

  callbackSwap() {
    setState(() {
      swap = !swap;
    });
  }

  callbackNone_cash_pay() {
    setState(() {
      none_cash_pay = !none_cash_pay;
    });
  }

  callbackAtown() {
    setState(() {
      own = !own;
    });
  }

  void initState() {
    get_flats_index();
    get_userinfo();
    super.initState();
  }

  List<File> selectedImages = [];
  final picker = ImagePicker();

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Surat saýlamadyňyz!')));
        }
      },
    );
  }

  setName(new_value) {
    setState(() {
      nameController.text = new_value;
    });
  }

  setAddress(new_value) {
    setState(() {
      addressController.text = new_value;
    });
  }

  _RealEstateAddState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: const Text(
            "Meniň sahypam",
            style: CustomText.appBarText,
          ),
        ),
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: const Text(
              "Emläk goşmak",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.appColors),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Radio(
                          splashRadius: 20.0,
                          activeColor: CustomColors.appColors,
                          value: 1,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value!;
                            });
                          }),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _value = 1;
                          });
                        },
                        child: Text("Satlyk"),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Radio(
                          splashRadius: 20.0,
                          activeColor: CustomColors.appColors,
                          value: 2,
                          groupValue: _value,
                          onChanged: (value) {
                            setState(() {
                              _value = value!;
                            });
                          }),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _value = 2;
                          });
                        },
                        child: Text("Arenda"),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          InputText(title: "Ady", height: 40.0, callFunc: setName),
          InputSelectText(
              title: "Dükan",
              height: 40.0,
              callFunc: callbackStores,
              items: stores),
          InputSelectText(
              title: "Emläk görnüşi",
              height: 40.0,
              callFunc: callbackTypeFlats,
              items: categories),
          Stack(children: <Widget>[
            GestureDetector(
                child: Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: CustomColors.appColors, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: locationsController['name_tm'] != null
                            ? Text(locationsController['name_tm'],
                                style: TextStyle(
                                  fontSize: 16,
                                ))
                            : Text(''))),
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return LocationWidget(callbackFunc: callbackLocation);
                      });
                }),
            Positioned(
                left: 25,
                top: 12,
                child: Container(
                    color: Colors.white,
                    child: Text('Ýerleşýän ýeri',
                        style: TextStyle(color: Colors.black, fontSize: 12))))
          ]),
          InputText(title: "Salgysy", height: 40.0, callFunc: setAddress),
          InputText(
              title: "Binadaky gat sany", height: 40.0, callFunc: setFloor),
          InputText(
              title: "Ýerleşýän gaty", height: 40.0, callFunc: setAtFloor),
          InputText(title: "Otag sany", height: 40.0, callFunc: setRoomCount),
          InputText(title: "Meýdany", height: 40.0, callFunc: setSquare),
          InputText(title: "Telefon", height: 40.0, callFunc: setPhone),
          InputSelectText(
              title: "Remondy",
              height: 40.0,
              callFunc: callbackRemontState,
              items: remont_states),
          InputText(
              title: "Giňişleýin maglumat",
              height: 100.0,
              callFunc: setDescription),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    child: CustomCheckBox(
                        labelText: 'Kredit',
                        callbackFunc: callbackCredit,
                        status: false),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(
                        labelText: 'Nagt däl töleg',
                        callbackFunc: callbackNone_cash_pay,
                        status: false),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    child: CustomCheckBox(
                        labelText: 'Çalyşma',
                        callbackFunc: callbackSwap,
                        status: false),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(
                        labelText: 'Eýesinden',
                        callbackFunc: callbackAtown,
                        status: false),
                  ),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedImages.map((country) {
                  return Stack(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 10, bottom: 10),
                          height: 100,
                          width: 100,
                          alignment: Alignment.topLeft,
                          child: Image.file(
                            country,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          )),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedImages.remove(country);
                          });
                        },
                        child: Container(
                          height: 100,
                          width: 110,
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColors,
                    foregroundColor: Colors.white),
                onPressed: () {
                  getImages();
                },
                child: const Text(
                  'Surat goş',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.appColors,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        Urls server_url = new Urls();
                        String url = server_url.get_server_url() + '/mob/flats';
                        final uri = Uri.parse(url);
                        var request = new http.MultipartRequest("POST", uri);
                        var token =
                            Provider.of<UserInfo>(context, listen: false)
                                .access_token;
                        Map<String, String> headers = {};
                        for (var i in global_headers.entries) {
                          headers[i.key] = i.value.toString();
                        }
                        headers['token'] = token;

                        request.headers.addAll(headers);
                        var own_num = '0';
                        if (own == true) {
                          own_num = '1';
                        }

                        var swap_num = '0';
                        if (swap == true) {
                          swap_num = '1';
                        }

                        var credit_num = '0';
                        if (credit == true) {
                          credit_num = '1';
                        }

                        var ipoteka_num = '0';
                        if (none_cash_pay == true) {
                          ipoteka_num = '1';
                        }

                        var document_num = '0';
                        if (document == true) {
                          document_num = '1';
                        }

                        if (storesController['id'] != null) {
                          request.fields['store'] =
                              storesController['id'].toString();
                        }
                        request.fields['remont_state'] =
                            remontStateController['id'].toString();
                        request.fields['category'] =
                            typeFlatsController['id'].toString();
                        request.fields['location'] =
                            locationsController['id'].toString();
                        request.fields['address'] = addressController.text;
                        request.fields['price'] = priceController.text;
                        request.fields['name'] = nameController.text;
                        request.fields['own'] = own_num;
                        request.fields['swap'] = swap_num;
                        request.fields['credit'] = credit_num;
                        request.fields['ipoteka'] = ipoteka_num;
                        request.fields['documents_ready'] = document_num;
                        request.fields['phone'] = phoneController.text;
                        request.fields['description'] = detailController.text;
                        request.fields['square'] = squareController.text;
                        request.fields['room_count'] = roomCountController.text;
                        request.fields['at_floor'] = atFloorController.text;
                        request.fields['floor'] = floorController.text;
                        request.fields['customer'] = customer_id.toString();

                        for (var i in selectedImages) {
                          var multiport = await http.MultipartFile.fromPath(
                            'images',
                            i.path,
                            contentType: MediaType('image', 'jpeg'),
                          );
                          request.files.add(multiport);
                        }
                        showLoaderDialog(context);

                        final response = await request.send();
                        if (response.statusCode == 200) {
                          widget.refreshFunc();
                          Navigator.pop(context);
                          showConfirmationDialogSuccess(context);
                        } else {
                          Navigator.pop(context);
                          showConfirmationDialogError(context);
                        }
                      },
                      child: const Text('Ýatda sakla',
                          style: TextStyle(fontWeight: FontWeight.bold)))))
        ]));
  }

  showConfirmationDialogSuccess(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessAlert(
          action: 'flats',
          callbackFunc: callbackStatus,
        );
      },
    );
  }

  showConfirmationDialogError(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();
      },
    );
  }

  void get_flats_index() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/flat';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json;
      categories = json['categories'];
      remont_states = json['remont_states'];
    });
  }

  void get_userinfo() async {
    var allRows = await dbHelper.queryAllRows();
    var data = [];
    for (final row in allRows) {
      data.add(row);
    }
    if (data.length == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
    Urls server_url = new Urls();
    String url = server_url.get_server_url() +
        '/mob/customer/' +
        data[0]['userId'].toString();
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      stores = json['data']['stores'];
    });
    Provider.of<UserInfo>(context, listen: false)
        .setAccessToken(data[0]['name'], data[0]['age']);
  }
}
