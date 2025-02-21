import 'package:flutter/material.dart';
import 'package:my_app/pages/Profile/verificationCode.dart';

import '../../dB/constants.dart';
import '../../dB/textStyle.dart';
import 'package:http/http.dart' as http;

class RestoreAccount extends StatefulWidget {
  const RestoreAccount({Key? key}) : super(key: key);

  @override
  State<RestoreAccount> createState() => _RestoreAccountState();
}

class _RestoreAccountState extends State<RestoreAccount> {
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  sendCode() async {
    this.setState(() {
      this.isLoading = true;
    });
    var phone = emailController.text.toString();
    String url = serverIp + '/send/otp';
    final uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.fields['phone'] = phone;

    request.headers.addAll({
      'Content-Type': 'application/x-www-form-urlencoded',
    });

    final response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Verification(phone: phone)));
    } else {
      this.setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (context) {
            return ErrorAlert(
              message: 'Bagyşlaň ýalňyşlyk ýüze çykdy, täzeden synanşyp gorüň',
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.appColorWhite,
        appBar: AppBar(
          title: const Text(
            "Açar sözüni dikeltmek",
            style: CustomText.appBarText,
          ),
        ),
        body: ListView(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height - 100,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Icon(Icons.account_circle,
                          color: CustomColors.appColor, size: 150),
                    ),
                    Text("Açar sözüni dikeltmek",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: CustomColors.appColor)),
                    SizedBox(height: 40),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    width: double.infinity,
                                    child: TextFormField(
                                        maxLength: 8,
                                        controller: emailController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            helperText:
                                                'Telefon belgiňize SMS kod ugradylar',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 10),
                                            labelText: "Telefon belgiňiz",
                                            hintText: 'xx xxxxxx',
                                            prefixIcon: Icon(Icons.phone),
                                            prefixText: '+993 ',
                                            fillColor: CustomColors.appColor,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black12,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black12,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                            )))))
                          ],
                        )),
                    SizedBox(height: 20),
                    if (this.isLoading) Text('Ýüklenýär garaşyň...'),
                    if (!this.isLoading)
                      Container(
                        child: ElevatedButton(
                            onPressed: () async {
                              this.sendCode();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.appColor,
                            ),
                            child: Text("Ugratmak",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: CustomColors.appColorWhite))),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ErrorAlert extends StatefulWidget {
  final String message;
  ErrorAlert({Key? key, required this.message}) : super(key: key);

  @override
  State<ErrorAlert> createState() => _ErrorAlertState(message: message);
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
      content: Container(
          width: 80,
          height: 180,
          child: Column(
            children: [
              Center(child: Icon(Icons.warning, size: 130, color: Colors.red)),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          )),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColor,
                foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context, 'Close');
            },
            child: const Text('Dowam et'),
          ),
        )
      ],
    );
  }
}
