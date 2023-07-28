import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/myPage.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';
import 'newStore.dart';
import '../../dB/colors.dart';

class MyStores extends StatefulWidget {
  MyStores({Key? key,  required this.customer_id, required this.callbackFunc}) : super(key: key);
  final String customer_id;
  final Function callbackFunc;
  
  @override
  State<MyStores> createState() => _MyStoresState(customer_id: customer_id);
}

class _MyStoresState extends State<MyStores> {
  final String customer_id ;
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;
  
  refreshFunc() async {
    widget.callbackFunc();
    get_my_stores(customer_id: customer_id);}

  @override
  void initState() {
    timers();  
    widget.callbackFunc();
    get_my_stores(customer_id: customer_id);
    super.initState();
  }
      timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }
  

  _MyStoresState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return status? Scaffold(
        appBar: AppBar(title: const Text("Meniň sahypam", style: CustomText.appBarText,),
              actions: [
        PopupMenuButton<String>(
          itemBuilder: (context) {
                List<PopupMenuEntry<String>> menuEntries2 = [
                   PopupMenuItem<String>(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewStore(customer_id: customer_id.toString() , refreshFunc: refreshFunc))); 
                      },
                      child: Container(
                        color: Colors.white,
                        height: 40, width: double.infinity,
                        child: Row(children: [
                          Icon(Icons.add, color: Colors.green),
                          Text(' Goşmak')
                        ]))
                    )
                  ),
         
                ];
                return menuEntries2;
              },
            ), 
      ],
        ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: ()async{
            setState(() {
            determinate = false;
            initState();
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: determinate ? Column(
        children: <Widget>[
          Expanded(flex: 1, 
            child: Row(
              children: [
                if (data.length>0)
                  Align(alignment: Alignment.centerLeft,child: Container( padding: const EdgeInsets.only(left: 10, top: 5),child:  Text("Söwda nokatlar " + data.length.toString() ,style: TextStyle(fontSize: 18, color:CustomColors.appColors),),),),
                if (data.length==0)
                  Align(alignment: Alignment.centerLeft,child: Container( padding: const EdgeInsets.only(left: 10, top: 5),child:  Text("Sizde şu wagtlykça söwda nokat ýok " ,style: TextStyle(fontSize: 16, color:CustomColors.appColors),),),),

              ],
          )),
          Expanded(flex: 15,child:ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async { 
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyPage(id: data[index]['id'].toString() , customer_id : customer_id, refreshFunc: refreshFunc)));  
                  },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Card(
                        elevation: 2,
                        child: Container(
                          height: 110,
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 1,
                                   child: ClipRect(
                                      child: Container(
                                      height: 110,
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: data[index]['img'] != '' ? Image.network(baseurl + data[index]['img'].toString(),):
                                        Image.asset('assets/images/default.jpg', ),),),
                                     )),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: CustomColors.appColors,
                                  margin: EdgeInsets.only(left: 2),
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data[index]['name'].toString(),
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,
                                            style: CustomText.itemTextBold,),),),
                                  
                                      Expanded(child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Icon(Icons.place,color: Colors.white,),
                                            SizedBox(
                                              width: 200,
                                              child: Text(data[index]['location'],
                                                style: CustomText.itemText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                ),
                                            )],),)),

                                      Expanded(
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children:  <Widget>[
                                                Icon(Icons.star_outline_sharp,color: Colors.white,),
                                                if (data[index]['status']!=null && data[index]['status']!= '' && data[index]['status'] == 'pending')
                                                 Text("Garşylýar".toString(),style: TextStyle(color: Colors.amber))
                                                else if (data[index]['status']!=null && data[index]['status']!= '' && data[index]['status'] == 'accepted')
                                                 Text("Tassyklanyldy".toString(),style: TextStyle(color: Colors.green))
                                                else if (data[index]['status']!=null && data[index]['status']!= '' && data[index]['status'] == 'canceled')
                                                 Text("Gaýtarylan".toString(),style: TextStyle(color: Colors.red))
                                            ],),)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                )
              );},),),
        ],
      ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
      
      )
    ): CustomProgressIndicator(funcInit: initState);
  }

  void get_my_stores({required customer_id}) async {
    print(customer_id);
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/stores?customer=$customer_id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      determinate = true;
    });
      print(data);
    }
}


