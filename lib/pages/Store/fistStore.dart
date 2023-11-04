import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';
import 'package:my_app/pages/Store/merketDetail.dart';
import '../../dB/colors.dart';
import '../../dB/textStyle.dart';
import '../progressIndicator.dart';


class StoreFirst extends StatefulWidget {
  StoreFirst({Key? key,  required this.id, required this.title}): super(key: key);
   final String id ;
  final String title;

  @override
  State<StoreFirst> createState() =>_StoreFirstState(title: title, id: id);
}

class _StoreFirstState extends State<StoreFirst> {
  final String id ;
  final String title;
  var baseurl = "";
  var data = {};
  bool status = true;
  bool determinate = false;
  List<dynamic> stores = [ ];
  List<String> imgList = [ ];
  List<dynamic> dataSlider = [{'img':''}];
  List<dynamic> dataStores = [];
  
  void initState() {
    timers();
    getsinglemarkets(id: id, title: title);
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

  
_StoreFirstState({required this.title, required this.id});

  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          data['name_tm']!=null && data['name_tm']!='' ? Text(data['name_tm'].toString(), style: CustomText.appBarText): Text(''),
          data['location']!=null && data['location']!=''? Row(
            children: [
              Icon(Icons.location_on, color: CustomColors.appColorWhite,),
              Text(data['location'].toString(), style: TextStyle(fontSize: 15, color: CustomColors.appColorWhite))
            ]
          ): Text(''),
          ]
        )
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
        child: determinate? ListView(
        children: <Widget>[
            Container(
              color: Colors.white,
              child: Container(
                height: 230, 
                width: double.infinity,
                  child: data['img_m'] != null && data['img_m']!='' ? Image.network(baseurl + data['img_m'].toString(), fit: BoxFit.cover):
                  Image.asset('assets/images/default16x9.jpg', fit: BoxFit.cover))),          

          Container(
            margin: EdgeInsets.only(bottom: 5, top: 5),
            alignment: Alignment.centerLeft,
            child: Text("  Dükanlar " + dataStores.length.toString() + " sany" , style: TextStyle(color: CustomColors.appColors, fontSize: 17))
          ),

            Wrap(alignment: WrapAlignment.spaceAround,
            children: dataStores.map((item) {
              return GestureDetector(
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context) => MarketDetail(id: item['id'].toString(), title: 'Dükanlar',) ));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 160,
                        child: Card(
                          color: CustomColors.appColorWhite,
                                        shadowColor: const Color.fromARGB(255, 200, 198, 198),
                                        surfaceTintColor: CustomColors.appColorWhite,
                                        elevation: 5,
                        
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: Container(
                            height: 160,
                            child: Column(
                              children: [
                               Container(
                                  alignment: Alignment.topCenter,
                                  child: item['img']!=null &&  item['img']!="" ? Image.network(
                                    baseurl + item['img'].toString(),
                                    fit: BoxFit.cover,
                                    height: 120, width: MediaQuery.of(context).size.width/2-10,
                        
                                  ): Image.asset('assets/images/default.jpg', height: 120,)
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                         Text(item['name'].toString(), maxLines: 1, style: TextStyle(fontSize: 14, color: CustomColors.appColors, overflow: TextOverflow.ellipsis, ),),
                                         
                                      ]
                                    )
                                  )
                                ]
                              )
                            )
                          ) 
                        )
                      )
                    );
                  }).toList()
                )
        ],
      ):Center(child: CircularProgressIndicator(color: CustomColors.appColors))
      )
    ): CustomProgressIndicator(funcInit: initState);
  }

    void getsinglemarkets({required id, required title}) async {
    Urls server_url  =  new Urls();
    String url = server_url.get_server_url() + '/mob/bazarlar/' + id;

    if (title=="Söwda merkezler"){
      url = server_url.get_server_url() + '/mob/shopping_centers/' + id;
    }

    final uri = Uri.parse(url);
      Map<String, String> headers = {};  
        for (var i in global_headers.entries){
          headers[i.key] = i.value.toString(); 
        }
    final response = await http.get(uri, headers: headers);
    final json = jsonDecode(utf8.decode(response.bodyBytes));
    setState(() {
        data  = json;
        stores = json['stores'];
        baseurl =  server_url.get_server_url();
        dataSlider = json['stores_on_slider'];
        if (dataSlider.length==0){
          dataSlider = [{'img':''}];
        }
        dataStores = data['stores'];
        determinate = true;
    });
  }

}


