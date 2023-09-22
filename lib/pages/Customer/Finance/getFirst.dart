
import '../../../dB/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../dB/textStyle.dart';

class GetFinanceFirst extends StatefulWidget {
  const GetFinanceFirst({Key? key}) : super(key: key);

  @override
  State<GetFinanceFirst> createState() => _GetFinanceFirstState();
}

class _GetFinanceFirstState extends State<GetFinanceFirst> {
  final TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: const Text("Meniň sahypam", style: CustomText.appBarText,),),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Card(
              elevation: 2,
              child: Container(
                color: CustomColors.appColors,
                  margin: const EdgeInsets.all(5),
                  padding: EdgeInsets.all(2),
                  child: Row(
                    children: const <Widget>[
                      SizedBox(width: 10,),
                      Text("Özara hasaplaşyk", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                      Spacer(),
                      Text("Serdar", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                      SizedBox(width: 10,),],)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            child: Card(
              elevation: 2,
              child: Container(
                color: CustomColors.appColors,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                height: 80,
                child: Column(
                  children: <Widget>[
                    Expanded(child: Row(
                      children: const <Widget>[
                        Text("Jemi algy", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                        Spacer(), // use Spacer
                        Text("+10000 TMT", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),],
                    )),
                    Expanded(child: Row(
                      children: const <Widget>[
                        Text("Jemi bergi", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),
                        Spacer(), // use Spacer
                        Text("-1000 TMT", style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),),],),),
                    Expanded(child:Container(
                      color: Colors.amberAccent,
                      child: Row(
                        children: const <Widget>[
                          Text("Galyndy", style: TextStyle(fontSize: 17, color: CustomColors.appColors, fontWeight: FontWeight.bold),),
                          Spacer(), // use Spacer
                          Text("+1000 TMT", style: TextStyle(fontSize: 17, color: CustomColors.appColors, fontWeight: FontWeight.bold),),],),),),
                  ],),),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: <Widget>[
          //     Container(
          //       color: Colors.black12,
          //       child: const Icon(Icons.sort_by_alpha, size: 35,color: CustomColors.appColors,),
          //     ),
          //     const SizedBox(width: 5),
          //     Container(
          //       color: Colors.black12,
          //       child: const Icon(Icons.filter_alt_sharp, size: 35,color: CustomColors.appColors,),),],),

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
                      height: 70,
                      width: 100,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Expanded(child: Row(
                            children: const <Widget>[
                              Text("03.02.2023", style: TextStyle(fontSize: 17, color: CustomColors.appColors, fontWeight: FontWeight.bold),),
                              Spacer(), // use Spacer
                              Text("+1000 TMT", style: TextStyle(fontSize: 17, color: CustomColors.appColors, fontWeight: FontWeight.bold),),],),),

                          Expanded(child: Row(
                            children: const <Widget>[
                              Text("Note ... ", style: TextStyle(fontSize: 17, color: CustomColors.appColors, fontWeight: FontWeight.bold),),
                              Spacer(), // use Spacer
                              Icon(Icons.check,size: 35,color: Colors.green,),],),),],),),
                  ),));},),),
           Container(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              width: double.infinity,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: CustomColors.appColors, foregroundColor: Colors.white),
                onPressed: () {
                    showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Data'),
                      content: Container(
                        decoration: BoxDecoration(border: Border.all(color: CustomColors.appColors)),
                        height: 240,
                        width: 300,
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextField(
                                controller: _date,
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.calendar_month_outlined , color: CustomColors.appColors,),
                                  labelText: "Select Date"
                                ),
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100));
                                    if (pickeddate != null ){
                                      setState(() {_date.text = DateFormat('yyyy-MM-dd').format(pickeddate);});}},),),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Note...',),),),
                            const Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Sum...',),),),
                            const Padding(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type...',),),),
                          ],
                        )
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.appColors,
                              foregroundColor: Colors.white),
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Gaýtarmak'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.appColors,
                              foregroundColor: Colors.white),
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Ýatda sakla'),
                        ),],),);},
                child: const Text('Goşmak',style: TextStyle(fontWeight: FontWeight.bold),),
              ),),),

        ],
      ),
    );
  }
}


