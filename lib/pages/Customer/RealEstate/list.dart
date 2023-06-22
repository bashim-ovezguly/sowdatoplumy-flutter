import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Customer/RealEstate/add.dart';
import 'package:my_app/pages/Customer/RealEstate/getFirst.dart';
import '../../../dB/colors.dart';
import '../../../dB/textStyle.dart';


class RealEstateList extends StatefulWidget {
  RealEstateList({Key? key, required this.customer_id, required this.callbackFunc}) : super(key: key);
  final String customer_id;
  final Function callbackFunc;
  @override
  State<RealEstateList> createState() => _RealEstateListState(customer_id: customer_id);
}

class _RealEstateListState extends State<RealEstateList> {
  final String customer_id;

  List<dynamic> data = [];
  var baseurl = "";
  bool determinate = false;

  void initState() {
    widget.callbackFunc();
    get_my_flats(customer_id: customer_id);
    super.initState();
  }

  refreshFunc() async {
    widget.callbackFunc();
    get_my_flats(customer_id: customer_id);
  }

  _RealEstateListState({required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meniň sahypam", style: CustomText.appBarText,),
            actions: [
        PopupMenuButton<String>(
          itemBuilder: (context) {
                List<PopupMenuEntry<String>> menuEntries2 = [
                   PopupMenuItem<String>(
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RealEstateAdd(customer_id:customer_id, refreshFunc: refreshFunc )));  
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.green,),
                          Text(' Goşmak')
                        ],
                      ),
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
        onRefresh: () async {
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
                  Align(alignment: Alignment.centerLeft,child: Container( padding: const EdgeInsets.only(left: 10, top: 5),child:  Text("Emläkler sany" + data.length.toString() ,style: TextStyle(fontSize: 18, color:CustomColors.appColors),),),),
                if (data.length==0)
                  Align(alignment: Alignment.centerLeft,child: Container( padding: const EdgeInsets.only(left: 10, top: 5),child:  Text("Sizde şu wagtlykça Emläkler yok  " ,style: TextStyle(fontSize: 16, color:CustomColors.appColors),),),),
                
              ],
          )),

          Expanded(flex: 12,child:ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){ 

                  Navigator.push(context, MaterialPageRoute(builder: (context) => GetRealEstateFirst(id: data[index]['id'].toString(), refreshFunc: refreshFunc )));  
                  
                  },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Card(
                        elevation: 4,
                        child: Container(
                          height: 110,
                          margin: EdgeInsets.only(bottom: 5, left: 5, right: 5,top: 5),
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
                                            margin: EdgeInsets.only(left: 5),
                                            child: Text(
                                              data[index]['name'].toString(),
                                              overflow: TextOverflow.clip,
                                                maxLines: 2,
                                                softWrap: false,
                                              style: CustomText.itemTextBold,)),),

                                      Expanded(child:Align(
                                            alignment: Alignment.centerLeft,


                                           child: Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            data[index]['location'].toString(),
                                            overflow: TextOverflow.clip,
                                            maxLines: 2,
                                            softWrap: false,
                                            style: CustomText.itemTextBold,),)
                                            
                                            
                                            )),
                                      
                                      Expanded(child: Row(
                                        children: [
                                          Expanded(child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children:  <Widget>[
                                            Text(data[index]['price'].toString(),style: CustomText.itemText)],),),),
                                            
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
              );},),),

        ],
      ):Center(child: CircularProgressIndicator(
        color: CustomColors.appColors,),),
      )
    );
  }

  void get_my_flats({required customer_id}) async {
    print(customer_id);
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/flats?customer=$customer_id';
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
