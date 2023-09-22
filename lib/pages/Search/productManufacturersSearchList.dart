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
import '../ProductManufacturers/productManufacturersDetail.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';

class ProductManufacturersSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  ProductManufacturersSearchList({Key? key, required this.params}) : super(key: key);

  @override
  State<ProductManufacturersSearchList> createState() => _ProductManufacturersSearchListState(params: params);
}

class _ProductManufacturersSearchListState extends State<ProductManufacturersSearchList> {
  Map<String, dynamic> params;
  var data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;

  bool filter = false;
  callbackFilter(){
    timers();
    setState(() { 
    determinate = false;
    getfactorieslist();
  });}
  
  void initState() {
    timers();
    getfactorieslist();
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

  _ProductManufacturersSearchListState({required this.params});
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: const Text('Gözleg', style: CustomText.appBarText,),
      ),
      body: determinate? Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
            child:Row(
              children: <Widget>[
                Text("Önüm öndürijiler - " + data.length.toString() + " sany",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: CustomColors.appColors),),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductManufacturersDetail(id: data[index]['id'].toString())));
                     },
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Card(
                      elevation: 2,
                      child: Container(
                        height: 110,
                        margin: EdgeInsets.all(5),
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
                                margin: EdgeInsets.only(left: 2),
                                padding: const EdgeInsets.all(10),
                                color: CustomColors.appColors,
                                child: Column(
                                  children: <Widget>[

                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          data[index]['name'].toString(),
                                          style: CustomText.itemTextBold,),),),

                                    Expanded(child:Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: <Widget>[
                                          Text(data[index]['location'].toString(), style: CustomText.itemText)],),)),

                                    // Expanded(
                                    //     child:Align(
                                    //       alignment: Alignment.centerLeft,
                                    //       child: Row(
                                    //         children: const <Widget>[
                                    //           SizedBox(width: 10,),
                                    //           Icon(Icons.access_time_outlined,color: Colors.white,),
                                    //           SizedBox(width: 10,),
                                    //           Text('1 sagat öň', style: CustomText.itemText)],),)),

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

  void getfactorieslist() async {
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
    String url = server_url.get_server_url() + '/mob/factories?';
    if (params['id']!=null){ url = url + 'id=' + params['id'] + "&"; }
    if (params['name_tm']!=null){ url = url + 'name_tm=' + params['name_tm'] + "&"; }

    if (params['category']!='null'){ url = url + 'category=' + params['category'] + "&"; }
    if (params['location']!='null'){ url = url + 'location=' + params['location'] + "&"; }
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
