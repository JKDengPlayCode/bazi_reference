import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';
class GanZhiMatch {
  final DaYun? daYun;
  final LiuNian? liuNian;
  final LiuYue? liuYue;
  final LiuRi? liuRi;
  final String? shiGanZhi;
  // final LiuShi liuShi;

  GanZhiMatch(this.daYun, this.liuNian, this.liuYue, this.liuRi, this.shiGanZhi);
}

List<GanZhiMatch> searchGanZhi(List<DaYun> daYun, String tianGan) {
  List<GanZhiMatch> matches = [];

  for (var dy in daYun) {
    if (dy.getGanZhi().contains(tianGan)) {
      for (var ln in dy.getLiuNian()) {
        if (ln.getGanZhi().contains(tianGan)) {
          for (var ly in ln.getLiuYue()) {
            if (ly.getGanZhi().contains(tianGan)) {
              for (var lr in ly.getLiuRi()) {
                if (lr.getGanZhi().contains(tianGan)) {
                  for (var lsh in lr.getLiuShi()) {
                    if (lsh.contains(tianGan)) {
                      matches.add(GanZhiMatch(dy, ln, ly, lr, lsh));
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  return matches;
}

// void main() {
//   Solar solar = Solar.fromYmdHms(2004, 6, 29, 23, 0, 0);
//   Lunar lunar = Lunar.fromSolar(solar);
//   EightChar eightChar = lunar.getEightChar();
//   // print('流派2:$eightChar');
//   // 流派1认为晚子时日柱算明天，流派2认为晚子时日柱算当天
//   eightChar.setSect(1);
//   print('流派1:$eightChar');
//   // 获取起运相关信息
//   Yun yun = eightChar.getYun(1, 2);
//   // 获取大运列表
//   List<DaYun> daYun = yun.getDaYun();
//   String tianGan = '乙';
//   //  甲 乙 丙 丁 戊 己 庚 辛 壬 癸
//   //  子 丑 寅 卯 辰 巳 午 未 申 酉 戌 亥
// // 调用 searchGanZhi 函数来查找所有符合要求的时刻
//   List<GanZhiMatch> matchedMoments = searchGanZhi(daYun, tianGan);
//   print('------------------------');
//
// // 现在可以遍历匹配结果，并打印出每个包含天干“庚”的完整时刻
//   for (var match in matchedMoments) {
//     print('大运: ${match.daYun?.getGanZhi()}');
//     print('流年: ${match.liuNian?.getGanZhi()}');
//     print('流月: ${match.liuYue?.getGanZhi()}');
//     print('流日: ${match.liuRi?.getGanZhi()}');
//     print('流时: ${match.shiGanZhi}');
//     print('------------------------');
//   }
//   print('--数量：${matchedMoments.length}--');
//
//   // 如果需要获取特定索引处的 GanZhiMatch 对象，可以直接访问 matchedMoments 列表
//   // if (matchedMoments.isNotEmpty) {
//   //   var firstMatch = matchedMoments[0];
//   //   print('首个匹配的完整时刻:');
//   //   print('大运: ${firstMatch.daYun.getGanZhi()}');
//   //   print('流年: ${firstMatch.liuNian.getGanZhi()}');
//   //   print('流月: ${firstMatch.liuYue.getGanZhi()}');
//   //   print('流日: ${firstMatch.liuRi.getGanZhi()}');
//   //   print('流时: ${firstMatch.shiGanZhi}');
//   // }
//
// }
void main() {
  Solar solar = Solar.fromYmdHms(2004, 6, 29, 23, 0, 0);
  Lunar lunar = Lunar.fromSolar(solar);
  EightChar eightChar = lunar.getEightChar();
  // print('流派2:$eightChar');
  // 流派1认为晚子时日柱算明天，流派2认为晚子时日柱算当天
  eightChar.setSect(1);
  print('流派1:$eightChar');
  // 获取起运相关信息
  Yun yun = eightChar.getYun(1, 2);
  // 获取大运列表
  List<DaYun> daYun = yun.getDaYun();
  // 依次嵌套打印大运、流年、流月、流日、流时的干支，这个数据量是巨大的
  // for (var dy in daYun) {
  //   // 打印每个大运的干支
  //   print(dy.getGanZhi());
  //   for(var ln in dy.getLiuNian()){
  //     // 打印每个流年的干支
  //     print(ln.getGanZhi());
  //     for(var ly in ln.getLiuYue()){
  //       // 打印每个流月的干支
  //       print(ly.getGanZhi());
  //       for(var lr in ly.getLiuRi()){
  //         // 打印每个流日的干支
  //         print(lr.getGanZhi());
  //         for(var lsh in lr.getLiuShi()){
  //           // 打印每个流时的干支
  //           print(lsh);
  //         }
  //       }
  //     }
  //   }
  // }
  List<String> ganZhiList = yun.getDaYun().map((element) => element.getGanZhi()).toList();

  // print('大运[${element.getIndex()}]:${element.getGanZhi()} ${element.getStartYear()}年-${element.getStartAge()}岁/${element.getEndYear()}年-${element.getEndAge()}岁');

  // 第1次大运流年
  List<LiuNian> liuNian = daYun[2].getLiuNian();
  for (var element in liuNian) {
    // print('流年[${element.getIndex()}]:${element.getYear()}年-${element.getAge()} 岁 ${element.getGanZhi()}');
  }
  // element.getYear()
  Lunar _lunar = Lunar.fromYmd(liuNian[1].getYear(), 1, 1);
  // print('立春:${_lunar.getJieQiSolar('立春').toYmdHms()}');
  final List<String> JIE_FOR_LIU_YUE_DISPLAY = ['立春', '惊蛰', '清明', '立夏', '芒种', '小暑', '立秋', '白露', '寒露', '立冬', '大雪', '小寒'];
  final List<String> JIE_FOR_LIU_YUE = ['立春', '惊蛰', '清明', '立夏', '芒种', '小暑', '立秋', '白露', '寒露', '立冬', '大雪', 'XIAO_HAN', 'LI_CHUN'];

  for (var i = 0; i < 12; i++) {
    // print('$element:${_lunar.getJieQiSolar(element).toYmdHms()}');
  }
  for (var element in JIE_FOR_LIU_YUE) {
    print('$element:${_lunar.getJieQiSolar(element).toYmdHms()}');
  }

  var startDate = _lunar.getJieQiSolar(JIE_FOR_LIU_YUE[0]);
  var endDate = _lunar.getJieQiSolar(JIE_FOR_LIU_YUE[1]);
  int n = endDate.subtract(startDate) + 1;
  // print(startDate.toYmdHms());
  // print(endDate.toYmdHms());
  // print(n);
  for (int i = 0; i < n; i++) {
    // print('$i: ${startDate.nextDay(i).toYmdHms()}');
  }

  // 大运[1]流年[0]的流月
  List<LiuYue> liuYue = liuNian[1].getLiuYue();
  for (var element in liuYue) {
    // print('流月[${element.getIndex()}]:${element.getMonthInChinese()}月 ${element.getGanZhi()}');
  }
  // 大运[1]流年[0]流月[0]的流日
  LiuYue theLiuYue = liuYue[0];
  List<LiuRi> liuRi = theLiuYue.getLiuRi();
  print(theLiuYue.getStartDate().toYmdHms());
  print(theLiuYue.getEndDate().toYmdHms());
  print(liuRi.length);
  for (var element in liuRi) {
    print('${element.getIndex() + 1}: ${element.getSolar().getMonth()}/${element.getSolar().getDay()} ${element.getGanZhi()}');
    // print('${element.getIndex()+1}: ${element.getSolar().getMonth()}/${element.getSolar().getDay()} ${element.getLunar().getTimeInGanZhi()}');
    // print(element.getGanZhi());
    // print(element.getSolar().toYmdHms());
  }
  // 2017-01-05 11:55:42
  // [庚子, 辛丑, 壬寅, 癸卯, 甲辰, 乙巳, 丙午, 丁未, 戊申, 己酉, 庚戌, 辛亥, 壬子]
  // 二〇一六年腊月初八
  // liuYue[10]的最后一天
  LiuYue theLiuYue0 = liuYue[0];
  List<LiuRi> liuRi0 = theLiuYue0.getLiuRi();
  print('// liuYue[10]的第一天');
  print(liuRi0[0].getLunar().getTimes());
  print(liuRi0[0].getLunar().toString());
  print(liuRi0[0].getSolar().toYmdHms());
  print(liuRi0[0].getLunar().getTimeInGanZhi());
  print(liuRi0[0].getLiuShi());
  print(liuRi0[0].getLiuShi().indexOf(''));
  print(liuRi0[0].getLiuShi().lastIndexOf(''));

  print('// liuYue[10]的最后一天');
  print(liuRi0[liuRi0.length - 1].getLiuShi());
  print(liuRi0[liuRi0.length - 1].getLiuShi().indexOf(''));
  print(liuRi0[liuRi0.length - 1].getLiuShi().lastIndexOf(''));

  print('// liuYue[11]的第一天');
  LiuYue theLiuYue1 = liuYue[11];
  List<LiuRi> liuRi1 = theLiuYue1.getLiuRi();
  // print(liuRi1[0].getLunar().getTimes());
  // print(liuRi1[0].getLunar().toString());
  // print(liuRi1[0].getSolar().toYmdHms());
  // print(liuRi1[0].getLunar().getTimeInGanZhi());
  print(liuRi1[0].getLiuShi());
  print(liuRi1[0].getLiuShi().indexOf(''));
  print(liuRi1[0].getLiuShi().lastIndexOf(''));

  print('// liuYue[11]中的第二天');
  print(liuRi1[1].getLiuShi());
  print(liuRi1[1].getLiuShi().indexOf(''));
  print(liuRi1[1].getLiuShi().lastIndexOf(''));

  // print('出生:${daYun[0].getLunar()}');
  // print('节气:${daYun[0].getLunar().getJieQiTable()}');
  // print('八字:${daYun[0].getLunar().getBaZi()}');
  // print('立春:${daYun[0].getLunar().getJieQiSolar(I18n.getMessage('jq.liChun')).getLunar()}');
  // print('立春:${daYun[0].getLunar().getJieQiSolar(I18n.getMessage('jq.liChun')).toYmdHms()}');
  //
  // print('出生:${lunar}');
  // print('节气:${lunar.getJieQiTable()}');
  // print('八字:${lunar.getBaZi()}');
  // print('立春:${lunar.getJieQiSolar(I18n.getMessage('jq.liChun')).getLunar()}');
  // print('立春:${lunar.getJieQiSolar(I18n.getMessage('jq.liChun')).toYmdHms()}');
  // // 获取干支纪年（新年以立春节气交接的时刻起算）
  // print('年柱:${daYun[0].getLunar().getJieQiSolar(I18n.getMessage('jq.liChun')).getLunar().getYearInGanZhiExact()}');

  // 解决流月中存在没有干支时辰的流日问题
  // 实际上，此流日不应存在
  // 节令转换的时间在某天的23点至0点中间，

  // 打印100年内，节令转换时刻是23点的节令
  // for (int year = 2000; year < 2100; year++) {
  //   Lunar lunar11 = Lunar.fromYmd(year, 1, 1);
  //   for (var element in JIE_FOR_LIU_YUE) {
  //     if (lunar11.getJieQiSolar(element).getHour() == 23) {
  //       print('$element:${lunar11.getJieQiSolar(element).toYmdHms()}');
  //     }
  //   }
  // }

  var prevJie = lunar.getPrevJie();
  var nextJie = lunar.getNextJie();
  String getShiShenShortName(shishen) {
    switch (shishen) {
      case '正官':
        return '官';
      case '七杀':
        return '杀';
      case '正印':
        return '印';
      case '偏印':
        return '枭';
      case '比肩':
        return '比';
      case '劫财':
        return '劫';
      case '食神':
        return '食';
      case '伤官':
        return '伤';
      case '日主':
        return '元';
      case '正财':
        return '财';
      case '偏财':
        return '才';
      default:
        return '';
    }
  }
}

/// test.dart
// 流派1:甲申 庚午 庚辰 丙子
// 立春:2016-02-04 17:46:00
// 惊蛰:2016-03-05 11:43:30
// 清明:2016-04-04 16:27:29
// 立夏:2016-05-05 09:41:50
// 芒种:2016-06-05 13:48:28
// 小暑:2016-07-07 00:03:18
// 立秋:2016-08-07 09:52:58
// 白露:2016-09-07 12:51:02
// 寒露:2016-10-08 04:33:20
// 立冬:2016-11-07 07:47:38
// 大雪:2016-12-07 00:41:05
// XIAO_HAN:2017-01-05 11:55:42
// LI_CHUN:2017-02-03 23:34:01
// 2016-12-07 00:41:05
// 2017-01-05 11:55:42
// 30
// 1: 12/7 癸亥
// 2: 12/8 甲子
// 3: 12/9 乙丑
// 4: 12/10 丙寅
// 5: 12/11 丁卯
// 6: 12/12 戊辰
// 7: 12/13 己巳
// 8: 12/14 庚午
// 9: 12/15 辛未
// 10: 12/16 壬申
// 11: 12/17 癸酉
// 12: 12/18 甲戌
// 13: 12/19 乙亥
// 14: 12/20 丙子
// 15: 12/21 丁丑
// 16: 12/22 戊寅
// 17: 12/23 己卯
// 18: 12/24 庚辰
// 19: 12/25 辛巳
// 20: 12/26 壬午
// 21: 12/27 癸未
// 22: 12/28 甲申
// 23: 12/29 乙酉
// 24: 12/30 丙戌
// 25: 12/31 丁亥
// 26: 1/1 戊子
// 27: 1/2 己丑
// 28: 1/3 庚寅
// 29: 1/4 辛卯
// 30: 1/5 壬辰
// [庚子, 辛丑, 壬寅, 癸卯, 甲辰, 乙巳, 丙午, 丁未, 戊申, 己酉, 庚戌, 辛亥, 壬子]
// 二〇一六年腊月初八
// 2017-01-05 11:55:42
// 丙午
// // liuYue[10]的最后一天
// [庚子, 辛丑, 壬寅, 癸卯, 甲辰, 乙巳, 丙午, , , , , ]
// 7
// 11
// // liuYue[11]的第一天
// [, , , , , , 丙午, 丁未, 戊申, 己酉, 庚戌, 辛亥]
// 0
// 5
// // liuYue[11]中的第二天
// [壬子, 癸丑, 甲寅, 乙卯, 丙辰, 丁巳, 戊午, 己未, 庚申, 辛酉, 壬戌, 癸亥]
// -1
// -1
// 立夏:2006-05-05 23:30:39
// 立秋:2006-08-07 23:40:47
// 清明:2009-04-04 23:33:46
// 寒露:2011-10-08 23:19:05
// 清明:2013-04-04 23:02:27
// LI_CHUN:2017-02-03 23:34:01
// 立春:2017-02-03 23:34:01
// 惊蛰:2018-03-05 23:28:06
// XIAO_HAN:2019-01-05 23:38:52
// 小暑:2020-07-06 23:14:20
// 白露:2022-09-07 23:32:07
// XIAO_HAN:2023-01-05 23:04:39
// 大雪:2024-12-06 23:16:47
// 芒种:2026-06-05 23:48:04
// 立冬:2027-11-07 23:38:15
// 立冬:2031-11-07 23:05:15
// 立夏:2035-05-05 23:54:25
// 立秋:2035-08-07 23:53:49
// 立夏:2039-05-05 23:17:33
// 立秋:2039-08-07 23:17:29
// 清明:2042-04-04 23:40:00
// 寒露:2044-10-07 23:12:36
// 小暑:2049-07-06 23:08:03
// LI_CHUN:2050-02-03 23:43:00
// 立春:2050-02-03 23:43:00
// 惊蛰:2051-03-05 23:21:17
// 白露:2051-09-07 23:50:33
// XIAO_HAN:2052-01-05 23:47:46
// LI_CHUN:2054-02-03 23:07:09
// 立春:2054-02-03 23:07:09
// 芒种:2055-06-05 23:55:08
// 白露:2055-09-07 23:14:47
// XIAO_HAN:2056-01-05 23:14:54
// 大雪:2057-12-06 23:33:53
// 芒种:2059-06-05 23:11:30
// 立冬:2060-11-06 23:48:06
// 立冬:2064-11-06 23:00:53
// 立夏:2068-05-04 23:19:50
// 立秋:2068-08-06 23:10:23
// 寒露:2073-10-07 23:40:33
// 清明:2075-04-04 23:30:17
// 寒露:2077-10-07 23:10:05
// 小暑:2078-07-06 23:28:05
// LI_CHUN:2083-02-03 23:57:43
// 立春:2083-02-03 23:57:43
// 惊蛰:2084-03-04 23:24:25
// 白露:2084-09-06 23:13:43
// XIAO_HAN:2085-01-04 23:55:40
// LI_CHUN:2087-02-03 23:14:34
// 立春:2087-02-03 23:14:34
// 芒种:2088-06-04 23:19:24
// XIAO_HAN:2089-01-04 23:20:37
// 大雪:2090-12-06 23:39:14
// 立冬:2093-11-06 23:55:12
// 大雪:2094-12-06 23:07:31
// 立秋:2097-08-06 23:32:21
// 立冬:2097-11-06 23:03:19
//
// Process finished with exit code 0
