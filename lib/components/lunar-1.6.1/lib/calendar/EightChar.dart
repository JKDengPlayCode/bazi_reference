
import 'IndexValue.dart';
import 'Lunar.dart';
import 'eightchar/Yun.dart';
import 'util/LunarUtil.dart';

/// 八字
/// @author 6tail
class EightChar {
  /// 流派，2晚子时日柱按当天，1晚子时日柱按明天
  int _sect = 2;

  /// 阴历
  Lunar _lunar;

  EightChar(this._lunar);

  static EightChar fromLunar(Lunar lunar) {
    return EightChar(lunar);
  }

  int getSect() => _sect;

  void setSect(int sect) {
    _sect = (1 == sect) ? 1 : 2;
  }

  Lunar getLunar() => _lunar;

  String getYear() => _lunar.getYearInGanZhiExact();

  String getYearGan() => _lunar.getYearGanExact();

  String getYearZhi() => _lunar.getYearZhiExact();

  List<String> getYearHideGan() => LunarUtil.ZHI_HIDE_GAN[getYearZhi()]!;

  String getYearWuXing() => LunarUtil.WU_XING_GAN[getYearGan()]! + LunarUtil.WU_XING_ZHI[getYearZhi()]!;

  String getYearNaYin() => LunarUtil.NAYIN[getYear()]!;

  String getYearShiShenGan() => LunarUtil.SHI_SHEN_GAN['${getDayGan()}${getYearGan()}']!;

  List<String> getShiShenZhi(String zhi) {
    List<String> hideGan = LunarUtil.ZHI_HIDE_GAN[zhi]!;
    List<String> l = <String>[];
    for (String gan in hideGan) {
      l.add(LunarUtil.SHI_SHEN_ZHI['${getDayGan()}$zhi$gan']!);
    }
    return l;
  }

  List<String> getYearShiShenZhi() => getShiShenZhi(getYearZhi());

  int getDayGanIndex() => 2 == _sect ? _lunar.getDayGanIndexExact2() : _lunar.getDayGanIndexExact();

  int getDayZhiIndex() => 2 == _sect ? _lunar.getDayZhiIndexExact2() : _lunar.getDayZhiIndexExact();

  /// lunar自带地势,根据此方法建立了‘自坐’的获取
  String getDiShi(int zhiIndex) {
    int? offset = LunarUtil.CHANG_SHENG_OFFSET[getDayGan()];
    int index = offset! + (getDayGanIndex() % 2 == 0 ? zhiIndex : -zhiIndex);
    if (index >= 12) {
      index -= 12;
    }
    if (index < 0) {
      index += 12;
    }
    return LunarUtil.CHANG_SHENG[index];
  }

  String getYearDiShi() => getDiShi(_lunar.getYearZhiIndexExact());

  String getMonth() => _lunar.getMonthInGanZhiExact();

  String getMonthGan() => _lunar.getMonthGanExact();

  String getMonthZhi() => _lunar.getMonthZhiExact();

  List<String> getMonthHideGan() => LunarUtil.ZHI_HIDE_GAN[getMonthZhi()]!;

  String getMonthWuXing() => LunarUtil.WU_XING_GAN[getMonthGan()]! + LunarUtil.WU_XING_ZHI[getMonthZhi()]!;

  String getMonthNaYin() => LunarUtil.NAYIN[getMonth()]!;

  String getMonthShiShenGan() => LunarUtil.SHI_SHEN_GAN['${getDayGan()}${getMonthGan()}']!;

  List<String> getMonthShiShenZhi() => getShiShenZhi(getMonthZhi());

  String getMonthDiShi() => getDiShi(_lunar.getMonthZhiIndexExact());

  String getDay() => 2 == _sect ? _lunar.getDayInGanZhiExact2() : _lunar.getDayInGanZhiExact();

  String getDayGan() => 2 == _sect ? _lunar.getDayGanExact2() : _lunar.getDayGanExact();

  String getDayZhi() => 2 == _sect ? _lunar.getDayZhiExact2() : _lunar.getDayZhiExact();

  List<String> getDayHideGan() => LunarUtil.ZHI_HIDE_GAN[getDayZhi()]!;

  String getDayWuXing() => LunarUtil.WU_XING_GAN[getDayGan()]! + LunarUtil.WU_XING_ZHI[getDayZhi()]!;

  String getDayNaYin() => LunarUtil.NAYIN[getDay()]!;

  String getDayShiShenGan() => '日主';

  List<String> getDayShiShenZhi() => getShiShenZhi(getDayZhi());

  String getDayDiShi() => getDiShi(getDayZhiIndex());

  String getTime() => _lunar.getTimeInGanZhi();

  String getTimeGan() => _lunar.getTimeGan();

  String getTimeZhi() => _lunar.getTimeZhi();

  List<String> getTimeHideGan() => LunarUtil.ZHI_HIDE_GAN[getTimeZhi()]!;

  String getTimeWuXing() => LunarUtil.WU_XING_GAN[getTimeGan()]! + LunarUtil.WU_XING_ZHI[getTimeZhi()]!;

  String getTimeNaYin() => LunarUtil.NAYIN[getTime()]!;

  String getTimeShiShenGan() => LunarUtil.SHI_SHEN_GAN[getDayGan() + getTimeGan()]!;

  List<String> getTimeShiShenZhi() => getShiShenZhi(getTimeZhi());

  String getTimeDiShi() => getDiShi(_lunar.getTimeZhiIndex());

  String getTaiYuan() {
    int ganIndex = _lunar.getMonthGanIndexExact() + 1;
    if (ganIndex >= 10) {
      ganIndex -= 10;
    }
    int zhiIndex = _lunar.getMonthZhiIndexExact() + 3;
    if (zhiIndex >= 12) {
      zhiIndex -= 12;
    }
    return LunarUtil.GAN[ganIndex + 1] + LunarUtil.ZHI[zhiIndex + 1];
  }

  String getTaiYuanNaYin() => LunarUtil.NAYIN[getTaiYuan()]!;

  String getTaiXi() {
    int ganIndex = (2 == _sect) ? _lunar.getDayGanIndexExact2() : _lunar.getDayGanIndexExact();
    int zhiIndex = (2 == _sect) ? _lunar.getDayZhiIndexExact2() : _lunar.getDayZhiIndexExact();
    return LunarUtil.HE_GAN_5[ganIndex] + LunarUtil.HE_ZHI_6[zhiIndex];
  }

  String getTaiXiNaYin() => LunarUtil.NAYIN[getTaiXi()]!;

  String getMingGong() {
    int monthZhiIndex = 0;
    int timeZhiIndex = 0;
    IndexValue? iv = LunarUtil.find(_lunar.getMonthZhiExact(), LunarUtil.MONTH_ZHI);
    if (null != iv) {
      monthZhiIndex = iv.getIndex();
    }
    iv = LunarUtil.find(_lunar.getTimeZhi(), LunarUtil.MONTH_ZHI);
    if (null != iv) {
      timeZhiIndex = iv.getIndex();
    }
    int zhiIndex = 26 - (monthZhiIndex + timeZhiIndex);
    if (zhiIndex > 12) {
      zhiIndex -= 12;
    }
    int jiaZiIndex = LunarUtil.getJiaZiIndex(_lunar.getMonthInGanZhiExact()) - (monthZhiIndex - zhiIndex);
    if (jiaZiIndex >= 60) {
      jiaZiIndex -= 60;
    }
    if (jiaZiIndex < 0) {
      jiaZiIndex += 60;
    }
    return LunarUtil.JIA_ZI[jiaZiIndex];
  }

  String getMingGongNaYin() => LunarUtil.NAYIN[getMingGong()]!;

  String getShenGong() {
    int monthZhiIndex = 0;
    int timeZhiIndex = 0;
    IndexValue? iv = LunarUtil.find(_lunar.getMonthZhiExact(), LunarUtil.MONTH_ZHI);
    if (null != iv) {
      monthZhiIndex = iv.getIndex();
    }
    iv = LunarUtil.find(_lunar.getTimeZhi(), LunarUtil.MONTH_ZHI);
    if (null != iv) {
      timeZhiIndex = iv.getIndex();
    }
    int zhiIndex = 2 + monthZhiIndex + timeZhiIndex;
    if (zhiIndex > 12) {
      zhiIndex -= 12;
    }
    int jiaZiIndex = LunarUtil.getJiaZiIndex(_lunar.getMonthInGanZhiExact()) - (monthZhiIndex - zhiIndex);
    if (jiaZiIndex >= 60) {
      jiaZiIndex -= 60;
    }
    if (jiaZiIndex < 0) {
      jiaZiIndex += 60;
    }
    return LunarUtil.JIA_ZI[jiaZiIndex];
  }

  String getShenGongNaYin() => LunarUtil.NAYIN[getShenGong()]!;

  Yun getYun(int gender, [int sect = 1]) => Yun(this, gender, sect);

  String getYearXun() => _lunar.getYearXunExact();

  String getYearXunKong() => _lunar.getYearXunKongExact();

  String getMonthXun() => _lunar.getMonthXunExact();

  String getMonthXunKong() => _lunar.getMonthXunKongExact();

  String getDayXun() => 2 == _sect ? _lunar.getDayXunExact2() : _lunar.getDayXunExact();

  String getDayXunKong() => 2 == _sect ? _lunar.getDayXunKongExact2() : _lunar.getDayXunKongExact();

  String getTimeXun() => _lunar.getTimeXun();

  String getTimeXunKong() => _lunar.getTimeXunKong();

  @override
  String toString() => '${getYear()} ${getMonth()} ${getDay()} ${getTime()}';

  /// 自建‘自坐’ START
  /// 根据lunar自带地势建立‘自坐’的获取
  /// 年柱自坐
  String getYearZiZuo() {
    int? offset = LunarUtil.CHANG_SHENG_OFFSET[_lunar.getYearGanExact()];
    int index = offset! + (_lunar.getYearGanIndexExact() % 2 == 0 ? _lunar.getYearZhiIndexExact() : -_lunar.getYearZhiIndexExact());
    if (index >= 12) {
      index -= 12;
    }
    if (index < 0) {
      index += 12;
    }
    return LunarUtil.CHANG_SHENG[index];
  }

  /// 月柱自坐
  String getMonthZiZuo() {
    int? offset = LunarUtil.CHANG_SHENG_OFFSET[_lunar.getMonthGanExact()];
    int index = offset! + (_lunar.getMonthGanIndexExact() % 2 == 0 ? _lunar.getMonthZhiIndexExact() : -_lunar.getMonthZhiIndexExact());
    if (index >= 12) {
      index -= 12;
    }
    if (index < 0) {
      index += 12;
    }
    return LunarUtil.CHANG_SHENG[index];
  }

  /// 日柱自坐
  String getDayZiZuo() {
    int? offset = LunarUtil.CHANG_SHENG_OFFSET[getDayGan()];
    int index = offset! + (getDayGanIndex() % 2 == 0 ? getDayZhiIndex() : -getDayZhiIndex());
    if (index >= 12) {
      index -= 12;
    }
    if (index < 0) {
      index += 12;
    }
    return LunarUtil.CHANG_SHENG[index];
  }

  /// 时柱自坐
  String getTimeZiZuo() {
    int? offset = LunarUtil.CHANG_SHENG_OFFSET[getTimeGan()];
    int index = offset! + (_lunar.getTimeGanIndex() % 2 == 0 ? _lunar.getTimeZhiIndex() : -_lunar.getTimeZhiIndex());
    if (index >= 12) {
      index -= 12;
    }
    if (index < 0) {
      index += 12;
    }
    return LunarUtil.CHANG_SHENG[index];
  } // 自建‘自坐’ END

  // 自建‘神煞’ START
  // TODO 已经移到 \lib\pages\bazi_result\bazi_lunar.dart 中，因有些神煞需要判断 人的性别
  // /// 是否有神煞，以一查四则四柱都可能有的神煞
  // /// [whichPillar]四柱0-3，[whichRule]神煞的拼音取其判断规则，[condition]条件干支，[equivalent]对应干支
  // bool hasShenShaFourPillar(int whichPillar, String whichRule, String condition, String equivalent) {
  //   bool conditionsMet = false;
  //   List<String> conditionsList = (shenShaRules[whichRule]?['conditionsList'] as List<String>);
  //   List<String> equivalentList = (shenShaRules[whichRule]?['equivalentList'] as List<String>);
  //   // 条件干支
  //   String conditionGetMethod = '';
  //   switch (condition) {
  //     case 'riGan':
  //       conditionGetMethod = getDayGan();
  //     case 'riZhi':
  //       conditionGetMethod = getDayZhi();
  //     case 'yueGan':
  //       conditionGetMethod = getMonthGan();
  //     case 'yueZhi':
  //       conditionGetMethod = getMonthZhi();
  //     case 'nianGan':
  //       conditionGetMethod = getYearGan();
  //     case 'nianZhi':
  //       conditionGetMethod = getYearZhi();
  //   }
  //   // 对应干支
  //   List<String> equivalentGetMethods = [];
  //   switch (equivalent) {
  //     case 'tianGan':
  //       equivalentGetMethods = [getYearGan(), getMonthGan(), getDayGan(), getTimeGan()];
  //     case 'diZhi':
  //       equivalentGetMethods = [getYearZhi(), getMonthZhi(), getDayZhi(), getTimeZhi()];
  //     case 'ganZhi':
  //       equivalentGetMethods = [getYearGanZhi(), getMonthGanZhi(), getDayGanZhi(), getTimeGanZhi()];
  //   }
  //   // 日干在条件列表conditionsList中的索引a，与以下四柱地支在equivalentList中的索引b相等时，有此贵人
  //   int a = conditionsList.indexWhere((element) => element.contains(conditionGetMethod));
  //   if (a >= 0) {
  //     switch (whichPillar) {
  //       case 0:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[0]));
  //         conditionsMet = a == b;
  //       case 1:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[1]));
  //         conditionsMet = a == b;
  //       case 2:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[2]));
  //         conditionsMet = a == b;
  //       case 3:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[3]));
  //         conditionsMet = a == b;
  //     }
  //   }
  //   return conditionsMet;
  // }
  //
  // /// 是否有神煞，以一查三则三柱都可能有的神煞
  // /// [whichPillar]四柱0-3，[whichRule]神煞的拼音取其判断规则，[condition]条件干支，[equivalent]对应干支
  // bool hasShenShaThreePillar(int whichPillar, String whichRule, String condition, String equivalent) {
  //   bool conditionsMet = false;
  //   List<String> conditionsList = (shenShaRules[whichRule]?['conditionsList'] as List<String>);
  //   List<String> equivalentList = (shenShaRules[whichRule]?['equivalentList'] as List<String>);
  //   // 条件干支
  //   String conditionGetMethod = '';
  //   // 对应干支
  //   List<String> equivalentGetMethods = [];
  //   switch (condition) {
  //     case 'riZhi':
  //       conditionGetMethod = getDayZhi();
  //       switch (equivalent) {
  //         case '3Zhi': // 以一支查其余三支，本支置为字符串null'以排除本支
  //           equivalentGetMethods = [getYearZhi(), getMonthZhi(), 'null', getTimeZhi()];
  //       }
  //     case 'yueZhi':
  //       conditionGetMethod = getMonthZhi();
  //       switch (equivalent) {
  //         case '3Zhi':
  //           equivalentGetMethods = [getYearZhi(), 'null', getDayZhi(), getTimeZhi()];
  //         case 'riGanZhi': // 四废日
  //           equivalentGetMethods = ['null', 'null', getDayGanZhi(), 'null'];
  //       }
  //     case 'nianZhi':
  //       conditionGetMethod = getYearZhi();
  //       switch (equivalent) {
  //         case '3Zhi':
  //           equivalentGetMethods = ['null', getMonthZhi(), getDayZhi(), getTimeZhi()];
  //       }
  //     case 'riKongWang': // 空亡
  //       // 把条件列表、比对列表、条件值都设置为日旬空getDayXunKong()，则a=0，然后判断b值即其余各支是否包含在日旬空中
  //       conditionsList=[getDayXunKong()];
  //       equivalentList=[getDayXunKong()];
  //       conditionGetMethod = getDayXunKong();
  //       equivalentGetMethods = [getYearZhi(), getMonthZhi(), 'null', getTimeZhi()];
  //     case 'nianKongWang': // 空亡
  //       conditionsList=[getYearXunKong()];
  //       equivalentList=[getYearXunKong()];
  //       conditionGetMethod = getYearXunKong();
  //       equivalentGetMethods = ['null', getMonthZhi(), getDayZhi(), getTimeZhi()];
  //   }
  //   // 日干在条件列表conditionsList中的索引a，与以下四柱地支在equivalentList中的索引b相等时，有此贵人
  //   // 当不存在时，a=-1
  //   int a = conditionsList.indexWhere((element) => element.contains(conditionGetMethod));
  //   if (a >= 0) {
  //     switch (whichPillar) {
  //       case 0:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[0]));
  //         conditionsMet = a == b;
  //       case 1:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[1]));
  //         conditionsMet = a == b;
  //       case 2:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[2]));
  //         conditionsMet = a == b;
  //       case 3:
  //         int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[3]));
  //         conditionsMet = a == b;
  //     }
  //   }
  //   return conditionsMet;
  // }
  //
  // /// 仅单柱包含
  // bool hasShenShaOnePillar(int pillarIndex, String whichRule, String condition) {
  //   bool conditionsMet = false;
  //   List<String> conditionsList = (shenShaRules[whichRule]?['conditionsList'] as List<String>);
  //   // 条件干支
  //   String conditionGetMethod = '';
  //   switch (condition) {
  //     case 'riGanZhi':
  //       conditionGetMethod = getDayGanZhi();
  //   }
  //   conditionsMet = conditionsList.indexWhere((element) => element.contains(conditionGetMethod)) >= 0;
  //   return conditionsMet;
  // }
  //
  // /// 三奇贵人
  // bool hasSanQiGuiRen() {
  //   bool conditionsMet = false;
  //   // 年月日时干
  //   String allGan = getYearGan() + getMonthGan() + getDayGan() + getTimeGan();
  //   List<String> conditionsList = (shenShaRules['sanQiGuiRen']?['conditionsList'] as List<String>);
  //   // 被测者年月日时干 包含 条件中的三个连续天干
  //   conditionsMet = conditionsList.indexWhere((element) => allGan.contains(element)) >= 0;
  //   return conditionsMet;
  // }
  //
  // /// 统一获取神煞的方法
  // List<List<String>> getShenSha() {
  //   // shenSha列表中含有4个子列表，分别存储四柱的神煞 yueZhi
  //   List<List<String>> tempShenSha = [[], [], [], []];
  //   List<List<String>> shenSha = [];
  //   // 根据神煞类型获取
  //   shenShaRules.forEach((key, value) {
  //     if (value['type'] == '4-Pillar') {
  //       for (int i = 0; i < 4; i++) {
  //         if (hasShenShaFourPillar(i, key, value['conditionsName'].toString(), value['equivalentName'].toString())) {
  //           tempShenSha[i].add(value['name'].toString());
  //         }
  //       }
  //     }
  //     if (value['type'] == '31-Pillar') {
  //       for (int i = 0; i < 4; i++) {
  //         if (hasShenShaThreePillar(i, key, value['conditionsName'].toString(), value['equivalentName'].toString())) {
  //           tempShenSha[i].add(value['name'].toString());
  //         }
  //       }
  //     }
  //     if (value['type'] == '10-Pillar') {
  //       int pillarIndex = int.parse(value['pillarIndex'].toString());
  //       if (hasShenShaOnePillar(pillarIndex, key, value['conditionsName'].toString())) {
  //         tempShenSha[pillarIndex].add(value['name'].toString());
  //       }
  //     }
  //     if (value['type'] == 'sanQiGuiRen') {
  //       if (hasSanQiGuiRen()) {
  //         tempShenSha[2].add(value['name'].toString()); // 在日柱神煞中添加三奇贵人
  //       }
  //     }
  //   });
  //
  //   // 各柱神煞去重;
  //   for (var element in tempShenSha) {
  //     final uniqueElement = element.toSet().toList();
  //     shenSha.add(uniqueElement);
  //   }
  //   return shenSha;
  // }
}
