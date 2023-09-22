import 'package:flutter/material.dart';
import 'package:flutter_circle_flags_svg/flutter_circle_flags_svg.dart';
import 'package:my_app/pages/Customer/verificationCode.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import 'package:http/http.dart' as http;



class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: const Text("Meniň sahypam", style:  CustomText.appBarText,),
        ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
            child: Text("Açar sözüni dikeltmek", style:  TextStyle(fontSize: 18, color: CustomColors.appColors),),),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50, top: 30),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                    children: [
                      Expanded(flex: 1, child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            CircleFlag('tm', size: 30,),
                            Text("  +993", style: TextStyle(fontSize: 18, color: CustomColors.appColors),)
                          ],
                        ),
                      )),
                      Expanded(flex: 2,child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: "Telefon belgiňiz",
                          fillColor: CustomColors.appColors,
                          enabledBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12, width: 1.0),
                            borderRadius: BorderRadius.circular(5.0),
                          ),),),)],),
                   ),
                   Container(
                    margin: EdgeInsets.only(left: 50, right: 50, top: 30),
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.appColors,
                          foregroundColor: Colors.white),
                          onPressed: () async {
                            var  phone = phoneController.text;
                            
                            if (phone.length!=8 || phone[0]!='6'){
                              showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Telefon belgiňizi dogry ýazyn',);});
                            }
                            else{
                                Urls server_url  =  new Urls();
                                String url = server_url.get_server_url() + '/mob/customers/send/code';
                                final uri = Uri.parse(url);
                                var  request = new http.MultipartRequest("POST", uri);

                                request.headers.addAll({'Content-Type': 'application/x-www-form-urlencoded', });
                                request.fields['phone'] = phoneController.text;
                                
                                final response = await request.send();
                                print(response.statusCode);
                                if (response.statusCode==200){
                                       
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(phone: phone)));
                                  
                                  }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Bagyşlaň ýalňyşlyk ýüze çykdy, täzeden synanşyp gorüň',);});
                                }
                              }
                            },
                            child: const Text('Telefon belgiňize sms ugrat',style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                        )
                ],
              ))
    );
  }
}



class ErrorAlert extends StatefulWidget {
  final String message;
  ErrorAlert({Key? key, required this.message}) : super(key: key);

  @override
  State<ErrorAlert> createState() => _ErrorAlertState( message: message);
}

class _ErrorAlertState extends State<ErrorAlert> {
  final String message;

  _ErrorAlertState({required this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: CustomColors.appColorWhite,
      surfaceTintColor: CustomColors.appColorWhite,
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: [
          Text('Ýalnyşlyk' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(Icons.close, color: Colors.red, size: 25,),
          )
        ],
      ),
      content: Container(
        width: 70,
        height: 50,
        child: Text(message, )
      ),
      actions: <Widget>[

        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    );
  }
}
