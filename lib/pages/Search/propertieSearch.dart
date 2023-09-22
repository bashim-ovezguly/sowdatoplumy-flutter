import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Search/propertieSearchList.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../customCheckbox.dart';
import '../select.dart';


class PropertieSearch extends StatefulWidget {
  final Function callbackFunc;
  PropertieSearch({Key? key, required this.callbackFunc}) : super(key: key);

  @override
  State<PropertieSearch> createState() => _PropertieSearchState(callbackFunc: callbackFunc);
}
  
class _PropertieSearchState extends State<PropertieSearch> {
  final Function callbackFunc;
  _PropertieSearchState({required this.callbackFunc});

  final idController = TextEditingController();
  final floorController = TextEditingController();
  final at_floorController = TextEditingController();
  final squareController = TextEditingController();
  final roomCountController = TextEditingController();

  var data = {};
  List<dynamic> categories = [];
  List<dynamic> remont_states = [];

  var categoryController = {};
  var remontStateController = {};

  callbackCategory(new_value){ setState(() { categoryController = new_value; });}
  callbackRemontState(new_value){ setState(() { remontStateController = new_value; });}

  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;
  bool own = false;

  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}
  callbackAtCustomer(){ setState(() { own = ! own; });}
  
  var locationController = {};
  callbackLocation(new_value){ setState(() { locationController = new_value; });}

  void initState() {
    get_flats_index();
    callbackFunc(3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
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
                child: TextFormField(
              controller: floorController,
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
                child: Text('Binadaky gat sany', style: TextStyle(color: Colors.black, fontSize: 12),
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
              controller: at_floorController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },)),),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Ýerleşýän gaty', style: TextStyle(color: Colors.black, fontSize: 12),
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
              controller: roomCountController,
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
                child: Text('Otag sany', style: TextStyle(color: Colors.black, fontSize: 12),
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
              controller: squareController,
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
                child: Text('Meýdany', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: remont_states, callbackFunc: callbackRemontState),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Remondynyň ýagdaýy', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),

        Container(margin: EdgeInsets.only(left: 15, top: 10),
                  height: 40,
                  child: CustomCheckBox(labelText:'Nagt däl töleg',  callbackFunc: callbackNone_cash_pay, status: false)),

        Container(margin: EdgeInsets.only(left: 15),
                  height: 40,
                  child: CustomCheckBox(labelText:'Kredit', callbackFunc: callbackCredit, status: false,)),
        
        Container(margin: EdgeInsets.only(left: 15),
                  height: 40,
                  child: CustomCheckBox(labelText:'Çalyşyk', callbackFunc: callbackSwap, status: false),),
        
        Container(margin: EdgeInsets.only(left: 15),
                  height: 40,
                  child: CustomCheckBox(labelText:'Eýesinden', callbackFunc: callbackAtCustomer,status: false),),
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
              
                borderRadius: BorderRadius.circular(500.0), 
                onTap: () {
                  Map<String, dynamic> params = {}; 
                    if (idController.text != ''){ params['id'] = idController.text.toString();}
                    if (floorController.text != ''){ params['floor'] = floorController.text.toString();}
                    if (at_floorController.text != ''){ params['at_floor'] = at_floorController.text.toString();}
                    if (roomCountController.text != ''){ params['room_count'] = roomCountController.text.toString();}
                    if (categoryController!={}){ params['category'] = categoryController['id'].toString(); }
                    if (remontStateController!={}){ params['remont_state'] = remontStateController['id'].toString(); }
                    if (locationController!={}){params['location'] = locationController['id'].toString();}   

                    if (credit == true) { params['credit'] = 'on';}
                    if (swap == true) { params['swap'] = 'on';}
                    if (none_cash_pay == true) { params['none_cash'] = 'on';}
                    if (own == true) { params['own'] = 'on';}                
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProperrieSearchList(params: params) ));
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

  void get_flats_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/flat';
    final uri = Uri.parse(url);
    var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'device_id': device_id});
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json;
      categories = json['categories'];
      remont_states = json['remont_states'];
    });
    }
}



