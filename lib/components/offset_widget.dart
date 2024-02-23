import 'package:flutter/material.dart';


/// 返回一个偏移widget，用于ListTile的trailing、leading、title等
Widget offsetWidget(double dx, Widget? widget) {
  return Transform.translate(offset: Offset(dx, 0), child: widget);
}

/// 自定义设置单元Section样式 带标题，原用于设置页面分区显示设置选项
class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 9.0), // 设置外边距
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.only(left: 18.0, top: 8, right: 8, bottom: 8),
              child: Text(
                title!,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Column(
            children: children,
          ),
        ],
      ),
    );
  }
}