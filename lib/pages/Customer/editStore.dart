import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/deleteImage.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:provider/provider.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../select.dart';
import '../success.dart';
import '../../dB/colors.dart';
import 'package:intl/intl.dart';

import 'loadingWidget.dart';


class EditStore extends StatefulWidget {
  var old_data;
  final Function callbackFunc ;
  EditStore({Key? key, required this.old_data, required this.callbackFunc}) : super(key: key);
  
  @override
  State<EditStore> createState() => _EditStoreState(old_data: old_data, callbackFunc: callbackFunc);
}

class _EditStoreState extends State<EditStore> {
  var old_data;
  var data = {};
  var baseurl = "";
  final Function callbackFunc ;
  List<dynamic> categories = [];
  List<dynamic> sizes = [];
  List<dynamic> trade_centers = [];
  List<dynamic> streets = [];
  List<File> images = [];
  bool desible = false;
  int _mainImg = 0;

  final nameController = TextEditingController();
  final body_tmController = TextEditingController();
  final open_atController = TextEditingController();
  final close_atController = TextEditingController();
  final addressController = TextEditingController();
  String phoneController = "Telefon" ;
  
  callbackPhone(new_value){ setState(() { 
    if (phoneController=='Telefon'){ phoneController =  new_value; }
    else{ phoneController =  phoneController +", " + new_value; }});}

  bool status = false;
  callbackStatus(){
    setState(() {
      status = true;
      initState();
    });
  }

  var categoryController = {};
  var locationController = {};
  var streetController = {};
  var sizeController = {};

  callbackCategory(new_value){ setState(() { categoryController = new_value; });}
  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  callbackStreet(new_value){ setState(() { streetController = new_value; });}
  callbackSize(new_value){ setState(() { sizeController = new_value; });}
  
  File? image;
  Future<void> addimages() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) { print('Failed to pick image: $e');}
    setState(() { if (image != null){ images.add(image!);}});
  }

  remove_image(value){ setState(() {old_data['images'].remove(value);});}

  void initState() {
    print(status);
    if (status==true){
      Navigator.pop(context);
    }
    get_store_index();
    super.initState();
  }
  _EditStoreState({required this.old_data, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Meniň sahypam", style: CustomText.appBarText,),),
    body: ListView(
      children: <Widget>[
        Container(alignment: Alignment.topLeft,
          padding: const EdgeInsets.only(left: 10,top: 10),
          child: Text("Söwda nokat üýtgetmek",
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: CustomColors.appColors)),),

            Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: nameController,
              decoration: InputDecoration(hintText: old_data['name_tm']!= null ? old_data['name_tm'].toString(): 'Ady',
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
                    Expanded(flex: 3,child: Text("Kategoriýasy", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                  Expanded(flex: 4, child: MyDropdownButton(items: categories, callbackFunc: callbackCategory)
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
                  decoration: InputDecoration(hintText: old_data['address']!= null ? 'Address :' +  old_data['address'].toString(): 'Address :',
                      border: InputBorder.none,
                      focusColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }return null;
                },),),

              GestureDetector(
                onTap: (){ showConfirmationDialogAddphone(context); },
                child: Container(
                alignment: Alignment.centerLeft,
                height: 35,
                margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                child:  Text(" " + phoneController,)),),

              Container(
                height: 35,
                margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                child: Row(
                  children: <Widget>[SizedBox(width: 10,),
                  
                  if (old_data['street']!= null && old_data['street']!='')
                    Expanded(flex: 2,child: Text(old_data['street'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54),)),
                  if (old_data['street']==null || old_data['street']=='') 
                    Expanded(flex: 2,child: Text("Ýerleşýän köçesi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                  
                  Expanded(flex: 4, child: MyDropdownButton(items: streets, callbackFunc: callbackStreet)
              ),],),),

              Container(
                height: 35,
                margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                child: Row(
                  children: <Widget>[SizedBox(width: 10,),
                  if (old_data['size']!= null && old_data['size']!='')
                    Expanded(flex: 2,child: Text(old_data['size'].toString(), style: TextStyle(fontSize: 15, color: Colors.black54),)),
                  if (old_data['size']==null || old_data['size']=='') 
                    Expanded(flex: 2,child: Text("Ululygy : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                  Expanded(flex: 4, child: MyDropdownButton(items: sizes, callbackFunc: callbackSize)
              ),],),),

              Container(
                alignment: Alignment.center,
                height: 35,
                margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                child:  TextFormField(
                  controller: open_atController,
                  decoration: InputDecoration(hintText: old_data['open_at']!= null ? 'Açylýan wagty: '+old_data['open_at'].toString(): 'Açylýan wagty:',
                      border: InputBorder.none,
                      focusColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay ? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                          );
                        if(pickedTime != null ){
                          DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                          String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                          setState(() {
                            open_atController.text = formattedTime; 
                            });
                        }else{
                          print("Time is not selected");
                        }
                    },),),

              Container(
                alignment: Alignment.center,
                height: 35,
                margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                child:  TextFormField(
                  controller: close_atController,
                  decoration: InputDecoration(hintText: old_data['close_at']!= null ? 'Ýapylýan wagty: '+old_data['close_at'].toString(): 'Ýapylýan wagty: ',
                      border: InputBorder.none,
                      focusColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 14)),
                      readOnly: true,
                      onTap: () async {
                        TimeOfDay ? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                          );
                        if(pickedTime != null ){
                          DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                          String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                          setState(() {
                            close_atController.text = formattedTime; 
                            });
                        }else{
                          print("Time is not selected");
                        }
                    },),),

              Container(
                alignment: Alignment.topLeft,
                height: 100,
                margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                child:  TextFormField(
                  controller: body_tmController,
                  decoration: InputDecoration(hintText: old_data['body_tm']!= null ? old_data['body_tm']: "Düşündiriliş",
                      border: InputBorder.none,
                      focusColor: Colors.white,
                      contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }return null;
                },),),
        SizedBox(height: 30,),
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
                                  child: Image.network(baseurl + country['img_l'],fit: BoxFit.cover,height: 100,width: 100,
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
        
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: images.map((country){
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
                      height: 100, width:100,
                      alignment: Alignment.topLeft,
                      child: Image.file(country, fit: BoxFit.cover, height: 100, width: 100,)
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
          height: 45,
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.appColors,
                  foregroundColor: Colors.white),
              onPressed: ()  async {
                addimages();
                },
              child: const Text('Surat goş',style: TextStyle(),),
            ),
          ),
        ),
        Container(
          height: 45,
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.appColors,
                  foregroundColor: Colors.white),
               onPressed: () async {
                                                      
                    Urls server_url  =  new Urls();
                    String url = server_url.get_server_url() + '/mob/stores/' + old_data['id'].toString();
                    final uri = Uri.parse(url);
                    print(uri);
                    var  request = new http.MultipartRequest("PUT", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;

                    request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                    
                    if (nameController.text!=''){
                      request.fields['name_tm'] = nameController.text;
                    }

                    if (categoryController['id']!= null){
                      request.fields['category'] = categoryController['id'].toString();
                    }
                    
                    if (_mainImg!=0){
                      request.fields['img'] = _mainImg.toString();
                    }

                    if (sizeController['id']!= null){
                      request.fields['size'] = sizeController['id'].toString();
                    }
                    
                    if ( locationController['id']!=null ){
                      request.fields['location'] = locationController['id'].toString();
                    }
                    
                    if (streetController['id']!=null){
                      request.fields['street'] = streetController['id'].toString();
                    }

                    if (addressController.text!=''){
                      request.fields['address'] = addressController.text;
                    }

                    if (phoneController!='' && phoneController!='Telefon'){
                      request.fields['phone'] = phoneController;
                    }

                    if (open_atController.text!=''){
                      request.fields['open_at'] = open_atController.text;
                    }

                    if (close_atController.text!=''){
                      request.fields['close_at'] = close_atController.text;
                    }
                    
                    if (body_tmController.text!=''){
                      request.fields['body_tm'] = body_tmController.text;
                    }
                    if (images.length!=0){
                      for (var i in images){
                       var multiport = await http.MultipartFile.fromPath('images', i.path, contentType: MediaType('image', 'jpeg'),);
                       request.files.add(multiport);
                       }
                    }
                    print(request.fields);
                    showLoaderDialog(context);
                    final response = await request.send();         
                    if (response.statusCode == 200){ 
                      callbackFunc();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      }
                    else{ 
                      Navigator.pop(context);
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                    width: 70,
                                    height: 70,
                                    child: Text('Bagyşlaň maglumat üýtgetmede ýalñyşlyk ýüze çykdy täzeden synanşyp görüň!'),),
                                  actions: <Widget>[
                                    Align(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white),
                                        onPressed: () {Navigator.pop(context,'Close');},
                                        child: const Text('Dowam et'),
                                      ),)],);},);
                      }
                },
              child: const Text('Ýatda sakla',style: TextStyle(),),
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
        return SuccessAlert(action: 'store', callbackFunc: callbackStatus);},);}


  showConfirmationDialogAddphone(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AddPhone(callbackFunc: callbackPhone,);},);}
  

  void get_store_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/store';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json;
      baseurl =  server_url.get_server_url();
      categories = json['categories'];
      sizes = json['sizes'];
      trade_centers = json['trade_centers'];
      streets = json['streets'];
    });
    }
  
}


class AddPhone extends StatefulWidget {

  AddPhone({Key? key, required this.callbackFunc}) : super(key: key);
  
  final Function callbackFunc;
  
  _AddPhoneState createState() => _AddPhoneState(callbackFunc: callbackFunc);
}

class _AddPhoneState extends State<AddPhone> {
  final Function callbackFunc;
  final phoneController1 = TextEditingController();

  _AddPhoneState({required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Row(
        children: [
          Text('Telefon belgi' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(Icons.close, color: Colors.red, size: 25,),
          )
        ],
      ),
      content: Container(
        alignment: Alignment.center,
        height: 35,
        margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
        child:  TextFormField(
        controller: phoneController1,
        decoration: const InputDecoration(hintText: 'Telefon',
          border: InputBorder.none,
          focusColor: Colors.white,
          contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }return null;
        },),),

      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            onPressed: () {
              setState(() {
                callbackFunc(phoneController1.text);
              });

              Navigator.pop(context, 'Close');
            },
            child: const Text('Goşmak'),
          ),
        )
      ],
    );
  }
}