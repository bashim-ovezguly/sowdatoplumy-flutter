// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';

import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../select.dart';
import '../loadingWidget.dart';


class FactoriesEdit extends StatefulWidget {
  final Function callbackFunc;
  FactoriesEdit({Key? key, required this.old_data, required this.callbackFunc}) : super(key: key);
  var old_data;
  @override
  State<FactoriesEdit> createState() => _FactoriesEditState(old_data: old_data, callbackFunc: callbackFunc);
}
class _FactoriesEditState extends State<FactoriesEdit> {
  var data = {};
  final Function callbackFunc;
  List<dynamic> categories = [];
  List<File> images = [];
  int _mainImg = 0; 
  var old_data;
  var baseurl = "";

  final name_tmController = TextEditingController();
  final body_tmController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  
  var categoryController = {};
  var locationController = {};
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
    });
  }
  
  void initState() {
    get_factorys_index();
    super.initState();
  }
  
  _FactoriesEditState({required this.old_data, required this.callbackFunc});
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
            child: const Text("Önüm öndüriji üýtgetmek", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.appColors),),
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
          
          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,),
                if (old_data['category']!= null && old_data['category']!='')
                  Expanded(flex: 2,child: Text(old_data['category'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54),)),
                if (old_data['category']==null || old_data['category']=='')
                Expanded(flex: 2,child: Text("Kategoriýa: ", style: TextStyle(fontSize: 15, color: Colors.black54),)),

              Expanded(flex: 4, child: MyDropdownButton(items:  categories, callbackFunc: callbackCategory)
              ),],),),

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

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
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
          
          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
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
              controller: body_tmController,
              decoration: InputDecoration(hintText: old_data['body_tm']!= null ? old_data['body_tm'].toString(): '...',
                border: InputBorder.none,
                focusColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),

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
          
          SizedBox(height: 10,),


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
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColors,
                    foregroundColor: Colors.white),
                onPressed: () async {

                    Urls server_url  =  new Urls();
                    String url = server_url.get_server_url() + '/mob/factories/' + old_data['id'].toString();
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("PUT", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;
                    
                    request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                    if (name_tmController.text!=''){
                      request.fields['name_tm'] = name_tmController.text;
                    }

                    if (body_tmController.text!=''){
                      request.fields['body_tm'] = body_tmController.text;
                    }
                    
                    if (addressController.text!=''){
                      request.fields['address'] = addressController.text;
                    }
                    
                    if (phoneController.text!=''){
                      request.fields['phone'] = phoneController.text;
                    }
                    
                    if (_mainImg!=0){
                      request.fields['img'] = _mainImg.toString();
                    }
                    
                    if (categoryController['id']!=null){
                      request.fields['category'] = categoryController['id'].toString();
                    }

                    if (locationController['id']!=null){
                      request.fields['location'] = locationController['id'].toString();
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


  void get_factorys_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/factory';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    
    setState(() {
      baseurl =  server_url.get_server_url();
      data  = json;
      categories = json['categories'];
      print(data);
    });}

}
