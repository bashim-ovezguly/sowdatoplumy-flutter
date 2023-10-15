// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../customCheckbox.dart';
import '../../select.dart';
import '../loadingWidget.dart';



class EditCar extends StatefulWidget {
  final Function callbackFunc;
  EditCar({Key? key, required this.old_data, required this.callbackFunc}) : super(key: key);
  var old_data;
  @override
  State<EditCar> createState() => _EditCarState(old_data: old_data, callbackFunc: callbackFunc);
}
class _EditCarState extends State<EditCar> {
  var baseurl = "";
  final Function callbackFunc;

  List<dynamic> models = [];
  List<dynamic> marks = [];
  List<dynamic> body_types= [];
  List<dynamic> fruits = [];
  List<dynamic> colors = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  List<File> images = [];

    List<dynamic> stores = [];
  var storesController = {};
  callbackStores(new_value){ setState(() { storesController = new_value; });}

  var old_data;
  final usernameController = TextEditingController();
  final yearController = TextEditingController();
  final millageController = TextEditingController();
  final engineController = TextEditingController();
  final vinCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final priceController = TextEditingController();
  final detailController = TextEditingController();

  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;
  bool recolored = false ;

  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}
  callbackRecolored(){ setState(() { recolored = ! recolored; });}

  var markaController = {};
  var modelController = {};
  var colorController = {};
  var body_typeController = {};
  var transmissionController = {};
  var wdController = {};
  var locationController = {};
  
  int _mainImg = 0;

   callbackMarka(new_value) async { setState(() { markaController = new_value; });
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/car?mark=' + markaController['id'].toString();
    final uri = Uri.parse(url);
    final responses = await http.get(uri);
    final jsons = jsonDecode(utf8.decode(responses.bodyBytes));
    setState(() {
      models = jsons['models'];
    });
    
    }

  callbackModel(new_value){ setState(() { modelController = new_value; });}
  callbackColor(new_value){ setState(() { colorController = new_value; });}
  callbackBodyType(new_value){ setState(() { body_typeController = new_value; });}
  callbackTransmission(new_value){ setState(() { transmissionController = new_value; });}
  callbackWd(new_value){ setState(() { wdController = new_value; });}
  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  
  List<File> selectedImages = []; 
  final picker = ImagePicker();
  
  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;
 
    setState(() {
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

  



  remove_image(value){
    setState(() {
      old_data['images'].remove(value);
    });}

  void initState() {
    credit = old_data['credit'];
    swap = old_data['swap'] ;
    none_cash_pay = old_data['none_cash_pay'] ;
    recolored = old_data['recolored'] ;
    get_cars_index();
    get_userinfo();
    super.initState();
  }


  _EditCarState({required this.old_data, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar( title: const Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text("Awtoulag üýtgetmek", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, color: CustomColors.appColors),),
          ),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,),
               if (old_data['store_name']!= null && old_data['store_name']!='')
                  Expanded(flex: 2,child: Text(old_data['store_name'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['store_name']==null || old_data['store_name']=='')

              Expanded(flex: 2,child: Text("Dükan: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                Expanded(flex: 4, child:MyDropdownButton(items: stores, callbackFunc: callbackStores)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(
                width: 10,),
              Expanded(flex: 2,child: Text("Marka : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
               if (old_data['mark']!= null && old_data['mark']!='')
                  Expanded(flex: 2,child: Text(old_data['mark'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['mark']==null || old_data['mark']=='')

              Expanded(flex: 1,child: Text("Marka: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                Expanded(flex: 4, child:MyDropdownButton(items: marks, callbackFunc: callbackMarka)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[
                SizedBox(width: 10,), 
                Expanded(flex: 2,child: Text("Model : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
              if (old_data['model']!= null && old_data['model']!='')
                  Expanded(flex: 2,child: Text(old_data['model'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['model']==null || old_data['model']=='')
              
                Expanded(flex: 1,child: Text("Model : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                Expanded(flex: 4, child: MyDropdownButton(items: models, callbackFunc: callbackModel)
                                                                
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
                Expanded(flex: 2,child: Text("Ýerleşýän ýeri : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (locationController['name_tm']!=null)
                Expanded(flex: 4, child: Text(locationController['name_tm']))
                else
                  if (old_data['location']!=null)
                    Expanded(flex: 4, child: Text(old_data['location']))
                  else
                    Expanded(flex: 4, child: Text(''))
              ],)
              ),
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
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: old_data['year']!= null ? 'Ýyl: ' + old_data['year'].toString(): 'Ýyl',
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
              controller: priceController,
              decoration: InputDecoration(hintText: old_data['price']!= null ? 'Bahasy :' + old_data['price'].toString(): 'Bahasy :',
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
              controller: millageController,
              decoration: InputDecoration(hintText: old_data['millage']!= null ? 'Geçen ýoly: ' + old_data['millage'].toString(): 'Geçen ýoly',
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
              Expanded(flex: 2,child: Text("Reňk: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['color']!= null && old_data['color']!='')
                  Expanded(flex: 2,child: Text(old_data['color'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['color']==null || old_data['color']=='')
                  Expanded(flex: 1,child: Text("Reňki : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),

                Expanded(flex: 4, child: MyDropdownButton(items: colors, callbackFunc: callbackColor  )
                ),],),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: engineController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: old_data['engine']!= null ? 'Matory: ' + old_data['engine'].toString(): 'Matory: ',
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
                if (old_data['body_type']!= null && old_data['body_type']!='')
                  Expanded(flex: 2,child: Text(old_data['body_type'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['body_type']==null || old_data['body_type']=='')
                  Expanded(flex: 2,child: Text("Kuzow görnüşi : ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                Expanded(flex: 4, child: MyDropdownButton(items: body_types, callbackFunc: callbackBodyType)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,),
                if (old_data['transmission']!= null && old_data['transmission']!='')
                  Expanded(flex: 2,child: Text(old_data['transmission'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['transmission']==null || old_data['transmission']=='')
                  
                  Expanded(flex: 2,child: Text("Karopka görnüş: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                Expanded(flex: 4, child: MyDropdownButton(items: transmissions, callbackFunc: callbackTransmission)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), 
                if (old_data['wd']!= null && old_data['wd']!='')
                  Expanded(flex: 2,child: Text(old_data['wd'].toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                if (old_data['wd']==null || old_data['wd']=='')

                  Expanded(flex: 3,child: Text("Ýörediji görnüşi: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54,),)),
                Expanded(flex: 4, child: MyDropdownButton(items: wheel_drives, callbackFunc: callbackWd)
                ),],),),
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
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: vinCodeController,
              decoration: InputDecoration(hintText: old_data['vin'] != null? 'VIN ' + old_data['vin'].toString(): 'VIN ',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.centerLeft,
            height: 80,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 200,
                      child: CustomCheckBox(labelText:'Nagt däl töleg',  callbackFunc: callbackNone_cash_pay, status: old_data['none_cash_pay']),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 180,
                      child: CustomCheckBox(labelText:'Kredit', callbackFunc: callbackCredit, status: old_data['credit']),

                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 200,
                      child: CustomCheckBox(labelText:'Çalyşyk', callbackFunc: callbackSwap, status: old_data['swap']),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 180,
                      child: CustomCheckBox(labelText:'Reñklenen', callbackFunc: callbackRecolored, status: old_data['recolored']),
                    )
                  ],
                )
              ],
            ),
          ),
   
          const SizedBox(height: 15,),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors, style: BorderStyle.solid, width: 1.0,),),
            height: 100,
            width: double.infinity,
            child: TextField(
              controller: detailController,
              cursorColor: Colors.red,
              maxLines:  3 ,
              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintText: old_data['detail']!= null ? old_data['detail']: '...', 
                fillColor: Colors.white,),),),


          if (old_data['images'].length > 0)
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("    Suratlar", style: TextStyle(color: CustomColors.appColors, fontSize: 16),),
                    Row(children: [
                      for(var country in old_data['images'])
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 10,bottom: 10),
                                  height: 100, width:100,
                                  alignment: Alignment.topLeft,
                                  child: Image.network(baseurl + country['img_m'],fit: BoxFit.cover,height: 100,width: 100,
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                              return Center(child: CircularProgressIndicator(color: CustomColors.appColors,),);},
                                  )
                              ),
                              GestureDetector(
                                onTap: (){
                                    showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return DeleteImage(action: 'cars', image: country, callbackFunc: remove_image,);},);
                                },
                                child: Container(
                                  height: 100, width:110,
                                  alignment: Alignment.topRight,
                                  child: Icon(Icons.close, color: Colors.red),),),
                            ],),

                            if (_mainImg == country['id'])
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: OutlinedButton(
                                child: Text("Esasy img", style: TextStyle(color: Colors.white),),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 15, 138, 19),
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
                      ],)])),

          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:Row(
                children: selectedImages.map((country){
                  return Stack(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 10,bottom: 10),
                          height: 100, width:100,
                          alignment: Alignment.topLeft,
                          child: Image.file(country, fit: BoxFit.cover, height: 100, width: 100,)
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            selectedImages.remove(country);
                          });
                        },
                        child: Container(
                          height: 100, width:110,
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close, color: Colors.red),),),
                    ],
                  );
                }).toList(),)),

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
                child: const Text('Surat goş',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ),
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


                    Urls server_url  =  new Urls();
                    String url = server_url.get_server_url() + '/mob/cars/' + old_data['id'].toString();
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("PUT", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;

                    var swap_num = '0';
                    if (swap==true){ swap_num = '1';}
                    
                    var credit_num = '0';
                    if (credit==true){ credit_num = '1';}

                    var none_cash_pay_num = '0';
                    if (none_cash_pay==true){ none_cash_pay_num = '1';}

                    var recolored_num = '0';
                    if (recolored==true){ recolored_num = '1';}
                      Map<String, String> headers = {};  
                      for (var i in global_headers.entries){
                        headers[i.key] = i.value.toString(); 
                      }
                      headers['token'] = token;
                    request.headers.addAll(headers);

                    if (storesController['id']!=null){
                      request.fields['store'] = storesController['id'].toString();
                    }
                    
                    if (modelController['id']!=null){
                      request.fields['model'] = modelController['id'].toString();
                    }
                    if (_mainImg!=0){
                      request.fields['img'] = _mainImg.toString();
                    }

                    if (markaController['id']!=null){
                      request.fields['mark'] = markaController['id'].toString();
                    }

                    if (transmissionController['id']!=null){
                      request.fields['transmission'] = transmissionController['id'].toString();
                    }
                    if (colorController['id']!=null){
                      request.fields['color'] = colorController['id'].toString();
                    }

                    if (locationController['id']!=null){
                      request.fields['location'] = locationController['id'].toString();
                    }

                    if (wdController['id']!=null){
                      request.fields['wd'] =  wdController['id'].toString();
                    }
                    
                    if (priceController.text!=''){
                      request.fields['price'] = priceController.text.toString();
                    }
                    
                    if (vinCodeController.text!=''){
                      request.fields['vin'] = vinCodeController.text;
                    }

                    if (phoneController.text!=''){
                      request.fields['phone'] = phoneController.text;
                    }

                    if (engineController.text!=''){
                      request.fields['engine'] = engineController.text;
                    }
                    if (yearController.text!=''){
                      request.fields['year'] = yearController.text;
                    }

                    if (millageController.text!=''){
                      request.fields['millage'] = millageController.text;
                    }
                    
                    if (detailController.text!=''){
                      request.fields['detail'] = detailController.text;
                    }
                    
                    request.fields['swap'] = swap_num;
                    request.fields['credit'] = credit_num;
                    request.fields['none_cash_pay'] = none_cash_pay_num;
                    request.fields['recolored'] = recolored_num;
                    
                    if (selectedImages.length!=0){
                      for (var i in selectedImages){
                       var multiport = await http.MultipartFile.fromPath('images', i.path, contentType: MediaType('image', 'jpeg'),);
                       request.files.add(multiport);
                       }
                    }
                    showLoaderDialog(context);
                    final response = await request.send();
                     if (response.statusCode == 200){
                      callbackFunc();
                      Navigator.pop(context); 
                      showSuccess(context); 
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
  
   showSuccess(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessPopup();},);}

  void get_cars_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/car';
    final uri = Uri.parse(url);
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      baseurl =  server_url.get_server_url();
      models = json['models'];
      marks = json['marks'];
      body_types = json['body_types'];
      colors = json['colors'];
      transmissions = json['transmissions'];
      wheel_drives = json['wheel_drives']; 
    });}

          
    void get_userinfo() async {
    var allRows = await dbHelper.queryAllRows();
    var data = [];for (final row in allRows) {data.add(row);}
    if (data.length==0){Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));}
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/customer/' + data[0]['userId'].toString() ;
    final uri = Uri.parse(url);
    Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
      headers['token'] = data[0]['name'];
    final response = await http.get(uri, headers: headers,);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {stores = json['data']['stores'];});
    Provider.of<UserInfo>(context, listen: false).setAccessToken(data[0]['name'], data[0]['age']);}
}

class SuccessPopup extends StatefulWidget {
  SuccessPopup({Key? key}) : super(key: key);
  @override
  _SuccessPopupState createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<SuccessPopup> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                shadowColor: CustomColors.appColorWhite,
                surfaceTintColor: CustomColors.appColorWhite,
                backgroundColor: CustomColors.appColorWhite,
                content: Container(
                  width: 200,
                  height: 100,
                  child: Text(
                      'Maglumat üýtgedildi operatoryň tassyklamagyna garaşyň'),
                ),
                actions: <Widget>[
                  Align(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        Navigator.pop(context); 
                        Navigator.pop(context); 
                        
                      },
                      child: const Text('Dowam et'),
                    ),
                  )
                ],
              );
  }
}
