import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';


class MyDropdownButton extends StatefulWidget {
  final  List<dynamic> items;
  final Function callbackFunc;
  final String oldData;

  MyDropdownButton({required this.items, required this.callbackFunc, this.oldData=''});
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState(callbackFunc: callbackFunc, items: items);
}
class _MyDropdownButtonState extends State<MyDropdownButton> {
  final  List<dynamic> items;
  String? selectedItem ;
  final Function callbackFunc;
  
  
  void initState() {    
    super.initState();
  }
  
  _MyDropdownButtonState({required this.callbackFunc , required this.items});
  @override
  Widget build(BuildContext context) {
    return
      DropdownButton<String>(   
        dropdownColor: CustomColors.appColorWhite,
        isExpanded: true,
        alignment: Alignment. center,
        elevation: 16,
        value: selectedItem,
        hint: Align(alignment: Alignment.centerLeft, child: Text(widget.oldData)),
        underline: const SizedBox(),
        onChanged: (dynamic newValue) {
          setState(() {
            selectedItem = newValue.toString();
            for(var i in widget.items){
              if (i['id'].toString()==newValue){
                callbackFunc(i);
              }
            }
          });
        },
        items: widget.items.map((value) {
          return DropdownMenuItem<String>(
            
              value: value['id'].toString(),
              child:  FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  children: [
                    if (value['parent']!= null)
                      if (value['parent']=='')
                        Text(value['name_tm'].toString(),style: const TextStyle(fontSize: 17, color: CustomColors.appColors),)
                      else
                        Text(value['parent']['name'].toString()+ " > " + value['name_tm'].toString(),style: const TextStyle(fontSize: 17, color: CustomColors.appColors),)
                    else if (value['name'] != null)
                      Text(value['name'].toString(),style: const TextStyle(fontSize: 17, color: CustomColors.appColors),)
                    else
                    Text(value['name_tm'].toString(),style: const TextStyle(fontSize: 17, color: CustomColors.appColors),),
                  ],
                )

              )
          );
        }).toList(),
      );
  }
}