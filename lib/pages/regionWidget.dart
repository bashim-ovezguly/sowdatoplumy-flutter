import 'package:flutter/material.dart';
import 'package:my_app/dB/constants.dart';

class RegionWidget extends StatefulWidget {
  @override
  _RegionWidgetState createState() => _RegionWidgetState();
}

class _RegionWidgetState extends State<RegionWidget> {
  List<bool> selectchildren = [false, false, false, false, false, false, true];
  List<String> _texts = [
    "Aşgabat",
    "Balkan",
    "Ahal",
    "Mary",
    "Lebap",
    "Daşaguz",
    "Hemmesi",
  ];
  int _selectedIndex = 6;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: CustomColors.appColorWhite,
      title: Row(
        children: <Widget>[
          Text(
            "Welaýatlar",
            style: TextStyle(color: CustomColors.appColor),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, 'Cancel');
            },
            child: Icon(Icons.close, color: Colors.red),
          )
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 600,
          height: 400,
          child: ListView(scrollDirection: Axis.vertical, children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: _texts.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Text(_texts[index]),
                  ),
                  leading: Radio(
                    activeColor: CustomColors.appColor,
                    value: index,
                    groupValue: _selectedIndex,
                    onChanged: (value) {
                      setState(() {
                        _selectedIndex = value!;
                      });
                    },
                  ),
                );
              },
            ),
          ]),
        ),
      ),
      actions: <Widget>[
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.appColor,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('FILTER'),
          ),
        )
      ],
    );
  }
}
