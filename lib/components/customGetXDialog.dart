import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 使用GetX自定义的仿苹果风格对话框，用在不传上下文context的情况下
Future customGetXDialog(String title, String content) {
  return Get.defaultDialog(
    title: title,
    titleStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
    content: Text(content),
    contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 18),
    radius: 14.0,
  );
}

/// 自定义的苹果风格对话框，用在需要传上下文context的情况下
Future customCuDialog(BuildContext context,String title, String content){
  return showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    // 对话框风格：苹果 CupertinoAlertDialog、安卓 AlertDialog
    builder: (context) => CupertinoAlertDialog(
      // scrollable: true,
      title: Text(
        // 去掉标题中的空格
        title.replaceAll(RegExp(r' '), ''),
      ),
      content: Text(
        '\n$content',
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 14),
      ),
      // actions: <Widget>[
      //   // 按钮风格：苹果 CupertinoButton
      //   CupertinoButton(
      //     alignment: Alignment.center,
      //     child: const Text('关闭'),
      //     onPressed: () => Navigator.of(context).pop(),
      //   ),
      // ],
    ),
  );
}
