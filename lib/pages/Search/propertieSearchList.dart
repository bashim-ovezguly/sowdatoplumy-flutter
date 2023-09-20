// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:provider/provider.dart';
  
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../Propertie/propertiesDetail.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';


class ProperrieSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  ProperrieSearchList({Key? key, required this.params}) : super(key: key);

  @override
  State<ProperrieSearchList> createState() => _ProperrieSearchListState(params: params);
}

class _ProperrieSearchListState extends State<ProperrieSearchList> {
  Map<String, dynamic> params;
  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;

  bool filter = false;
  callbackFilter(){
    timers();
    setState(() { 
    determinate = false;
    getflatslist();
  });}

  void initState() {
    timers();
    getflatslist();
  super.initState();}

    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      print(t);
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  _ProperrieSearchListState({required this.params});

  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
      appBar: AppBar(
        title: const Text('Gözleg', style: CustomText.appBarText,),
      ),
      body:determinate? Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
            child:Row(
              children: <Widget>[
                Text("Emläk - " + data.length.toString() + " sany",
                  style:  TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: CustomColors.appColors),),
                const Spacer(),
                Container(margin: const EdgeInsets.only(right: 20), child:
                GestureDetector(
                    onTap: (){ showConfirmationDialog(context); },
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PropertiesDetail(id: data[index]['id'].toString())));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      child: Card(
                        elevation: 4,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                            alignment: Alignment.centerLeft,

                                            child: Text(
                                              data[index]['name'].toString(),
                                              style: CustomText.itemTextBold,)),),

                                      Expanded(child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children:  <Widget>[
                                                Text(data[index]['location'].toString() + " " + data[index]['location_status'].toString(),
                                                    style: CustomText.itemText)],),)),
                                      
                                      Expanded(child: Row(
                                        children: [
                                          Expanded(child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children:  <Widget>[
                                            Text(data[index]['price'].toString() + ' man',style: CustomText.itemText)],),),),
                                            
                                          Expanded(child:Align(
                                            alignment: Alignment.topCenter,
                                            child: Row(
                                          children:  <Widget>[
                                            SizedBox(width: 10,),
                                            Text('otag sany: ', style: CustomText.itemText),
                                            Text(data[index]['room_count'].toString(),style: CustomText.itemText)],),)),
                                        ],
                                      )),    
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  );
                }),
          )
        ],
      ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
    ): CustomProgressIndicator(funcInit: initState);
  }

  void getflatslist() async {

           var sort = Provider.of<UserInfo>(context, listen: false).sort;
    var sort_value = "";
    
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
    String url = server_url.get_server_url() + '/mob/flats?';
    if (params['id']!=null){ url = url + 'id=' + params['id'] + "&"; }
    if (params['floor']!=null){ url = url + 'floor=' + params['floor'] + "&"; }
    if (params['at_floor']!=null){ url = url + 'at_floor=' + params['at_floor'] + "&"; }
    if (params['room_count']!=null){ url = url + 'room_count=' + params['room_count'] + "&"; }
    if (params['location']!='null'){ url = url + 'location=' + params['location'] + "&"; }

    if (params['category']!='null'){ url = url + 'category=' + params['category'] + "&"; }
    if (params['remont_state']!='null'){ url = url + 'remont_state=' + params['remont_state'] + "&"; }

    if (params['credit']!=null && params['credit']=='on'){ url = url + 'credit=' + params['credit'] + "&"; }
    if (params['swap']!=null && params['swap']=='on'){ url = url + 'swap=' + params['swap'] + "&"; }
    if (params['none_cash']!=null && params['none_cash']=='on'){ url = url + 'none_cash=' + params['none_cash'] + "&"; }
    if (params['own']!=null && params['own']=='on'){ url = url + 'own=' + params['own'] + "&"; }
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
        return CustomDialog(sort_value: sort, callbackFunc:  callbackFilter,);},);}
}


