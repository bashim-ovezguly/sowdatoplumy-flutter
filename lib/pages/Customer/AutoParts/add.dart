import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../error.dart';
import '../../select.dart';
import '../../success.dart';
import '../loadingWidget.dart';


class AutoPartsAdd extends StatefulWidget {
  AutoPartsAdd({Key? key, required this.customer_id, required this.refreshFunc}): super(key: key);
  final String customer_id;
  final Function refreshFunc;
  @override
  State<AutoPartsAdd> createState() => _AutoPartsAddState(customer_id: customer_id);
}

class _AutoPartsAddState extends State<AutoPartsAdd> {

  var data = {};
  List<dynamic> categories = [];
  List<dynamic> factories = [];
  List<dynamic> made_in_countries = [];
  List<dynamic> fuels = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  List<dynamic> models = [];
  List<dynamic> marks = [];
  List<dynamic> stores = [];
  
  final String customer_id;
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final priceController = TextEditingController();
  final startYearController = TextEditingController();
  final endYearController = TextEditingController();
  final simpleCodeController = TextEditingController();
  final origCodeController = TextEditingController();
  final duplicateCodeController = TextEditingController();
  final vinCodeController = TextEditingController();
  
  var markaController = {};
  var storesController = {};
  var modelController = {};  
  var locationDestController = {};
  var categoryController = {};
  var locationController = {};
  
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
  callbackStores(new_value){ setState(() { storesController = new_value; });}
  callbackModel(new_value){ setState(() { modelController = new_value; });}
  callbackCategory(new_value){ setState(() { categoryController = new_value; });}
  callbackLocation(new_value){ setState(() { locationController = new_value; });}  
  callbackStatus(){Navigator.pop(context);}

  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;
  
  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}


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
  
  void initState() {
    get_parts_index();
    get_userinfo();
    super.initState();
  }
  
  _AutoPartsAddState({required this.customer_id});
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar( title: Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: const Text("Awtoulag şaýlary goşmak", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, color: CustomColors.appColors),),
          ),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Ady',
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
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Dükan: ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),)),
                Expanded(flex: 4, child: MyDropdownButton(items: stores, callbackFunc: callbackStores,)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Marka: ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),)),
                Expanded(flex: 4, child: MyDropdownButton(items: marks, callbackFunc: callbackMarka,)
                ),],),),
          const SizedBox(height: 15,),
            
          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 1,child: Text("Model: ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),)),
                Expanded(flex: 4, child: MyDropdownButton(items: models, callbackFunc: callbackModel)
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
                Expanded(flex: 2,child: Text("Ýerleşýän ýeri: ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),)),
                if (locationController['name_tm']!=null)
                Expanded(flex: 4, child: Text(locationController['name_tm']))
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
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Kategoriýa: ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold),)),
                Expanded(flex: 4, child: MyDropdownButton(items: categories, callbackFunc: callbackCategory)
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
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: priceController,
              decoration: const InputDecoration(hintText: 'Bahasy: ',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors, style: BorderStyle.solid, width: 1.0,),),
            height: 100,
            width: double.infinity,
            child:  const TextField(
              cursorColor: Colors.red,
              maxLines:  3 ,
              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintText: '........',
                fillColor: Colors.white,),),),
          const SizedBox(height: 10,),


          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: selectedImages.map((country){
                  return Column(
                    children: [
                      Stack(
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
                              selectedImages.remove(country);
                            });
                          },
                          child: Container(
                            height: 100, width:110,
                            alignment: Alignment.topRight,
                            child: Icon(Icons.close, color: Colors.red),),),
                          ],

                  )
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
                    String url = server_url.get_server_url() + '/mob/parts';
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;
                   
                    Map<String, String> headers = {};  
                    for (var i in global_headers.entries){
                      headers[i.key] = i.value.toString(); 
                    }
                    headers['token'] = token;
                    request.headers.addAll(headers);
                    
                    if (storesController['id']!=null){request.fields['store'] = storesController['id'].toString();}
                    request.fields['model'] = modelController['id'].toString();
                    request.fields['mark'] = markaController['id'].toString();
                    request.fields['price'] = priceController.text.toString();
                    request.fields['phone'] = phoneController.text.toString();
                    request.fields['name_tm'] = nameController.text.toString();
                    request.fields['category'] = categoryController['id'].toString();
                    request.fields['customer'] =  customer_id.toString();
                    request.fields['location'] = locationController['id'].toString();
                    
                    for (var i in selectedImages){
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
        return SuccessAlert(action: 'parts', callbackFunc: callbackStatus,);},);}
  
  showConfirmationDialogError(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();},);}

  void get_parts_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/part';
    final uri = Uri.parse(url);
    Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json;
      categories = json['categories'];
      factories = json['factories'];
      fuels = json['fuels'];
      transmissions = json['transmissions'];
      wheel_drives = json['wheel_drives'];
      made_in_countries = json['made_in_countries'];
      models = json['models'];
      marks = json['marks'];
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

    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded','token': data[0]['name']},);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {stores = json['data']['stores'];});
    Provider.of<UserInfo>(context, listen: false).setAccessToken(data[0]['name'], data[0]['age']);}

    
}



