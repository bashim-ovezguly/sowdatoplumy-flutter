import 'package:flutter/material.dart';
import 'package:my_app/dB/providers.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../dB/colors.dart';
import '../../../dB/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../call.dart';

class ArrivedOrderDetail extends StatefulWidget {
  final String order_id;
  final Function refresh;
  ArrivedOrderDetail({Key? key, required this.order_id, required this.refresh}) : super(key: key);

  @override
  State<ArrivedOrderDetail> createState() => _ArrivedOrderDetailState();
}

class _ArrivedOrderDetailState extends State<ArrivedOrderDetail> {
  bool determinate = false;
  int item_count = 0;
  var shoping_carts = [];
  var array = [];
  var baseurl = "";
  var order = {};
  var products = [];
  int delivery_price_int = 0;
  var status ;
  void set_order_status(value){
    setState(() {
      status=value;
    });
  }
  void initState() {
    get_order_detail(widget.order_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showSuccessAlert(){
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Sagydyň ýagdaýy üýtgedildi!',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success,
        onConfirmBtnTap: (){
          Navigator.pop(context);
          get_order_detail(widget.order_id);
        });
    }

    showErrorAlert(String text){
      QuickAlert.show(
        text: text,
        title: "Ýalňyşlyk!",
        confirmBtnColor: Colors.green,
        confirmBtnText: 'Dowam et',
        context: context, 
        type: QuickAlertType.error);
    }

    showWorningAlert(String text, String id){
      QuickAlert.show(
        title: 'Sebet ID: $id',
        text: text,
        context: context, 
        confirmBtnText: 'Tassyklaýaryn',
        confirmBtnColor: Colors.green,
        onConfirmBtnTap: () async {
          
            Urls server_url  =  new Urls();
            String url = server_url.get_server_url() + '/mob/orders/delete/$id';
            final uri = Uri.parse(url);
            var responsess = Provider.of<UserInfo>(context, listen: false).update_tokenc();
            if (await responsess){
              var token = Provider.of<UserInfo>(context, listen: false).access_token;
              final response = await http.post(uri, headers: {'token': token});
              if (response.statusCode==200){
                widget.refresh();
                Navigator.pop(context);
                Navigator.pop(context);
              }
              else { 
                Navigator.pop(context);
                showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');
              }  
            setState(() {determinate = false;});
            get_order_detail(widget.order_id);
            }
        },
        type: QuickAlertType.info);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Sargyt: ' + widget.order_id.toString())),
    body: RefreshIndicator(
         color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: () async {
          setState(() {
            get_order_detail(widget.order_id);
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },

        child: determinate? CustomScrollView(
        slivers: [
            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,(BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: Row(
                        children: [
                          SizedBox(height: 10),
                          Expanded(flex: 3, child: GestureDetector(
                            onTap: () async {
                              final call = Uri.parse('tel:'+ order['customer']['phone'].toString());
                              if (await canLaunchUrl(call)) {
                                launchUrl(call);}
                              else {
                                throw 'Could not launch $call';
                                }
                            },
                            child: Text(order['customer']['name'].toString() + "  " + order['customer']['phone'].toString(), overflow: TextOverflow.clip, style: TextStyle(color: CustomColors.appColors, fontSize: 16))
                          )),
                          Spacer(),
                          if (order['status']=='accepted')
                           Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors)),
                            child: const Text("Kabul edilen", style: TextStyle(color: Color.fromARGB(255, 160, 121, 3)))),
                          if (order['status']=='canceled')
                           Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors)),
                            child: const Text("Gaýtarylan", style: TextStyle(color: Colors.red))),
                          if (order['status']=='pending')
                           Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors)),
                            child: const Text("Garaşylýar", style: TextStyle(color: Colors.green)))
                        ]
                      ))
                  ]));
            })),

            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,(BuildContext context, int index) {
                return Container(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("Harytlaryň bahasy:", style: TextStyle(color: CustomColors.appColors, fontSize: 15)),
                          Spacer(),
                          Text(order['product_total'].toString() + " TMT", style: TextStyle(color: CustomColors.appColors, fontSize: 15))
                      ]),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text("Eltip bermek bahasy:", style: TextStyle(color: CustomColors.appColors, fontSize: 15)),
                          Spacer(),
                          Text(order['delivery_price'].toString(), style: TextStyle(color: CustomColors.appColors, fontSize: 15))
                      ]),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Text("Umumy töleg:", style: TextStyle(color: CustomColors.appColors, fontSize: 15)),
                          Spacer(),
                          Text(order['total'].toString() + " TMT", style: TextStyle(color: CustomColors.appColors, fontSize: 15))
                      ]),
                      SizedBox(height: 5),
                      if (order['note']!='' && order['note']!=null)
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Bellik: " + order['note'].toString(), style: TextStyle(color: CustomColors.appColors, fontSize: 15))
                            )
                          ]
                        )
                  ]));
            })),

          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: products.length, (BuildContext context, int index) {
              return Container(
                height: 110,
                child: Card(
                  elevation: 4,
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Container(
                        child: Image.network(
                          baseurl + products[index]['img'].toString(),
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
                          fit: BoxFit.cover)
                      )),
                      Expanded(flex: 5, child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            Expanded(flex: 2, child: Container(alignment: Alignment.centerLeft,
                              child: Text(products[index]['name'].toString() , maxLines: 1, overflow: TextOverflow.clip , style: CustomText.size_16)
                            )),
                        
                            Expanded(flex: 2, child: Container(alignment: Alignment.centerLeft,
                                child: Text(products[index]['price'].toString()+ ' TMT' , style: CustomText.size_16))),

                            Expanded(flex: 3, child: Row(
                              children: [
                                Text(products[index]['total'].toString()+ ' TMT' , style: CustomText.size_16),
                                Spacer(),
                                Expanded(flex: 3, child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                                  children: [
                                    if (order['status']=='pending')
                                    Expanded(child: GestureDetector(
                                      onTap: () async {
                                        // Decrement Item count ------
                                          if (products[index]['amount']>1){
                                            var amount = products[index]['amount'].toInt() - 1;
                                            var id = products[index]['id'];
                                            Urls server_url  =  new Urls();
                                              String url = server_url.get_server_url() + '/mob/orders/products/$id';
                                              final uri = Uri.parse(url);
                                              var token = Provider.of<UserInfo>(context, listen: false).access_token;

                                              final response = await http.put(uri, headers: {'token': token}, 
                                                                              body: {'amount': amount.toString()});
                                              if (response.statusCode==200){
                                                get_order_detail(widget.order_id);
                                              }
                                              else{
                                                showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');
                                              }  
                                          } else {showErrorAlert('Harydyň sany birden az bolup bilmeýär');}
                                      },
                                      child: Container(
                                      height: 35,
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Color.fromARGB(255, 155, 154, 154))),
                                  child: Icon(Icons.remove, color: Colors.green, size: 20)),
                                )),
                                
                                Expanded(child: Align(child: Text(products[index]['amount'].toString(), style: CustomText.size_16))),

                                  if (order['status']=='pending')
                                        Expanded(child: GestureDetector(
                                          onTap: () async {
                                              // Increment Item count ++++++
                                              var id = products[index]['id'];
                                              var amount = products[index]['amount'].toInt() + 1;
                                                Urls server_url  =  new Urls();
                                                  String url = server_url.get_server_url() + '/mob/orders/products/$id';
                                                  final uri = Uri.parse(url);
                                                  var token = Provider.of<UserInfo>(context, listen: false).access_token;
                                                  final response = await http.put(uri, headers: {'token': token}, body: {'amount':amount.toString()});
                                                  if (response.statusCode==200){
                                                    get_order_detail(widget.order_id);
                                                  }
                                                  else{
                                                    showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');
                                                  }  
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Color.fromARGB(255, 155, 154, 154))),
                                            child: Icon(Icons.add, color: Colors.green, size: 20))
                                        ))

                                      ],
                                    ),
                                  )),
                                    if (order['status']=='pending')
                                    Expanded(flex: 2, child: Container(
                                  child: GestureDetector(
                                    onTap: () async {

                                        // Detele Item
                                        var id = products[index]['id'];
                                        Urls server_url  =  new Urls();
                                        String url = server_url.get_server_url() + '/mob/orders/products/delete/$id';
                                        final uri = Uri.parse(url);
                                        var token = Provider.of<UserInfo>(context, listen: false).access_token;
                                        final response = await http.post(uri, headers: {'token': token});
                                        if (response.statusCode==200){
                                          setState(() {determinate = false;});
                                        get_order_detail(widget.order_id);
                                        }else{showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');}  
                                      
                                      },
                                    child: Icon(Icons.delete, color: Colors.red, size: 30))))
                              ],
                            ))
                          ]
                        )
                      )),
                    ]
                    )));
              })),
          ]
        ): Center(child: CircularProgressIndicator(
        color: CustomColors.appColors))
    ),
  floatingActionButton: Container(
    margin: EdgeInsets.only(left: 30),
    height: 40, width: double.infinity,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: FloatingActionButton.extended(
        onPressed: () async {
          Urls server_url  =  new Urls();
          var id = widget.order_id; 
          String url = server_url.get_server_url() + '/mob/orders/$id';
          final uri = Uri.parse(url);
          var token = Provider.of<UserInfo>(context, listen: false).access_token;
          final response = await http.put(uri, headers: {'token': token}, body: {'status': 'accepted'});

          if (response.statusCode==200){
            showSuccessAlert();
            widget.refresh();
          }
          else{
            Navigator.pop(context);
              showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy!');
            }  

          },
        label: Row(children: [Icon(Icons.check, size: 15,), Text('Kabul etmek', style: TextStyle(fontSize: 12))]),
        backgroundColor: Colors.green,
        )),
        Expanded(child: FloatingActionButton.extended(
        onPressed: () async {
          Urls server_url  =  new Urls();
          var id = widget.order_id; 
          String url = server_url.get_server_url() + '/mob/orders/$id';
          final uri = Uri.parse(url);
          var token = Provider.of<UserInfo>(context, listen: false).access_token;
          final response = await http.put(uri, headers: {'token': token}, body: {'status': 'canceled'});

          if (response.statusCode==200){
            showSuccessAlert();
            widget.refresh();
          }
          else{
            Navigator.pop(context);
              showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy!');
            } 
          },
        label: Row(children: [Icon(Icons.close, size: 15), Text('Gaýtarmak', style: TextStyle(fontSize: 12))]),
        backgroundColor: Colors.amber,
        )),
        
        Expanded(child: FloatingActionButton.extended(
        onPressed: () async {
          showWorningAlert('Sargydy pozmagy tassyklaň!', order['id'].toString());
          },
        label: Row(children: [Icon(Icons.delete, size: 15), Text('Pozmak', style: TextStyle(fontSize: 12))]),
        backgroundColor: Colors.red,
        )) 
      ]
    ),
  )
    );
  }
    get_order_detail(String order_id)async {
    Urls server_url  =  new Urls();
      String url = server_url.get_server_url() + '/mob/orders/$order_id';
      final uri = Uri.parse(url);
      final response = await http.get(uri);
      final json = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
        baseurl =  server_url.get_server_url();
        order  = json['data'];
        products = json['data']['products'];
        item_count = products.length;
        determinate = true;
    });
  }
}

class OrderUpdateStatus extends StatefulWidget {
  final Function set_order_status;
  final String id;
  final Function refresh;
   OrderUpdateStatus({Key? key, required this.set_order_status, required this.refresh, required this.id}) : super(key: key);

  @override
  State<OrderUpdateStatus> createState() => OorderUpdateSatatuState();
}

class OorderUpdateSatatuState extends State<OrderUpdateStatus> {
  String? gender;
  @override
  Widget build(BuildContext context) {

    showErrorAlert(String text){
      QuickAlert.show(
        text: text,
        title: "Ýalňyşlyk!",
        confirmBtnColor: Colors.green,
        confirmBtnText: 'Dowam et',
        onConfirmBtnTap: (){
          Navigator.pop(context);
        },
        context: context, 
        type: QuickAlertType.error);}
    
    showSuccessAlert(){
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Sagydyň ýagdaýy üýtgedildi!',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success,
        onConfirmBtnTap: (){
          widget.refresh();
          Navigator.pop(context);
          Navigator.pop(context);
        });
    }
    return AlertDialog(
      icon: Row(
        children: [
          Icon(Icons.shopping_cart_sharp, color: Colors.green),
          Text("  Sagydyň ýagdaýyny saýlaň!", style: TextStyle(color: CustomColors.appColors, fontSize: 16))
        ]),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
        height: 180,
        width: 100,
        child:  Column(
            children: [  
              RadioListTile(
                title: Text("Garaşylýar"),
                value: "pending", 
                groupValue: gender, 
                onChanged: (value){
                  setState(() {
                    gender = value.toString();
                  });
              }),
              RadioListTile(
                title: Text("Tassyklanyldy"),
                value: "accepted", 
                groupValue: gender, 
                onChanged: (value){
                  setState(() {
                    gender = value.toString();
                  });
                }),
                RadioListTile(
                  title: Text("Gaýtarylan"),
                  value: "canceled", 
                  groupValue: gender, 
                  onChanged: (value){
                    setState(() {
                      gender = value.toString();
                    });
                  })
            ]
          )
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: (){ Navigator.pop(context);},
              child: const Text('Goý bolsun')
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async { 

                Urls server_url  =  new Urls();
                var id = widget.id; 
                String url = server_url.get_server_url() + '/mob/orders/$id';
                final uri = Uri.parse(url);
                var token = Provider.of<UserInfo>(context, listen: false).access_token;
                final response = await http.put(uri, headers: {'token': token}, 
                                                body: {'status': gender});
                if (response.statusCode==200){
                  Navigator.pop(context);
                  showSuccessAlert();
                }
                else{
                  Navigator.pop(context);
                  showErrorAlert('Bagyşlaň ýalňyşlyk ýüze çykdy');
                }  
                widget.refresh();
                widget.set_order_status(gender);
                Navigator.pop(context);
                
                },
              child: const Text('OK')
            )
          ],
        )
      ],
    );
  }
}