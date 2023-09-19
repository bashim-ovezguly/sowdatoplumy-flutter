import 'package:flutter/material.dart';

import '../../dB/colors.dart';
import '../../dB/textStyle.dart';


class StoresList extends StatefulWidget {
  const StoresList({Key? key}) : super(key: key);

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: const Text("Dükanlar", style:  CustomText.appBarText,)),
      body: Column(
        children: <Widget>[
          SizedBox(height: 20,),
          Expanded(flex: 10,child:ListView.builder(
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/store/detail');
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Card(
                    elevation: 2,
                    child: Container(
                      height: 120,
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: ClipRRect(
                                child: Image.network('https://images.unsplash.com/photo-1527368746281-798b65e1ac6e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1075&q=80', fit: BoxFit.cover, height: 120,),
                              )
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: CustomColors.appColors,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Berkararlyk dükany merkeze',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,),),),),
                                  Expanded(
                                      child:Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: const <Widget>[
                                            SizedBox(width: 10,),
                                            Icon(Icons.access_time_outlined,color: Colors.white,),
                                            Text('1 sagat öň',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                ))],),)),
                                  Expanded(child:Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: const <Widget>[
                                        SizedBox(width: 10,),
                                        Icon(Icons.place,color: Colors.white,),
                                        Text('Türkmenistan, Aşgabat ş.',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,))],),)),
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

              },),),
          SizedBox(height: 10,),

        ],
      ),
    );
  }
}


