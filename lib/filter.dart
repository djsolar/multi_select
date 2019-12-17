/**
 * 筛选的页面
 * 参数：
 *  data: 传入的组件的数据
 *  height: 组件的高度（因为组件是可以滚动的）
 *  clickCB: 点击的回调函数
 * author: djytwy on 2019-11-22 09:29
 */

import 'package:flutter/material.dart';
import 'dart:convert';
import 'components/itemsButton.dart';
import 'components/filterButton.dart';

class Filter extends StatefulWidget {
  Filter({
    Key key,
    this.data,
    this.height,
    this.clickCB,
  }):super();
  final data;
  final height;
  final clickCB;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // 当前被选中的项最终是否单选：false：多选，true：单选
  bool single = false;
  // 根据选择生成的id的数据
  dynamic genData = [];
  // 用于遍历genData的临时变量
  dynamic copyGenData = [];
  // 根据选择生成的item的数据
  dynamic genItems = [];
  // 所有id所构成的list
  List singleList = [];
  // 所有的name构成的list
  List labelList = [];
  // 多选的idList
  List multiList = [];
  // 中间级的数据（非第一级和最后一级）
  List renderData = [];
  // 最后一级供选择的项
  List itemsData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Container(
                  height: widget.height,
                  color: Color.fromARGB(255, 248, 248, 249),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        for(Map _index in widget.data)
                          FilterButton(
                            changed: _index["changed"],
                            checked: _index["checked"],
                            clickCb: _clickFirst,
                            item: _index,
                            id: widget.data.indexOf(_index)
                          ),
                      ],
                    ),
                  )
                ),
                Expanded(
                  flex: renderData.length == 0 ? 0 : 3,
                  child: Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black26,
                          blurRadius: 1.0,
                        )
                      ],
                      border: Border(
                        right: BorderSide(
                          color: Colors.black12,
                          width: 1.0
                        )
                      )
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for(Map _index in renderData)
                            FilterButton(
                              render:true,
                              changed: _index["changed"],
                              checked: _index["checked"],
                              clickCb: _clickSecond,
                              item: _index,
                              id: renderData.indexOf(_index)
                            )
                        ],
                      ),
                    ),
                  )
                ),
                Expanded(
                  flex: 5,
                  child:  Container(
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(
                          color: Colors.blue,
                          width: 2.0
                        )
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black26,
                          blurRadius: 1.0,
                        )
                      ]
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for(Map _index in itemsData)
                            CheckItem(
                              item: _index,
                              id: itemsData.indexOf(_index),
                              checked: _index["checked"],
                              clickCb: _clickItem,
                            )
                        ],
                      ),
                    )
                  )
                )
              ],
            )
          )
        ],
      ),
    );
  }

  // 单选选中的值,并根据选中的值生成下一级的column
  void _clickFirst(Map item, int id) {
    // 第一级、第二级、第三级全部清空
    _clearClickData(widget.data);
    _clearClickData(renderData);
    _clearItemsData();
    // _childrenLength 用于判断是三级联动还是二级联动
    List _childrenLength = item['children'].where((e) => e["children"].length != 0).toList();
    // 若被点击的这一级的下一级children长度大于0，则渲染renderData，反之渲染itemsData
    if (widget.data.contains(item) && _childrenLength.length != 0) {
      for (var _index in genData) {
        // _index.length > 2表示3级联动，widget.data[_index.first] == item表示当前选中的第一级与将被渲染的第一级相等
        if(_index is List && _index.length > 2 && widget.data[_index.first] == item)
          item['children'][_index[1]]['changed'] = true;
      }
      setState(() {
        widget.data[widget.data.indexOf(item)]["checked"] = true;
        renderData = item['children'];
        singleList = [id];
        labelList = [item['label']];
        // 若有三级，点第一级则清空第三级
        itemsData = [];
      });
    } else if(widget.data.contains(item)) {
      setState(() {
        multiList = [];
        renderData = [];
        single = item["single"] ?? false;
        widget.data[widget.data.indexOf(item)]["checked"] = true;
        itemsData = item['children'];
        singleList = [id];
        labelList = [item['label']];
      });
    }
  }

  // 第二项的点击回调
  void _clickSecond(Map item, int id) {
    _clearClickData(renderData);
    _clearItemsData();
    for(var _index in genData) {
      if(_index is List && _index.length > 2) {
        setState(() {
          widget.data[_index[0]]["children"][_index[1]]["changed"] = true;
        });
        if(item == widget.data[_index[0]]["children"][_index[1]]) {
          item['children'][_index[2]]["checked"] = true;
        }
      }
    }
    if (renderData.contains(item))
      setState(() {
        multiList = [];
        single = item["single"] ?? false;
        renderData[renderData.indexOf(item)]["checked"] = true;
        itemsData = item['children'];
        singleList = [singleList.first, id , null];
        labelList = [labelList.first, item['label'], null];
      });
  }

  // 点击最后一项的回调
  void _clickItem(Map item, int id){
    // _tempItem使用浅拷贝避免修改失效
    List _tempItem = singleList.map((e) {
      if (e == null)
        return id;
      else
        return e;
    }).toList();
    _tempItem[_tempItem.length -1 ] = id;
    if(itemsData.contains(item) && !single) {
      // 多选
      if(itemsData[itemsData.indexOf(item)]["checked"] == true) {
        setState(() {
          itemsData[itemsData.indexOf(item)]["checked"] = false;
          multiList =_removeListInList(source: multiList,element: _tempItem);
        });
        _genAllData(_tempItem);
      } else {
        setState(() {
          itemsData[itemsData.indexOf(item)]["checked"] = true;
          multiList.add(_tempItem);
        });
        _genAllData();
        setState(() {
          genItems = [];
        });
        for(var _index in genData) {
          // 浅拷贝
          setState(() {
            copyGenData = _index.map((e) => e).toList();
            genItems.add([]);
          });
          _genItemsData(widget.data, multiIndex: genData.indexOf(_index));
        }
      }
    } else {
      // 单选
      _clearItemsData();
      _genAllData(_tempItem);
      final _tempSingleList = genData.map((e) => e).toList();
      setState(() {
        itemsData[itemsData.indexOf(item)]["checked"] = true;
        singleList[singleList.length -1 ] = id;
        copyGenData = _tempSingleList;
      });
      _genItemsData(widget.data);
    }
    widget.clickCB(genData,genItems);
    // 单选回调完需要清空genData、genItems以便重新赋值
    if(single)
      setState(() {
        genData = [];
        genItems = [];
      });
  }

  // 递归循环生成选中的数据的label
  void _genItemsData(_data, {multiIndex}) {
    // 从最外层父级开始遍历
    dynamic _listIndex;
    if(copyGenData.length > 0) {
      _listIndex = copyGenData.first;
      setState(() {
        multiIndex != null ?
        genItems[multiIndex].add({"label":_data[_listIndex]["label"],"id": _data[_listIndex]["id"] ?? "暂无"}) :
        genItems.add({"label":_data[_listIndex]["label"],"id": _data[_listIndex]["id"] ?? "暂无" });
        copyGenData.remove(_listIndex);
      });
    }
    for(var _index in _data) {
      if( _index["children"] != null && _index["children"].length >0 && _listIndex == _data.indexOf(_index))
        multiIndex != null ? _genItemsData(_index["children"],multiIndex: multiIndex) : _genItemsData(_index["children"]);
    }
  }

  // 生成选中的数据
  void _genAllData([indexList = false]) {
    if (!single && indexList == false) {
      List _newList = _filterList(source: [...genData,...multiList]);
      setState(() {
        genData = _newList.toList();
      });
    } else if (!single && indexList != false) {
      setState(() {
        genData = _removeListInList(source: genData, element: indexList);
      });
    } else if (single) {
      setState(() {
        genData = indexList;
      });
    }
  }

  // 在[[2,3],[3,4],[0,1,2,3]] 这样的数组中使用remove方法直接remove([2,3])无法删除此元素，
  // 这里使用先转字符串再替换的思路来删除数组中的数组并返回一个新的数组
  List _removeListInList({source: List, element: List}) {
    String _strSource = jsonEncode(source);
    _strSource = _strSource.replaceAll(jsonEncode(element.toList()), 'null');
    List _genList = jsonDecode(_strSource);
    _genList.remove(null);
    return _genList;
  }

  // 数组去重，由于数组内的元素的数组，无法用set去重，故先将元素内的数组转为str
  List _filterList({source: List}) {
    var _filterList = source.map((e) => e.toString());
    var _newList = _filterList.toList().toSet().toList().map((e) => jsonDecode(e));
    return _newList.toList();
  }

  // 清空最后一级的选项
  void _clearItemsData() {
    for(Map _index in itemsData) {
      if(_index["checked"] == true)
        setState(() {
          itemsData[itemsData.indexOf(_index)]["checked"] = false;
        });
    }
  }

  // 清空父级的选项
  void _clearClickData(dataItems) {
    if (dataItems == renderData)
      renderData.forEach((e) {
        if(e["checked"] == true)
          setState(() {
            renderData[renderData.indexOf(e)]["checked"] = false;
          });
      });
    else
      dataItems.forEach((e) {
        if(e["checked"] == true)
          setState(() {
            dataItems[dataItems.indexOf(e)]["checked"] = false;
          });
      });
  }
}
