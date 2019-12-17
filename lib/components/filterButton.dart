/**
 * 筛选页面的按钮组件——展开按钮
 *  参数：
 *    clickCb：点击按钮的回调
 *    item: 传入的按钮的文案等数据
 *    checked：是否被选中
 *    id: 当前元素在外层list的index
 *    changed: 是否被更改过
 *    render: 是否是中间级（改变颜色）
 * author: djytwy on 2019-11-22 09:15
 */

import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  FilterButton({
    Key key,
    this.clickCb,
    this.item,
    this.checked,
    this.id,
    this.changed,
    this.render,
  }):super();
  final clickCb;
  final item;
  final checked;
  final id;
  final changed;
  final render;

  @override
  _FilterButtonState createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _clickCb,
      child: Container(
        height: 96.0,
        width: 100.0,
        decoration: BoxDecoration(
          color: widget.checked == true ? Colors.white : widget.render == true ?
          Colors.white: Color.fromARGB(255, 248, 248, 249)
        ),
        child: Center(
          child: Text(widget.item["label"], style: TextStyle(
            color: widget.checked == true ? Colors.black : widget.changed == true ?
            Colors.blue : Color.fromARGB(255, 101, 113, 128),
            fontWeight: widget.checked == true ? FontWeight.w600 : FontWeight.w200
          )
          ),
        ),
      ),
    );
  }

  void _clickCb() {
    print('ID: ${widget.id}, ${widget.item}');
    widget.clickCb(widget.item, widget.id);
  }
}