// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../customCheckbox.dart';
import '../../select.dart';
import '../deleteImage.dart';
import '../loadingWidget.dart';


class OtherGoodsEdit extends StatefulWidget {
  var old_data;
  var title;
  final Function callbackFunc;
  OtherGoodsEdit({Key? key, required this.old_data, required this.callbackFunc, required this.title}) : super(key: key);
  

  @override
  State<OtherGoodsEdit> createState() => _OtherGoodsEditState(old_data: old_data, callbackFunc: callbackFunc, title: title);
}
class _OtherGoodsEditState extends State<OtherGoodsEdit> {
  final Function callbackFunc;
  var title;
  var data = {};
  var baseurl = "";
  List<dynamic> categories = [];
  List<dynamic> brands = [];
  List<dynamic> units = [];
  List<dynamic> countries = [];
  
  List<File> images = [];
  
  final name_tmController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();
  final amountController = TextEditingController();
  final unitController = TextEditingController();

  var locationController = {};
  var categoryController = {};
  var barndController = {};
  var madeInController = {};  

  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;
  
  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}

  bool status = false;
  callbackStatus(){
    setState(() {
      status = true;
    });
  }
  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  callbackCategory(new_value){ setState(() { categoryController = new_value; });}
  callbackBrand(new_value){ setState(() { barndController = new_value; });}
  callbackMadein(new_value){ setState(() { madeInController = new_value; });}

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

  remove_image(value){
    setState(() {

      old_data['images'].remove(value);
    });
  }
  
  void initState() {
    credit = old_data['credit'];
    swap = old_data['swap'] ;
    none_cash_pay = old_data['none_cash_pay'] ;
    get_product_index();
    super.initState();
  }
  var old_data;
  _OtherGoodsEditState({required this.old_data, required this.callbackFunc, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(title + " üýtgetmek", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.appColors),),
          ),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: name_tmController,
              decoration: InputDecoration(hintText: old_data['name_tm']!= null ? 'Ady :' + old_data['name_tm'].toString(): "Ady",
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
              controller: amountController,
              decoration: InputDecoration(hintText: old_data['amount']!= null ? 'Sany :' + old_data['amount'].toString(): 'Sany :',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
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
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,),

                if (old_data['made_in']!= null && old_data['made_in']!='')
                  Expanded(flex: 2,child: Text(old_data['made_in'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54),)),
                if (old_data['made_in']==null || old_data['made_in']=='')
                  Expanded(flex: 2,child: Text("Öndülilen ýurdy : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),

                Expanded(flex: 4, child: MyDropdownButton(items: countries, callbackFunc: callbackMadein)
                ),],),),
          const SizedBox(height: 15,),

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
                  Expanded(flex: 3,child: Text("Bölümi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),

                Expanded(flex: 4, child: MyDropdownButton(items: categories, callbackFunc: callbackCategory)
                ),],),),
          const SizedBox(height: 15,),
          
          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), 
                if (old_data['brand']!= null && old_data['brand']!='')
                  Expanded(flex: 2,child: Text(old_data['brand']['name'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54),)),
                if (old_data['brand']==null || old_data['brand']=='')
                  Expanded(flex: 2,child: Text("Brend : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),

                Expanded(flex: 4, child: MyDropdownButton(items: brands, callbackFunc: callbackBrand)
                ),],),),
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
            child: TextFormField(
              controller: detailController,
              cursorColor: Colors.red,
              maxLines:  3 ,
              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintText: old_data['body_tm']!= null ? old_data['body_tm'].toString(): '...',
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
                      Stack(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 10,bottom: 10),
                            height: 100, width:100,
                            alignment: Alignment.topLeft,
                            child: Image.network(baseurl + country['img_l'],fit: BoxFit.cover,height: 100,width: 100,
                               errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return Center(child: CircularProgressIndicator(color: CustomColors.appColors,),);},)
                        ),
                        GestureDetector(
                          onTap: (){
                              showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteImage(action: 'products', image: country, callbackFunc: remove_image,);},);
                          },
                          child: Container(
                            height: 100, width:110,
                            alignment: Alignment.topRight,
                            child: Icon(Icons.close, color: Colors.red),),),
                      ],)],)])),

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
                    String url = server_url.get_server_url() + '/mob/products/' + old_data['id'].toString();
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("PUT", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token; 

                    request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                    
                    var swap_num = '0';
                    if (swap==true){ swap_num = '1';}
                    
                    var credit_num = '0';
                    if (credit==true){ credit_num = '1';}

                    var none_cash_pay_num = '0';
                    if (none_cash_pay==true){ none_cash_pay_num = '1';}

                    if (name_tmController.text!=''){
                      request.fields['name_tm'] = name_tmController.text;
                    }

                    if (categoryController['id']!=null){
                      request.fields['category'] = categoryController['id'].toString();
                    }

                    if (priceController.text!=''){
                      request.fields['price'] = priceController.text;
                    }
                    
                    if (phoneController.text!=''){
                      request.fields['phone'] = phoneController.text;
                    }
                      
                    if (detailController.text!=''){
                      request.fields['body_tm'] = detailController.text;
                    }
                    
                    if (amountController.text!=''){
                      request.fields['amount'] = amountController.text;
                    }

                    if ( barndController['id']!=null ){
                      print(barndController);
                      request.fields['brand'] = barndController['id'].toString();
                    }

                    if ( locationController['id']!=null ){
                      request.fields['location'] = locationController['id'].toString();
                    }

                    if ( madeInController['id']!=null ){
                      request.fields['made_in'] = madeInController['id'].toString();
                    }
                    
                    if (unitController.text!=''){
                      request.fields['unit'] = unitController.text;
                    }
                    request.fields['swap'] = swap_num;
                    request.fields['credit'] = credit_num;
                    request.fields['none_cash_pay'] = none_cash_pay_num;
                    
                    print(request.fields);
                    if (images.length!=0){
                      for (var i in images){
                       var multiport = await http.MultipartFile.fromPath('images', i.path, contentType: MediaType('image', 'jpeg'),);
                       request.files.add(multiport);
                       }
                    }
                    showLoaderDialog(context);

                    final response = await request.send();
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

  void get_product_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/product';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      baseurl =  server_url.get_server_url();
      data  = json;
      categories = json['categories'];
      brands = json['brands'];
      units = json['units'];
      countries = json['countries'];
      print(json);

    });
    }
}