// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../customCheckbox.dart';
import '../../select.dart';
import '../loadingWidget.dart';


class RealEstateEdit extends StatefulWidget {
  var old_data;
  final Function callbackFunc;
  RealEstateEdit({Key? key, required this.old_data, required this.callbackFunc}) : super(key: key);
  
  @override
  State<RealEstateEdit> createState() => _RealEstateEditState(old_data: old_data, callbackFunc: callbackFunc);
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
  
  List<File> images = [];

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
  final documentsController = TextEditingController();
  
  var typeFlatsController = {};
  var remontStateController = {};
  var locationController = {};
  
  callbackTypeFlats(new_value){ setState(() { typeFlatsController = new_value; });}
  callbackRemontState(new_value){ setState(() { remontStateController = new_value; });}
  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  

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
  

  remove_image(value){
    setState(() {
      old_data['images'].remove(value);
    });
  }

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

  bool status = false;
  callbackStatus(){
    setState(() {
      status = true;
    });
  }

  _RealEstateEditState({required this.old_data , required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: const Text("Emläk üýtgetmek", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.appColors),),
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
              children: <Widget>[SizedBox(width: 10,),
                if (old_data['category']!= null && old_data['category']!='')
                  Expanded(flex: 2,child: Text(old_data['category'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54),)),
                if (old_data['category']==null || old_data['category']=='')
              
                  Expanded(flex: 2,child: Text("Emläk görnüşi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: categories, callbackFunc: callbackTypeFlats)
                ),],),),
          const SizedBox(height: 5,),  

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
                if (locationController['name_tm']!=null)
                Expanded(flex: 4, child: Text(locationController['name_tm']))
                else
                  if (old_data['location']!=null)
                    Expanded(flex: 4, child: Text(old_data['location']))
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
              decoration: InputDecoration(hintText: old_data['address']!= null ? 'Address: ' + old_data['address'].toString(): 'Address:',
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
              decoration: InputDecoration(hintText:  old_data['floor']!= null ? 'Binadaky gat sany: ' + old_data['floor'].toString():'Binadaky gat sany',
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
              decoration: InputDecoration(hintText: old_data['at_floor']!= null ? 'Ýerleşyän gaty: ' + old_data['at_floor'].toString(): 'Ýerleşyän gaty',
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
              decoration: InputDecoration(hintText: old_data['room_count']!= null ? 'Otag sany: ' + old_data['room_count'].toString():'Otag sany',
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
              decoration: InputDecoration(hintText: old_data['square']!= null ? 'Meýdany: ' + old_data['square'].toString(): 'Meýdany: ',
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
              decoration: InputDecoration(hintText: old_data['phone']!= null ? 'Telefon :' + old_data['phone'].toString(): 'Telefon :',
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
              children: <Widget>[SizedBox(width: 10,),
                if (old_data['remont_state']!= null && old_data['remont_state']!='')
                  Expanded(flex: 2,child: Text(old_data['remont_state'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54),)),
                if (old_data['remont_state']==null || old_data['remont_state']=='')
              
                  Expanded(flex: 2,child: Text("Remonty : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
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
              decoration: InputDecoration(hintText: old_data['price']!= null ? 'Bahasy: ' + old_data['price'].toString(): 'Bahasy: ',
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
              decoration: InputDecoration(hintText: old_data['people']!= null ? 'Ýazgydaky adam sany: ' + old_data['people'].toString(): 'Ýazgydaky adam sany: ',
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
              controller: documentsController,
              decoration: const InputDecoration(hintText: 'Resminamalary',
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
                    child:  CustomCheckBox(labelText: 'Kredit', callbackFunc: callbackCredit, status: old_data['credit']),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(labelText: 'Nagt däl töleg', callbackFunc: callbackNone_cash_pay, status: old_data['ipoteka']),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    child:  CustomCheckBox(labelText: 'Çalyşma',callbackFunc: callbackSwap, status: old_data['swap'] ),),
                    const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: CustomCheckBox(labelText: 'Eýesinden', callbackFunc: callbackAtown, status: old_data['own']),
                  ),
                ],
              ),
               Container(
                    margin: const EdgeInsets.only(left: 20),
                    height: 50,
                    width: 100,
                    child:  CustomCheckBox(labelText: 'Resminamalary taýyn', callbackFunc: callbackDocument, status: old_data['documents_ready']),)
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
                hintText: old_data['detail']!= null ? old_data['detail']: '...', 
                fillColor: Colors.white,),),),
          const SizedBox(height: 10,),


          if (old_data['images'].length > 0)
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("    Suratlar", style: TextStyle(color: CustomColors.appColors, fontSize: 16),),
                    Row(children: [
                      for(var country in old_data['images'])
                      Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 10,bottom: 10),
                            height: 100, width:100,
                            alignment: Alignment.topLeft,
                            child: Image.network(baseurl + country['img'],fit: BoxFit.cover,height: 100,width: 100,
                               errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Center(child: CircularProgressIndicator(color: CustomColors.appColors,),);},)
                        ),
                        GestureDetector(
                          onTap: (){
                            showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteImage(action: 'flats', image: country, callbackFunc: remove_image,);},);
                          },
                          child: Container(
                            height: 100, width:110,
                            alignment: Alignment.topRight,
                            child: Icon(Icons.close, color: Colors.red),),),
                      ],)],)])),

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
                    String url = server_url.get_server_url() + '/mob/flats/' + old_data['id'].toString();
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("PUT", uri);
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

                    if (remontStateController['id']!=null ){
                      request.fields['remont_state'] = remontStateController['id'].toString();
                    }

                    if (typeFlatsController['id']!=null){
                      request.fields['category'] = typeFlatsController['id'].toString();
                    }

                    if (locationController['id']!=null){
                      request.fields['location'] = locationController['id'].toString();
                    }
                    
                    if (addressController.text!=''){
                      request.fields['address'] = addressController.text;
                    }
                    
                    if (priceController.text!=''){
                      request.fields['price'] = priceController.text;
                    }

                    if (phoneController.text!=''){
                      request.fields['phone'] = phoneController.text;
                    }
                    
                    if (detailController.text!=''){
                      request.fields['detail'] = detailController.text;
                    }
                    
                    if (documentsController.text!=''){
                      request.fields['documents'] = documentsController.text;
                    }
                    
                    if (squareController.text!=''){
                      request.fields['square'] = squareController.text;
                    }

                    if (roomCountController.text!=''){
                      request.fields['room_count'] = roomCountController.text;                     
                    }

                    if (atFloorController.text!=''){
                      request.fields['at_floor'] = atFloorController.text;
                    }

                    if (floorController.text!=''){
                      request.fields['floor'] = floorController.text;
                    }

                    request.fields['own'] = own_num;
                    request.fields['swap'] = swap_num;
                    request.fields['credit'] = credit_num;
                    request.fields['ipoteka'] = ipoteka_num;

                    if (images.length!=0){
                      for (var i in images){
                       var multiport = await http.MultipartFile.fromPath('images', i.path, contentType: MediaType('image', 'jpeg'),);
                       request.files.add(multiport);
                       }
                    }
                    showLoaderDialog(context);

                    final response = await request.send();
                    print(response.statusCode);
                     if (response.statusCode == 200){
                      callbackFunc();
                      Navigator.pop(context); 
                      Navigator.pop(context); 
                      
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
      baseurl =  server_url.get_server_url();
      categories = json['categories'];
      remont_states = json['remont_states'];
      locations = json['locations'];
      print(json);
    });
    }
}

