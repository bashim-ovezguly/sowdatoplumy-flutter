import 'package:flutter/material.dart';
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
  void initState() {
    super.initState();
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
              height: MediaQuery.of(context).size.height-100,
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: Icon(Icons.account_circle,
                          color: CustomColors.appColors, size: 150),
                    ),
                    Text("Açar sözüni dikeltmek",
                        style: TextStyle(
                            fontSize: 18, color: CustomColors.appColors)),
                    SizedBox(height: 80),
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    child: TextFormField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            prefixIcon: Padding(
                                                padding: EdgeInsets.all(1),
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 10, top: 8),
                                                  width: 50,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text("+993 ",
                                                      style: TextStyle(
                                                        color: CustomColors
                                                            .appColors,
                                                        fontSize: 16,
                                                      )),
                                                )),
                                            labelText: "Telefon",
                                            labelStyle: TextStyle(
                                                color: CustomColors.appColors),
                                            fillColor: CustomColors.appColors,
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black12,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black12,
                                                  width: 1.0),
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            )))))
                          ],
                        )),
                    SizedBox(height: 20),
                    Container(
                      child: ElevatedButton(
                          onPressed: () async {
                            var phone = phoneController.text.toString();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePage(phone: phone)));

                            Urls server_url = new Urls();
                            String url = server_url.get_server_url() +'/mob/customers/send/code';
                            final uri = Uri.parse(url);
                            var request = new http.MultipartRequest("POST", uri);

                            request.headers.addAll({
                              'Content-Type':
                                  'application/x-www-form-urlencoded',
                            });
                            request.fields['phone'] = phone;

                            final response = await request.send();
                            print(response.statusCode);
                            if (response.statusCode == 200) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyHomePage(phone: phone)));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ErrorAlert(
                                      message:
                                          'Bagyşlaň ýalňyşlyk ýüze çykdy, täzeden synanşyp gorüň',
                                    );
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.appColors,
                          ),
                          child: Text("Telefon belgiňize sms ugrat",
                              style: TextStyle(
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
                backgroundColor: CustomColors.appColors,
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
