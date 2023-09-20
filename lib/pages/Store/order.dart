import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:my_app/dB/textStyle.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:my_app/pages/Store/checkout.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../main.dart';
import '../progressIndicator.dart';


class Order extends StatefulWidget {
  final String store_name;
  final String store_id;
  final Function refresh;
  final String delivery_price;
  
  Order({Key? key, required this.store_name, required this.store_id, required this.refresh, required this.delivery_price}) : super(key: key);

  @override
  State<Order> createState() => _OrderState(store_name: store_name, store_id: store_id, delivery_price: delivery_price);
}

class _OrderState extends State<Order> {
  bool determinate = true;
  final String store_name;
  final String store_id;
  var total_price;
  int item_count = 0;
  var shoping_carts = [];
  var array = [];
  var baseurl = "";
  final String delivery_price;
  int delivery_price_int = 0;
  var data = [];
  bool status = true;

  void initState() {
    timers();
    if (delivery_price != 'tölegsiz'){
      setState(() {
        String sss =  delivery_price.substring(0, delivery_price.length-4);
        delivery_price_int = int.parse(sss);
      });}
    get_products();
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
  _OrderState({required this.store_name, required this.store_id, required this.delivery_price});
  @override
  Widget build(BuildContext context) {
    return status ? Scaffold(
      appBar: AppBar(title: Text('Sebet'),
       actions: [
              // Badge(
              //   badgeColor: Colors.green,
              //   badgeContent: Text(item_count.toString(),
              //     style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              //   position: BadgePosition(start: 30, bottom: 30),
              //   child: IconButton(
              //     onPressed: () {
              //     },
              //     icon: const Icon(Icons.shopping_cart),
              //   ),
              // ),
              const SizedBox(
                width: 20.0,
              ),
            ],
      ),
    body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CustomColors.appColors,
        onRefresh: () async {
          setState(() {
            get_products();
          });
          return Future<void>.delayed(const Duration(seconds: 3));
        },

        child: determinate? CustomScrollView(
        slivers: [
          if (store_name!='')
            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,(BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(flex: 3, child: Text(store_name, style: TextStyle(color: CustomColors.appColors, fontSize: 16))),
                  ]));
            })),

            SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,(BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text("Harytlaryň bahasy:", style: TextStyle(color: CustomColors.appColors, fontSize: 15)),
                          Spacer(),
                          Text(total_price.toString() + " TMT", style: TextStyle(color: CustomColors.appColors, fontSize: 15))
                      ]),
                      Row(
                        children: [
                          Text("Eltip bermek bahasy:", style: TextStyle(color: CustomColors.appColors, fontSize: 15)),
                          Spacer(),
                          Text(delivery_price.toString(), style: TextStyle(color: CustomColors.appColors, fontSize: 15))
                      ]),
                      Row(
                        children: [
                          Text("Umumy töleg:", style: TextStyle(color: CustomColors.appColors, fontSize: 15)),
                          Spacer(),
                          Text(total_price.toString() + " TMT", style: TextStyle(color: CustomColors.appColors, fontSize: 15))
                      ]),
                  ]));
            })),

          SliverList(delegate: SliverChildBuilderDelegate(
            childCount: array.length, (BuildContext context, int index) {
              return Container(
                height: 110,
                child: Card(
                  elevation: 4,
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: Container(
                        child: Image.network(
                          baseurl + array[index]['product_img'],
                          height: 110,
                          fit: BoxFit.cover)
                      )),
                      Expanded(flex: 4, child: Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Column(
                          children: [
                            Expanded(child: Container(
                              alignment: Alignment.bottomLeft,
                              child: Text('Ady: ' + array[index]['product_name'] , style: CustomText.size_16,),
                            )),
                        
                            Expanded(child: Container(
                              alignment: Alignment.topLeft,
                              child: Text('Baha: ' + array[index]['product_price'].toString(), style: CustomText.size_16,),
                            )),
                          ],
                        ),
                      )),
                      Expanded(flex: 3, child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                          children: [
                            Expanded(child: GestureDetector(
                              onTap: () async {
                                if (array[index]['count']>1){
                                  var decrement = await dbHelper.product_count_increment(item_id: array[index]['id'].toString(), count: array[index]['count'] - 1);
                                  get_products();
                                }
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
                            
                            Expanded(child: Align(child: Text(array[index]['count'].toString(), style: CustomText.size_16))),

                            Expanded(child: GestureDetector(
                              onTap: () async {
                                var increment = await dbHelper.product_count_increment(item_id: array[index]['id'].toString(), count: array[index]['count'] + 1);
                                setState(() {
                                  get_products();
                                });
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
                      Expanded(flex: 2, child: Container(
                        child: GestureDetector(
                          onTap: () async {
                            var delete_item = await dbHelper.delete_item(item_id: array[index]['id'].toString());
                            widget.refresh();
                            setState(() {
                              get_products();  
                            });},
                          child: Icon(Icons.delete, color: Colors.red, size: 30,))))
                    ])));
              })),
              SliverList(delegate: SliverChildBuilderDelegate(childCount: 1,(BuildContext context, int index) {return Container(height: 70);}))
          ],
        ): Center(child: CircularProgressIndicator(color: CustomColors.appColors))
        
    ),
      floatingActionButton: item_count>0 ? FloatingActionButton.extended(
        onPressed: () async {
          final Map<String, dynamic> dict = {'products':[],};
          for (var i in array){dict['products']!.add({"product": i['product_id'],"amount":i['count']});}
          dict['store'] = store_id;
          var allRows = await dbHelper.queryAllRows();
          var data1=[];
          for (final row in allRows) {data1.add(row);}
          setState(() {data = data1; });
          if (data.length==0){Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));}
          for (final row in allRows) {data.add(row);}
          dict['customer'] = data[0]['userId'];
          dict['delivery_price'] = delivery_price_int ;
          Navigator.push(context, MaterialPageRoute(builder: (context) => Checkout(total_price: total_price, dict: dict, refresh: widget.refresh)));  
          },
        label: const Text('Sagydy taýýarla'),
        backgroundColor: Colors.green,
      ): Container()
    ): CustomProgressIndicator(funcInit: initState);
  }
  get_products() async {
    array = [];
    baseurl = "";
    shoping_carts = [];
    var shoping_cart = await dbHelper.get_shoping_cart_by_store(id: store_id);
    for (final row in shoping_cart) {
      shoping_carts.add(row);
    }
    var count = await dbHelper.get_shoping_cart_items(soping_cart_id: shoping_carts[0]['id'].toString());
    var array1 = []; int total_price1 = 0;
    for (final row in count) {
      array1.add(row);
      String ss =  row['product_price'].substring(0, row['product_price'].length - 4);
      ss = ss.replaceAll(RegExp(' '), '');
      int qq = row['count'] * int.parse(ss);
      total_price1 = total_price1 + qq;
    }
    Urls server_url  =  new Urls();
    setState(() {
      total_price = total_price1 + delivery_price_int;
      item_count = array1.length;
      baseurl =  server_url.get_server_url();
      array = array1;
    });
  }
}