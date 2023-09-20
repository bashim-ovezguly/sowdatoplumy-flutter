import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/ProductManufacturers/add.dart';
import 'package:my_app/pages/Customer/ProductManufacturers/getFirst.dart';

import '../../../dB/colors.dart';
import '../../../dB/textStyle.dart';
import '../../progressIndicator.dart';

class MyFactories extends StatefulWidget {
  MyFactories({Key? key, required this.customer_id, required this.callbackFunc}) : super(key: key);

  final String customer_id;
  final Function callbackFunc;


  @override
  State<MyFactories> createState() => _MyFactoriesState(customer_id: customer_id);
}

class _MyFactoriesState extends State<MyFactories> {
  final String customer_id;
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;
  
  void initState() {
    timers();
    widget.callbackFunc();
    get_my_factores(customer_id: customer_id);
    super.initState();
  }


  refreshFunc() async {
    timers();
    widget.callbackFunc();
    get_my_factores(customer_id: customer_id);
  }
    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }
  
  _MyFactoriesState({required this.customer_id});

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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FactoriesAdd(customer_id: customer_id.toString(), refreshFunc: refreshFunc ))); 
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
        onRefresh: () async{
          setState(() {
            determinate = false;
            initState();
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: determinate? Column(
        children: <Widget>[

          Expanded(flex: 1, 
            child: Row(
              children: [
                if (data.length>0)
                  Align(alignment: Alignment.centerLeft,child: Container( padding: const EdgeInsets.only(left: 10, top: 5),child:  Text("Önüm öndürijileriñ sany " + data.length.toString() ,style: TextStyle(fontSize: 18, color:CustomColors.appColors),),),),
                if (data.length==0)
                  Align(alignment: Alignment.centerLeft,child: Container( padding: const EdgeInsets.only(left: 10, top: 5),child:  Text("Sizde şu wagtlykça Önüm öndürijiler ýok" ,style: TextStyle(fontSize: 16, color:CustomColors.appColors),),),),
        ],
          )),
          Expanded(flex: 12,child:ListView.builder(
            itemCount: data.length ,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FactoriesFirst(id: data[index]['id'].toString() , customer_id: customer_id, refreshFunc: refreshFunc))); 
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
                                margin: EdgeInsets.only(left: 2),
                                padding: const EdgeInsets.all(10),
                                color: CustomColors.appColors,
                                child: Column(
                                  children: <Widget>[

                                    Expanded( flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(left: 5),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[index]['name'].toString(),
                                          overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,
                                          style: CustomText.itemTextBold,),),),

                                    Expanded( flex: 3,
                                      child:Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(Icons.place,color: Colors.white,),
                                          SizedBox(width: 5,),
                                          if (data[index]['location'].toString().length>25)
                                            Text(data[index]['location'].toString().substring(0, 25)+"...", style: CustomText.itemText)
                                          else
                                          Text(data[index]['location'].toString(), style: CustomText.itemText)                
                                          ],),)),
                                        
                                    Expanded( flex: 2,
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children:  <Widget>[
                                                Icon(Icons.star_outline_sharp,color: Colors.white,),
                                                if (data[index]['status']!=null && data[index]['status']!= '' && data[index]['status'] == 'pending')
                                                 Text("Garşylyar".toString(),style: TextStyle(color: Colors.amber))
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
      
      ),
    ): CustomProgressIndicator(funcInit: initState);
  }

    void get_my_factores({required customer_id}) async {
    print(customer_id);
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/factories?customer=$customer_id';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      determinate = true;
    });     
    }
}
