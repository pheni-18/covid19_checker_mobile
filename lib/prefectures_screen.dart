import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'network.dart';
import 'prefectures.dart';
import 'package:intl/intl.dart';

class PrefecturesScreen extends StatefulWidget {
  @override
  _PrefecturesScreenState createState() => _PrefecturesScreenState();
}

class _PrefecturesScreenState extends State<PrefecturesScreen> {
  final Covid19APIClient _client = Covid19APIClient(http.Client());
  Future<List<Prefecture>> _prefectures;
  String _countText = '-';
  List<Text> _prefectureNames;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getPrefectures(DateFormat('yyyyMMdd').format(_selectedDate));
  }

  void _getPrefectures(String date) {
    _prefectures = _client.getAll(date);
  }

  void _showDatePicker(BuildContext context, double height) {
    DateTime _date;
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: height * 1.5,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Container(
              height: height,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (value) {
                    _date = value;
                  }),
            ),
            CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                if (_date == null) {
                  Navigator.of(context).pop();
                  return;
                }
                setState(() {
                  _selectedDate = _date;
                  _countText = '-';
                });
                _getPrefectures(DateFormat('yyyyMMdd').format(_selectedDate));
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
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
              FlatButton(
                onPressed: () => _showDatePicker(context, size.height * .20),
                child: Text(
                  DateFormat('yyyy年MM月dd日').format(_selectedDate),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    color: Colors.grey,
                  ),
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
              FutureBuilder<List<Prefecture>>(
                future: _prefectures,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length == 0) {
                        return Text(
                          '指定された日付のデータは\nありませんでした。\n別の日付を選択してください。',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.red[500],
                          ),
                          textAlign: TextAlign.center,
                        );
                      }

                      List<Text> names = [Text(''), Text('全国')];
                      int nationalCount = 0;
                      for (Prefecture pref in snapshot.data) {
                        names.add(Text(pref.name));
                        nationalCount += pref.count;
                      }
                      _prefectureNames = names;

                      return Expanded(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _countText + '人',
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
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    if (index == 0) {
                                      _countText = '-';
                                      return;
                                    }
                                    if (index == 1) {
                                      _countText = nationalCount.toString();
                                      return;
                                    }
                                    int count = snapshot.data[index - 2].count;
                                    _countText = count.toString();
                                  });
                                },
                                children: _prefectureNames,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text("future builder error");
                    }
                  }

                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
