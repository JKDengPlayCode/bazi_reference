import 'package:flutter/material.dart';


import 'package:bazi/components/offset_widget.dart';

import '../components/radius_no_div_expansion_tile.dart';

class HelpPage extends StatelessWidget {
  HelpPage({super.key});
  // 万年历页面二级帮助菜单
  final List<SubTitle> subTitles = [
    SubTitle(title: '界面', linkTo: ''),
    SubTitle(title: '功能', linkTo: ''),
    SubTitle(title: '日期查询', linkTo: ''),
    SubTitle(title: '4.翻页', linkTo: ''),
    SubTitle(title: '5.口算心算', linkTo: ''),
    // 其他...
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('帮助')),
      endDrawer: SizedBox(
        width: 256,
        child: Drawer(
          // 这里添加抽屉（Drawer）
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildHeader(),
              _buildItem(context, Icons.palette, '应用设置', '/settings', false),
              _buildItem(context, Icons.palette, '数据管理', '/data_manage', false),
              const Divider(height: 1),
              _buildFlutterUnit(context, Icons.calendar_today, '黄历/万年历', subTitles),
              _buildItem(context, Icons.palette, 'Dart 手册', '', false),
              const Divider(height: 1),
              _buildItem(context, Icons.palette, '关于应用', '/about_app', false),
              _buildItem(context, Icons.palette, '联系本王', '/about_me', false),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text('主页面内容'),
      ),
    );
  }

  // 自定义的DrawerHeader
  Widget _buildHeader() => const SizedBox(
        height: 90,
        child: DrawerHeader(
          child: Text(
            '目录',
            // textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
      );

  /// 自定义的DrawerItem，有子项
  Widget _buildFlutterUnit(BuildContext context, IconData? icon, String title, List<SubTitle> subTitles) {
    return RadiusNoBorderExpansionTile(
      // backgroundColor: Colors.white70,
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      children: List.generate(
        subTitles.length,
        (index) {
          final subTitle = subTitles[index];
          return _buildItem(context, Icons.palette, subTitle.title, subTitle.linkTo, true);
        },
      ),
    );
  }

  /// 自定义的DrawerItem，没有子项，[isSubItem]本身是否是子项
  Widget _buildItem(BuildContext context, IconData? icon, String title, String linkTo, bool isSubItem, {VoidCallback? onTap}) {
    return ListTile(
      title: isSubItem ? offsetWidget(38, Text(title, style: const TextStyle(fontSize: 15))) : Text(title),
      dense: isSubItem ? true : false,
      visualDensity: isSubItem ? const VisualDensity(vertical: -4) : VisualDensity.compact,
      leading: isSubItem ? null : Icon(icon, color: Theme.of(context).colorScheme.primary),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
      onTap: () {},
    );
  }
}

/// 自定义DrawerItem的子项类 [title]标题、[linkTo]链接到页面 TODO: 尝试使用路由表
class SubTitle {
  String title;
  String linkTo;

  SubTitle({required this.title, required this.linkTo});
}
