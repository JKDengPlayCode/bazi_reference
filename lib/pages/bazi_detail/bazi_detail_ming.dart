import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bazi_detail_logic.dart';

class BaziDetailMingPage extends StatelessWidget {
  const BaziDetailMingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final getAll = Get.arguments;

    var daYun = getAll.rt()['daYun'];

    print(daYun[0].getXiaoYun().length);
    return Center(
      child: Container(
          // "人元司令": "生於" +this.月令 + "月，" + this.生日.節 + "後" + this.生日.距離節的天數 + "天出生，" + this.分析.人元司令 + 天干屬性(this.分析.人元司令, "五行") + "當令",
        child: Text('${getAll.getGanZhi()[5]}生于${getAll.getGanZhi()[3]}月，${getAll.rt()['prevJieQi']}后${getAll.rt()['afterJieDays']}天出生，${BAZI().getRenYuanSiLingFenYe(getAll.rt()['prevJieQi'],getAll.rt()['afterJieDays'])}当令'),
      ),
    );
  }
}
