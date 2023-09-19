import 'package:flutter/material.dart';
  

import '../../dB/colors.dart';
import '../../dB/textStyle.dart';

class Help extends StatelessWidget {
  const Help({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(title: const Text("Sazlamalar", style: CustomText.appBarText,),),
      body: Column(
        children: <Widget>[
         Container(
           padding: const EdgeInsets.all(10),
           child:  Text("Kömekçi",  style:  TextStyle(fontSize: 25, color: CustomColors.appColors, fontWeight: FontWeight.bold),),),
          Container(
            padding: const EdgeInsets.all(15),
              child:  Text("""
     1.27-njiýanwarda Türkmenistanda Watan goragçylarynyň güni bellenildi. Bu waka mynasybetli Prezident Serdar Berdimuhamedowýurduň harby we hukuk goraýjy edaralarynyň harby gullukçylaryny we işgärlerini gutlady. Döwlet Baştutany bu baýramyň ata Watanymyzyň mukaddes Garaşsyzlygyny goraýan harby we hukuk goraýjy edaralaryň harby gullukçylaryna, işgärlerine bildirilýän uly ynamy, belent sarpany, olar hakynda edilýän çuňňur aladany giňden dabaralandyrýandygyny diýip belledi.
     2. Astrahan döwlet uniwersitetinde Ahal welaýatyň täze döwrebap edara ediş merkeziniň – Arkadag şäheriniň tanyşdyrylyş dabarasy boldy. Bu çäre Türkmenistanyň Astrahandaky konsuly Nury Gölliýewiň ADU-nyň rektory Konstantin Markelow bilen duşuşygynyň çäklerinde geçirildi.
              """,
                overflow: TextOverflow.clip,
                  style:  TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)
              )
          )
        ],
      )
    );
  }
}
