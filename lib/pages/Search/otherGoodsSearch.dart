import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/Customer/locationWidget.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../customCheckbox.dart';
import '../select.dart';
import 'otherGoodsSearchList.dart';


class OtherGoodsSearch extends StatefulWidget {
  final Function callbackFunc;
  OtherGoodsSearch({Key? key, required this.callbackFunc}) : super(key: key);

  @override
  State<OtherGoodsSearch> createState() => _OtherGoodsSearchState(callbackFunc: callbackFunc);
}

class _OtherGoodsSearchState extends State<OtherGoodsSearch> {
  final Function callbackFunc;
  _OtherGoodsSearchState({required this.callbackFunc});
  final nameController = TextEditingController();
  final idController = TextEditingController();
  
  var data = {};
  List<dynamic> categories = [];
  List<dynamic> brands = [];
  List<dynamic> units = [];
  List<dynamic> countries = [];

  var categoryController = {};
  var barndController = {};
  var madeInController = {};  
  var locationController = {};

  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  callbackCategory(new_value){ setState(() { categoryController = new_value; });}
  callbackBrand(new_value){ setState(() { barndController = new_value; });}
  callbackMadein(new_value){ setState(() { madeInController = new_value; });}
  

  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;

  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}

  void initState() {
    get_product_index();
    callbackFunc(4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(

      children: <Widget>[
        Expanded(child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[

          Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container( margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(items: categories, callbackFunc: callbackCategory,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Kategoriýasy', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),

          Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container( margin: EdgeInsets.only(left: 15),
                child: TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },)
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Id', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),

         Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container( margin: EdgeInsets.only(left: 15),
                child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },)
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Ady', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),

                 Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container( margin: EdgeInsets.only(left: 15, top: 10),
                child: locationController['name_tm']!= null ? Text(locationController['name_tm'],
                style: TextStyle(
                  fontSize: 16,

                ),):  Text(''),
              ),
              ),
              onTap: (){
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return LocationWidget(callbackFunc: callbackLocation);},);
              },
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Ýerleşýän ýeri', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),

        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container( margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(items: categories, callbackFunc: callbackCategory,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Kategoriýasy', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container( margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(items: brands, callbackFunc: callbackCategory,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Brend', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
              ),
              child: Container( margin: EdgeInsets.only(left: 15),
                child: MyDropdownButton(items: countries, callbackFunc: callbackMadein,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Öndürije ýurt', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        Container(margin: EdgeInsets.only(left: 15, top: 10),
                  height: 40,
                  child: CustomCheckBox(labelText:'Nagt däl töleg',  callbackFunc: callbackNone_cash_pay, status: false)),

        Container(margin: EdgeInsets.only(left: 15, top: 10),
                  height: 40,
                  child: CustomCheckBox(labelText:'Kredit', callbackFunc: callbackCredit, status: false)),
        
        Container(margin: EdgeInsets.only(left: 15, top: 10),
                  height: 40,
                  child: CustomCheckBox(labelText:'Çalyşyk', callbackFunc: callbackSwap,status: false),),
          ],
        )),

      ],
    ),
          floatingActionButton: Container(
          height: 45,
          width: 45,
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 182, 210, 196), width: 2.0),
                color : Colors.blue[900],
                shape: BoxShape.circle,
              ),
              child: InkWell(
              
                borderRadius: BorderRadius.circular(
                    500.0), 
                onTap: () {
                   Map<String, dynamic> params = {}; 
                    if (idController.text != ''){ params['id'] = idController.text.toString();}
                    if (nameController.text != ''){ params['name'] = nameController.text.toString();}
                    if (locationController!={}){params['location'] = locationController['id'].toString();}                    
                    if (categoryController!={}){params['category'] = categoryController['id'].toString();}
                    if (barndController!={}){params['brand'] = barndController['id'].toString();}
                    if (madeInController!={}){params['made_in'] = madeInController['id'].toString();}               

                    if (credit == true) { params['credit'] = 'on';}
                    if (swap == true) { params['swap'] = 'on';}
                    if (none_cash_pay == true) { params['none_cash'] = 'on';}

                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsSearchList(params: params) ));
                    },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  //size: 50,
                ),
              ),
            ),
          ),
        ),
    )
    ;
  }
    void get_product_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/product';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
  
    setState(() {
      data  = json;
      categories = json['categories'];
      brands = json['brands'];
      units = json['units'];
      countries = json['countries'];
      });
  }
}

