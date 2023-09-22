import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../main.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class RibbonListAdd extends StatefulWidget {
  final Function refreshListFunc;
  
  RibbonListAdd({Key? key, required this.refreshListFunc}) : super(key: key);

  @override
  State<RibbonListAdd> createState() => _RibbonListAddState();
}

class _RibbonListAddState extends State<RibbonListAdd> {

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

  bool determinate = true;

  @override
  Widget build(BuildContext context) {

    showErrorAlert(String text) {
      QuickAlert.show(
          text: text,
          title: "Ýalňyşlyk ýüze çykdy!",
          confirmBtnColor: Colors.green,
          confirmBtnText: 'Dowam et',
          onConfirmBtnTap: (){
            Navigator.pop(context);
          },
          context: context,
          type: QuickAlertType.error);
    }

    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: Text('Täze lenta goşmak')),
      body: determinate? ListView(
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
                      contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
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
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedImages.map((country) {
                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(left: 10, bottom: 10),
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
                      )
                    ],
                  );
                }).toList(),
              )),
        ],
      ): Center(child:CircularProgressIndicator(color: CustomColors.appColors)),

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
            String url = server_url.get_server_url() + '/mob/lenta';
            final uri = Uri.parse(url);
            var request = new http.MultipartRequest("POST", uri);
            var token =Provider.of<UserInfo>(context, listen: false).access_token;
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
            if (response.statusCode == 200){
              widget.refreshListFunc();
              Navigator.pop(context);
            }
            else{
              setState(() {
                determinate = false; 
              });
              showErrorAlert('Lenta goşmak');
            }
          },
          child: Text('Ýatda sakla'),
        ),
      ),
    );
  }
}
