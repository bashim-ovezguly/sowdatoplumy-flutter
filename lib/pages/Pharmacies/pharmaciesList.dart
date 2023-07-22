import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
  
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Pharmacies/pharmacieFirst.dart';
import 'package:my_app/pages/homePages.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/providers.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';
import '../sortWidget.dart';


class PharmaciesList extends StatefulWidget {
  const PharmaciesList({Key? key}) : super(key: key);

  @override
  State<PharmaciesList> createState() => _PharmaciesListState();
}

class _PharmaciesListState extends State<PharmaciesList> {

  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;
  bool status = true;
  
  bool filter = false;
  callbackFilter(){
    timers();
    setState(() { 
    determinate = false;
    getpharmacieslist();
    });}
  
  void initState() {
    timers();
    getpharmacieslist();
    super.initState();}
  
  timers() async {
      setState(() {status = true;});
      final completer = Completer();
      final t = Timer(Duration(seconds: 5), () => completer.complete());
      await completer.future;
      setState(() {if (determinate==false){status = false;}});
  }

  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
      appBar: AppBar(
        title: const Text("Dermanhanalar", style: CustomText.appBarText,),
        actions: [
          Row(
            children: <Widget>[

              Container(
                  padding: const EdgeInsets.all(10),
                  child:  GestureDetector(
                      onTap: (){
                        showConfirmationDialog(context);
                      },
                      child: const Icon(Icons.sort, size: 25,))),

    
              ],)],),

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
          Expanded(flex: 1, child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 10, left: 10),
              child:  Text("Jemi " + data.length.toString() + " dermanhana",
                  style: TextStyle(fontSize: 18, color: CustomColors.appColors, fontWeight: FontWeight.bold)))),
          Expanded(flex:12, child:
            ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacieFirst(id: data[index]['id'].toString()) ));
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
                                        Image.asset('assets/images/default16x9.jpg', ),),),
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
                                              margin: EdgeInsets.only(left: 5),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                data[index]['name'].toString(),
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
                                                    data[index]['phone'].toString(),
                                                    style: CustomText.itemText
                                                ),)),
                                          // Expanded(child:Align(
                                          //   alignment: Alignment.centerLeft,
                                          //   child: Row(
                                          //     children:  <Widget>[
                                          //         SizedBox(width: 5,),
                                          //         Text('Kredit',style: TextStyle(color: Colors.white, fontSize: 12)),
                                          //         data[index]['credit'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                          //         SizedBox(width: 5,),
                                          //         Text('Obmen',style: TextStyle(color: Colors.white, fontSize: 12)),
                                          //         data[index]['swap'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                          //         SizedBox(width: 5,),
                                          //         Text('Nagt däl',style: TextStyle(color: Colors.white, fontSize: 12)),
                                          //         data[index]['none_cash_pay'] ? Icon(Icons.check,color: Colors.green,): Icon(Icons.close,color: Colors.red,),
                                                
                                          //     ],)
                                          //   ,)),
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
      ),
      drawer: const MyDraver(),
      floatingActionButton: Container(
          height: 45,
          width: 45,
          child: Material(
            type: MaterialType.transparency,
            child: Ink(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 182, 210, 196), width: 2.0),
                color : Colors.blue[900],
                shape: BoxShape.circle,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(500.0), 
                onTap: () {
                  Navigator.pushNamed(context, "/search");
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                  //size: 50,
                ),
              ),
            ),
          ),
        ),

    ): CustomProgressIndicator(funcInit: initState);
  }

  showConfirmationDialog(BuildContext context){
    var sort = Provider.of<UserInfo>(context, listen: false).sort;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(sort_value: sort, callbackFunc: callbackFilter,);},);}


  void getpharmacieslist() async {

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
    String url = server_url.get_server_url() + '/mob/pharmacies?'+ sort_value.toString();
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
      data  = json['data'];
      baseurl =  server_url.get_server_url();
      print(data);
      determinate = true;
    });}
}

