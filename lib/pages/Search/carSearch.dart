import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Search/carSearchList.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../customCheckbox.dart';
import '../select.dart';


class CarSerach extends StatefulWidget {
  final Function callbackFunc;
  CarSerach({Key? key, required this.callbackFunc}) : super(key: key);
  @override
  State<CarSerach> createState() => _CarSerachState(callbackFunc: callbackFunc);
}

class _CarSerachState extends State<CarSerach> {
  final Function callbackFunc;
  
  
  _CarSerachState({required this.callbackFunc});

  var data = {};
  final vinCodeController = TextEditingController();
  final idController = TextEditingController();
  final startYearController = TextEditingController();
  final endYearController = TextEditingController();
  final startPriceController = TextEditingController();
  final endPriceController = TextEditingController();
  
  List<dynamic> models = [];
  List<dynamic> marks = [];
  List<dynamic> body_types= [];
  List<dynamic> colors = [];
  List<dynamic> fuels = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  


  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;
  bool recolored = false ;

  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}
  callbackRecolored(){ setState(() { recolored = ! recolored; });}

  var modelController = {};
  var markaController = {};
  var body_typeController = {};
  var colorController = {};
  var fuelController = {};
  var transmissionController = {};
  var wdController = {};
  var locationController = {};
  
  callbackModel(new_value){ setState(() { modelController = new_value; });}
  callbackMarka(new_value){ setState(() async { 
    markaController = new_value; 
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/car?mark=' + markaController['id'].toString();
    final uri = Uri.parse(url);
    final responses = await http.get(uri);
    final jsons = jsonDecode(utf8.decode(responses.bodyBytes));
    setState(() {
      models = jsons['models'];
    });});}
  callbackBodyType(new_value){ setState(() { body_typeController = new_value; });}
  callbackColor(new_value){ setState(() { colorController = new_value; });}
  callbackFuel(new_value){ setState(() { fuelController = new_value; });}
  callbackTransmission(new_value){ setState(() { transmissionController = new_value; });}
  callbackWd(new_value){ setState(() { wdController = new_value; });}
  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  

  void initState() {
    get_cars_index();
    callbackFunc('0');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,
      body: ListView(
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
              controller: vinCodeController,
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
                child: Text('VIN', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: marks, callbackFunc: callbackMarka,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Marka', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: models, callbackFunc: callbackModel,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Model', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: body_types, callbackFunc: callbackBodyType,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Kuzow görnüşi', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: colors, callbackFunc: callbackColor,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Reňki', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: fuels, callbackFunc: callbackFuel,),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Ýangyç görnüşi', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: transmissions, callbackFunc: callbackTransmission),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Karopka görnüşi', style: TextStyle(color: Colors.black, fontSize: 12),
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
                child: MyDropdownButton(items: wheel_drives, callbackFunc: callbackWd),
              ),
            ),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Ýöredijiniň görnüşi', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        
        Row(
          children: <Widget>[
            Expanded(child:
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
                  controller: startYearController,
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
                    child: Text('Pes ýyl', style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),),
          
            Expanded(child: Stack(
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
                      controller: endYearController,
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
                        child: Text('Ýokary ýyl', style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        
        Row(
          children: <Widget>[
            Expanded(child:Stack(
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
              controller: startPriceController,
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
                child: Text('Pes baha', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),),

            Expanded(child:Stack(
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
              controller: endPriceController,
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
                child: Text('Ýokary baha', style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
            ),
          ],
        ),),],),
        const SizedBox(height: 10,),
        Container(margin: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 200,
                  child: CustomCheckBox(labelText:'Nagt däl töleg',  callbackFunc: callbackNone_cash_pay, status: false)),

        Container(margin: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 180,
                  child: CustomCheckBox(labelText:'Kredit', callbackFunc: callbackCredit, status: false)),
        
        Container(margin: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 200,
                  child: CustomCheckBox(labelText:'Çalyşyk', callbackFunc: callbackSwap,status: false),),
        
        Container(margin: EdgeInsets.only(left: 15),
                  height: 40,
                  width: 180,
                  child: CustomCheckBox(labelText:'Reňki öwrülen', callbackFunc: callbackRecolored, status: false),),        

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
                    if (modelController!={}){params['model'] = modelController['id'].toString();}
                    if (markaController!={}){params['mark'] = markaController['id'].toString();}
                    if (body_typeController!={}){params['body_type'] = body_typeController['id'].toString();}
                    if (colorController!={}){params['color'] = colorController['id'].toString();}
                    if (fuelController!={}){params['fuel'] = fuelController['id'].toString();}
                    if (transmissionController!={}){params['transmission'] = transmissionController['id'].toString();}
                    if (wdController!={}){params['wd'] = wdController['id'].toString();}
                    if (locationController!={}){params['location'] = locationController['id'].toString();}
                    if (vinCodeController.text!=''){params['vin'] = vinCodeController.text.toString();}
                    if (idController.text!=''){params['id'] = idController.text.toString();}
                    
                    if (startPriceController.text!=''){params['price_min'] = startPriceController.text.toString();}
                    if (endPriceController.text!=''){params['price_max'] = endPriceController.text.toString();}

                    if (startYearController.text!=''){params['yearStart'] = startYearController.text.toString();}
                    if (endYearController.text!=''){params['yearEnd'] = endYearController.text.toString();}    

                    if (credit == true) { params['credit'] = 'on';}
                    if (swap == true) { params['swap'] = 'on';}
                    if (none_cash_pay == true) { params['none_cash'] = 'on';}
                    if (recolored == true) { params['recolored'] = 'on';}
                  
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CarSearchList(params: params) )); 
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
    );
  }
  void get_cars_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/car';
    final uri = Uri.parse(url);
    var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'device_id': device_id});
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json;
      models = json['models'];
      marks = json['marks'];
      body_types = json['body_types'];
      colors = json['colors'];
      fuels = json['fuels'];
      transmissions = json['transmissions'];
      wheel_drives = json['wheel_drives'];
    });
    }
}

