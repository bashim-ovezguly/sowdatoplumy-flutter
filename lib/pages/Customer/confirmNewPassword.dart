import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/pages/Customer/newPassword.dart';
import 'package:my_app/pages/homePages.dart';

import '../../dB/colors.dart';
import '../../dB/constants.dart';
import '../../dB/db.dart';
import '../../main.dart';
import 'myPages.dart';
import 'package:http/http.dart' as http;


class ConfirmNewPassword extends StatefulWidget {
  ConfirmNewPassword({Key? key, required this.phone, required this.access_token, required this.refresh_token, required this.customer_id}) : super(key: key);

  final String phone;
  final String access_token;
  final String refresh_token;
  final int customer_id;

  @override
  State<ConfirmNewPassword> createState() => _ConfirmNewPasswordState(phone: phone, access_token: access_token, refresh_token: refresh_token, customer_id: customer_id);
}

class _ConfirmNewPasswordState extends State<ConfirmNewPassword> {

  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  bool _password = false;
  bool _confirmPassword = false;
  
  final passwordFieldFocusNode = FocusNode();
  final confirmpasswordFieldFocusNode = FocusNode();

  void _toggleObscured() {
    setState(() {
      _password = !_password;
      if (passwordFieldFocusNode.hasPrimaryFocus) return;
      passwordFieldFocusNode.canRequestFocus = false;    
    });
  }

  void _toggleObscured1() {
    setState(() {
      _confirmPassword = !_confirmPassword;
      if (confirmpasswordFieldFocusNode.hasPrimaryFocus) return; 
      confirmpasswordFieldFocusNode.canRequestFocus = false;
    });
  }
  final String phone;
  final String access_token;
  final String refresh_token;
  final int customer_id;
  _ConfirmNewPasswordState({required this.phone, required this.access_token, required this.refresh_token, required this.customer_id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: CustomColors.appColorWhite,
      appBar: AppBar(
        title: Text('Täze açar sözi'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(left: 50, right: 50),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _password,
                  controller: passwordController,
                  focusNode: passwordFieldFocusNode,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_rounded, size: 24),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _password
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 24,
                        ),
                      ),
                    ),
                    labelText: "Açar söz",
                    fillColor: CustomColors.appColors,
                    enabledBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12, width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _confirmPassword,
                  focusNode: confirmpasswordFieldFocusNode,
                  controller: confirmpasswordController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_rounded, size: 24),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: _toggleObscured1,
                        child: Icon(
                          _confirmPassword
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          size: 24,
                        ),
                      ),
                    ),
                    labelText: "Açar sözüni tassykla",
                    fillColor: CustomColors.appColors,
                    enabledBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12, width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                
                SizedBox(
                  child: ElevatedButton(
                    onPressed: () async {
                      String password = passwordController.text;
                      String confirmpassword = confirmpasswordController.text;
                      
                      if (password=='' ){
                        showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Täze açar sözüňüzi ýazyň !',);});
                      }
                      else if(confirmpassword==''){
                        showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Täze açar sözüňüzüniň tassyklamasyny ýazyň !',);});
                      }
                      else if(password!=confirmpassword){
                        showDialog(
                                    context: context,
                                    builder: (context){
                                      return ErrorAlert(message: 'Täze açar sözüňiz bilen tasyklanylan açar sözüňiz birmeňzeş däl',);});
                      }
                      else{
                          Urls server_url  =  new Urls();
                          String url = server_url.get_server_url() + '/mob/restore/password';
                          final uri = Uri.parse(url);

                          var map = new Map<String, dynamic>();
                          map['phone'] = phone;
                          map['new_password'] = password;

                          final response = await http.post(uri, headers: {'token': access_token},body: map);
                          final json = jsonDecode(utf8.decode(response.bodyBytes));
                          if (response.statusCode==200){
                            Map<String, dynamic> row = {
                                      DatabaseSQL.columnUserId: customer_id,
                                      DatabaseSQL.columnName: access_token,
                                      DatabaseSQL.columnPassword: refresh_token,
                                      };

                                      Map<String, dynamic> row1 = {
                                      DatabaseSQL.columnName: phone.toString(),
                                      DatabaseSQL.columnPassword: password.toString()};

                                      final id = await dbHelper.insert(row);
                                      final id1 = await dbHelper.inser1(row1);

                                      print('-----1--------  $id');
                                      print('-----2--------  $id1');
                                      
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyPages()));  
                          }
                          else{ 
                            showDialog(
                              context: context,
                              builder: (context){
                                return ErrorAlert(message: 'Bagyşlaň ýalnyşlyk ýüze çykdy täzeden synanşyp görüň');});                              
                          }
                      }
                    },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(CustomColors.appColors),
                      ),
                      child: const Text("Tassykla" ,style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Raleway'),)
                  ),
                )
          ],
        ),
        )
      ),
    );
  }
}