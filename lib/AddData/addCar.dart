import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_app/AddData/addPage.dart';

import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:my_app/pages/customCheckbox.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/pages/homePageLocation.dart';
import 'package:my_app/pages/select.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    getCarsIndex();
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

  showErrorAlert(text) {
    QuickAlert.show(
        context: context,
        title: '',
        text: text,
        confirmBtnText: 'OK',
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.error,
        onConfirmBtnTap: () {
          Navigator.pop(context);
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
        confirmBtnColor: CustomColors.appColor,
        type: QuickAlertType.success,
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => AddDatasPage(index: 0)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListView(scrollDirection: Axis.vertical, children: [
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: marks, callbackFunc: callbackMarka))),
          Positioned(
              left: 10,
              top: 2,
              child: Container(
                  color: Colors.white,
                  child: Text('Marka',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: models, callbackFunc: callbackModel))),
          Positioned(
              left: 10,
              top: 2,
              child: Container(
                  color: Colors.white,
                  child: Text('Model',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),

        TextFormField(
          controller: yearController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ýyly',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(10)),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: priceController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Bahasy',
              suffixText: 'TMT',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(10)),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          readOnly: true,
          onTap: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return LocationWidget(callbackFunc: callbackLocation);
                });
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(),
              labelText: 'Ýerleşýän ýeri',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: locationController['name_tm'],
              contentPadding: EdgeInsets.all(10)),
        ),
        SizedBox(height: 15),

        TextFormField(
          controller: phoneController,
          maxLength: 8,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone),
            hintMaxLines: 1,
            border: OutlineInputBorder(),
            labelText: 'Telefon belgisi',
            contentPadding: EdgeInsets.all(10),
          ),
        ),

        TextFormField(
          controller: millageController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Geçen ýoly',
              suffixText: 'km',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(10)),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 15,
        ),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: colors, callbackFunc: callbackColor))),
          Positioned(
              left: 10,
              top: 2,
              child: Container(
                  color: Colors.white,
                  child: Text('Reňki',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),

        TextFormField(
          controller: engineController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Motory',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(10)),
          keyboardType: TextInputType.number,
        ),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: body_types, callbackFunc: callbackBodyType))),
          Positioned(
              left: 10,
              top: 2,
              child: Container(
                  color: Colors.white,
                  child: Text('Kuzow görnüşi',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: transmissions,
                      callbackFunc: callbackTransmission))),
          Positioned(
              left: 10,
              top: 2,
              child: Container(
                  color: Colors.white,
                  child: Text('Korobka görnüşi',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: wheel_drives, callbackFunc: callbackWd))),
          Positioned(
              left: 10,
              top: 2,
              child: Container(
                  color: Colors.white,
                  child: Text('Ýöredijiniň görnüş',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),

        TextFormField(
          controller: vinCodeController,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'VIN',
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(10)),
        ),
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: detailController,
          decoration: InputDecoration(
              hintText: 'Goşmaça', border: OutlineInputBorder()),
          maxLines: 5,
        ),

        Row(
          children: [
            Checkbox(
                value: this.credit,
                onChanged: (value) {
                  this.setState(() {
                    credit = !credit;
                  });
                }),
            Text(
              'Kredit',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        Row(
          children: [
            Checkbox(
                value: this.swap,
                onChanged: (value) {
                  this.setState(() {
                    swap = !swap;
                  });
                }),
            Text(
              'Obmen',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),

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
                        backgroundColor: CustomColors.appColor,
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
                        backgroundColor: CustomColors.appColor,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      saveCar();
                    },
                    child: const Text('Ýatda sakla',
                        style: TextStyle(fontWeight: FontWeight.bold))))),
        // SizedBox(height: 200)
      ]),
    );
  }

  saveCar() async {
    if (markaController['id'] == null) {
      showErrorAlert('Marka hökman görkezmeli');
      return null;
    }

    if (selectedImages.length == 0) {
      showErrorAlert('Surat hökman saýlamaly');
      return null;
    }

    String url = carsUrl;
    final uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    var token = await get_access_token();

    var swap_num = '0';
    if (swap == true) {
      swap_num = '1';
    }

    var credit_num = '0';
    if (credit == true) {
      credit_num = '1';
    }

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    headers['token'] = token;
    request.headers.addAll(headers);
    final pref = await SharedPreferences.getInstance();
    request.fields['store'] = pref.getInt('user_id').toString();
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
  }

  void getCarsIndex() async {
    final uri = Uri.parse(indexCarsUrl);
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
