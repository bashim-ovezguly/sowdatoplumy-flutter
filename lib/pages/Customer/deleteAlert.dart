import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_app/pages/Customer/login.dart';
import 'package:provider/provider.dart';
import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/providers.dart';

class DeleteAlert extends StatefulWidget {

  DeleteAlert({Key? key, required this.action, required this.id, required this.callbackFunc}) : super(key: key);
  final String action;
  final String id;
  final Function callbackFunc;
  @override
  State<DeleteAlert> createState() => _DeleteAlertState(action: action, id: id, callbackFunc: callbackFunc);
}

class _DeleteAlertState extends State<DeleteAlert> {
  bool isChecked = false;
  final String action;
  final String id;
  final Function callbackFunc;
  
  void initState() {
    print(action);
    print(id);
    super.initState();
  }
  _DeleteAlertState({required this.action, required this.id, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(Icons.close, color: Colors.red, size: 25,),
          )
        ],
      ),
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () async {
                Navigator.pop(context, 'Cancel');
              },
            child: const Text('Goý bolsun'),
          ),
        ),
        SizedBox(width: 10,),
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            onPressed: () async {
                var token = Provider.of<UserInfo>(context, listen: false).access_token;
                Urls server_url  =  new Urls();
                String url = server_url.get_server_url() + '/mob/' + action.toString() +"/delete/" + id.toString();
                final uri = Uri.parse(url);
                final response = await http.post(uri, headers: {'token': token},);

                if (response.statusCode==200){
                  callbackFunc();
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));  
                  }
                if (response.statusCode != 200){
                  var response  = Provider.of<UserInfo>(context, listen: false).update_tokenc();
                  if (response==false){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));  
                  }
                }
              },
            child: const Text('Pozmak'),
          ),
        )

          ],
          
      ),),
      actions: <Widget>[

      ],
    );
  }
}



class DeletePhoneAlert extends StatefulWidget {

  DeletePhoneAlert({Key? key,  required this.id, required this.callbackFunc}) : super(key: key);
  final String id;
  final Function callbackFunc;
  @override
  State<DeletePhoneAlert> createState() => _DeletePhoneAlertState(id: id, callbackFunc: callbackFunc);
}

class _DeletePhoneAlertState extends State<DeletePhoneAlert> {
  bool isChecked = false;
  
  final String id;
  final Function callbackFunc;
  
  void initState() {
    
    print(id);
    super.initState();
  }
  _DeletePhoneAlertState({ required this.id, required this.callbackFunc});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text('' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: () => Navigator.pop(context, 'Cancel'),
            child: Icon(Icons.close, color: Colors.red, size: 25,),
          )
        ],
      ),
      content: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () async {
                Navigator.pop(context, 'Cancel');
              },
            child: const Text('Goý bolsun'),
          ),
        ),
        SizedBox(width: 10,),
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white),
            onPressed: () async {
                var token = Provider.of<UserInfo>(context, listen: false).access_token;
                Urls server_url  =  new Urls();
                String url = server_url.get_server_url() + '/mob/stores/phone/delete/' + id.toString();
                final uri = Uri.parse(url);
                print(uri);
                final response = await http.post(uri, headers: {'token': token},);
                print(response.statusCode);

                if (response.statusCode==200){
                  callbackFunc();
                  Navigator.pop(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));  
                  }
                if (response.statusCode != 200){
                  var response  = Provider.of<UserInfo>(context, listen: false).update_tokenc();
                  if (response==false){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));  
                  }
                }
              },
            child: const Text('Pozmak'),
          ),
        )

          ],
          
      ),),
      actions: <Widget>[

      ],
    );
  }
}
