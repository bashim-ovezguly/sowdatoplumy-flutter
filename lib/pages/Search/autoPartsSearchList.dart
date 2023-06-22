// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../Awtoparts/awtoPartsDetail.dart';
import '../sortWidget.dart';


class AutoPartsSearchList extends StatefulWidget {
  Map<String, dynamic> params;
  AutoPartsSearchList({Key? key, required this.params}) : super(key: key);

  @override
  State<AutoPartsSearchList> createState() => _AutoPartsSearchListState(params: params);
}

class _AutoPartsSearchListState extends State<AutoPartsSearchList> {
  Map<String, dynamic> params;
  var baseurl = "";
  bool determinate = false;
  List<dynamic> data = [];

  bool filter = false;
  callbackFilter(){setState(() { 
    determinate = false;
    getpartslist();

  });}

  _AutoPartsSearchListState({required this.params});

    void initState() {
      getpartslist();
      print(params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gözleg', style:  CustomText.appBarText,),
      ),
      body: determinate ? Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
            child:Row(
              children: <Widget>[
                Text("Awtoşaylaryň - " + data.length.toString() + " sany",
                  style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: CustomColors.appColors),),
                const Spacer(),
                Container(margin: const EdgeInsets.only(right: 20), child: GestureDetector(
                    onTap: (){showConfirmationDialog(context);},
                    child: const Icon(Icons.sort, size: 25,)))
              ],
            ),),
          SizedBox(
            height: MediaQuery.of(context).size.height - 130,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => AutoPartsDetail(id: data[index]['id'].toString())));
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                data[index]['name_tm'].toString(),
                                                style: CustomText.itemTextBold,),),),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                 data[index]['location'].toString(),
                                                style: CustomText.itemText,),),),
                                          Expanded(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                    data[index]['price'].toString(),
                                                    style: CustomText.itemText
                                                ),)),
                                          Expanded(child:Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children:  <Widget>[
                                                  SizedBox(width: 5,),
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
                        )

                  );
                }),
          )
        ],
      ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),
    );
  }

  void getpartslist() async {

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
    String url = server_url.get_server_url() + '/mob/parts?';

    if (params['model']!='null'){ url = url + 'model=' + params['model'] + "&"; }
    if (params['mark']!='null'){ url = url + 'mark=' + params['mark'] + "&"; }
    if (params['category']!='null'){ url = url + 'category=' + params['category'] + "&"; }
    if (params['made_in']!='null'){ url = url + 'made_in=' + params['made_in'] + "&"; }
    if (params['part_factory']!='null'){ url = url + 'part_factory=' + params['part_factory'] + "&"; }
    if (params['fuel']!='null'){ url = url + 'fuel=' + params['fuel'] + "&"; }
    
    if (params['location']!='null'){ url = url + 'location=' + params['location'] + "&"; }
    if (params['transmission']!='null'){ url = url + 'transmission=' + params['transmission'] + "&"; }
    if (params['wd']!='null'){ url = url + 'wd=' + params['wd'] + "&"; }
    if (params['name_tm']!=null){ url = url + 'name_tm=' + params['name_tm'] + "&"; }
    if (params['id']!=null){ url = url + 'id=' + params['id'] + "&"; }

    if (params['price_min']!=null){ url = url + 'price_min=' + params['price_min'] + "&"; }
    if (params['price_max']!=null){ url = url + 'price_max=' + params['price_max'] + "&"; }
    if (params['yearStart']!=null){ url = url + 'yearStart=' + params['yearStart'] + "&"; }
    if (params['yearEnd']!=null){ url = url + 'yearEnd=' + params['yearEnd'] + "&"; }

    if (params['credit']!=null && params['credit']=='on'){ url = url + 'credit=' + params['credit'] + "&"; }
    if (params['swap']!=null && params['swap']=='on'){ url = url + 'swap=' + params['swap'] + "&"; }
    if (params['none_cash']!=null && params['none_cash']=='on'){ url = url + 'none_cash=' + params['none_cash'] + "&"; }
    if (params['new']!=null && params['new']=='on'){ url = url + 'new=' + params['new'] + "&"; }
    url = url + sort_value.toString();
    print(url);
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      determinate = true;
      print(data);
    });}

  showConfirmationDialog(BuildContext context){
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter,);},);}
}




