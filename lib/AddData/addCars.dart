import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/dB/providers.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/customCheckbox.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/pages/homePageLocation.dart';
import 'package:my_app/pages/select.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class AddCars extends StatefulWidget {
  const AddCars({super.key});

  @override
  State<AddCars> createState() => _AddCarsState();
}

class _AddCarsState extends State<AddCars> {
  List<dynamic> models = [];
  List<dynamic> marks = [];
  List<dynamic> body_types = [];
  List<dynamic> fruits = [];
  List<dynamic> colors = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  List<File> selectedImages = [];
  List<dynamic> stores = [];

  var storesController = {};
  var locationController = {};
  var markaController = {};
  var modelController = {};
  var colorController = {};
  var body_typeController = {};
  var transmissionController = {};
  var wdController = {};

  final picker = ImagePicker();
  final yearController = TextEditingController();
  final priceController = TextEditingController();
  final millageController = TextEditingController();
  final engineController = TextEditingController();
  final phoneController = TextEditingController();
  final vinCodeController = TextEditingController();
  final detailController = TextEditingController();
  bool credit = false;
  bool swap = false;
  bool none_cash_pay = false;
  bool recolored = false;

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

  void initState() {
    get_cars_index();
    get_userinfo();
    super.initState();
  }

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

  callbackRecolored() {
    setState(() {
      recolored = !recolored;
    });
  }

  callbackStores(new_value) {
    setState(() {
      storesController = new_value;
    });
  }

  callbackModel(new_value) {
    setState(() {
      modelController = new_value;
    });
  }

  callbackWd(new_value) {
    setState(() {
      wdController = new_value;
    });
  }

  callbackLocation(new_value) {
    setState(() {
      locationController = new_value;
    });
  }

  callbackColor(new_value) {
    setState(() {
      colorController = new_value;
    });
  }

  callbackBodyType(new_value) {
    setState(() {
      body_typeController = new_value;
    });
  }

  callbackTransmission(new_value) {
    setState(() {
      transmissionController = new_value;
    });
  }

  callbackMarka(new_value) async {
    setState(() {
      markaController = new_value;
    });
    Urls server_url = new Urls();
    String url = server_url.get_server_url() +
        '/mob/index/car?mark=' +
        markaController['id'].toString();
    final uri = Uri.parse(url);
    final responses = await http.get(uri);
    final jsons = jsonDecode(utf8.decode(responses.bodyBytes));
    setState(() {
      modelController = {};
      models = jsons['models'];
    });
  }

  showSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: '',
        text: 'Awtoulag goşuldy. Operatoryň tassyklamagyna garaşyň',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success,
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddDatasPage(index: 0)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(scrollDirection: Axis.vertical, children: [
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: stores, callbackFunc: callbackStores))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Dükan',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: marks, callbackFunc: callbackMarka))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Marka',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: models, callbackFunc: callbackModel))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Model',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        GestureDetector(
            child: Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColors, width: 1),
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
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: yearController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Ýyly',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: vinCodeController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('VIN kody',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Bahasy',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Telefon',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: millageController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Geçen ýoly',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: colors, callbackFunc: callbackColor))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Reňki',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: engineController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Matory',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: body_types, callbackFunc: callbackBodyType))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Kuzow görnüşi',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: transmissions, callbackFunc: callbackTransmission))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Karopka görnüşi',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(
                    items: wheel_drives, callbackFunc: callbackWd))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Ýöredijiniň görnüş',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Stack(children: <Widget>[
        Container(
            width: double.infinity,
            height: 100,
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            decoration: BoxDecoration(
                border: Border.all(color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle),
            child: Container(
                margin: EdgeInsets.only(left: 15),
                child: TextFormField(
                    controller: detailController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    }))),
        Positioned(
            left: 25,
            top: 12,
            child: Container(
                color: Colors.white,
                child: Text('Giňişleýin maglumat',
                    style: TextStyle(color: Colors.black, fontSize: 12))))
      ]),
      Container(
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.centerLeft,
          height: 80,
          width: double.infinity,
          child: Column(children: [
            Row(children: [
              Container(
                  margin: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 200,
                  child: CustomCheckBox(
                      labelText: 'Nagt däl töleg',
                      callbackFunc: callbackNone_cash_pay,
                      status: false)),
              Spacer(),
              Container(
                  margin: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 180,
                  child: CustomCheckBox(
                      labelText: 'Kredit',
                      callbackFunc: callbackCredit,
                      status: false))
            ]),
            Row(children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                height: 40,
                width: 200,
                child: CustomCheckBox(
                    labelText: 'Çalyşyk',
                    callbackFunc: callbackSwap,
                    status: false),
              ),
              Spacer(),
              Container(
                  margin: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 180,
                  child: CustomCheckBox(
                      labelText: 'Reñklenen',
                      callbackFunc: callbackRecolored,
                      status: false))
            ])
          ])),
      SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: selectedImages.map((country) {
            return Stack(children: [
              Container(
                  margin: const EdgeInsets.only(left: 10, bottom: 10),
                  height: 100,
                  width: 100,
                  alignment: Alignment.topLeft,
                  child: Image.file(country,
                      fit: BoxFit.cover, height: 100, width: 100)),
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
                      child: Icon(Icons.close, color: Colors.red)))
            ]);
          }).toList())),
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
                  child: const Text('Surat goş',
                      style: TextStyle(fontWeight: FontWeight.bold))))),
      Container(
          height: 50,
          padding: const EdgeInsets.all(10),
          child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.appColors,
                      foregroundColor: Colors.white),
                  onPressed: () async {
                    Urls server_url = new Urls();
                    String url = server_url.get_server_url() + '/mob/cars';
                    final uri = Uri.parse(url);
                    var request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false)
                        .access_token;

                    var swap_num = '0';
                    if (swap == true) {
                      swap_num = '1';
                    }

                    var credit_num = '0';
                    if (credit == true) {
                      credit_num = '1';
                    }

                    var none_cash_pay_num = '0';
                    if (none_cash_pay == true) {
                      none_cash_pay_num = '1';
                    }

                    var recolored_num = '0';
                    if (recolored == true) {
                      recolored_num = '1';
                    }
                    Map<String, String> headers = {};
                    for (var i in global_headers.entries) {
                      headers[i.key] = i.value.toString();
                    }
                    headers['token'] = token;
                    request.headers.addAll(headers);
                    if (storesController['id'] != null) {
                      request.fields['store'] =
                          storesController['id'].toString();
                    }

                    request.fields['model'] = modelController['id'].toString();
                    request.fields['mark'] = markaController['id'].toString();
                    request.fields['price'] = priceController.text.toString();
                    request.fields['vin'] = vinCodeController.text;
                    request.fields['engine'] = engineController.text;
                    request.fields['location'] = locationController['id'].toString();
                    request.fields['transmission'] = transmissionController['id'].toString();
                    request.fields['color'] = colorController['id'].toString();
                    request.fields['body_type'] = body_typeController['id'].toString();
                    request.fields['phone'] = phoneController.text;
                    request.fields['wd'] = wdController['id'].toString();
                    request.fields['year'] = yearController.text;
                    request.fields['millage'] = millageController.text;
                    request.fields['description'] = detailController.text;

                    request.fields['swap'] = swap_num;
                    request.fields['credit'] = credit_num;
                    request.fields['none_cash_pay'] = none_cash_pay_num;
                    request.fields['recolored'] = recolored_num;

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
                      Navigator.pop(context);
                      showSuccessAlert();
                    } else {
                      Navigator.pop(context);
                      showConfirmationDialogError(context);
                    }
                  },
                  child: const Text('Ýatda sakla',
                      style: TextStyle(fontWeight: FontWeight.bold))))),
      SizedBox(height: 200)
    ]);
  }

  void get_cars_index() async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/index/car';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      models = json['models'];
      marks = json['marks'];
      body_types = json['body_types'];
      colors = json['colors'];
      transmissions = json['transmissions'];
      wheel_drives = json['wheel_drives'];
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
    final response = await http.get(
      uri,
      headers: headers,
    );
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      stores = json['data']['stores'];
    });
    Provider.of<UserInfo>(context, listen: false)
        .setAccessToken(data[0]['name'], data[0]['age']);
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
}
