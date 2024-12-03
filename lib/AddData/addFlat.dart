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

class AddRealestate extends StatefulWidget {
  const AddRealestate({super.key});

  @override
  State<AddRealestate> createState() => _AddRealestateState();
}

class _AddRealestateState extends State<AddRealestate> {
  List<dynamic> categories = [];
  List<File> selectedImages = [];
  List<dynamic> stores = [];
  List<dynamic> remont_states = [];

  var storesController = {};
  var locationController = {};
  var categoryController = {};
  var remontStateController = {};
  var typeFlatsController = {};
  var locationsController = {};

  final picker = ImagePicker();
  final priceController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  final addressController = TextEditingController();
  final floorController = TextEditingController();
  final atFloorController = TextEditingController();
  final roomCountController = TextEditingController();
  final squareController = TextEditingController();

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

  callbackRemontState(new_value) {
    setState(() {
      remontStateController = new_value;
    });
  }

  callbackTypeFlats(new_value) {
    setState(() {
      typeFlatsController = new_value;
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

  callbackLocation(new_value) {
    setState(() {
      locationsController = new_value;
    });
  }

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
    super.initState();
    get_flats_index();
  }

  callbackStores(new_value) {
    setState(() {
      storesController = new_value;
    });
  }

  callbackCategory(new_value) {
    setState(() {
      categoryController = new_value;
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

  showSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: '',
        text: 'Bildiriş goşuldy. Operatoryň tassyklamagyna garaşyň',
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
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ListView(scrollDirection: Axis.vertical, children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
              labelText: 'Ady',
              border: OutlineInputBorder(),
              focusColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
        ),
        SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: priceController,
          decoration: const InputDecoration(
              labelText: 'Bahasy',
              suffixText: 'TMT',
              border: OutlineInputBorder(),
              focusColor: Colors.white,
              contentPadding: EdgeInsets.all(5)),
        ),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: categories, callbackFunc: callbackCategory))),
          Positioned(
              left: 10,
              top: 12,
              child: Container(
                  color: Colors.white,
                  child: Text('Kategoriýa',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        Stack(children: <Widget>[
          GestureDetector(
              child: Container(
                  width: double.infinity,
                  height: 40,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColors.appColor, width: 1),
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
              left: 10,
              top: 12,
              child: Container(
                  color: Colors.white,
                  child: Text('Ýerleşýän ýeri',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        SizedBox(height: 20),
        TextFormField(
          controller: addressController,
          decoration: const InputDecoration(
              labelText: 'Salgysy',
              border: OutlineInputBorder(),
              focusColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
        ),
        SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: floorController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, bottom: 14),
            labelText: 'Binadaky gat sany',
            border: OutlineInputBorder(),
            focusColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: atFloorController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, bottom: 14),
            labelText: 'Ýerleşýän gaty',
            border: OutlineInputBorder(),
            focusColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: roomCountController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, bottom: 14),
            labelText: 'Otag sany',
            border: OutlineInputBorder(),
            focusColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: squareController,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(left: 10, bottom: 14),
            suffixText: 'm.kw.',
            labelText: 'Meýdany',
            border: OutlineInputBorder(),
            focusColor: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          maxLength: 8,
          controller: phoneController,
          decoration: const InputDecoration(
              labelText: 'Telefon belgisi',
              prefixText: '+993',
              border: OutlineInputBorder(),
              focusColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
        ),
        Stack(children: <Widget>[
          Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.appColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle),
              child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: MyDropdownButton(
                      items: remont_states,
                      callbackFunc: callbackRemontState))),
          Positioned(
              left: 10,
              top: 12,
              child: Container(
                  color: Colors.white,
                  child: Text('Remont ýagdaýy',
                      style: TextStyle(color: Colors.black, fontSize: 12))))
        ]),
        SizedBox(height: 20),
        TextFormField(
          maxLines: 10,
          controller: detailController,
          decoration: const InputDecoration(
              hintText: 'Goşmaça maglumat',
              border: OutlineInputBorder(),
              focusColor: Colors.white,
              contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
        ),
        SizedBox(height: 15),
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
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    height: 50,
                    width: 100,
                    child: CustomCheckBox(
                        labelText: 'Kredit',
                        callbackFunc: callbackCredit,
                        status: false)),
                Container(
                    height: 50,
                    width: 100,
                    child: CustomCheckBox(
                        labelText: 'Obmen',
                        callbackFunc: callbackSwap,
                        status: false)),
                SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(
                        labelText: 'Eýesinden',
                        callbackFunc: callbackAtown,
                        status: false)),
              ]),
        ),
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
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.appColor,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      if (nameController.text == '') {
                        showErrorAlert('Adyny hökman girizmeli');
                        return null;
                      }
                      if (priceController.text == '') {
                        showErrorAlert('Bahasyny hökman girizmeli');
                        return null;
                      }
                      if (selectedImages.length == 0) {
                        showErrorAlert('Surat hökman goşmaly');
                        return null;
                      }

                      final uri = Uri.parse(flatsUrl);
                      var request = new http.MultipartRequest("POST", uri);
                      var token = await get_access_token();
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

                      request.fields['remont_state'] =
                          remontStateController['id'].toString();
                      request.fields['category'] =
                          categoryController['id'].toString();
                      request.fields['location'] =
                          locationsController['id'].toString();

                      final pref = await SharedPreferences.getInstance();
                      request.fields['store'] =
                          pref.getInt('user_id').toString();

                      request.fields['address'] = addressController.text;
                      request.fields['price'] = priceController.text;
                      request.fields['name'] = nameController.text;
                      request.fields['own'] = own_num;
                      request.fields['swap'] = swap_num;
                      request.fields['credit'] = credit_num;
                      request.fields['ipoteka'] = ipoteka_num;
                      request.fields['documents_ready'] = document_num;
                      request.fields['phone'] = phoneController.text;
                      request.fields['detail'] = detailController.text;
                      request.fields['description'] = detailController.text;
                      request.fields['square'] = squareController.text;
                      request.fields['room_count'] = roomCountController.text;
                      request.fields['at_floor'] = atFloorController.text;
                      request.fields['floor'] = floorController.text;
                      // request.fields['store'] = await getStoreId();

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
      ]),
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
      categories = json['categories'];
      remont_states = json['remont_states'];
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
