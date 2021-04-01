import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dummy_data.dart';

class PrefecturesScreen extends StatefulWidget {
  @override
  _PrefecturesScreenState createState() => _PrefecturesScreenState();
}

class _PrefecturesScreenState extends State<PrefecturesScreen> {
  int selectedCount = prefectures[0]['count'];

  List<Text> getPrefectureNames() {
    List<Text> prefectureNames = [];
    for (Map<String, dynamic> pref in prefectures) {
      prefectureNames.add(Text(pref['name']));
    }
    return prefectureNames;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid19-Checker'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                '2021年3月28日',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 50.0),
              Text(
                '新規感染者数',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Text(
                  selectedCount.toString() + '人',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.0,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                height: size.height * .20,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.grey[300],
                child: CupertinoPicker(
                  backgroundColor: Colors.grey[300],
                  itemExtent: 32.0,
                  onSelectedItemChanged: (selectedIndex) {
                    setState(() {
                      selectedCount = prefectures[selectedIndex]['count'];
                    });
                  },
                  children: getPrefectureNames(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
