import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';
import 'package:flutter/material.dart';
import 'package:bazi/components/iconfont.dart';

// 自定义类，用于返回查询lunar返回的数据内容及格式
class MyLunar {
  // 天干 五行编号：木火土金水01234
  static final Map<String, int> wuXingGan = {
    // 甲乙丙丁戊己庚辛壬癸
    '甲': 0,
    '乙': 0,
    '丙': 1,
    '丁': 1,
    '戊': 2,
    '己': 2,
    '庚': 3,
    '辛': 3,
    '壬': 4,
    '癸': 4,
  };
  // 地支五行编号：木火土金水01234
  static final Map<String, int> wuXingZhi = {
    // 子丑寅卯辰巳午未申酉戌亥
    '寅': 0,
    '卯': 0,
    '巳': 1,
    '午': 1,
    '辰': 2,
    '丑': 2,
    '戌': 2,
    '未': 2,
    '申': 3,
    '酉': 3,
    '亥': 4,
    '子': 4,
  };
  // 五行对应的颜色
  static final Map<int, Color> wuXingColor = {
    // 木火土金水
    0: Colors.green.shade800,
    1: Colors.red.shade800,
    2: Colors.brown.shade500,
    3: Colors.orange.shade300,
    4: Colors.blue.shade700,
  };

  // 地支对应的生肖图标
  static final Map<String, Icon> shengXiaoIcon = {
    // 子丑寅卯辰巳午未申酉戌亥
    '寅': Icon(TaiJiIconFont.huxiao, color: Colors.green.shade800, size: 40),
    '卯': Icon(TaiJiIconFont.tuxiao, color: Colors.green.shade800, size: 40),
    '巳': Icon(TaiJiIconFont.shexiao, color: Colors.red.shade800, size: 40),
    '午': Icon(TaiJiIconFont.maxiao, color: Colors.red.shade800, size: 40),
    '辰': Icon(TaiJiIconFont.longxiao, color: Colors.brown.shade500, size: 40),
    '丑': Icon(TaiJiIconFont.niuxiao, color: Colors.brown.shade500, size: 40),
    '戌': Icon(TaiJiIconFont.gouxiao, color: Colors.brown.shade500, size: 40),
    '未': Icon(TaiJiIconFont.yangxiao, color: Colors.brown.shade500, size: 40),
    '申': Icon(TaiJiIconFont.houxiao, color: Colors.orange.shade300, size: 40),
    '酉': Icon(TaiJiIconFont.jixiao, color: Colors.orange.shade300, size: 40),
    '亥': Icon(TaiJiIconFont.zhuxiao, color: Colors.blue.shade700, size: 40),
    '子': Icon(TaiJiIconFont.shuxiao, color: Colors.blue.shade700, size: 40),
  };

  // 星期数字123 转 星期一二三
  static final Map<int, String> weekChinese = {
    1: '一',
    2: '二',
    3: '三',
    4: '四',
    5: '五',
    6: '六',
    7: '七',
  };

  // DateTime now = DateTime.now();
  // Lunar date = Lunar.fromDate(DateTime.now());

  // Lunar date = Lunar.fromDate(DateTime.parse('20240117T040000'));

  // 公历
  String _year = '';
  String _month = '';
  String _day = '';
  String _hour = '';
  String _minute = '';
  String _week = '';
  // 农历年月日
  String _xingzuo = '';
  String _cyear = '';
  String _cmonth = '';
  String _cday = '';
  String _shengxiao = '';
  // 四柱 对应的 干和支
  String _yearGanZhi = '';
  String _monthGanZhi = '';
  String _dayGanZhi = '';
  String _hourGanZhi = '';
  // 四柱 对应的 干或支
  String _yearGan = '';
  String _yearZhi = '';
  String _monthGan = '';
  String _monthZhi = '';
  String _dayGan = '';
  String _dayZhi = '';
  String _hourGan = '';
  String _hourZhi = '';
  //  节气
  String _prevJieQi = '';
  String _prevJieQiDate = '';
  String _nextJieQi = '';
  String _nextJieQiDate = '';
  // 四柱 干支 五行对应的颜色
  late Color _yearGanColor;
  late Color _yearZhiColor;
  late Color _monthGanColor;
  late Color _monthZhiColor;
  late Color _dayGanColor;
  late Color _dayZhiColor;
  late Color _hourGanColor;
  late Color _hourZhiColor;
  late Icon? _shengxiaoIcon;

  // 计算
  MyLunar.computeTheDay(DateTime dateTime) {
    Lunar date = Lunar.fromDate(dateTime);
    // 公历
    _year = dateTime.year.toString();
    _month = dateTime.month.toString();
    _day = dateTime.day.toString();
    _hour = dateTime.hour.toString();
    _minute = dateTime.minute.toString();
    _week = weekChinese[dateTime.weekday]!; //date.getWeekInChinese();
    // 星座
    _xingzuo = date.getSolar().getXingZuo();
    // 农历
    _cyear = date.getYearInChinese();
    _cmonth = date.getMonthInChinese();
    _cday = date.getDayInChinese();
    // 生肖
    _shengxiao = date.getYearShengXiao();
    // 四柱 对应的 干和支
    _yearGanZhi = date.getYearInGanZhi();
    _monthGanZhi = date.getMonthInGanZhi();
    _dayGanZhi = date.getDayInGanZhi();
    _hourGanZhi = date.getTimeInGanZhi();
    // 四柱 对应的 干或支
    _yearGan = date.getYearGan();
    _yearZhi = date.getYearZhi();
    _monthGan = date.getMonthGan();
    _monthZhi = date.getMonthZhi();
    _dayGan = date.getDayGan();
    _dayZhi = date.getDayZhi();
    _hourGan = date.getTimeGan();
    _hourZhi = date.getTimeZhi();
    // 四柱 干支 五行对应的颜色
    _yearGanColor = wuXingColor[wuXingGan[_yearGan]]!;
    _yearZhiColor = wuXingColor[wuXingZhi[_yearZhi]]!;
    _monthGanColor = wuXingColor[wuXingGan[_monthGan]]!;
    _monthZhiColor = wuXingColor[wuXingZhi[_monthZhi]]!;
    _dayGanColor = wuXingColor[wuXingGan[_dayGan]]!;
    _dayZhiColor = wuXingColor[wuXingZhi[_dayZhi]]!;
    _hourGanColor = wuXingColor[wuXingGan[_hourGan]]!;
    _hourZhiColor = wuXingColor[wuXingZhi[_hourZhi]]!;
    // 节气
    _prevJieQi = date.getPrevJie(true).toString();
    _prevJieQiDate = date.getPrevJie(true).getSolar().toString();
    _nextJieQi = date.getNextJie(true).toString();
    _nextJieQiDate = date.getNextJie(true).getSolar().toString();
    // 生肖图标
    _shengxiaoIcon = shengXiaoIcon[_yearZhi];
  }

  // 公历 年/月/日/时/分/星期/星座
  List<String> getGongLi() => [
        _year,
        _month,
        _day,
        _hour,
        _minute,
        _week,
        _xingzuo,
      ];

  // 农历 年/月/日/生肖
  List<String> getNongLi() => [
        _cyear,
        _cmonth,
        _cday,
        _shengxiao,
      ];

  // 四柱 对应的 天干和地支
  List<String> getGanAndZhi() => [
    _yearGanZhi,
    _monthGanZhi,
    _dayGanZhi,
    _hourGanZhi,
  ];

  // 四柱 对应的 天干/地支
  List<String> getGanOrZhi() => [
        _yearGan,
        _yearZhi,
        _monthGan,
        _monthZhi,
        _dayGan,
        _dayZhi,
        _hourGan,
        _hourZhi
      ];

  // 四柱干支 五行的颜色
  List<Color> getWuXingColor() => [
        _yearGanColor,
        _yearZhiColor,
        _monthGanColor,
        _monthZhiColor,
        _dayGanColor,
        _dayZhiColor,
        _hourGanColor,
        _hourZhiColor,
      ];

  // 生肖图标
  Icon? getShengXiaoIcon() => _shengxiaoIcon;

  // 节气
  List<String> getJieQi() => [
        _prevJieQi,
        _prevJieQiDate,
        _nextJieQi,
        _nextJieQiDate,
      ];
}
