import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PRMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PRMS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _data = '급식 정보 가져오는 중';
  late String _currentDate;

  @override
  void initState() {
    super.initState();
    _setCurrentDate();
    _fetchData();
  }

  void _setCurrentDate() {
    DateTime now = DateTime.now();
    _currentDate = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }

  String _processMenuData(String rawData) {
    String processedData = rawData
        .replaceAll(RegExp(r'\([^)]*\)'), '')
        .replaceAll('*', '')
        .replaceAll('<br/>', '\n')
        .trim();
    return processedData;
  }

  Future<void> _fetchData() async {
    final response = await http.get(Uri.parse('https://open.neis.go.kr/hub/mealServiceDietInfo/?ATPT_OFCDC_SC_CODE=J10&SD_SCHUL_CODE=7679123&MLSV_YMD=$_currentDate&Type=json'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      String menuData = jsonData["mealServiceDietInfo"][1]["row"][0]["DDISH_NM"];
      setState(() {
        _data = _processMenuData(menuData);
      });
    } else {
      setState(() {
        _data = '급식 정보를 가져오는데 실패했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(_data,
          style: const TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
