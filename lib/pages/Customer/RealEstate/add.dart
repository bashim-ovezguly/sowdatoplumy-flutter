import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/error.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../customCheckbox.dart';
import '../../select.dart';
import '../../success.dart';
import '../loadingWidget.dart';


class RealEstateAdd extends StatefulWidget {
  RealEstateAdd({Key? key, required this.customer_id, required this.refreshFunc}) : super(key: key);
  final String customer_id;
  final Function refreshFunc;
  @override
  State<RealEstateAdd> createState() => _RealEstateAddState(customer_id: customer_id);
}

class _RealEstateAddState extends State<RealEstateAdd> {
  final String customer_id;
  int _value = 1;
  bool canUpload = false;

  var data = {};
  List<dynamic> categories = [];
  List<dynamic> remont_states = [];
  List<File> images = [];

  callbackStatus(){
    Navigator.pop(context);
  }

  final usernameController = TextEditingController();
  final addressController = TextEditingController();
  final squareController = TextEditingController();
  final priceController = TextEditingController();
  final personController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  final floorController = TextEditingController();
  final atFloorController = TextEditingController();
  final roomCountController = TextEditingController();
  
  
  var typeFlatsController = {};
  var remontStateController = {};
  var locationsController = {};
  
  callbackTypeFlats(new_value){ setState(() { typeFlatsController = new_value; });}
  callbackRemontState(new_value){ setState(() { remontStateController = new_value; });}

  callbackLocation(new_value){ setState(() { locationsController = new_value; });}
  

  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;
  bool own = false ;
  bool document = false;
  
  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}
  callbackAtown(){ setState(() { own = ! own; });}
  callbackDocument(){setState(() { document = ! document; });}

  void initState() {
    get_flats_index();
    super.initState();
  }
  
  File? image;
  Future<void> addimages() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
    setState(() {
      if (image != null){
        images.add(image!);
        }
      });
  }

  _RealEstateAddState({ required this.customer_id });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: const Text("Emläk goşmak", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.appColors),),
          ),

          Container(
            margin: EdgeInsets.only(left: 10),
            height: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: Row(
                  children: <Widget>[
                    Radio(
                        splashRadius: 20.0,
                        activeColor: CustomColors.appColors,
                        value: 1,
                        groupValue: _value,
                        onChanged: (value){ setState(() {
                          _value = value!;
                        });}),
                    GestureDetector(
                      onTap: (){setState(() {_value = 1;});},
                      child: Text("Satlyk"),)
                  ],
                ),
                ),


                Expanded(child:Row(
                  children: <Widget>[
                    Radio(
                        splashRadius: 20.0,
                        activeColor: CustomColors.appColors,
                        value: 2,
                        groupValue: _value,
                        onChanged: (value){ setState(() {
                          _value = value!;
                        });}),
                    GestureDetector(
                      onTap: (){setState(() {_value = 2;});},
                      child: Text("Arenda"),)
                  ],
                ),
                ),

              ],
            ),
          ),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Emläk görnüşi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: categories, callbackFunc: callbackTypeFlats)
                ),],),),
          const SizedBox(height: 15,),  

          GestureDetector(
              child: Container(
              height: 35,
              margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
              child: Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Expanded(flex: 2,child: Text("Ýerleşýän ýeri : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                if (locationsController['name_tm']!=null)
                Expanded(flex: 4, child: Text(locationsController['name_tm']))
                else
                  Expanded(flex: 4, child: Text(''))
              ],),),
              onTap: (){
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return LocationWidget(callbackFunc: callbackLocation);},);
              },
            ),



          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: addressController,
              decoration: const InputDecoration(hintText: 'Salgysy',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: floorController,
              decoration: const InputDecoration(hintText: 'Binadaky gat sany',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: atFloorController,
              decoration: const InputDecoration(hintText: 'Ýerleşýän gaty',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),
                    
          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: roomCountController,
              decoration: const InputDecoration(hintText: 'Otag sany',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: squareController,
              decoration: const InputDecoration(hintText: 'Meýdany',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(hintText: 'Telefon',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Remonty : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: remont_states, callbackFunc: callbackRemontState)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: priceController,
              decoration: const InputDecoration(hintText: 'Bahasy :',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: personController,
              decoration: const InputDecoration(hintText: 'Ýazgydaky adam sany :',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          // Container(
          //   alignment: Alignment.center,
          //   height: 35,
          //   margin: const EdgeInsets.only(left: 20,right: 20),
          //   width: double.infinity,
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
          //   child:  TextFormField(
          //     controller: documentsController,
          //     decoration: const InputDecoration(hintText: 'Resminamalary',
          //         border: InputBorder.none,
          //         focusColor: Colors.white,
          //         contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter some text';
          //     }return null;
          //   },),),
          // const SizedBox(height: 15,),

          // Container(
          //   alignment: Alignment.center,
          //   height: 35,
          //   margin: const EdgeInsets.only(left: 20,right: 20),
          //   width: double.infinity,
          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
          //   child:  TextFormField(
          //     controller: usernameController,
          //     decoration: const InputDecoration(hintText: 'Karz ýagdaýy :',
          //         border: InputBorder.none,
          //         focusColor: Colors.white,
          //         contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
          //     if (value == null || value.isEmpty) {
          //       return 'Please enter some text';
          //     }return null;
          //   },),),
          // const SizedBox(height: 15,),

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
                    child:  CustomCheckBox(labelText: 'Kredit', callbackFunc: callbackCredit,status: false),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(labelText: 'Nagt däl töleg', callbackFunc: callbackNone_cash_pay, status: false),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    child:  CustomCheckBox(labelText: 'Çalyşma',callbackFunc: callbackSwap , status: false),),
                    const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(labelText: 'Eýesinden', callbackFunc: callbackAtown, status: false),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: SizedBox(
                    height: 50,
                    width: 100,
                    child:  CustomCheckBox(labelText: 'Resminamalary taýyn', callbackFunc: callbackDocument, status: false),
                  ),
                  
              )
            ],
          ),
          const SizedBox(height: 10,),

          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors, style: BorderStyle.solid, width: 1.0,),),
            height: 100,
            width: double.infinity,
            child: TextFormField(
              controller: detailController,
              cursorColor: Colors.red,
              maxLines:  3 ,
              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintText: '........',
                fillColor: Colors.white,),),),
          const SizedBox(height: 10,),

          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:Row(
                children: images.map((country){
                  return Stack(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 10,bottom: 10),
                          height: 100, width:100,
                          alignment: Alignment.topLeft,
                          child: Image.file(country,fit: BoxFit.cover,height: 100,width: 100,)
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                          images.remove(country);
                          });
                        },
                        child: Container(
                          height: 100, width:110,
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close, color: Colors.red),),),
                    ],
                  );
                }).toList(),)),
          const SizedBox(height: 10,),

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
                  addimages();
                },
                child: const Text('Surat goş',style: TextStyle(fontWeight: FontWeight.bold),),
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

                    Urls server_url  =  new Urls();
                    String url = server_url.get_server_url() + '/mob/flats';
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;

                    request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                    var own_num = '0';
                    if (own==true){ own_num = '1';}

                    var swap_num = '0';
                    if (swap==true){ swap_num = '1';}
                    
                    var credit_num = '0';
                    if (credit==true){ credit_num = '1';}

                    var ipoteka_num = '0';
                    if (none_cash_pay==true){ ipoteka_num = '1';}

                    var document_num = '0';
                    if (document==true){ document_num = '1';}
                    
                    print(typeFlatsController);
                    request.fields['remont_state'] = remontStateController['id'].toString();
                    request.fields['category'] = typeFlatsController['id'].toString();
                    request.fields['location'] = locationsController['id'].toString();
                    request.fields['address'] = addressController.text;
                    request.fields['price'] = priceController.text;
                    request.fields['own'] = own_num;
                    request.fields['swap'] = swap_num;
                    request.fields['credit'] = credit_num;
                    request.fields['ipoteka'] = ipoteka_num;
                    request.fields['documents_ready'] = document_num;
                    request.fields['phone'] = phoneController.text;
                    request.fields['detail'] = detailController.text;
                    request.fields['square'] = squareController.text;
                    request.fields['room_count'] = roomCountController.text;
                    request.fields['at_floor'] = atFloorController.text;
                    request.fields['floor'] = floorController.text;
                    request.fields['customer'] = customer_id.toString();
                    
                    print(request.fields);
                    for (var i in images){
                       var multiport = await http.MultipartFile.fromPath('images', i.path, contentType: MediaType('image', 'jpeg'),);
                       request.files.add(multiport);
                    }
                    showLoaderDialog(context);
                    
                    final response = await request.send();
                     if (response.statusCode == 200){
                      widget.refreshFunc();
                      Navigator.pop(context); 
                      showConfirmationDialogSuccess(context);  
                     }
                     else{
                      Navigator.pop(context); 
                      showConfirmationDialogError(context);    
                     }
                },
                child: const Text('Ýatda sakla',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          )
        ],
      ),
    );
  }

  showConfirmationDialogSuccess(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessAlert(action: 'flats', callbackFunc: callbackStatus,);},);}

  showConfirmationDialogError(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();},);}


  void get_flats_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/flat';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json;
      categories = json['categories'];
      remont_states = json['remont_states'];
    });
    }
}

