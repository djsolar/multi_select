/**
 * 最后一级的单选按钮
 * 参数：
 *  checked: 是否选中
 *  item：传入组件的信息（文案等）
 *  clickCb: 点击的回调
 *  id: 当前组件在外面list的index
 * author: djytwy on 2019-11-22 09:20
 */

import 'package:flutter/material.dart';

class CheckItem extends StatefulWidget {

  CheckItem({
    Key key,
    this.checked,
    this.item,
    this.clickCb,
    this.id,
  }):super();
  final checked;
  final item;
  final clickCb;
  final id;

  @override
  _CheckItemState createState() => _CheckItemState();
}

class _CheckItemState extends State<CheckItem> {

  // 触发点击的函数
  void _check() {
    print('${widget.id} ,${widget.item}');
    widget.clickCb(widget.item, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _check,
      child: Row(
        children: <Widget>[
          // areaName
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 10.0,
                top: 20.0,
                bottom: 20.0
              ),
              alignment: Alignment.centerLeft,
              child: Text(widget.item["label"], style: widget.checked ?
              TextStyle(fontWeight: FontWeight.w600) : TextStyle(fontWeight: FontWeight.w200)),
            ),
          ),
          // 状态
          Expanded(
            flex: 1,
            child: Offstage(
              offstage: !widget.checked,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 10.0,
                  top: 25.0,
                  bottom: 25.0
                ),
                alignment: Alignment.centerRight,
                child: Icon(Icons.check,color: Colors.orange),
              ),
            ),
          )
        ],
      ),
    );
  }
}