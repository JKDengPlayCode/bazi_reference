import 'package:bazi/pages/bazi_info/bazi_info_view.dart';
import 'package:bazi/pages/user_home_page.dart';
import 'package:flutter/material.dart';
import 'package:bazi/pages/wan_nian_li/wan_nian_li_page.dart';
import 'package:bazi/pages/knowledge_page.dart';
import 'package:bazi/pages/user_info_page.dart';
import 'package:bazi/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Flutter 三种方式实现页面切换后保持原页面状态
  // https://zhuanlan.zhihu.com/p/58582876?utm_id=0
  final items = [
    const BottomNavigationBarItem(
      activeIcon: Icon(Icons.calendar_today),
      icon: Icon(Icons.calendar_today_outlined),
      label: "黄历",
    ),
    const BottomNavigationBarItem(
      activeIcon: Icon(Icons.local_library),
      icon: Icon(Icons.local_library_outlined),
      label: "知识",
    ),
    const BottomNavigationBarItem(
      activeIcon: Icon(Icons.now_widgets),
      icon: Icon(Icons.now_widgets_outlined),
      label: "命运",
    ),
    const BottomNavigationBarItem(
      activeIcon: Icon(Icons.shopping_bag),
      icon: Icon(Icons.shopping_bag_outlined),
      label: "商城",
    ),
    const BottomNavigationBarItem(
      activeIcon: Icon(Icons.person),
      icon: Icon(Icons.person_outlined),
      label: "我的",
    ),
  ];

  final pageController = PageController();

  int currentIndex = 0;

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: items,
          currentIndex: currentIndex,
          onTap: onTap,
          // items大于3个时，底部导航栏会白屏
          type: BottomNavigationBarType.fixed,
        ),
        // body: bodyList[currentIndex],
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(), // 禁止滑动
          children: [
            const LaoHuangLiPage(),
            const KnowledgePage(),
            BaziInfoNewPage(),
            const UserInfoPage(),
            // const UserHomePage(),
            SettingsPage(),
          ],
        ));
  }
}
