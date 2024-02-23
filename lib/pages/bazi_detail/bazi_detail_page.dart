import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bazi_detail_ben.dart';
import 'bazi_detail_chuan.dart';
import 'bazi_detail_liu.dart';
import 'bazi_detail_ming.dart';

class BaziDetailPage extends StatefulWidget {
  const BaziDetailPage({super.key});

  @override
  State<BaziDetailPage> createState() => _BaziDetailPageState();
}

class _BaziDetailPageState extends State<BaziDetailPage> {
  @override
  Widget build(BuildContext context) {
    // 接收从BaziResultPage页面传递过来的Get.arguments
    // final getAll = Get.arguments;
    // print(getAll.rt()['age']);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                stretch: false,
                title: const Text('分析论断'),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.picture_as_pdf,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    tooltip: '导出PDF',
                  )
                ],
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: Theme.of(context).colorScheme.primary,
                    unselectedLabelColor: Colors.grey,
                    tabs: _tabs,
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: const TabBarView(
            children: [
              BaziDetailMingPage(),
              BaziDetailBenPage(),
              BaziDetailChuanPage(),
              BaziDetailLiuPage(),
            ],
          ),
        ),
      ),
    );
  }
}

const _tabs = [
  Tab(text: '命盘分析'),
  Tab(text: '本命论断'),
  Tab(text: '传统论断'),
  Tab(text: '流运分析'),
];

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
