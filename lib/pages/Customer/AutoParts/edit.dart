// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/AwtoCar/edit.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/selectEdit.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../select.dart';
import '../../success.dart';
import '../loadingWidget.dart';


class AutoPartsEdit extends StatefulWidget {
  final Function callbackFunc;
  AutoPartsEdit({Key? key, required this.old_data, required this.callbackFunc}) : super(key: key);
  var old_data ;
  @override
  State<AutoPartsEdit> createState() => _AutoPartsEditState(old_data: old_data, callbackFunc: callbackFunc);
}

class _AutoPartsEditState extends State<AutoPartsEdit> {
  var data = {};
  final Function callbackFunc;
  var baseurl = "";
  var old_data ={}; 
  List<dynamic> categories = [];
  List<dynamic> made_in_countries = [];
  List<dynamic> fuels = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  List<dynamic> models = [];
  List<dynamic> marks = [];
  
  int _mainImg = 0;

  
  List<dynamic> stores = [];
  var storesController = {};
  callbackStores(new_value){ setState(() { storesController = new_value; });}

  bool status = false;
  callbackStatus(){ setState(() { status = true; });}

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final priceController = TextEditingController();
  final detailController = TextEditingController();

  var markaController = {};
  var modelController = {};  
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
  callbackModel(new_value){ setState(() { modelController = new_value; });}
  callbackCategory(new_value){ setState(() { categoryController = new_value; });}
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
    get_parts_index();
    get_userinfo();
    super.initState();
  }
  
  _AutoPartsEditState({required this.old_data, required this.callbackFunc});
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar( title: Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: const Text("Awtoulag şaýlary üýtgetmek", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, color: CustomColors.appColors),),
          ),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors, )),
            child:  TextFormField(
              controller: nameController,
              decoration: InputDecoration(hintText: old_data['name_tm']!='' && old_data['name_tm']!=null ? old_data['name_tm']: "Ady",
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
              if (old_data['store_name']!= null && old_data['store_name']!='')
                Expanded(flex: 2,child: Text(old_data['store_name'].toString() , style: TextStyle(fontSize: 15, color: Colors.black54),)),
              if (old_data['store_name']==null || old_data['store_name']=='')
                Expanded(flex: 2,child: Text("Dükan : ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),

              Expanded(flex: 4, child: MyDropdownButtonEdit(items: stores, callbackFunc: callbackStores, text: "aman")
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,),
              if (old_data['mark']!= null && old_data['mark']!='')
                Expanded(flex: 2,child: Text(old_data['mark'].toString() , style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),
              if (old_data['mark']==null || old_data['mark']=='')
                Expanded(flex: 2,child: Text("Awtoulag marka : ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),

              Expanded(flex: 4, child: MyDropdownButtonEdit(items: marks, callbackFunc: callbackMarka, text: "aman")
                ),],),),
          const SizedBox(height: 15,),
            
          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), 
              if (old_data['model']!= null && old_data['model']!='')
                Expanded(flex: 2,child: Text(old_data['model'].toString() , style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),
              if (old_data['model']==null || old_data['model']=='')
                Expanded(flex: 2,child: Text("Model: ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),

                Expanded(flex: 4, child: MyDropdownButton(items: models, callbackFunc: callbackModel)
                ),],),),
          const SizedBox(height: 15,),

        GestureDetector(
              child: Container(
              height: 35,
              margin: const EdgeInsets.only(left: 20,right: 20),
              width: double.infinity,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
              child: Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Expanded(flex: 2,child: Text("Ýerleşýän ýeri : ", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),
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
              if (old_data['category']!= null && old_data['category']!='')
                Expanded(flex: 2,child: Text(old_data['category']['name'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),
              if (old_data['category']==null || old_data['category']=='')
                Expanded(flex: 3,child: Text("Kategoriýa", style: TextStyle(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.bold,),)),
              
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
              decoration:  InputDecoration(hintText: old_data['phone']!=null ? 'Telefon ' + old_data['phone'].toString(): "Telefon",
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors, )),
            child:  TextFormField(
              controller: priceController,
              decoration: InputDecoration(hintText: old_data['price']!= null ? 'Baha' + old_data['price'].toString(): "Baha",
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
 
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors, style: BorderStyle.solid, width: 1.0,),),
            height: 100,
            width: double.infinity,
            child:  TextField(
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
                                      return DeleteImage(action: 'parts', image: country, callbackFunc: remove_image,);},);
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
              child: Row(
                children: selectedImages.map((country){
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
                    String url = server_url.get_server_url() + '/mob/parts/'+ old_data['id'].toString();
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("PUT", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;
                    
                      // create request headers
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

                    if (markaController['id']!=null){
                      request.fields['mark'] = markaController['id'].toString();
                    }

                    if (priceController.text!=''){
                      request.fields['price'] = priceController.text.toString();
                    }

                    if (nameController.text!=''){
                      request.fields['name_tm'] = nameController.text.toString();
                    }
                    
                    if (locationController['id']!=null){
                      request.fields['location'] = locationController['id'].toString();
                    }    

                    if (_mainImg!=0){
                      request.fields['img'] = _mainImg.toString();
                    }
                    
                    if (phoneController.text!=''){
                      request.fields['phone'] = phoneController.text.toString();
                    }

                    if (categoryController['id']!=null){
                      request.fields['category'] = categoryController['id'].toString();
                    }
           
                    if (detailController.text!=''){
                      request.fields['detail'] =  detailController.text.toString();
                    }

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

    showSuccess(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return SuccessPopup();},);}

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
      // create request headers
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      baseurl =  server_url.get_server_url();
      data  = json;
      categories = json['categories'];
      fuels = json['fuels'];
      transmissions = json['transmissions'];
      wheel_drives = json['wheel_drives'];
      models = json['models'];
      marks = json['marks'];
    });
    }

      
    void get_userinfo() async {
    var allRows = await dbHelper.queryAllRows();
    var data = [];for (final row in allRows) {data.add(row);}
    if (data.length==0){Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));}
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/customer/' + data[0]['userId'].toString() ;
    final uri = Uri.parse(url);
    // create request headers
      Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
      headers['token'] = data[0]['name'];
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {stores = json['data']['stores'];});
    Provider.of<UserInfo>(context, listen: false).setAccessToken(data[0]['name'], data[0]['age']);}
}


