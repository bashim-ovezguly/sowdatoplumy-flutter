import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/error.dart';
import 'package:my_app/pages/success.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../select.dart';
import '../loadingWidget.dart';

class FactoriesAdd extends StatefulWidget {
  FactoriesAdd({Key? key, required this.customer_id, required this.refreshFunc}) : super(key: key);
  final String customer_id;
  final Function refreshFunc;
  @override
  State<FactoriesAdd> createState() => _FactoriesAddState(customer_id: customer_id);
}
class _FactoriesAddState extends State<FactoriesAdd> {

  var data = {};
  List<dynamic> categories = [];
  
  List<File> images = [];

  final String customer_id;
  final name_tmController = TextEditingController();
  final body_tmController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  
  callbackStatus(){
    Navigator.pop(context);
  }

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
  
  void initState() {
    get_factorys_index();
    super.initState();
  }
  
  _FactoriesAddState({required this.customer_id});
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
            child: const Text("Önüm öndüriji goşmak", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.appColors),),
          ),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: name_tmController,
              decoration: const InputDecoration(hintText: 'Ady :',
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
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Kategoriýasy : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
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
              decoration: const InputDecoration(hintText: 'Address :',
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
              decoration: const InputDecoration(hintText: 'Telefon :',
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
              decoration: const InputDecoration(hintText: 'Düşündürülişi :',
                border: InputBorder.none,
                focusColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          
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
                    String url = server_url.get_server_url() + '/mob/factories';
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;
                    
                    request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                    request.fields['name_tm'] = name_tmController.text;
                    request.fields['body_tm'] = body_tmController.text;
                    request.fields['address'] = addressController.text;
                    request.fields['phone'] = phoneController.text;
                    request.fields['location'] = locationController['id'].toString();
                    request.fields['category'] = categoryController['id'].toString();
                    request.fields['customer'] =  customer_id.toString();
                    
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
        return SuccessAlert(action: 'factories', callbackFunc: callbackStatus,);},);}
  
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
      data  = json;
      categories = json['categories'];
      print(data);
    });}

}
