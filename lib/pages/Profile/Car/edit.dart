import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/globalFunctions.dart';
import 'package:my_app/pages/Profile/deleteImage.dart';
import 'package:my_app/pages/Profile/locationWidget.dart';
import 'package:my_app/widgets/inputText.dart';
import 'package:quickalert/quickalert.dart';
import '../../../dB/constants.dart';
import '../../../dB/textStyle.dart';
import '../loadingWidget.dart';

class EditCar extends StatefulWidget {
  final initData;
  final Function callbackFunc;

  EditCar({Key? key, required this.initData, required this.callbackFunc})
      : super(key: key);
  @override
  State<EditCar> createState() =>
      _EditCarState(initData: initData, callbackFunc: callbackFunc);
}

class _EditCarState extends State<EditCar> {
  final Function callbackFunc;

  var location = {};
  var mark = {};
  var model = {};
  var transmission = {};
  var fuel = {};
  var color = {};
  var wheelDrive = {};
  var bodyType = {};
  var millage = 0;
  double engine = 0;
  int year = 0;
  int price = 0;
  String description = '';
  String phone = '';
  String vin = '';
  List<dynamic> models = [];
  List<dynamic> marks = [];
  List<dynamic> body_types = [];
  List<dynamic> fuels = [];
  List<dynamic> colors = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  var images = [];
  bool credit = false;
  bool obmen = false;

  var initData;
  final yearController = TextEditingController();
  final millageController = TextEditingController();
  final engineController = TextEditingController();
  final vinCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final priceController = TextEditingController();
  final detailController = TextEditingController();
  final locationController = TextEditingController();

  _EditCarState({required this.initData, required this.callbackFunc});

  void initState() {
    getCarsIdex();

    this.images = initData['images'];
    try {
      location['name'] = initData['location']['name'];
      locationController.text = location['name'].toString();
    } catch (err) {
      location['name'] = '';
    }
    try {
      transmission = initData['transmission'];
    } catch (err) {
      print(err);
      transmission['name'] = '';
    }
    try {
      fuel = initData['fuel'];
    } catch (err) {
      fuel['name'] = '';

      print(err);
    }
    try {
      wheelDrive = initData['wd'];
    } catch (err) {
      wheelDrive['name'] = '';

      print(err);
    }

    try {
      engine = initData['engine'];
      engineController.text = initData['engine'].toString();
    } catch (err) {
      engine = 0;
    }
    try {
      year = initData['year'];
      yearController.text = initData['year'].toString();
    } catch (err) {
      engine = 0;
    }
    try {
      price = initData['price'];
      priceController.text = initData['price'].toString();
    } catch (err) {
      engine = 0;
    }

    try {
      millage = initData['millage'];
      millageController.text = initData['millage'].toString();
    } catch (err) {
      millage = 0;
    }
    try {
      vin = initData['vin'];
      vinCodeController.text = initData['vin'];
    } catch (err) {
      vin = '';
    }
    try {
      color = initData['color'];
    } catch (err) {
      color['name'] = '';
    }
    try {
      fuel = initData['fuel'];
    } catch (err) {
      fuel['name'] = '';
    }

    try {
      bodyType = initData['body_type'];
    } catch (err) {
      print(err);
      bodyType['name'] = '';
    }

    try {
      price = int.parse(initData['price']
          .toString()
          .replaceAll(' ', '')
          .replaceAll('TMT', ''));
      priceController.text = initData['price'];
    } catch (err) {}

    try {
      obmen = initData['swap'];
    } catch (err) {}
    try {
      credit = initData['credit'];
    } catch (err) {}

    super.initState();
  }

  callbackCredit() {
    setState(() {
      credit = !credit;
    });
  }

  callbackMarka(new_value) async {
    setState(() {
      this.mark = new_value;
    });

    String url = serverIp + '/mob/index/car?mark=' + mark['id'].toString();
    final uri = Uri.parse(url);
    final responses = await http.get(uri);
    final jsons = jsonDecode(utf8.decode(responses.bodyBytes));

    setState(() {
      models = jsons['models'];
    });
  }

  callbackModel(new_value) {
    setState(() {
      model = new_value;
    });
  }

  callbackColor(new_value) {
    setState(() {
      color = new_value;
    });
  }

  callbackBodyType(new_value) {
    setState(() {
      bodyType = new_value;
    });
  }

  callbackTransmission(new_value) {
    setState(() {
      transmission = new_value;
    });
  }

  callbackWd(new_value) {
    setState(() {
      wheelDrive = new_value;
    });
  }

  callbackFuel(new_value) {
    setState(() {
      fuel = new_value;
    });
  }

  callbackLocation(new_value) {
    setState(() {
      location = new_value;
    });
  }

  List<File> selectedImages = [];
  final picker = ImagePicker();

  Future selectImages() async {
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

  removeImage(value) {
    setState(() {
      initData['images'].remove(value);
    });
  }

  setYear(new_value) {
    setState(() {
      yearController.text = new_value;
    });
  }

  setPrice(new_value) {
    setState(() {
      priceController.text = new_value;
    });
  }

  setMillage(new_value) {
    setState(() {
      millageController.text = new_value;
    });
  }

  setEngine(new_value) {
    setState(() {
      engineController.text = new_value;
    });
  }

  setPhone(new_value) {
    setState(() {
      phoneController.text = new_value;
    });
  }

  setVin(new_value) {
    setState(() {
      vinCodeController.text = new_value;
    });
  }

  setDescription(new_value) {
    setState(() {
      detailController.text = new_value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: const Text(
            "Awtoulag düzetmek",
            style: CustomText.appBarText,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView(scrollDirection: Axis.vertical, children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputSelectText(
                  title: "Marka",
                  height: 50.0,
                  callFunc: callbackMarka,
                  items: marks,
                  oldData: initData['mark']['name'].toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputSelectText(
                  title: "Model",
                  height: 50.0,
                  callFunc: callbackModel,
                  items: models,
                  oldData: initData['model']['name'].toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Ýyly',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    suffixText: 'TMT',
                    labelText: 'Bahasy',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return LocationWidget(callbackFunc: callbackLocation);
                      });
                },
                controller: locationController,
                readOnly: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined),
                    labelText: 'Ýerleşýän ýeri',
                    hintText: location['name_tm'],
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: millageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    suffixText: 'km',
                    labelText: 'Geçen ýoly',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: engineController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Motory',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputSelectText(
                  title: "Reňki",
                  height: 50.0,
                  callFunc: callbackColor,
                  items: colors,
                  oldData: color['name']),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputSelectText(
                  title: "Kuzow görnüşi",
                  height: 50.0,
                  callFunc: callbackBodyType,
                  items: body_types,
                  oldData: bodyType['name']),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputSelectText(
                  title: "Korobka görnüşi",
                  height: 50.0,
                  callFunc: callbackTransmission,
                  items: transmissions,
                  oldData: transmission['name'].toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputSelectText(
                  title: "Ýöredijiniň görnüşi",
                  height: 50.0,
                  callFunc: callbackWd,
                  items: wheel_drives,
                  oldData: wheelDrive['name'].toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputSelectText(
                  title: "Ýangyjy",
                  height: 50.0,
                  callFunc: callbackFuel,
                  items: fuels,
                  oldData: fuel['name'].toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: vinCodeController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'VIN',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Telefon belgisi',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8)),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: this.obmen,
                  onChanged: (value) {
                    this.setState(() {
                      this.obmen = !this.obmen;
                    });
                  },
                ),
                Text(
                  'Obmen',
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: this.credit,
                  onChanged: (value) {
                    this.setState(() {
                      this.credit = !this.credit;
                    });
                  },
                ),
                Text(
                  'Kredit',
                  style: TextStyle(fontSize: 17),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputText(
                  title: "Giňişleýin maglumat",
                  height: 200.0,
                  callFunc: setDescription,
                  oldData: description),
            ),
            Text(
              "Suratlar",
              style: TextStyle(color: CustomColors.appColor, fontSize: 16),
            ),
            Container(
              height: 120,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Row(children: [
                  for (var item in this.images)
                    Stack(children: [
                      GestureDetector(
                        onLongPress: () {
                          this.setMainImg(item['id']);
                        },
                        child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(5),
                            height: double.infinity,
                            width: 130,
                            alignment: Alignment.topLeft,
                            child: Image.network(serverIp + item['img_s'],
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity, errorBuilder:
                                    (BuildContext context, Object exception,
                                        StackTrace? stackTrace) {
                              return Center(
                                  child: CircularProgressIndicator(
                                      color: CustomColors.appColor));
                            })),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DeleteImage(
                                        action: 'cars',
                                        image: item,
                                        callbackFunc: removeImage);
                                  });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              child: Container(
                                  child: Center(
                                      child: Icon(Icons.close,
                                          size: 30, color: Colors.white))),
                            )),
                      )
                    ])
                ])
              ]),
            ),
            if (this.selectedImages.length > 0)
              Text(
                "Saýlanan suratlar",
                style: TextStyle(color: CustomColors.appColor, fontSize: 16),
              ),
            if (this.selectedImages.length > 0)
              Container(
                height: 120,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: selectedImages.map((item) {
                      return Stack(children: [
                        Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(5),
                            height: double.infinity,
                            width: 130,
                            alignment: Alignment.topLeft,
                            child: Image.file(item,
                                fit: BoxFit.cover,
                                height: double.infinity,
                                width: double.infinity)),
                        Positioned(
                          right: 2,
                          top: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.remove(item);
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              child: Container(
                                  child: Center(
                                      child: Icon(Icons.close,
                                          size: 30, color: Colors.white))),
                            ),
                          ),
                        )
                      ]);
                    }).toList()),
              ),
            Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.appColor,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      selectImages();
                    },
                    child: const Text(
                      'Surat goş',
                    ))),
            Container(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.appColor,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      this.save();
                    },
                    child: const Text(
                      'Ýatda sakla',
                    )))
          ]),
        ));
  }

  save() async {
    String url = carsUrl + '/' + initData['id'].toString();
    final uri = Uri.parse(url);
    var request = new http.MultipartRequest("PUT", uri);

    var credit_num = '0';
    if (credit == true) {
      credit_num = '1';
    }

    Map<String, String> headers = {};
    for (var i in global_headers.entries) {
      headers[i.key] = i.value.toString();
    }
    headers['token'] = await get_access_token();
    request.headers.addAll(headers);

    if (model['id'] != null) {
      request.fields['model'] = model['id'].toString();
    }

    if (mark['id'] != null) {
      request.fields['mark'] = mark['id'].toString();
    }

    if (transmission['id'] != null) {
      request.fields['transmission'] = transmission['id'].toString();
    }
    if (color['id'] != null) {
      request.fields['color'] = color['id'].toString();
    }

    if (location['id'] != null) {
      request.fields['location'] = location['id'].toString();
    }

    if (wheelDrive['id'] != null) {
      request.fields['wd'] = wheelDrive['id'].toString();
    }
    if (bodyType['id'] != null) {
      request.fields['body_type'] = bodyType['id'].toString();
    }
    if (fuel['id'] != null) {
      request.fields['fuel'] = fuel['id'].toString();
    }

    if (priceController.text != '') {
      request.fields['price'] =
          priceController.text.toString().replaceAll(' ', '');
    }

    if (vinCodeController.text != '') {
      request.fields['vin'] = vinCodeController.text;
    }

    if (phoneController.text != '') {
      request.fields['phone'] = phoneController.text;
    }

    if (engineController.text != '') {
      request.fields['engine'] = engineController.text;
    }
    if (yearController.text != '') {
      request.fields['year'] = yearController.text;
    }

    if (millageController.text != '') {
      request.fields['millage'] = millageController.text;
    }

    if (detailController.text != '') {
      request.fields['description'] = detailController.text;
    }

    request.fields['credit'] = this.credit.toString();
    request.fields['swap'] = this.obmen.toString();

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
      this.setState(() {
        this.images.addAll(this.selectedImages);
        this.selectedImages.clear();
      });

      callbackFunc();
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      showConfirmationDialogError(context);
    }
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

  setMainImg(imgId) async {
    var body = {
      'img': imgId.toString(),
    };

    String url = carsUrl + '/' + this.initData['id'].toString();
    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      body: body,
      headers: global_headers,
    );
    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (response.statusCode == 200) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Esasy surat üýtgedildi');
    }
  }

  void getCarsIdex() async {
    String url = serverIp + '/index/car';
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
      fuels = json['fuels'];
    });
  }
}
