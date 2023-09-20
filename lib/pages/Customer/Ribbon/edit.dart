import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../../dB/providers.dart';
import '../../../main.dart';

class MyRibbonEdit extends StatefulWidget {
  final String id;
  final Function refreshListFunc;
  MyRibbonEdit({Key? key, required this.id, required this.refreshListFunc})
      : super(key: key);

  @override
  State<MyRibbonEdit> createState() => _MyRibbonEditState();
}

class _MyRibbonEditState extends State<MyRibbonEdit> {
  var data = {};
  var baseurl = '';
  bool determinate = false;

  @override
  void initState() {
    get_ribbon_by_id(id: widget.id);
    super.initState();
  }

  remove_image() {get_ribbon_by_id(id: widget.id);}

  final textController = TextEditingController();
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
            int sizeInBytes = File(xfilePick[i].path).lengthSync();
            var j = (log(sizeInBytes) / log(1024)).floor();
            double sizeInMb = sizeInBytes / pow(1024, j);
            if (sizeInMb > 5000) {
            } else {
              selectedImages.add(File(xfilePick[i].path));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Surat saýlamadyňyz!')));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    showErrorAlert(String text) {
      QuickAlert.show(
          text: text,
          title: "Ýalňyşlyk ýüze çykdy!",
          confirmBtnColor: Colors.green,
          confirmBtnText: 'Dowam et',
          onConfirmBtnTap: () {
            Navigator.pop(context);
          },
          context: context,
          type: QuickAlertType.error);
    }

    showSuccessAlert(){
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Sagydyň ýagdaýy üýtgedildi!',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success,
        onConfirmBtnTap: (){
          Navigator.pop(context);
        });
    }

    return Scaffold(
      appBar: AppBar(title: Text('Söwda lenta - 12 üýtget')),
      body: determinate
          ? ListView(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20, top: 20),
                  child: Text("Tekst",
                      style: TextStyle(
                          color: CustomColors.appColors,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                    height: 250,
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: CustomColors.appColors)),
                    child: TextFormField(
                        maxLines: 10,
                        controller: textController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusColor: Colors.white,
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 14)),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        })),
                Row(
                  children: [
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.appColors),
                      onPressed: () {
                        getImages();
                      },
                      child: Text('Surat goşmak'),
                    ),
                  ],
                ),
                if (data['images'].length > 0)
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
                                for (var country in data['images'])
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
                                                baseurl + country['img'],
                                                fit: BoxFit.cover,
                                                height: 100,
                                                width: 100,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: CustomColors
                                                          .appColors,
                                                    ),
                                                  );
                                                },
                                              )),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DeleteImage(
                                                    action: 'lenta',
                                                    image: country,
                                                    callbackFunc: remove_image,
                                                  );
                                                },
                                              );
                                              widget.refreshListFunc();
                                              setState(() {});
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
                                    ],
                                  )
                              ],
                            )
                          ])),
                if (selectedImages.length > 0)
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.image, color: CustomColors.appColors),
                      SizedBox(width: 5),
                      Text('Täze surat',
                          style: TextStyle(color: CustomColors.appColors)),
                    ],
                  ),
                if (selectedImages.length > 0)
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: selectedImages.map((country) {
                          return Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, bottom: 10),
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
                                      child:
                                          Icon(Icons.close, color: Colors.red),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }).toList(),
                      )),
              ],
            )
          : Center(child: CircularProgressIndicator(color: CustomColors.appColors)),
      floatingActionButton: Container(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.appColors,
          ),
          onPressed: () async {
            var allRows = await dbHelper.queryAllRows();

            var data = [];
            for (final row in allRows) {
              data.add(row);
            }
            setState(() {
              determinate = false;
            });
            Urls server_url = new Urls();
            String url =
                server_url.get_server_url() + '/mob/lenta/' + widget.id;
            final uri = Uri.parse(url);
            var request = new http.MultipartRequest("PUT", uri);
            var token = Provider.of<UserInfo>(context, listen: false).access_token;
              Map<String, String> headers = {};  
              for (var i in global_headers.entries){
                headers[i.key] = i.value.toString(); 
              }
              headers['token'] = token;
            request.headers.addAll(headers);
            request.fields['text'] = textController.text;
            for (var i in selectedImages) {
              var multiport = await http.MultipartFile.fromPath(
                'images',
                i.path,
                contentType: MediaType('image', 'jpeg'),
              );
              request.files.add(multiport);
            }
            final response = await request.send();
            if (response.statusCode == 200) {
              showSuccessAlert();
              widget.refreshListFunc();
              setState(() {
                selectedImages = [];
              });
              get_ribbon_by_id(id: widget.id);
            } else {
              showErrorAlert('Lenta üýtgetmek'); 
            }
          },
          child: Text('Ýatda sakla')
        )
      )
    );
  }

  void get_ribbon_by_id({required id}) async {
    Urls server_url = new Urls();
    String url = server_url.get_server_url() + '/mob/lenta/' + id;
    final uri = Uri.parse(url);
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data = json['msg'];
      determinate = true;
      baseurl = server_url.get_server_url();
      textController.text = data['text'].toString();
    });
  }
}
