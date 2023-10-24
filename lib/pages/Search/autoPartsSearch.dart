import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../select.dart';
import 'autoPartsSearchList.dart';



class AutoPartsSearch extends StatefulWidget {
  final Function callbackFunc;
  AutoPartsSearch({Key? key, required this.callbackFunc}) : super(key: key);
  @override
  State<AutoPartsSearch> createState() => _AutoPartsSearchState(callbackFunc: callbackFunc);
}

class _AutoPartsSearchState extends State<AutoPartsSearch> {
  var data = {};
  final Function callbackFunc;
  _AutoPartsSearchState({required this.callbackFunc});

  final nameCodeController = TextEditingController();
  final idController = TextEditingController();
  final startPriceController = TextEditingController();
  final endPriceController = TextEditingController();
  
  List<dynamic> categories = [];
  List<dynamic> models = [];
  List<dynamic> marks = [];

  var markaController = {};
  var modelController = {};  
  var categoryController = {};
  var locationController = {};
  
  callbackMarka(new_value){ setState(() async { 
    markaController = new_value;
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/car?mark=' + markaController['id'].toString();
    final uri = Uri.parse(url);
    final responses = await http.get(uri);
    final jsons = jsonDecode(utf8.decode(responses.bodyBytes));
    setState(() { models = jsons['models'];});});}

  callbackModel(new_value){ setState(() { modelController = new_value; });}
  callbackCategory(new_value){ setState(() { categoryController = new_value; });}
  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  
  void initState() {
    get_parts_index();
    callbackFunc(1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
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
        
        //   Stack(
        //   children: <Widget>[
        //     Container(
        //       width: double.infinity,
        //       height: 40,
        //       margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        //       decoration: BoxDecoration(border: Border.all( color: CustomColors.appColors, width: 1),
        //         borderRadius: BorderRadius.circular(5),
        //         shape: BoxShape.rectangle,
        //       ),
        //       child: Container( margin: EdgeInsets.only(left: 15),
        //         child: TextFormField(
        //       controller: idController,
        //       decoration: const InputDecoration(
        //           border: InputBorder.none,
        //           focusColor: Colors.white,
        //           contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
        //       if (value == null || value.isEmpty) {
        //         return 'Please enter some text';
        //       }return null;
        //     },)
        //       ),
        //     ),
        //     Positioned(
        //       left: 25,
        //       top: 12,
        //       child: Container(color: Colors.white,
        //         child: Text('Id', style: TextStyle(color: Colors.black, fontSize: 12),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),

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
              },)),),
            Positioned(
              left: 25,
              top: 12,
              child: Container(color: Colors.white,
                child: Text('Ýokary baha', style: TextStyle(color: Colors.black, fontSize: 12)
                )
              )
            )
          ]
        )
        )])
      ]
    
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
                    if (categoryController!={}){params['category'] = categoryController['id'].toString();}
                    if (locationController!={}){params['location'] = locationController['id'].toString();}
                    if (nameCodeController.text!=''){params['name_tm'] = nameCodeController.text.toString();}
                    // if (idController.text!=''){params['id'] = idController.text.toString();}
                    if (startPriceController.text!=''){params['price_min'] = startPriceController.text.toString();}
                    if (endPriceController.text!=''){params['price_max'] = endPriceController.text.toString();}
                  
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AutoPartsSearchList(params: params) )); 
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
    void get_parts_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/part';
    final uri = Uri.parse(url);
    var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'device_id': device_id});
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json;
      categories = json['categories'];
      models = json['models'];
      marks = json['marks'];
    });
    }
}














