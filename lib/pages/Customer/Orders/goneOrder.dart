import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../dB/constants.dart';
import 'goneOrderDetail.dart';

class GoneOrders extends StatefulWidget {
  final String customer_id;
  final Function callbackFunc;
  const GoneOrders({Key? key, required this.customer_id, required this.callbackFunc}) : super(key: key);

  @override
  State<GoneOrders> createState() => _GoneOrdersState();
}

class _GoneOrdersState extends State<GoneOrders> {
  bool determinate = false;
  var baseurl = "";
  var orders = [];
  void initState() {
    get_my_orders(widget.customer_id);
    super.initState();
  }
  refresh(){
    get_my_orders(widget.customer_id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: Text('Giden sargytlar', style: TextStyle(color: CustomColors.appColorWhite)),),
      extendBody: true,
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: ()async{
            setState(() {
            determinate = false;
            get_my_orders(widget.customer_id);
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: determinate? Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text("Jemi: " + orders.length.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: CustomColors.appColors))),

            Container(
              height: MediaQuery.of(context).size.height-130,
              child: ListView.separated(
              itemCount: orders.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 140,
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => GoneOrderDetail(order_id: orders[index]['id'].toString(), refresh: refresh)));
                    },
                    child: Card(
                      color: CustomColors.appColorWhite,
                      shadowColor: const Color.fromARGB(255, 200, 198, 198),
                      surfaceTintColor: CustomColors.appColorWhite,
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: Row(
                            children: [
                              Text('ID: '+ orders[index]['id'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors)),
                              Spacer(),
                              Text(orders[index]['created_at'].toString(), style: TextStyle(fontSize: 14, color: CustomColors.appColors)),
                            ]
                          )),
                          Container(height: 2, color: CustomColors.appColors),
                          Expanded(flex: 4, child: Row(
                            children: [
                              Expanded(flex: 2, child: Container(
                                width: 100,
                                margin: EdgeInsets.only(left: 5, top: 5, bottom: 5), 
                                child: orders[index]['store_img']!=null && orders[index]['store_img']!='' && determinate==true ?Image.network(
                                  baseurl + orders[index]['store_img'].toString(),
                                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: CustomColors.appColors,
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  height: 110,
                                  fit: BoxFit.cover
                              ): Image.asset('assets/images/default16x9.jpg')
                              )
                              
                              ),
                              Expanded(flex: 6, child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [                                 
                                    SizedBox(height: 5),

                                    Expanded(child: Container(margin: EdgeInsets.only(left: 5),
                                            child: Text(orders[index]['store_name'].toString(), overflow: TextOverflow.clip, style: TextStyle(fontSize: 14, color: CustomColors.appColors)))),
                                    
                                    Expanded(child: Container(margin: EdgeInsets.only(left: 5),
                                            child: Text(orders[index]['total'].toString() + " TMT", overflow: TextOverflow.clip, style: TextStyle(fontSize: 14, color: CustomColors.appColors)))),
                                    
                                    Expanded(child: Container(margin: EdgeInsets.only(left: 5),
                                            child: Text(orders[index]['product_count'].toString() + " haryt", overflow: TextOverflow.clip, style: TextStyle(fontSize: 14, color: CustomColors.appColors)))),
                                   
                                    Expanded(child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [
                                          if (orders[index]['status']=='pending')
                                            Container(child: Text('Garaşylýar', style: TextStyle(fontSize: 14, color: Colors.green))),
                                          
                                          if (orders[index]['status']=='canceled')
                                            Container(child: Text('Gaýtarylan', style: TextStyle(fontSize: 14, color: Colors.green))),
                                          
                                          if (orders[index]['status']=='accepted')
                                            Container(child: Text('Kabul edilen', style: TextStyle(fontSize: 14, color: Colors.green))),

                                        ]))),
                                  ]
                                )
                              ))  
                            ]
                          ))
                        ]
                      )
                    )
                  )
                  )
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            )
            )
            
          ],

        ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
      )
    );
  }  
  get_my_orders(String customer_id) async {
    Urls server_url  =  new Urls();
      String url = server_url.get_server_url() + '/mob/customers/$customer_id/orders/out';
      final uri = Uri.parse(url);
        Map<String, String> headers = {};  
      for (var i in global_headers.entries){
        headers[i.key] = i.value.toString(); 
      }
      final response = await http.get(uri, headers: headers);
      final json = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
        baseurl =  server_url.get_server_url();
        orders  = json['data'];
        determinate = true;
    });
  }
}
