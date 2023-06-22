import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/locationWidget.dart';
import 'package:my_app/pages/success.dart';
import 'package:provider/provider.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import '../../../dB/providers.dart';
import '../../../dB/textStyle.dart';
import '../../customCheckbox.dart';
import '../../error.dart';
import '../../select.dart';
import '../loadingWidget.dart';

class AddCar extends StatefulWidget {
  AddCar({Key? key, required this.customer_id, required this.refreshFunc}) : super(key: key);
  final String customer_id;
  final Function refreshFunc;
  @override
  State<AddCar> createState() => _AddCarState(customer_id: customer_id);
}

class _AddCarState extends State<AddCar> {
  var data = {};
  List<dynamic> models = [];
  List<dynamic> marks = [];
  List<dynamic> body_types= [];
  List<dynamic> fruits = [];
  List<dynamic> colors = [];
  List<dynamic> fuels = [];
  List<dynamic> transmissions = [];
  List<dynamic> wheel_drives = [];
  List<File> images = [];
  List<dynamic> made_in_countries = [];
  
  int s = 0;

  final String customer_id;
  final usernameController = TextEditingController();
  final yearController = TextEditingController();
  final millageController = TextEditingController();
  final engineController = TextEditingController();
  final vinCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final priceController = TextEditingController();
  final detailController = TextEditingController();

  bool credit = false ;
  bool swap = false ;
  bool none_cash_pay = false ;
  bool recolored = false ;

  callbackCredit(){ setState(() { credit = ! credit; });}
  callbackSwap(){ setState(() { swap = ! swap; });}
  callbackNone_cash_pay(){ setState(() { none_cash_pay = ! none_cash_pay; });}
  callbackRecolored(){ setState(() { recolored = ! recolored; });}

  var markaController = {};
  var modelController = {};
  var colorController = {};
  var body_typeController = {};
  var fuelController = {};
  var transmissionController = {};
  var wdController = {};
  var locationController = {};
  var locationDestController = {};
  
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
  callbackColor(new_value){ setState(() { colorController = new_value; });}
  callbackBodyType(new_value){ setState(() { body_typeController = new_value; });}
  callbackFuel(new_value){ setState(() { fuelController = new_value; });}
  callbackTransmission(new_value){ setState(() { transmissionController = new_value; });}
  callbackWd(new_value){ setState(() { wdController = new_value; });}
  callbackLocation(new_value){ setState(() { locationController = new_value; });}
  callbackLocationDest(new_value){ setState(() { locationDestController = new_value; });}
  
  callbackStatus(){
    Navigator.pop(context);
  }
  
  File? image;
  Future<void> addimages() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
    setState(() {
      if (image != null){
        images.add(image!);
        s=s+1;
        }
      });
  }

  void initState() {
    get_cars_index();
    super.initState();
  }

  bool light = true;


  _AddCarState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: const Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text("Awtoulag goşmak", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold, color: CustomColors.appColors),),
          ),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 1,child: Text("Marka : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child:MyDropdownButton(items: marks, callbackFunc: callbackMarka)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 1,child: Text("Model : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: models, callbackFunc: callbackModel)
                                                                
                ),],),),
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
                children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Ýurdy : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: made_in_countries, callbackFunc: callbackLocationDest)
              ),],),),
            const SizedBox(height: 15,),
            
          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: yearController,
              decoration: const InputDecoration(hintText: 'Ýyl',
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
              decoration: const InputDecoration(hintText: 'Bahasy',
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
              controller: millageController,
              decoration: const InputDecoration(hintText: 'Geçen ýoly',
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
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 1,child: Text("Reňki : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: colors, callbackFunc: callbackColor  )
                ),],),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child:  TextFormField(
              controller: engineController,
              decoration: const InputDecoration(hintText: 'Matory : ',
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
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Kuzow görnüşi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: body_types, callbackFunc: callbackBodyType)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 2,child: Text("Karopka görnüşi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: transmissions, callbackFunc: callbackTransmission)
                ),],),),
          const SizedBox(height: 15,),

          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 3,child: Text("Ýöredijiniň görnüşi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: wheel_drives, callbackFunc: callbackWd)
                ),],),),
          const SizedBox(height: 15,),
            
          Container(
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
            child: Row(
              children: <Widget>[SizedBox(width: 10,), Expanded(flex: 3,child: Text("Ýangyç görnüşi : ", style: TextStyle(fontSize: 15, color: Colors.black54),)),
                Expanded(flex: 4, child: MyDropdownButton(items: fuels, callbackFunc: callbackFuel)
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
              controller: vinCodeController,
              decoration: const InputDecoration(hintText: 'VIN kod',
                  border: InputBorder.none,
                  focusColor: Colors.white,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 14)), validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }return null;
            },),),
          const SizedBox(height: 15,),

          Container(
            alignment: Alignment.centerLeft,
            height: 80,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 200,
                      child: CustomCheckBox(labelText:'Nagt däl töleg',  callbackFunc: callbackNone_cash_pay, status: false),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 180,
                      child: CustomCheckBox(labelText:'Kredit', callbackFunc: callbackCredit, status: false),

                    )
                  ],
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 200,
                      child: CustomCheckBox(labelText:'Çalyşyk', callbackFunc: callbackSwap, status: false),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      height: 40,
                      width: 180,
                      child: CustomCheckBox(labelText:'Reñklenen', callbackFunc: callbackRecolored, status: false),
                    )
                  ],
                )
              ],
            ),
          ),
   
          const SizedBox(height: 15,),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors, style: BorderStyle.solid, width: 1.0,),),
            height: 100,
            width: double.infinity,
            child: TextField(
              controller: detailController,
              cursorColor: Colors.red,
              maxLines:  3 ,
              decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide.none,),
                filled: true,
                hintText: '........',
                fillColor: Colors.white,),),),
       
       
            //  for (var i in images)
            //   Container(
            //     margin: EdgeInsets.only(left: 8, right: 8),
            //     padding: EdgeInsets.all(5),
            //     height: 150,
            //     width: double.infinity,
            //     child: Card(
            //       elevation: 2,
            //         child: Row(
            //           children: [
            //             GestureDetector(
            //               onTap: (){
            //                 showDialog(context: context,
            //                   builder: (context) => AlertDialog(
            //                     content: Stack(
            //                       alignment: Alignment.center,
            //                       children: <Widget>[
            //                         Image.file(i, fit: BoxFit.cover),
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               },
            //               child: Container(
            //                 margin: const EdgeInsets.all(5),
            //                 height: 140, width: 140,
            //                 alignment: Alignment.topLeft,
            //                 child: Image.file(i, fit: BoxFit.cover, height: 140, width: 140,)
            //               ),
            //             ),
            //             Spacer(),
            //             Container(
            //               height: 120, width: 150,
            //               margin: const EdgeInsets.all(5),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Row(
            //                     children: [
            //                       Text('Pozmak', style: const TextStyle(fontSize: 17, color: CustomColors.appColors)),
            //                       Spacer(),
            //                       GestureDetector(
            //                         onTap: (){
            //                           setState(() {
            //                           images.remove(i);
            //                           });
            //                         },
            //                         child: Icon(Icons.close, color: Colors.red)
            //                       )
            //                     ],
            //                   ),
            //                   Row(
            //                     children: [
            //                       Text('Esasy surat', style: const TextStyle(fontSize: 17, color: CustomColors.appColors)),
            //                       Spacer(),
            //                       Switch(value: light,
            //                         activeColor: CustomColors.appColors,
            //                         onChanged: (bool value) {
            //                           setState(() {
            //                             light = value;
            //                           });
            //                         },
            //                       )
            //                     ],
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //     ),
            //   ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                children: images.map((country){
                  return 
                  Stack(
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
                  addimages();
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
                    String url = server_url.get_server_url() + '/mob/cars';
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;

                    var swap_num = '0';
                    if (swap==true){ swap_num = '1';}
                    
                    var credit_num = '0';
                    if (credit==true){ credit_num = '1';}

                    var none_cash_pay_num = '0';
                    if (none_cash_pay==true){ none_cash_pay_num = '1';}

                    var recolored_num = '0';
                    if (recolored==true){ recolored_num = '1';}


                    request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                    request.fields['model'] = modelController['id'].toString();
                    print(modelController);
                    request.fields['mark'] = markaController['id'].toString();
                    request.fields['price'] = priceController.text.toString();
                    request.fields['vin'] = vinCodeController.text;
                    request.fields['engine'] = engineController.text;
                    request.fields['location'] = locationController['id'].toString();
                    request.fields['made_in'] = locationDestController['id'].toString();
                    request.fields['fuel'] = fuelController['id'].toString();
                    request.fields['transmission'] = transmissionController['id'].toString();
                    
                    request.fields['color'] = colorController['id'].toString();
                    request.fields['body_type'] = body_typeController['id'].toString();
                    request.fields['phone'] = phoneController.text;
                    
                    request.fields['wd'] =  wdController['id'].toString();

                    request.fields['customer'] = customer_id.toString();
                    request.fields['year'] = yearController.text;
                    request.fields['millage'] = millageController.text;
                    request.fields['detail'] = detailController.text;

                    request.fields['swap'] = swap_num;
                    request.fields['credit'] = credit_num;
                    request.fields['none_cash_pay'] = none_cash_pay_num;
                    request.fields['recolored'] = recolored_num;
                    
                    
                    print(request.fields);
                    for (var i in images){
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
        return SuccessAlert(action: 'cars', callbackFunc: callbackStatus,);},);}
  
  showConfirmationDialogError(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();},);}

  void get_cars_index() async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/index/car';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
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
      made_in_countries = json['countries'];
    });
    }
}
