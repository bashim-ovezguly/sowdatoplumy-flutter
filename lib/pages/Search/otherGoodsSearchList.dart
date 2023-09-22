// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../OtherGoods/otherGoodsDetail.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';


class OtherGoodsSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  OtherGoodsSearchList({Key? key, required this.params}) : super(key: key);
  @override
  State<OtherGoodsSearchList> createState() => _OtherGoodsSearchListState(params: params);
}

class _OtherGoodsSearchListState extends State<OtherGoodsSearchList> {
  Map<String, dynamic> params;
  List<dynamic> data = [];
  var baseurl = "";  
  bool determinate = false;
  bool status = true;

  callbackFilter(){setState(() { 
    timers();
    determinate = false;
    getproductlist();
    
    });}
  
  void initState() {
    timers();
    getproductlist();
    super.initState();
  }
     timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      print(t);
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  _OtherGoodsSearchListState({required this.params});
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: const Text('Gözleg', style: CustomText.appBarText,),
      ),
      body: determinate ? Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
            child:Row(
              children: <Widget>[
                Text("Harytlar - " + data.length.toString() + " sany",
                  style: TextStyle(fontSize: 18, color: CustomColors.appColors),),
                const Spacer(),
                Container(margin: const EdgeInsets.only(right: 20), child:
                GestureDetector(
                    onTap: (){showConfirmationDialog(context);},
                    child: const Icon(Icons.sort, size: 25,))
                )
              ],
            ),),
          SizedBox(
            height: MediaQuery.of(context).size.height - 130,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){ 
                      if (data[index]['id']!=null){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OtherGoodsDetail(id: data[index]['id'].toString(), title: 'Harytlar',)));
                      }
                       
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
                                        child: data[index]['img'] != '' && data[index]['img'] != null ? Image.network(baseurl + data[index]['img'].toString(),):
                                        Image.asset('assets/images/default.jpg', ),),),
                                     )),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  color: CustomColors.appColors,
                                  margin: EdgeInsets.only(left: 2),
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data[index]['name'],
                                            style: CustomText.itemTextBold,),),),

                                      Expanded(child:Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Text(data[index]['location'].toString(), style: CustomText.itemText)],),)),

                                      Expanded(
                                          child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: <Widget>[
                                                Text(data[index]['delta_time'].toString(),style: CustomText.itemText)],),)),

                                            Expanded(child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children:  <Widget>[
                                                  Text('Kredit',style: TextStyle(color: Colors.white, fontSize: 12)),
                                                  data[index]['credit'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                                  SizedBox(width: 5,),
                                                  Text('Obmen',style: TextStyle(color: Colors.white, fontSize: 12)),
                                                  data[index]['swap'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                                  SizedBox(width: 5,),
                                                  Text('Nagt däl',style: TextStyle(color: Colors.white, fontSize: 12)),
                                                  data[index]['none_cash_pay'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                                
                                              ],)
                                            ,)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
      
    ): CustomProgressIndicator(funcInit: initState);
  }
  void getproductlist() async {

        var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    print(sort_value);
    
    if (int.parse(sort)==2){
      sort_value = 'sort=price';
    }
    
    if (int.parse(sort)==3){
      sort_value = 'sort=-price';
    }
    
    if (int.parse(sort)==4){
      sort_value = 'sort=id';
    }

    if (int.parse(sort)==4){
      sort_value = 'sort=-id';
    }
    
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/products?';
      
    if (params['category']!='null'){ url = url + 'category=' + params['category'] + "&"; }
    if (params['brand']!='null'){ url = url + 'brand=' + params['brand'] + "&"; }
    if (params['made_in']!='null'){ url = url + 'made_in=' + params['made_in'] + "&"; }  
    if (params['name']!=null){ url = url + 'name=' + params['name'] + "&"; }
    if (params['id']!=null){ url = url + 'id=' + params['id'] + "&"; }
    if (params['location']!='null'){ url = url + 'location=' + params['location'] + "&"; }

    if (params['credit']!=null && params['credit']=='on'){ url = url + 'credit=' + params['credit'] + "&"; }
    if (params['swap']!=null && params['swap']=='on'){ url = url + 'swap=' + params['swap'] + "&"; }
    if (params['none_cash']!=null && params['none_cash']=='on'){ url = url + 'none_cash=' + params['none_cash'] + "&"; }
    url = url + sort_value; 
    final uri = Uri.parse(url);
    var device_id = Provider.of<UserInfo>(context, listen: false).device_id;
    final response = await http.get(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded', 'device_id': device_id});
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      determinate = true;
    });}

  showConfirmationDialog(BuildContext context){
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter,);},);}
}
