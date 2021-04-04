import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'network.dart';
import 'prefectures.dart';

class PrefecturesScreen extends StatefulWidget {
  @override
  _PrefecturesScreenState createState() => _PrefecturesScreenState();
}

class _PrefecturesScreenState extends State<PrefecturesScreen> {
  final Covid19APIClient _client = Covid19APIClient();
  Future<List<Prefecture>> _prefectures;
  String _countText = '-';
  List<Text> _prefectureNames;

  @override
  void initState() {
    super.initState();
    getPrefectures();
  }

  void getPrefectures() {
    _prefectures = _client.getAll('20210328');
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
              FutureBuilder<List<Prefecture>>(
                future: _prefectures,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Text> names = [Text('')];
                      for (Prefecture pref in snapshot.data) {
                        names.add(Text(pref.name));
                        _prefectureNames = names;
                      }

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
                                    int count = snapshot.data[index - 1].count;
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
