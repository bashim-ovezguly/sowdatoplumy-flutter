// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import 'loadingWidget.dart';
import 'package:quickalert/quickalert.dart';


class EditProfil extends StatefulWidget {
  EditProfil({Key? key, required this.customer_id,
                        required this.email,
                        required this.name,
                        required this.img,
                        required this.callbackFunc,
                        required this.phone,
                        required this.showSuccessAlert
                        }) : super(key: key);
  final String customer_id;
  final String email;
  final String name;
  final String phone;
  final String img;
  final Function callbackFunc;
  final Function showSuccessAlert;
  
  @override
  State<EditProfil> createState() => _EditProfilState(customer_id: customer_id,
                                                      email: email,
                                                      name: name,
                                                      phone: phone);
}

class _EditProfilState extends State<EditProfil> {
  final String customer_id;
  final String email;
  final String name;
  late final String phone;
  
  final newNameController = TextEditingController();
  final newPhoneController = TextEditingController();
  
  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }}

  void initState() {
    if (phone == null){setState(() { phone = '';});}
    super.initState();
  }

  _EditProfilState({required this.customer_id,
                    required this.email,
                    required this.name,
                    required this.phone});
  @override
  Widget build(BuildContext context) {
    showErrorAlert(String text){
      QuickAlert.show(
        text: text,
        context: context, 
        type: QuickAlertType.error);
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Meniň sahypam", style: CustomText.appBarText,),
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height:MediaQuery.of(context).size.height-90,
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(flex: 1,child:  Container(padding: const EdgeInsets.all(10),child: Text("Id: "+ customer_id, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: CustomColors.appColors),),),),
                  Expanded(flex:3,child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: <Widget>[
                        // image == null ? Container() : Image.file(File(image!.path)),
                        SizedBox(
                            height: 150,
                            child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000), color: Colors.white, boxShadow: const [BoxShadow(color: CustomColors.appColors, spreadRadius: 3),],),
                                child: image == null ? ClipRRect(borderRadius: BorderRadius.circular(1000.0), child: Image.network(widget.img, width: 150,height: 150,),
                                ): ClipRRect(borderRadius: BorderRadius.circular(1000.0),
                                  child: Image.file(File(image!.path), fit: BoxFit.fill, height: 150.0, width: 150,),))
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: MaterialButton(
                              color: CustomColors.appColors,
                              onPressed: () { pickImage(); },
                              elevation: 2.0,
                              padding: const EdgeInsets.all(10.0),
                              shape: const CircleBorder(),
                              child: const Icon(Icons.camera_alt_outlined, size: 20,color: Colors.white,),
                            )),],),),),
                  const Expanded(flex:1,child: SizedBox(height: 20,)),
                  Expanded(flex:4,child: Column(
                    children: <Widget>[

                      Expanded(child: Container(
                       padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: newNameController,
                          decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Täze adyñyz',
                          hintText: name,
                        ),
                      ),
                      ),),

                       Expanded(child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          controller: newPhoneController,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: "Täze elektron poçtaňyz",
                          hintText: email,
                        ),),),),

                      Expanded(child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: phone,
                            hintText: phone,
                        ),
                      ),
                      ),)
                    ],
                  )),
                
                  Expanded(flex:3,child: Align(
                    child: Column(
                      children: <Widget>[
                        Expanded(flex:6,child: Container()),

                        Expanded(flex:4,child: Container(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.appColors,
                                foregroundColor: Colors.white),
                              onPressed: () async {

                                Urls server_url  =  new Urls();
                                String url = server_url.get_server_url() + '/mob/customer/'+ customer_id.toString();
                                final uri = Uri.parse(url);
                                var  request = new http.MultipartRequest("PUT", uri);
                                var token = Provider.of<UserInfo>(context, listen: false).access_token;

                                request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                                
                                request.fields['name'] = newNameController.text;
                                request.fields['email'] = newPhoneController.text;
                                try {
                                  var multiport = await http.MultipartFile.fromPath('img', image!.path, contentType: MediaType('image', 'jpeg'),);
                                  request.files.add(multiport);
                                  }
                                catch(e){}
                                
                                showLoaderDialog(context);
                                final response = await request.send();
                                if (response.statusCode==200){
                                    widget.callbackFunc();
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    widget.showSuccessAlert();
                                  }

                                  if (response.statusCode != 200){
                                   var response  = Provider.of<UserInfo>(context, listen: false).update_tokenc();
                                   if (response==false){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));  
                                   }
                                   else{
                                    final response = await request.send();
                                    if (response.statusCode==200){ 
                                      widget.callbackFunc();
                                      Navigator.pop(context);  }
                                    else{showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy!');}
                                    }
                                  }
                              },
                              child: const Text('Ýatda sakla',style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),),
                      ],
                    ),
                  )
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}














