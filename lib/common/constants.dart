// 定义一些常量

import 'package:flutter/material.dart';

import 'package:bazi/components/city_pickers-1.3.0/lib/modal/result.dart';
import 'package:bazi/common/classPersonData.dart';

/// 应用名称
const String appName = '卜算子';


/// 主题颜色/设置页面
enum ColorSeed {
  baseColor('鸢尾紫', Color(0xff6750a4)),
  blue('太空蓝', Colors.indigo),
  green('碧玉青', Colors.teal),
  pink('珊瑚橙', Colors.deepOrange);

  const ColorSeed(this.label, this.color);

  final String label;
  final Color color;
}

// 根据选项改变翻面日期时间的类型/万年历页面
enum ChangeDateType {
  year('年', Icon(Icons.calendar_today_outlined, color: Color(0xF1E16969))),
  month('月', Icon(Icons.calendar_month_outlined, color: Color(0xF1E16969))),
  day('日', Icon(Icons.calendar_view_day_outlined, color: Color(0xF1E16969))),
  hour('小时', Icon(Icons.access_time_outlined, color: Color(0xF1E16969))),
  week('周', Icon(Icons.calendar_view_week_outlined, color: Color(0xF1E16969))),
  lunarYear('农历年', Icon(Icons.calendar_today, color: Color(0xBE3290D7))),
  lunarMonth('农历月', Icon(Icons.calendar_month, color: Color(0xBE3290D7))),
  lunarHour('时辰', Icon(Icons.access_time_filled, color: Color(0xBE3290D7))),
  lunarJieQi('节气', Icon(Icons.contrast, color: Color(0xBE3290D7)));

  // 后续可考虑加入干支年、干支月两项
  const ChangeDateType(this.label, this.icon);
  final String label;
  final Icon icon;
}

// 五行编号：木火土金水01234
final Map<String, int> wuXing = {
  '木': 0,
  '火': 1,
  '土': 2,
  '金': 3,
  '水': 4,
};
// 天干 五行编号：木火土金水01234
final Map<String, int> wuXingGan = {
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
final Map<String, int> wuXingZhi = {
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
final Map<int, Color> wuXingColor = {
  // 木火土金水
  0: const Color(0xFF05891d),
  1: const Color(0xFFd30505),
  2: const Color(0xFF8b6d03),
  3: const Color(0xffe1a900),
  4: const Color(0xFF1560c5),
};

/// 人员信息排盘记录测试数据
List<PersonData> tempPersonDataList = [
  PersonData(
    id: '',
    name: '王一平',
    gender: 1,
    birthday: '19760824112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '王二平',
    gender: 2,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 0,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '王三平',
    gender: 1,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 0,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '张二平',
    gender: 1,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 0,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '张三平平',
    gender: 2,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '刘大年',
    gender: 1,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '刘一年',
    gender: 1,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '刘二年',
    gender: 2,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '刘三年',
    gender: 1,
    birthday: '20040512112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '郭大饼',
    gender: 2,
    birthday: '19770512112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '杨二饼',
    gender: 2,
    birthday: '19770512112233',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  ),
  PersonData(
    id: '',
    name: '杨一饼',
    gender: 1,
    birthday: '19820410112233',
    birthLocation: Result(
        provinceName: "黑龙江省",
        provinceId: "230000",
        cityName: "哈尔滨市",
        cityId: "230100",
        areaName: "平房区",
        areaId: "230108"),
    solarOrLunar: 1,
    leapMonth: false,
  ),
];
