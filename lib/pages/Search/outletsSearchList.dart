// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';  
import 'package:http/http.dart' as http;
import 'package:my_app/pages/Store/merketDetail.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';



class OutletsSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  OutletsSearchList({Key? key, required this.params}) : super(key: key);

  @override
  State<OutletsSearchList> createState() => _OutletsSearchListState(params: params);
}

class _OutletsSearchListState extends State<OutletsSearchList> {
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
    get_stores();
    });}

    void initState() {  
      timers();
    get_stores();
    super.initState();
  }
    timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  _OutletsSearchListState({required this.params});
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
      appBar: AppBar(
        title: const Text('Gözleg', style: CustomText.appBarText,),
      ),
      body: determinate? Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
            child:Row(
              children: <Widget>[
                Text("Söwda nokatlary - " + data.length.toString() + " sany",
                  style:  TextStyle(fontSize: 18, color: CustomColors.appColors),),
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
                  
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(title: 'Söwda nokatlar', id: data[index]['id'].toString() )));  
                  
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
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
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
                                            SizedBox(
                                              width: 200,
                                              child: Text(data[index]['location'],
                                                style: CustomText.itemText,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                ),
                                            )],),)),
                                      if (data[index]['category']!=null && data[index]['category']!='')
                                        Expanded(child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: <Widget>[
                                              SizedBox(
                                                child: Text(data[index]['category'],
                                                  style: CustomText.itemText,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  ),
                                              )],),))

                                      
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                )
              );},)
          )
        ],
      ):Center(child: CircularProgressIndicator(color: CustomColors.appColors)) 
      
    ): CustomProgressIndicator(funcInit: initState);
  }

  void get_stores() async {
    

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
    String url = server_url.get_server_url() + '/mob/stores?';

    if (params['category']!='null'){ url = url + 'category=' + params['category'] + "&"; }
    if (params['size']!='null'){ url = url + 'size=' + params['size'] + "&"; }
    if (params['name_tm']!=null){ url = url + 'name_tm=' + params['name_tm'] + "&"; }
    if (params['id']!=null){ url = url + 'id=' + params['id'] + "&"; }
    
    if (params['open_at']!=null){ url = url + 'open_at=' + params['open_at'] + "&"; }
    if (params['close_at']!=null){ url = url + 'close_at=' + params['close_at'] + "&"; }
    if (params['location']!='null'){ url = url + 'location=' + params['location'] + "&"; }

    if (params['credit']!=null && params['credit']=='on'){ url = url + 'credit=' + params['credit'] + "&"; }
    if (params['none_cash']!=null && params['none_cash']=='on'){ url = url + 'none_cash=' + params['none_cash'] + "&"; }
    url = url + sort_value; 

    final uri = Uri.parse(url);
    print(uri);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      determinate = true;
    });
      print(data);
    }
  showConfirmationDialog(BuildContext context){
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort,callbackFunc: callbackFilter,);},);}
}


