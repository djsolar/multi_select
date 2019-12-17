import 'package:flutter/material.dart';
import 'package:multi_select/multi_select.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

// 测试数据
List _childrenData(name) {
  List _tchildrenData = List<Map>.generate(12, (i) => {
    'children': [],
    'label':'$name:测试数据${i.toString()}',
    'checked': false
  });
  return _tchildrenData;
}

// 测试数据
List singleData = [
  {
    'label': '一楼',
    'id': 'yilou',
    'children': [
        {'label': '走廊1', 'id':'走廊1','children': _childrenData('走廊1'),'checked': false,'changed': false,'single': true },
        {'label': '走廊2', 'id':'走廊1','children': _childrenData('走廊2'),'checked': false,'changed': false,'single': true },
        {'label': '大厅', 'id':'走廊1','children': _childrenData('走廊3'),'checked': false,'changed': false,'single': true },
        {'label': '房间', 'id':'走廊1','children': _childrenData('走廊4'),'checked': false,'changed': false,'single': true },
        {'label': '房间1','id':'走廊1','children': _childrenData('走廊5'),'checked': false,'changed': false,'single': true },
        {'label': '房间2', 'id':'走廊1','children': _childrenData('走廊6'),'checked': false,'changed': false,'single': true },
        {'label': '房间3', 'id':'走廊1','children': _childrenData('走廊7'),'checked': false,'changed': false,'single': true },
        {'label': '房间4', 'id':'走廊1','children': _childrenData('走廊8'),'checked': false,'changed': false,'single': true }
    ],
    'changed': false,
    'checked': false
  },
  {
  'label': '二楼',
  'id': 'erlou',
    'children': [
      {'label': '1走廊1', 'children': _childrenData('龙鸣2'),'checked': false,'changed': false,'single': true },
      {'label': '2走廊2', 'children': _childrenData('龙鸣3'),'checked': false,'changed': false,'single': true },
      {'label': '3大厅', 'children': _childrenData('龙鸣4'),'checked': false,'changed': false,'single': true },
      {'label': '4房间', 'children': _childrenData('龙鸣5'),'checked': false,'changed': false,'single': true },
      {'label': '2房间1', 'children': _childrenData('龙鸣6'),'checked': false,'changed': false,'single': true },
      {'label': '1房间2', 'children': _childrenData('龙鸣7'),'checked': false,'changed': false,'single': true },
      {'label': '2房间3', 'children': _childrenData('龙鸣8'),'checked': false,'changed': false,'single': true },
      {'label': '3房间4', 'children': _childrenData('龙鸣9'),'checked': false,'changed': false,'single': true }
    ],
    'changed': false,
    'checked': false
  },
  {
    'label': '三楼',
    'id': 'sanlou',
    'children': [
      {'label': '12走廊1', 'children': _childrenData('机构'),'checked': false,'changed': false,'single': true },
      {'label': '2t走廊2', 'children': _childrenData('机构1'),'checked': false,'changed': false,'single': true },
      {'label': '34大厅', 'children': _childrenData('机构2'),'checked': false,'changed': false,'single': true },
      {'label': '45房间', 'children': _childrenData('机构3'),'checked': false,'changed': false,'single': true },
      {'label': '22房间1', 'children': _childrenData('机构4'),'checked': false,'changed': false,'single': true },
      {'label': '12房间2', 'children': _childrenData('机构5'),'checked': false,'changed': false,'single': true },
      {'label': '24房间3', 'children': _childrenData('机构6'),'checked': false,'changed': false,'single': true },
      {'label': '36房间4', 'children': _childrenData('机构7'),'checked': false,'changed': false,'single': true }
    ],
  'changed': false,
  'checked': false
  }
];

List multiData = [
  {
    'label': '一楼',
    'id': 'yilou',
    'children': [
      {'label': '走廊1', 'id':'走廊1','children': _childrenData('走廊1'),'checked': false,'changed': false,'single': false },
      {'label': '走廊2', 'id':'走廊1','children': _childrenData('走廊2'),'checked': false,'changed': false,'single': false },
      {'label': '大厅', 'id':'走廊1','children': _childrenData('走廊3'),'checked': false,'changed': false,'single': false }
    ],
    'changed': false,
    'checked': false
  },
  {
    'label': '二楼',
    'id': 'erlou',
    'children': [
      {'label': '1走廊1', 'children': _childrenData('龙鸣2'),'checked': false,'changed': false,'single': false },
      {'label': '2走廊2', 'children': _childrenData('龙鸣3'),'checked': false,'changed': false,'single': false },
      {'label': '3大厅', 'children': _childrenData('龙鸣4'),'checked': false,'changed': false,'single': false },
      {'label': '4房间', 'children': _childrenData('龙鸣5'),'checked': false,'changed': false,'single': false }
    ],
    'changed': false,
    'checked': false
  },
  {
    'label': '三楼',
    'id': 'sanlou',
    'children': [
      {'label': '12走廊1', 'children': _childrenData('机构'),'checked': false,'changed': false,'single': false },
      {'label': '2t走廊2', 'children': _childrenData('机构1'),'checked': false,'changed': false,'single': false },
      {'label': '34大厅', 'children': _childrenData('机构2'),'checked': false,'changed': false,'single': false },
      {'label': '45房间', 'children': _childrenData('机构3'),'checked': false,'changed': false,'single': false }
    ],
    'changed': false,
    'checked': false
  }
];

class _MyAppState extends State<MyApp> {

  String status = 'single';
  List testData = singleData;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Filter(data: testData, height: 1344.0,clickCB: _click),
        floatingActionButton: Container(
          child: GestureDetector(
            child: Text(status),
            onTap: (){
              setState(() {
                testData == singleData ? testData = multiData : testData = singleData;
                status == 'single' ? status = 'multi' : status = 'single';
              });
            },
          ),
        ),
      ),
    );
  }

  void _click(data,labelData) {
    print('$data++++$labelData');
  }
}
