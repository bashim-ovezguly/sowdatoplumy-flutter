import 'package:flutter/material.dart';

import '../../dB/colors.dart';
import '../../dB/textStyle.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: const Text('Sazlamalar', style: CustomText.appBarText,),),
      body: Column(
        children: <Widget>[
          Expanded(flex: 1,child: Container(
            padding: const EdgeInsets.all(10),
            child: Text("Umumy sazlamalar", style:  TextStyle(fontSize: 22, color: CustomColors.appColors, fontWeight: FontWeight.bold),),),),

          Expanded(flex: 6,child: Column(
            children: const <Widget>[
              Expanded(child: MyContainer(title: "Dil", description: "Türkmençe",)),
              Expanded(child: MyContainer(title: "Wersiýa", description: "1.9.4 (Soňky 1.9.5)",)),
              Expanded(child: MyContainer(title: "Saýlanan ýer", description: "Aşgabat",),),
             Expanded(child: MyContainer(title: "Saýlanan ýer", description: "Aşgabat",)),],
          ),),

           Expanded(flex: 1,child: Text("Goşmaça", style:  TextStyle(fontSize: 22, color: CustomColors.appColors, fontWeight: FontWeight.bold),),),
          Expanded(flex: 6,child: Column(
            children: <Widget>[
             Expanded(child: GestureDetector(
               onTap: () {Navigator.pushNamed(context, "/settings/help");},
               child: const MyContainer(title: "Kömekçi", description: "Okamak maslahat berilýär",),)),
              const Expanded(child: MyContainer(title: "Dùzgünnama", description: "Okap taňyş",)),
              const Expanded(child: MyContainer(title: "Saýlanan ýer", description: "Aşgabat",)),
              const Expanded(child: MyContainer(title: "Saýlanan ýer", description: "Aşgabat",)),
            ],
          ),),
        ],
      )
    );
  }
}


class MyContainer extends StatelessWidget {
  const MyContainer({Key? key, required this.title, required this.description}) : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Colors.black12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style:  TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),),
          Text(description, style:  TextStyle(fontSize: 18, color: Colors.black54,fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

