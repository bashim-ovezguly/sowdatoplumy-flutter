import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/main.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/error.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../select.dart';
import '../../success.dart';
import '../loadingWidget.dart';


class ConstructionAdd extends StatefulWidget {
  ConstructionAdd({Key? key, required this.customer_id, required this.refreshFunc}) : super(key: key);
  final String customer_id;
  final Function refreshFunc;

  @override
  State<ConstructionAdd> createState() => _ConstructionAddState(customer_id: customer_id);
}
class _ConstructionAddState extends State<ConstructionAdd> {
  var data = {};
  List<dynamic> categories = [];
  
  List<dynamic> stores = [];
  var storesController = {};
  callbackStores(new_value){ setState(() { storesController = new_value; });}
  
  final String customer_id;
  final name_tmController = TextEditingController();
  final priceController = TextEditingController();
  final phoneController = TextEditingController();
  final detailController = TextEditingController();

  var locationController = {};
  var categoryController = {} ;

  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  callbackCategory(new_value){ setState(() { categoryController = new_value; });}

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

  callbackStatus(){
    Navigator.pop(context);
  }

  
  void initState() {
    get_materials_index();
    get_userinfo();
    super.initState();
  }
  _ConstructionAddState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar( title: const Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text("Gurluşyk haryt goşmak", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CustomColors.appColors),),
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
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Dükan : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: stores, callbackFunc: callbackStores)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: priceController,
              decoration: const InputDecoration(hintText: 'Bahasy :',
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
              decoration: const InputDecoration(hintText: 'Telefon :',
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
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Bölümi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: categories, callbackFunc: callbackCategory)
                ),],),),
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
                hintText: '...',
                fillColor: Colors.white,),),),

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
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.appColors,
                    foregroundColor: Colors.white),
                onPressed: () async {

                    Urls server_url  =  new Urls();
                    String url = server_url.get_server_url() + '/mob/materials';
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
                    request.fields['name_tm'] = name_tmController.text;
                    request.fields['category'] = categoryController['id'].toString();
                    request.fields['price'] = priceController.text;
                    request.fields['phone'] =  phoneController.text;      
                    request.fields['detail'] = detailController.text;
                    request.fields['location'] = locationController['id'].toString();
                    request.fields['customer'] =  customer_id.toString();

                    for (var i in selectedImages){
                       var multiport = await http.MultipartFile.fromPath('images', i.path, contentType: MediaType('image', 'jpeg'),);
                       request.files.add(multiport);
                    }
                    showLoaderDialog(context);
                    
                    final response = await request.send();
                    if (response.statusCode == 200){
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
        return SuccessAlert(action: 'construction', callbackFunc: callbackStatus,);},);}

  showConfirmationDialogError(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();},);}

  void get_materials_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/material';
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
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {stores = json['data']['stores'];});
    Provider.of<UserInfo>(context, listen: false).setAccessToken(data[0]['name'], data[0]['age']);}
}