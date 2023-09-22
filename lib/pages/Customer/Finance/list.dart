import 'package:flutter/material.dart';
import '../../../dB/colors.dart';
import '../../../dB/textStyle.dart';

class FinanceList extends StatefulWidget {
  const FinanceList({Key? key}) : super(key: key);

  @override
  State<FinanceList> createState() => _FinanceListState();
}

class _FinanceListState extends State<FinanceList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: const Text('Meniň sahypam', style: CustomText.appBarText,),),
      body: Column(
        children: <Widget>[
          Container(

            height: 40,
            margin: const EdgeInsets.only(left: 5,right: 5),
            child: Card(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(5),
                color: CustomColors.appColors,
                child: Row(
                  children: const <Widget>[
                    SizedBox(width: 10,),
                    Text("Özara hasaplaşyk",
                      style: TextStyle(fontSize: 17, color: Colors.white),),
                    Spacer(), // use Spacer
                    Text("+5000 TMT", style: TextStyle(fontSize: 17, color: Colors.white),),
                    SizedBox(width: 10,),],),
              )
            )
          ),

            Container(

              margin: EdgeInsets.only(left: 5, right: 5),
              child: Card(
                elevation: 2,
                child: Container(
                  color: CustomColors.appColors,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  height: 60,
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Row(
                        children: const <Widget>[
                          Text("Algy", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                          Spacer(), // use Spacer
                          Text("+5000 TMT", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),],
                      )),
                      Expanded(child: Row(
                        children: const <Widget>[
                          Text("Bergi", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                          Spacer(), // use Spacer
                          Text("-1000 TMT", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),],
                      )),],),),
              ),
            ),
          Expanded(flex: 10,child:ListView.builder(
            itemCount: 6  ,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: (){ Navigator.pushNamed(context, "/customer/myPages/finance/getFirst");},
                child: Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: Card(
                    elevation: 2,
                    child: Container(
                      height: 100,
                      width: 100,
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        children:  <Widget>[
                          Row(
                            children: <Widget>[
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(48), // Image radius
                                  child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRsm0_H8gRmgBxW4wl51OJjHqYRRwy0W47zCg&usqp=CAU', fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(width: 10), // give it width
                              const Text("Aman", style: TextStyle(fontSize: 20, color: CustomColors.appColors, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const Spacer(), // use Spacer
                          const Text("-1000 TMT", style: TextStyle(fontSize: 20, color: CustomColors.appColors, fontWeight: FontWeight.bold),),],

                      ),),
                  ),
                )
              );},),),

        ],
      ),
    );
  }
}
