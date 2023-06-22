// Align(
//         alignment: Alignment.center,
//         child: Container(
//           padding: EdgeInsets.only(left: 40,right: 40),
//           height: 250,
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[

//                 TextFormField(
//                   controller: usernameController,
//                   decoration: InputDecoration(
//                     focusColor: CustomColors.appColors,
                    
//                     labelText: "Email ýa-da Telefon",
//                     fillColor: CustomColors.appColors,
//                     enabledBorder:OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.black12, width: 1.0),
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10,),
      
//                 TextFormField(
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                     labelText: "Açar sözi",
//                     fillColor: CustomColors.appColors,
//                     enabledBorder:OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.black12, width: 1.0),
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(top:10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         width: 330,
//                         child: ElevatedButton(
//                             onPressed: () async {
//                               if (usernameController.text != '' && passwordController.text != ''){
//                                 Urls server_url  =  new Urls();
//                                 String url = server_url.get_server_url() + '/mob/token/obtain';
//                                 final uri = Uri.parse(url);
//                                 final response = await http.post(uri,
//                                                                  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//                                                                  body: { 'password': passwordController.text.toString(),
//                                                                          'email': usernameController.text.toString()},);
                                                                         
//                                   final json = jsonDecode(utf8.decode(response.bodyBytes));
//                                   print(json);
//                                   if (response.statusCode!=200)
//                                   {
//                                     showDialog(
//                                     context: context,
//                                     builder: (context){
//                                       return AlertError();});
//                                   }
//                                   if (json['status']=='success'){

//                                     Map<String, dynamic> row = {
//                                       DatabaseSQL.columnUserId: json['data']['id'],
//                                       DatabaseSQL.columnName: json['data']['access_token'],
//                                       DatabaseSQL.columnPassword: json['data']['refresh_token'],
//                                       };

//                                       Map<String, dynamic> row1 = {
//                                       DatabaseSQL.columnName: usernameController.text.toString(),
//                                       DatabaseSQL.columnPassword: passwordController.text.toString()};
//                                       final id = await dbHelper.insert(row);
//                                       final id1 = await dbHelper.inser1(row1);

//                                       print('-----1--------  $id');
//                                       print('-----2--------  $id1');
//                                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyPages()));  
//                                   }
//                                   else{
//                                   }                                                          
//                                 } 
//                             },
//                             child: Text("Içeri gir" ,style: TextStyle(color: Colors.white,fontSize: 16,fontFamily: 'Raleway'),),
//                             style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all(CustomColors.appColors),
//                             )
//                         ),
//                       ),
                    
//                     ],
//                   ),
//                 ),
//                   Container(
//                         width: 300,
//                         child: GestureDetector(
//                           onTap: (){
//                              Navigator.push(context, MaterialPageRoute(builder: (context){
//                                 return Register();}));

//                           },
//                           child: Text('Agza bolduňyzmy?', style: TextStyle(fontSize: 18),),
//                         )
//                       ),


//               ],
//             ),
//           ),
//         ),
//       ),