// ignore_for_file: unused_local_variable
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/pages/Customer/AutoParts/list.dart';
import 'package:my_app/pages/Customer/AwtoCar/list.dart';
import 'package:my_app/pages/Customer/Construction/list.dart';
import 'package:my_app/pages/Customer/OtherGoods/list.dart';
import 'package:my_app/pages/Customer/RealEstate/list.dart';
import 'package:my_app/pages/Customer/Services/list.dart';
import 'package:my_app/pages/Customer/editProfil.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Customer/myStores.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import '../../main.dart';
import 'package:quickalert/quickalert.dart';
import '../progressIndicator.dart';
import 'Orders/arrivedOrders.dart';
import 'Orders/goneOrder.dart';

var user_data = [];


class MyPages extends StatefulWidget {
  const MyPages({Key? key}) : super(key: key);
  

  @override
  State<MyPages> createState() => _MyPagesState();
}

class _MyPagesState extends State<MyPages> {
  var user = {};
  var baseurl = "";
  bool determinate = false;
  bool status = true;
  List<dynamic> stores = [];
  void initState() { 
    timers();
    get_userinfo(); super.initState();
  }

  refreshFunc() async {get_userinfo();}
    
    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }
  
  @override
  Widget build(BuildContext context) {

    showSuccessAlert(){
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Siziň maglumatyňyz üýtgedildi !',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success);
    }
    
    return status? Scaffold(
      appBar: AppBar(title: const Text("Meniň sahypam", style: CustomText.appBarText,),
      actions: [
        GestureDetector(
          onTap: (){
            showConfirmationDialog(context);
          },
          child: Container(
          margin: EdgeInsets.only(right: 10),
          child: Icon(Icons.login_outlined),
        ))],),
      body: 
         determinate ? Column(
        children: <Widget>[
   
              Expanded(flex: 2,child: Row(
            children: <Widget>[
              Expanded(flex: 2,child: SizedBox(
                height: 150,
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(48), // Image radius
                    child: user['img']!=null && user['img']!='' ? Image.network(baseurl + user['img'].toString(), fit: BoxFit.cover,):
                    Image.asset('assets/images/default.jpg')
                  ),))),
              const SizedBox(width: 10),
              Expanded(flex: 3,child: Column(

                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: user['name'] != null ? Text(user['name'].toString(), style: TextStyle(fontSize: 16, color: CustomColors.appColors),):
                                                  Text('', style: TextStyle(fontSize: 16, color: CustomColors.appColors),)
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: user['phone'] != null ? Text(user['phone'].toString(), style: TextStyle(fontSize: 16, color: CustomColors.appColors ),):
                                                   Text('', style: TextStyle(fontSize: 16, color: CustomColors.appColors),)
                    ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: user['email'] != null ? Text(user['email'].toString(), style: TextStyle(fontSize: 16, color: CustomColors.appColors),):
                                                   Text('', style: TextStyle(fontSize: 16, color: CustomColors.appColors),)
                    ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(top: 10),
                    child: user['id'] != null ? Text(user['id'].toString(),style: TextStyle(fontSize: 16, color: CustomColors.appColors),):
                                                Text('', style: TextStyle(fontSize: 16, color: CustomColors.appColors),)
                    ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(5),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const ShapeDecoration(shape: CircleBorder(), color: CustomColors.appColors,
                        ),
                        child: IconButton(onPressed: () {
                          
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfil(customer_id: user['id'].toString(),
                                                                                                     email: user['email'].toString(),
                                                                                                     name: user['name'.toString()],
                                                                                                     phone: user['phone'].toString(),
                                                                                                     img: baseurl + user['img'].toString(),
                                                                                                     callbackFunc: refreshFunc,
                                                                                                     showSuccessAlert: showSuccessAlert
                                                                                                     ) )); 
                          
                          },
                          icon: const Icon(Icons.edit, color: Colors.white,),),),),
                ],),),],),),

          const Divider(color: Colors.black,),
          
          Expanded(flex: 5,child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: (){ 
                     Navigator.push(context, MaterialPageRoute(builder: (context) => MyStores(customer_id: user['id'].toString(),
                                                                                              callbackFunc: refreshFunc,))); 
                  },
                child: Container(
                  padding: EdgeInsets.only(left: 5,right: 5),
                  height: 50,
                  child: Card(
                    elevation: 2,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Söwda nokatlary", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        Spacer(), // use Spacer
                        if (user['room']!= null)
                        Text(user['room']['store'].toString() ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        SizedBox(width: 10,),
                      ],),
                  )
                ),),
              // GestureDetector(
              //   onTap: (){  
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => MyFactories(customer_id: user['id'].toString(), callbackFunc: refreshFunc,)));  
              //     },
              //   child: Container(
              //       padding: EdgeInsets.only(left: 5,right: 5),
              //       height: 50,
              //       child: Card(
              //         elevation: 2,
              //         child: Row(
              //           children:  <Widget>[
              //             SizedBox(width: 10,),
              //             Text("Önüm öndürijiler",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
              //             Spacer(), // use Spacer
              //             if (user['room']!= null)
              //             Text(user['room']['factories'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
              //             SizedBox(width: 10,),
              //           ],),
              //       )
              //   ),),
              GestureDetector(
                onTap: (){ 
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyCars(customer_id: user['id'].toString(), )));  
                  },
                child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    height: 40,
                    child: Card(
                      elevation: 2,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10,),
                          Text("Awtoulaglar",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                          Spacer(), // use Spacer
                          if (user['room']!= null)
                          Text(user['room']['cars'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                          SizedBox(width: 10,),
                      ],),
                  )
                )
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AutoPartsList(customer_id: user['id'].toString(), callbackFunc: refreshFunc,)));  
                  },
                child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                    height: 40,
                    child: Card(
                      elevation: 2,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10,),
                          Text("Awtoşaýlar",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                          Spacer(), // use Spacer
                          if (user['room']!= null)
                          Text(user['room']['parts'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                          SizedBox(width: 10,),
                        ],),)),),
                      
              GestureDetector(
                onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => RealEstateList(customer_id: user['id'].toString(), callbackFunc: refreshFunc,)));  
                  },
                child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                  height: 40,
                  child: Card(
                    elevation: 2,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Emläkler",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        Spacer(), // use Spacer
                        if (user['room']!= null)
                        Text(user['room']['flats'].toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        SizedBox(width: 10,),
                      ],),)),),

              GestureDetector(
                onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ConstructionList(customer_id: user['id'].toString(), callbackFunc: refreshFunc,)));  
                  },
                child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                  height: 40,
                  child: Card(
                    elevation: 2,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Gurluşuk",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        Spacer(), // use Spacer
                        if (user['room']!= null)
                        Text(user['room']['materials'].toString() ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        SizedBox(width: 10,)
                      ],),)),),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyOtherGoodsList(customer_id: user['id'].toString(), callbackFunc: refreshFunc)));  
                  },
                child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                  height: 40,
                  child: Card(
                    elevation: 2,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Harytlar",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        Spacer(), // use Spacer
                        if (user['room']!= null)
                        Text(user['room']['products'].toString() ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        SizedBox(width: 10,)
                      ],),)),),

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyServiceList(customer_id: user['id'].toString(), callbackFunc: refreshFunc)));  
                  },
                child: Container(
                    padding: EdgeInsets.only(left: 5,right: 5),
                  height: 40,
                  child: Card(
                    elevation: 2,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text("Hyzmatlar",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        Spacer(), // use Spacer
                        if (user['room']!= null)
                        Text(user['room']['services'].toString() ,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)),
                        SizedBox(width: 10,)
                      ],),)),),
              Container(
                height: 70,
                padding: EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    children: [
                      Expanded(child: Container(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ArrivedOrders(customer_id: user['id'].toString(), callbackFunc: refreshFunc)));  
                          },
                          child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Expanded(child: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 34, 173, 39))),
                              Expanded(child: Text("Gelen sargytlar: "+ user['orders_in'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)))
                          ]))
                        ))),
                      SizedBox(width: 10),
                      Expanded(child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => GoneOrders(customer_id: user['id'].toString(), callbackFunc: refreshFunc)));  
                          },
                          child: Card(
                          elevation: 2,
                          child: Column(
                            children: [
                              Expanded(child: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 34, 173, 39))),
                              Expanded(child: Text("Giden sargytlar: " + user['orders_out'].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors)))
                          ]))
                        ))),
                    ]
                  )
                
              )
            ],
          ))
        ],
      ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
    ): CustomProgressIndicator(funcInit: initState);
  }
    showConfirmationDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogLogout();},);}
  
  void get_userinfo() async {
    var allRows = await dbHelper.queryAllRows();
  
    var data = [];
    for (final row in allRows) {data.add(row);}
    if (data.length==0){Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));}
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/customer/' + data[0]['userId'].toString() ;
    final uri = Uri.parse(url);
    
    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'token': data[0]['name']});
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      user  = json['data'];
      determinate = true;
      stores = json['data']['stores'];
      baseurl =  server_url.get_server_url();
    });
    Provider.of<UserInfo>(context, listen: false).setAccessToken(data[0]['name'], data[0]['age']);
    }
}

class CustomDialogLogout extends StatefulWidget {
  @override
  _CustomDialogLogoutState createState() => _CustomDialogLogoutState();
}

class _CustomDialogLogoutState extends State<CustomDialogLogout> {
  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(            
            'Ulagamdan çykmak' ,style: TextStyle(color: CustomColors.appColors),
            maxLines: 3,
            ),
        ],
      ),
      content: Row(
          children: [
            ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Goý bolsun'),
          ),
          SizedBox(width: 10,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white),
            onPressed: () async {
              final deleteallRows = await dbHelper.deleteAllRows();
              final deleteallRows1 = await dbHelper.deleteAllRows();
            
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
            },
            child: const Text('Ulgamdan çyk'),
          ),
          ],
        ),
      actions: <Widget>[],
    );
  }
}