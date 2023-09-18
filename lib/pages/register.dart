// ignore_for_file: unused_local_variable
import 'package:flutter/material.dart';
import 'package:my_app/dB/colors.dart';
import 'package:my_app/dB/constants.dart';
import 'dart:convert';
import '../dB/db.dart';
import '../dB/textStyle.dart';
import '../main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_circle_flags_svg/flutter_circle_flags_svg.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  var text = '';

  var data = {};
  @override
  void initState() {
    super.initState();    
  }
  bool _password = true;
  bool _confirmPassword = true;
  
  final passwordFieldFocusNode = FocusNode();
  final confirmpasswordFieldFocusNode = FocusNode();

  void _toggleObscured() {
    setState(() {
      _password = !_password;
      if (passwordFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      passwordFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }

  void _toggleObscured1() {
    setState(() {
      _confirmPassword = !_confirmPassword;
      if (confirmpasswordFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      confirmpasswordFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ulgama ýazyl", style: CustomText.appBarText,),),
      body: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.only(left: 40,right: 40),
          height: 520,
          child: Form(
            child: ListView(
              
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Adyňyz",
                    fillColor: CustomColors.appColors,
                    enabledBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12,  width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(flex: 1, child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            CircleFlag('tm', size: 30,),
                            Text("   +993", style: TextStyle(fontSize: 18, color: CustomColors.appColors),)
                          ],
                          
                        ),
                      )),
                      Expanded(flex: 2,child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Telefon belgiňiz",
                          fillColor: CustomColors.appColors,
                          enabledBorder:OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12, width: 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                          ),),),)
                    ],
                  ),
                
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email, size: 24),
                    labelText: "Email",
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
                const SizedBox(height: 10,),
                SizedBox(
                  width: 400,
                  child: ElevatedButton(
                    onPressed: () async {
                    
                      if (passwordController.text!='' && phoneController.text !='' && confirmpasswordController.text == passwordController.text){
                          Urls server_url  =  new Urls();
                          String url = server_url.get_server_url() + '/mob/reg';
                          final uri = Uri.parse(url);
                                      
                            final response = await http.post(
                              uri,
                              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                              body: {
                                'phone': phoneController.text.toString(),
                                'password': passwordController.text.toString(),
                                'name': usernameController.text.toString(),
                                'email':emailController.text.toString()
                                },
                            );
                              final json = jsonDecode(utf8.decode(response.bodyBytes));

                            if (json['status']=='success')
                            {
                              setState(() {
                              data  = json;
                              showConfirmationDialogSuccess(context);    
                              });
                            }
                            else{
                              usernameController.text ='';
                              passwordController.text ='';
                              confirmpasswordController.text='';
                              phoneController.text = '';
                              phoneController.text = '';
                              emailController.text = '';
                              if (json['error_code']==2){
                                setState(() {
                                  text = 'Bagyşlaň bular ýaly ulanyjy bar';
                                });
                              }
                              showConfirmationDialog(context);
                            }}
                        else{
                              usernameController.text ='';
                              passwordController.text ='';
                              confirmpasswordController.text='';
                              phoneController.text = '';
                              phoneController.text = '';
                              emailController.text = '';
                              setState(() {
                                text = 'Telefon belgiňiz we açar sözüňiz hökmany';
                              });
                          showConfirmationDialog(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(CustomColors.appColors),
                      ),
                      child: const Text("Ulgama ýazyl" ,style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Raleway'),)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

      
    showConfirmationDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogLogout(error_msg: text);},);}

      
    showConfirmationDialogSuccess(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialogLogoutSuccess(phone: phoneController.text.toString(), email: emailController.text.toString(), password: passwordController.text.toString());},);}


}



class CustomDialogLogoutSuccess extends StatefulWidget {
  CustomDialogLogoutSuccess({Key? key, required this.phone, required this.email, required this.password}) : super(key: key);
  final String phone ;
  final String email ;
  final String password ;

  @override
  _CustomDialogLogoutSuccessState createState() => _CustomDialogLogoutSuccessState(phone: phone, email: email, password: password);
}

class _CustomDialogLogoutSuccessState extends State<CustomDialogLogoutSuccess> {
  bool canUpload = false;  
  final codeController = TextEditingController();
  final String phone ;
  late final String email ;
  late final String password ;

  _CustomDialogLogoutSuccessState({required String this.phone, required String this.email, required String this.password});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Sms kodyýazyn' ,style: TextStyle(color: CustomColors.appColors),),
          Spacer(),
          GestureDetector(
            onTap: (){
              Navigator.pop(context, 'Cancel');
            },
            child: Icon(Icons.close, color: Colors.red,),
          )]),
      content: Container(
        padding: EdgeInsets.all(10),
        child: 
        TextFormField(
                  controller: codeController,
                  decoration: InputDecoration(
                    labelText: "Code",
                    fillColor: CustomColors.appColors,
                    enabledBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black12, width: 1.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
      ),
      actions: <Widget>[

         ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () async {

              Urls server_url  =  new Urls();
              String url = server_url.get_server_url() + '/mob/verif';
              final uri = Uri.parse(url);
                                      
              final response = await http.post(
              uri,
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              body: {'phone': phone.toString(),
                     'code': codeController.text.toString()},);

              final json = jsonDecode(utf8.decode(response.bodyBytes));
              if (json['status']=='success'){

                  Map<String, dynamic> row = {
                  DatabaseSQL.columnName: json['access_token'],
                  DatabaseSQL.columnPassword: json['refresh_token'],
                  DatabaseSQL.columnUserId: json['id'],
                  };

                  Map<String, dynamic> row1 = {
                  DatabaseSQL.columnName: phone.toString(),
                  DatabaseSQL.columnPassword: password.toString()};

                  final id = await dbHelper.insert(row);
                  final id1 = await dbHelper.inser1(row1);

                  print('-----1--------  $id');
                  print('-----2--------  $id1');

                  //  Navigator.of(context).popUntil((route) => route.isFirst);  
                  int count = 0;
                  Navigator.popUntil(context, (route) {
                      return count++ == 2;
                  });
              }
              else{
                 Navigator.pop(context, 'Cancel');
              }
            },
            child: const Text('Tassykla'),
          ),          
      ],
    );
  }
}




  class CustomDialogLogout extends StatefulWidget {
    final String error_msg;
    CustomDialogLogout({Key? key, required this.error_msg }) : super(key: key);
  @override
  _CustomDialogLogoutState createState() => _CustomDialogLogoutState();
}

class _CustomDialogLogoutState extends State<CustomDialogLogout> {
  bool canUpload = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Ulmaga ýazylmak' ,style: TextStyle(color: CustomColors.appColors),),],),
      content: Container(
        padding: EdgeInsets.all(10),
        child: Text(
          widget.error_msg,
          maxLines: 3,
        )
      ),
      actions: <Widget>[

         ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColors,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Täzeden synanşyp görüñ'),
          ),          
      ],
    );
  }
}
