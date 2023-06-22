import 'package:flutter/material.dart';

import '../../dB/textStyle.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key? key}) : super(key: key);

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bu sahypa häzirlikçe taýýarlykda", style: CustomText.appBarText,),),
      body: Container(
        child: Image.network('https://previews.123rf.com/images/mamanamsai/mamanamsai1411/mamanamsai141100130/33758269-laptop-setting-symbol-on-black-background.jpg',fit: BoxFit.cover,height: double.infinity,),
      ),
    );
  }
}
