// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/AwtoCar/edit.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../../main.dart';
import '../../../widgets/inputText.dart';
import '../../customCheckbox.dart';
import '../loadingWidget.dart';

class RealEstateEdit extends StatefulWidget {
  var old_data;
  final Function callbackFunc;
  RealEstateEdit({Key? key, required this.old_data, required this.callbackFunc})
      : super(key: key);

  @override
  State<RealEstateEdit> createState() =>
      _RealEstateEditState(old_data: old_data, callbackFunc: callbackFunc);
}

class _RealEstateEditState extends State<RealEstateEdit> {
  final Function callbackFunc;
  int _value = 1;
  bool canUpload = false;
  var baseurl = "";
  var old_data;
  List<dynamic> categories = [];
  List<dynamic> remont_states = [];
  List<dynamic> locations = [];

  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final squareController = TextEditingController();
  final priceController = TextEditingController();
  final personController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  final floorController = TextEditingController();
  final atFloorController = TextEditingController();
  final roomCountController = TextEditingController();
  final documentsController = TextEditingController();

  List<dynamic> stores = [];
  var storesController = {};
  callbackStores(new_value) {
    setState(() {
      storesController = new_value;
    });
  }

  var typeFlatsController = {};
  var remontStateController = {};
  var locationController = {};

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
      locationController = new_value;
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

  callbackDocument() {
    setState(() {
      document = !document;
    });
  }

  setAddress(new_value) {
    setState(() {
      addressController.text = new_value;
    });
  }

  remove_image(value) {
    setState(() {
      old_data['images'].remove(value);
    });
  }

  int _mainImg = 0;

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

  bool status = false;
  callbackStatus() {
    setState(() {
      status = true;
    });
  }

  setName(new_value) {
    setState(() {
      nameController.text = new_value;
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

  _RealEstateEditState({required this.old_data, required this.callbackFunc});
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
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: const Text(
              "Emläk üýtgetmek",
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
                        child: Row(children: <Widget>[
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
                          child: Text("Satlyk"))
                    ])),
                    Expanded(
                        child: Row(children: <Widget>[
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
                          child: Text("Arenda"))
                    ]))
                  ])),
          InputText(
              title: "Ady",
              height: 40.0,
              callFunc: setName,
              oldData: old_data['name'].toString()),
          InputSelectText(
              title: "Dükan",
              height: 40.0,
              callFunc: callbackStores,
              items: stores,
              oldData: old_data['store_name'].toString()),
          InputSelectText(
              title: "Emläk görnüşi",
              height: 40.0,
              callFunc: callbackTypeFlats,
              items: categories,
              oldData: old_data['category'].toString()),
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
                        child: locationController['name_tm'] != null
                            ? Text(locationController['name_tm'],
                                style: TextStyle(
                                  fontSize: 16,
                                ))
                            : Text(old_data['location']))),
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
          InputText(
              title: "Salgysy",
              height: 40.0,
              callFunc: setAddress,
              oldData: old_data['address'].toString()),
          InputText(
              title: "Binadaky gat sany",
              height: 40.0,
              callFunc: setFloor,
              oldData: old_data['floor'].toString()),
          InputText(
              title: "Ýerleşýän gaty",
              height: 40.0,
              callFunc: setAtFloor,
              oldData: old_data['at_floor'].toString()),
          InputText(
              title: "Otag sany",
              height: 40.0,
              callFunc: setRoomCount,
              oldData: old_data['room_count'].toString()),
          InputText(
              title: "Meýdany",
              height: 40.0,
              callFunc: setSquare,
              oldData: old_data['square'].toString()),
          InputText(
              title: "Telefon",
              height: 40.0,
              callFunc: setPhone,
              oldData: old_data['phone'].toString()),
          InputText(
              title: "Bahasy",
              height: 40.0,
              callFunc: setPrice,
              oldData: old_data['price'].toString()),
          InputSelectText(
            title: "Remondy",
            height: 40.0,
            callFunc: callbackRemontState,
            items: remont_states,
            oldData: old_data['remont_state'],
          ),
          InputText(
              title: "Giňişleýin maglumat",
              height: 100.0,
              callFunc: setDescription,
              oldData: old_data['detail'].toString()),
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
                        status: old_data['credit']),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(
                        labelText: 'Nagt däl töleg',
                        callbackFunc: callbackNone_cash_pay,
                        status: old_data['ipoteka']),
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
                        status: old_data['swap']),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(
                        labelText: 'Eýesinden',
                        callbackFunc: callbackAtown,
                        status: old_data['own']),
                  ),
                ],
              ),
            ]
          ),
          const SizedBox(height: 10),
          if (old_data['images'].length > 0)
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "    Suratlar",
                        style: TextStyle(
                            color: CustomColors.appColors, fontSize: 16),
                      ),
                      Row(
                        children: [
                          for (var country in old_data['images'])
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, bottom: 10),
                                        height: 100,
                                        width: 100,
                                        alignment: Alignment.topLeft,
                                        child: Image.network(
                                          baseurl + country['img'].toString(),
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                          errorBuilder: (BuildContext context,
                                              Object exception,
                                              StackTrace? stackTrace) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: CustomColors.appColors,
                                              ),
                                            );
                                          },
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DeleteImage(
                                              action: 'cars',
                                              image: country,
                                              callbackFunc: remove_image,
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 110,
                                        alignment: Alignment.topRight,
                                        child: Icon(Icons.close,
                                            color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_mainImg == country['id'])
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: OutlinedButton(
                                      child: Text(
                                        "Esasy img",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 15, 138, 19),
                                        primary: Colors.green,
                                        side: BorderSide(
                                          color: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _mainImg = country['id'];
                                        });
                                      },
                                    ),
                                  )
                                else
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: OutlinedButton(
                                      child: Text("Esasy img"),
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.red,
                                        side: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _mainImg = country['id'];
                                        });
                                      },
                                    ),
                                  )
                              ],
                            )
                        ],
                      )
                    ])),
          const SizedBox(
            height: 10,
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
                  String url = server_url.get_server_url() +
                      '/mob/flats/' +
                      old_data['id'].toString();
                  final uri = Uri.parse(url);
                  var request = new http.MultipartRequest("PUT", uri);
                  var token = Provider.of<UserInfo>(context, listen: false)
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

                  if (storesController['id'] != null) {
                    request.fields['store'] = storesController['id'].toString();
                  }

                  if (remontStateController['id'] != null) {
                    request.fields['remont_state'] =
                        remontStateController['id'].toString();
                  }

                  if (typeFlatsController['id'] != null) {
                    request.fields['category'] =
                        typeFlatsController['id'].toString();
                  }

                  if (locationController['id'] != null) {
                    request.fields['location'] =
                        locationController['id'].toString();
                  }

                  if (_mainImg != 0) {
                    request.fields['img'] = _mainImg.toString();
                  }

                  if (addressController.text != '') {
                    request.fields['address'] = addressController.text;
                  }

                  if (nameController.text != '') {
                    request.fields['name'] = nameController.text;
                  }

                  if (priceController.text != '') {
                    request.fields['price'] = priceController.text;
                  }

                  if (phoneController.text != '') {
                    request.fields['phone'] = phoneController.text;
                  }

                  if (detailController.text != '') {
                    request.fields['detail'] = detailController.text;
                  }

                  if (documentsController.text != '') {
                    request.fields['documents'] = documentsController.text;
                  }

                  if (squareController.text != '') {
                    request.fields['square'] = squareController.text;
                  }

                  if (roomCountController.text != '') {
                    request.fields['room_count'] = roomCountController.text;
                  }

                  if (atFloorController.text != '') {
                    request.fields['at_floor'] = atFloorController.text;
                  }

                  if (floorController.text != '') {
                    request.fields['floor'] = floorController.text;
                  }

                  request.fields['own'] = own_num;
                  request.fields['swap'] = swap_num;
                  request.fields['credit'] = credit_num;
                  request.fields['ipoteka'] = ipoteka_num;

                  if (selectedImages.length != 0) {
                    for (var i in selectedImages) {
                      var multiport = await http.MultipartFile.fromPath(
                        'images',
                        i.path,
                        contentType: MediaType('image', 'jpeg'),
                      );
                      request.files.add(multiport);
                    }
                  }
                  showLoaderDialog(context);

                  final response = await request.send();
                  if (response.statusCode == 200) {
                    callbackFunc();
                    Navigator.pop(context);
                    showSuccess(context);
                  } else {
                    Navigator.pop(context);
                    showConfirmationDialogError(context);
                  }
                },
                child: const Text(
                  'Ýatda sakla',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  showSuccess(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessPopup();
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
      baseurl = server_url.get_server_url();
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
    headers['token'] = data[0]['name'];
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      stores = json['data']['stores'];
    });
    Provider.of<UserInfo>(context, listen: false)
        .setAccessToken(data[0]['name'], data[0]['age']);
  }
}
