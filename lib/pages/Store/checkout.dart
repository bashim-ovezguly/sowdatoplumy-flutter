import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../../dB/colors.dart';
import 'package:http/http.dart' as http;
import '../../dB/constants.dart';
import '../../main.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class Checkout extends StatefulWidget {
  var total_price;
  var dict;
  final Function refresh;

  Checkout({Key? key, required this.total_price, required this.dict, required this.refresh}) : super(key: key);
  @override
  State<Checkout> createState() => _CheckoutState(dict: dict);
}
final nameController = TextEditingController();
final phoneController = TextEditingController();
final noteController = TextEditingController();
final startdateinput = TextEditingController();
final stopdateinput = TextEditingController();
final addressController = TextEditingController();
TextEditingController dateinput = TextEditingController(); 

class _CheckoutState extends State<Checkout> {
    var dict;
  
  _CheckoutState({required this.dict});
  @override



  Widget build(BuildContext context) {
    showSuccessAlert(){
      QuickAlert.show(
        context: context,
        title: '',
        text: 'Siziň sargydyňyz kabul edildi!',
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.success,
        onConfirmBtnTap: (){
          widget.refresh();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        });
    }

    showWarningAlert(String text){
      QuickAlert.show(
        context: context,
        title: 'Sargyt et.',
        text: text,
        confirmBtnText: 'Dowam et',
        confirmBtnColor: CustomColors.appColors,
        type: QuickAlertType.warning);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Saryt et")),
      body: CustomScrollView(
        slivers: [
           SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,(BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20,right: 20),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text("Salgyňyz", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                              child: TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 8,
                                controller: addressController,
                                decoration: const InputDecoration(hintText: '',
                                  border: InputBorder.none,
                                  focusColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 10)), validator: (String? value) {
                              if (value == null || value.isEmpty) {return 'Please enter some text';
                              }return null;}),
                              )])),
                      
                      Container(
                        margin: const EdgeInsets.only(left: 20,right: 20),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text("Bellik", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: CustomColors.appColors)),
                              child: TextFormField(
                                autocorrect: false,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 8,
                                controller: noteController,
                                decoration: const InputDecoration(hintText: '',
                                  border: InputBorder.none,
                                  focusColor: Colors.white,
                                contentPadding: EdgeInsets.only(left: 10)), validator: (String? value) {
                              if (value == null || value.isEmpty) {return 'Please enter some text';
                              }return null;}),
                              )])),

                        Container(
                        margin: const EdgeInsets.only(left: 20,right: 20),
                        alignment: Alignment.centerLeft,
                        child: Center( 
                          child:TextField(
                              controller: dateinput, //editing controller of this TextField
                              decoration: InputDecoration( 
                                icon: Icon(Icons.calendar_today), 
                                labelText: "Enter Date"
                              ),
                              readOnly: true,  
                              onTap: () async {
                                dateTimePickerWidget(context);
                              },
                          ))),

                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.centerLeft),
                      ],
                    ),
                  ),
                );
            })),

          SliverList(delegate: SliverChildBuilderDelegate(
              childCount: 1,(BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Card(
                    elevation: 5,
                    child: Column(
                      children: [
                        SizedBox(height: 10),  
                        Row(
                        children: [
                          SizedBox(width: 10),
                          Text(" Umumy töleg:", style: TextStyle(color: CustomColors.appColors, fontSize: 16)),
                          Spacer(),
                          Text(widget.total_price.toString() + " TMT", style: TextStyle(color: CustomColors.appColors, fontSize: 16)),
                          SizedBox(width: 10),
                      ]),
                      SizedBox(height: 150),
                      ]
                    )
                  )
                );
            }))
        ]
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          
          
          if (addressController.text==''){showWarningAlert('Salgyňyz hökmany!');}
          else {
            setState(() {
              dict['note'] = noteController.text;
              dict['address'] = addressController.text;
              dict['created_at'] = dateinput.text;
            });
            Urls server_url  =  new Urls();
            String url = server_url.get_server_url() + '/mob/orders';
            final uri = Uri.parse(url);
            var body = json.encode(dict);
            var req = await http.post(uri, headers: {"Content-Type": "application/json"}, body: body);
            print(req.statusCode);
            print(req.body);
            if (req.statusCode==200){
              var shoping_carts = [];
              var shoping_cart = await dbHelper.get_shoping_cart_by_store(id: dict['store']);
              for (final row in shoping_cart) {shoping_carts.add(row);}
              var delete_shoping_cart_items = await dbHelper.delete_shoping_cart_items(shoping_cart_id: shoping_carts[0]['id']);
              showSuccessAlert();
            }
            else{
              showWarningAlert('Bagyşlaň ýalňyşlyk ýüze çykdy. Täzeden synanşyp görüň!');
            }
            
          }
          },
        label: const Text('Sagyt et'),
        backgroundColor: Colors.green,
      )
    );
    
  }  
  dateTimePickerWidget(BuildContext context) {
    return DatePicker.showDatePicker(
      context,
      dateFormat: 'dd MMMM yyyy HH:mm',
      initialDateTime: DateTime.now(),
      minDateTime: DateTime(2000),
      maxDateTime: DateTime(3000),
      onMonthChangeStartWithFirstDate: true,
      onConfirm: (dateTime, List<int> index) {
        DateTime selectdate = dateTime;
        final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
        setState(() {
          dateinput.text = selIOS;
        });
      },
    );
  }

}

