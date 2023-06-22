import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/pages/Customer/loadingWidget.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../error.dart';
import '../success.dart';


class NewProduct extends StatefulWidget {
  
  const  NewProduct({Key? key, required this.title, required this.customer_id, required this.id, required this.action}) : super(key: key);
  final String title;
  final String customer_id, id, action;
  @override
  State<NewProduct> createState() => _NewProductState(title: title , customer_id: customer_id, id:id , action: action);
}

class _NewProductState extends State<NewProduct> {
  List<String> img = [
    "https://www.southernliving.com/thmb/dvvxHbEnU5yOTSV1WKrvvyY7clY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-1205217071-2000-2a26022fe10b4ec8923b109197ea5a69.jpg",

  ];
  final String customer_id, id, action;
  String title;
  List<File> images = [];

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
        images = [];
        images.add(image!);
        }
      });
  }
  callbackStatus(){
    Navigator.pop(context);
  }

  final name_tmController = TextEditingController();
  final priceController = TextEditingController();

  _NewProductState({required this.title, required this.customer_id, required this.id, required this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: ListView(
        children: <Widget>[
          Container(alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10,top: 10),
            child: Text("Haryt goşmak",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: CustomColors.appColors)),),

           Container(
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
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
            alignment: Alignment.center,
            height: 35,
            margin: const EdgeInsets.only(left: 20,right: 20, top: 10),
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
          SizedBox(height: 300,),

          if (images.length==0)
            SizedBox(height: 100,),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child:Row(
                children: images.map((country){
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
                onPressed: () {
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
                    String url = server_url.get_server_url() + '/mob/products';
                    final uri = Uri.parse(url);
                    var  request = new http.MultipartRequest("POST", uri);
                    var token = Provider.of<UserInfo>(context, listen: false).access_token;
                    
                    request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', 'token': token});
                    request.fields['name_tm'] = name_tmController.text;
                    request.fields['price'] = priceController.text;
                    request.fields['customer'] =  customer_id.toString();
                    if (action=='store'){
                      request.fields['store'] = id;  
                    }
                    if (action=='factory'){
                      request.fields['factory'] = id;  
                    }
                    
                    for (var i in images){
                       var multiport = await http.MultipartFile.fromPath('images', i.path, contentType: MediaType('image', 'jpeg'),);
                       request.files.add(multiport);
                    }
                    showLoaderDialog(context);
                    
                    final response = await request.send();
                    if (response.statusCode == 200){
                      Navigator.pop(context); 
                      showConfirmationDialogSuccess(context);    
                     }
                     else{
                      Navigator.pop(context); 
                      showConfirmationDialogError(context);    
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
        return SuccessAlert(action: 'factories', callbackFunc: callbackStatus,);},);}
  
  showConfirmationDialogError(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ErrorAlert();},);}

}
