import 'package:flutter/material.dart';
import 'package:bazi/components/iconfont.dart';

import 'package:bazi/components/city_pickers-1.3.0/lib/modal/result.dart';
import 'package:bazi/components/city_pickers-1.3.0/lib/meta/province.dart';

// 计算真太阳时
import 'package:bazi/common/paipan.dart';
import 'package:bazi/common/classPersonData.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';

import '../../common/shen_sha_static.dart';

// 自定义类，用于返回查询lunar返回的数据内容及格式
class MyLunar {
  static final List<List<String>> wuXingWangShuai = [
    ['金', '木', '水', '火', '土'],
    /*金*/
    ['旺', '死', '相', '囚', '休'],
    /*木*/
    ['囚', '旺', '休', '相', '死'],
    /*水*/
    ['休', '相', '旺', '死', '囚'],
    /*火*/
    ['死', '休', '囚', '旺', '相'],
    /*土*/
    ['相', '囚', '死', '休', '旺'],
  ];
  // 五行编号：木火土金水01234
  static final Map<String, int> wuXing = {
    '木': 0,
    '火': 1,
    '土': 2,
    '金': 3,
    '水': 4,
  };
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
    0: const Color(0xFF05891d),
    1: const Color(0xFFd30505),
    2: const Color(0xFF8b6d03),
    3: const Color(0xffecb400),
    4: const Color(0xFF1560c5),
  };

  // 根据天干值获取对应的颜色
  Color getColorForValue(String value) {
    int wuXingIndex = wuXingGan[value] ?? 0; // 从 wuXingGan 中获取天干值对应的五行编号
    return wuXingColor[wuXingIndex] ?? Colors.black; // 从 wuXingColor 中获取对应的颜色，如果未找到，默认返回黑色
  }

  // 根据纳音最后一个值获取对应的颜色
  Color getColorForNaYinValue(String value) {
    if (value.isEmpty) {
      return Colors.black;
    }
    String lastCharacter = value.substring(value.length - 1);
    int wuXingIndex = wuXing[lastCharacter] ?? 0; // 从 wuXing 中获取天干值对应的五行编号
    return wuXingColor[wuXingIndex] ?? Colors.black; // 从 wuXingColor 中获取对应的颜色，如果未找到，默认返回黑色
  }

  // 地支对应的生肖图标
  static final Map<String, Icon> shengXiaoIcon = {
    // 子丑寅卯辰巳午未申酉戌亥
    '寅': Icon(TaiJiIconFont.huxiao, color: wuXingColor[0], size: 40),
    '卯': Icon(TaiJiIconFont.tuxiao, color: wuXingColor[0], size: 40),
    '巳': Icon(TaiJiIconFont.shexiao, color: wuXingColor[1], size: 40),
    '午': Icon(TaiJiIconFont.maxiao, color: wuXingColor[1], size: 40),
    '辰': Icon(TaiJiIconFont.longxiao, color: wuXingColor[2], size: 40),
    '丑': Icon(TaiJiIconFont.niuxiao, color: wuXingColor[2], size: 40),
    '戌': Icon(TaiJiIconFont.gouxiao, color: wuXingColor[2], size: 40),
    '未': Icon(TaiJiIconFont.yangxiao, color: wuXingColor[2], size: 40),
    '申': Icon(TaiJiIconFont.houxiao, color: wuXingColor[3], size: 40),
    '酉': Icon(TaiJiIconFont.jixiao, color: wuXingColor[3], size: 40),
    '亥': Icon(TaiJiIconFont.zhuxiao, color: wuXingColor[4], size: 40),
    '子': Icon(TaiJiIconFont.shuxiao, color: wuXingColor[4], size: 40),
  };

  // 星期数字123 转 星期一二三
  static final Map<int, String> weekChinese = {
    1: '一',
    2: '二',
    3: '三',
    4: '四',
    5: '五',
    6: '六',
    7: '日',
  };

  final DateTime _now = DateTime.now();
  // Lunar date = Lunar.fromDate(DateTime.now());
  // Lunar date = Lunar.fromDate(DateTime.parse('20240117T040000'));
  late DateTime _dateTime;
  late Solar _solar;
  late Lunar _lunar;
  late EightChar _bazi;
  late Yun _yun;
  late List<DaYun> _daYun;
  // 录入的生日信息
  late int _inputYear;
  late int _inputMonth;
  late int _inputDay;
  late int _inputHour;
  late int _inputMinute;
  late int _inputSecond;
  // 公历
  // String _year = '';
  late int _year;
  late int _month;
  late int _day;
  late int _hour;
  late int _minute;
  late int _second;
  String _week = '';
  String _xingZuo = '';
  // 农历年月日
  String _cYear = '';
  String _cMonth = '';
  String _cDay = '';
  String _cHour = '';
  String _shengxiao = '';
  // 四柱 对应的 干支
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
  int _afterJieDays = 0;
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
  // 顾客信息
  // gender(数字)为性别，1为男，0为女
  int _gender = 1;
  // 出生辰期时间字符串，如19760820112233
  String _birthday = '';
  // 出生地
  late Result _birthLocation;
  // 省、市、县三级代码
  late String? _provinceId;
  late String? _cityId;
  late String? _areaId;
  //solarOrLunar(数字)为所用历法，1为阳历，0为阴历
  int _solarOrLunar = 1;
  // leapMonth农历某年月有闫月，false 为选前面的 某月，或认为不存在闫月，true为有闫月且选后面的 闫某月，为true时month取负
  bool _leapMonth = false;
  // 命盘解析流派设置
  // late int _selectedZiShiPai; // 初始默认子时流派2
  // late int _selectedQiYunPai; // 初始默认起运流派2

  /// 继承MyLunar.getAll方法，仅获取生辰信息，用于排盘记录列表显示
  MyLunar.getBirthday(PersonData person) : this.getAll(person, 1, 2);

  /// 计算从 bazi_info_page.dart传递过来的信息
  /// late PersonData personData;
  MyLunar.getAll(PersonData person, int selectedZiShiPai, int selectedQiYunPai) {
    // print('getAll ${selectedZiShiPai}');
    // print('getAll ${selectedQiYunPai}');
    // 获取person各项信息
    _gender = person.gender;
    _birthday = person.birthday;
    _birthLocation = person.birthLocation;
    _solarOrLunar = person.solarOrLunar;
    _leapMonth = person.leapMonth;
    // _selectedZiShiPai = person.ziShiPai!;
    // _selectedQiYunPai = person.qiYunPai!;

    // 出生地信息省市县三级ID
    _provinceId = _birthLocation.provinceId;
    _cityId = _birthLocation.cityId;
    _areaId = _birthLocation.areaId;

    // 分解录入的生日信息各位数
    _inputYear = int.parse(_birthday.substring(0, 4));
    _inputMonth = int.parse(_birthday.substring(4, 6));
    _inputDay = int.parse(_birthday.substring(6, 8));
    _inputHour = int.parse(_birthday.substring(8, 10));
    _inputMinute = int.parse(_birthday.substring(10, 12));
    _inputSecond = int.parse(_birthday.substring(12, 14));

    // 计算出公历的日期
    // 如果输入的是公历生日
    if (_solarOrLunar == 1) {
      // 直接赋值给公历日期年月日时分秒
      _year = _inputYear;
      _month = _inputMonth;
      _day = _inputDay;
      _hour = _inputHour;
      _minute = _inputMinute;
      _second = _inputSecond;
    } else {
      // 如果输入的是农历// 农历转换为公历日期
      // 如果是农历闫月，month取负
      if (_leapMonth) {
        _solar = Lunar.fromYmdHms(_inputYear, -_inputMonth, _inputDay, _inputHour, _inputMinute, _inputSecond).getSolar();
      } else {
        // 如果是农历 非闫月，month取正
        _solar = Lunar.fromYmdHms(_inputYear, _inputMonth, _inputDay, _inputHour, _inputMinute, _inputSecond).getSolar();
      }
      // 转换后赋值给公历日期年月日时分秒
      _year = _solar.getYear();
      _month = _solar.getMonth();
      _day = _solar.getDay();
      _hour = _solar.getHour();
      _minute = _solar.getMinute();
      _second = _solar.getSecond();
    }
    // 如果选择了出生地，则计算出公历的真太阳时
    if (_provinceId != null && _provinceId != '') {
      // print(_provinceId);
      // 获取出生地经度、纬度
      var lon = double.parse(citiesData[_cityId][_areaId]['lon']);
      var lat = double.parse(citiesData[_cityId][_areaId]['lat']);
      // 初始化类PaiPan()
      var pp = PaiPan();
      // 计算标准时间的儒略日
      var julianDay = pp.Jdays(_year, _month, _day, _hour, _minute, _second);
      // 计算当地的儒略日
      var locationJulianday = pp.zty(julianDay!, lon, lat);
      // 计算真太阳时
      var realSolarTime = pp.Jtime(locationJulianday);
      // 转换后赋值给公历日期年月日时分秒
      _year = realSolarTime[0];
      _month = realSolarTime[1];
      _day = realSolarTime[2];
      _hour = realSolarTime[3];
      _minute = realSolarTime[4];
      _second = realSolarTime[5];
    }
    // 将以上获得的公历日期组合为公历日期类型
    _dateTime = DateTime(_year, _month, _day, _hour, _minute, _second);
    // print(_dateTime);
    // 在_dateTime的基础上进行八字解析
    // 公历
    _year = _dateTime.year;
    _month = _dateTime.month;
    _day = _dateTime.day;
    _hour = _dateTime.hour;
    _minute = _dateTime.minute;
    _week = weekChinese[_dateTime.weekday]!; //date.getWeekInChinese(); -'五'

    // 农历
    _lunar = Lunar.fromDate(_dateTime);
    _solar = Solar.fromDate(_dateTime);
    // _cYMD = _lunar.toString();
    _cYear = _lunar.getYearInChinese();
    _cMonth = _lunar.getMonthInChinese();
    _cDay = _lunar.getDayInChinese();
    _cHour = _lunar.getTimeZhi();
    // 生肖 （以正月初一起getYearShengXiao）（以立春当天起getYearShengXiaoByLiChun）（以立春交接时刻起）
    _shengxiao = _lunar.getYearShengXiaoExact();
    // 星座
    _xingZuo = _solar.getXingZuo();

    // 八字相关信息，大运等
    _bazi = _lunar.getEightChar();
    _bazi.setSect(selectedZiShiPai);
    _yun = _bazi.getYun(_gender, selectedQiYunPai);
    _daYun = _yun.getDaYun();

    // 四柱 对应的 干支 应采用八字的方法获取
    _yearGan = _bazi.getYearGan();
    _yearZhi = _bazi.getYearZhi();
    _monthGan = _bazi.getMonthGan();
    _monthZhi = _bazi.getMonthZhi();
    _dayGan = _bazi.getDayGan();
    _dayZhi = _bazi.getDayZhi();
    _hourGan = _bazi.getTimeGan();
    _hourZhi = _bazi.getTimeZhi();
    // 四柱 干支 五行对应的颜色
    // _yearGanColor = WU_XING_COLOR[WU_XING_GAN[date.getYearGan()]]!;
    _yearGanColor = wuXingColor[wuXingGan[_yearGan]]!;
    _yearZhiColor = wuXingColor[wuXingZhi[_yearZhi]]!;
    _monthGanColor = wuXingColor[wuXingGan[_monthGan]]!;
    _monthZhiColor = wuXingColor[wuXingZhi[_monthZhi]]!;
    _dayGanColor = wuXingColor[wuXingGan[_dayGan]]!;
    _dayZhiColor = wuXingColor[wuXingZhi[_dayZhi]]!;
    _hourGanColor = wuXingColor[wuXingGan[_hourGan]]!;
    _hourZhiColor = wuXingColor[wuXingZhi[_hourZhi]]!;
    // 节气
    _prevJieQi = _lunar.getPrevJie().toString();
    _prevJieQiDate = _lunar.getPrevJie().getSolar().toString();
    _nextJieQi = _lunar.getNextJie().toString();
    _nextJieQiDate = _lunar.getNextJie().getSolar().toString();
    // 节后多少天出生
    _afterJieDays = _solar.subtract(_lunar.getPrevJie().getSolar()).abs();
    // 生肖图标
    _shengxiaoIcon = shengXiaoIcon[_yearZhi];

    // _daYun = _yun.getDaYun()[0].getGanZhi();LunarUtil.NAYIN[getYear()]
    // _yun.getDaYun()[1].getLiuNian()[2].getLiuYue()[0].getMonthInChinese();
  }

  /// 仅获取生辰信息，用于排盘记录列表显示
  Map<String, dynamic> infoForRecord() {
    return {
      // 公历
      'solar': '$_year年$_month月$_day日',
      // 农历年月日
      'lunar': '$_cYear年$_cMonth月$_cDay',
      'bazi': '$_bazi',
      'age': getAge(),
    };
  }

  /// 所有的八字结果，放在这个MAP里面
  Map<String, dynamic> rt() {
    return {
      // 公历: 不加$_minute分、$_second秒
      'solar': '$_year年$_month月$_day日 $_hour时$_minute分$_second秒 星期$_week',
      // 农历:年月日，_cDay后面不加'日'
      'lunar': '$_cYear年$_cMonth月$_cDay $_cHour时 (属$_shengxiao)',
      'age': getAge(),
      'xingZuo': _xingZuo,
      'prevJieQi': _prevJieQi,
      'afterJieDays': _afterJieDays,
      // 十神-干-主星
      'yearShiShenGan': _bazi.getYearShiShenGan(),
      'monthShiShenGan': _bazi.getMonthShiShenGan(),
      // 'dayShiShenGan': _bazi.getDayShiShenGan(),
      // 'dayShiShenGan': _gender == 1 ? '元男' : '元女',
      'timeShiShenGan': _bazi.getTimeShiShenGan(),
      // 'daYunShiShenGan': LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[0].getGanZhi().substring(0,1)],
      // 十神-支-藏干 结果是列表
      'yearHideGan': _bazi.getYearHideGan(),
      'monthHideGan': _bazi.getMonthHideGan(),
      'dayHideGan': _bazi.getDayHideGan(),
      'timeHideGan': _bazi.getTimeHideGan(),
      //十神-支-副星 结果是列表
      'yearShiShenZhi': _bazi.getYearShiShenZhi(),
      'monthShiShenZhi': _bazi.getMonthShiShenZhi(),
      'dayShiShenZhi': _bazi.getDayShiShenZhi(),
      'timeShiShenZhi': _bazi.getTimeShiShenZhi(),
      // 在EightChar八字对象中获取旬空(空亡)：
      'yearXunKong': _bazi.getYearXunKong(),
      'monthXunKong': _bazi.getMonthXunKong(),
      'dayXunKong': _bazi.getDayXunKong(),
      'timeXunKong': _bazi.getTimeXunKong(),
      // 'daYun': computeEightChar(_lunar, _solar, _gender),
      // 纳音、地势、自坐
      'naYin': [_bazi.getYearNaYin(), _bazi.getMonthNaYin(), _bazi.getDayNaYin(), _bazi.getTimeNaYin()],
      'diShi': [_bazi.getYearDiShi(), _bazi.getMonthDiShi(), _bazi.getDayDiShi(), _bazi.getTimeDiShi()],
      'ziZuo': [_bazi.getYearZiZuo(), _bazi.getMonthZiZuo(), _bazi.getDayZiZuo(), _bazi.getTimeZiZuo()],
      'sanHuan': [_bazi.getTaiYuan(), _bazi.getMingGong(), _bazi.getShenGong(), _bazi.getTaiXi()],
      'sanHuanNaYin': [_bazi.getTaiYuanNaYin(), _bazi.getMingGongNaYin(), _bazi.getShenGongNaYin(), _bazi.getTaiXiNaYin()],
      // 'shenSha': _bazi.getShenSha(),
      'shenSha': getShenSha(),
      'qiYun': getQiYunText(),
      'wxWangShuai': getWxData(_bazi.getMonthZhi()),
      'jiaoYun': getJiaoYunText(),
      // '出生后${_yun.getStartYear()}年${_yun.getStartMonth()}个月${_yun.getStartDay()}天${_yun.getStartHour()}小时 (${_yun.getStartSolar()})',
      // 如果起运小于1年，即当年起运，则大运列表第1组元素错，应删除
      // 如19860907T112200,daYun[0].getStartYear()=1986,daYun[0].getEndYear()=1985 ???1986>1985!!!
      'daYun': _daYun[0].getXiaoYun().isEmpty ? _daYun.removeAt(0) : _daYun,
      'getCurrentIndex': getCurrentIndex(),
      'isYYNN': isYYNN(),
    };
  }

  /// 获取大运
  DaYun daYun(int index) {
    return _daYun[index];
  }

  /// 获取流年
  LiuNian liuNian(int currentDaYunIndex, int index) {
    return _daYun[currentDaYunIndex].getLiuNian()[index];
  }

  /// 获取流月
  LiuYue liuYue(int currentDaYunIndex, int currentLiuYearIndex, int index) {
    return _daYun[currentDaYunIndex].getLiuNian()[currentLiuYearIndex].getLiuYue()[index];
  }

  /// 获取流日
  LiuRi liuRi(int currentDaYunIndex, int currentLiuYearIndex, int currentLiuMonthIndex, int index) {
    // if (index < 0) print('查bug获取流日index:$index');
    return _daYun[currentDaYunIndex].getLiuNian()[currentLiuYearIndex].getLiuYue()[currentLiuMonthIndex].getLiuRi()[index];
  }

  /// 获取流时，仅返回该流时时刻对应的干支，
  String liuShi(int currentDaYunIndex, int currentLiuYearIndex, int currentLiuMonthIndex, int currentLiuDayIndex, int index) {
    // if (index < 0) print('查bug获取流时index:$index');

    return _daYun[currentDaYunIndex]
        .getLiuNian()[currentLiuYearIndex]
        .getLiuYue()[currentLiuMonthIndex]
        .getLiuRi()[currentLiuDayIndex]
        .getLiuShi()[index];

    // if (index >= 0) {
    //   return _daYun[currentDaYunIndex]
    //       .getLiuNian()[currentLiuYearIndex]
    //       .getLiuYue()[currentLiuMonthIndex]
    //       .getLiuRi()[currentLiuDayIndex]
    //       .getLiuShi()[index];
    // } else {
    //   return '';
    // }
  }

  /// 是否有神煞，以一查四则四柱都可能有的神煞
  /// [whichPillar]四柱0-3，[whichRule]神煞的拼音取其判断规则，[condition]条件干支，[equivalent]对应干支
  bool hasShenShaFourPillar(int whichPillar, String whichRule, String condition, String equivalent) {
    bool conditionsMet = false;
    List<String> conditionsList = (shenShaRules[whichRule]?['conditionsList'] as List<String>);
    List<String> equivalentList = (shenShaRules[whichRule]?['equivalentList'] as List<String>);
    // //大耗（元辰）阳男阴女,阴男阳女的基准条件相同，但对应条件不同
    if (whichRule == 'daHao' && '阴男阳女'.contains(isYYNN())) {
      equivalentList = (shenShaRules[whichRule]?['equivalentList1'] as List<String>);
    }

    // 条件干支
    String conditionGetMethod = '';
    switch (condition) {
      case 'riGan':
        conditionGetMethod = _bazi.getDayGan();
      case 'riZhi':
        conditionGetMethod = _bazi.getDayZhi();
      case 'yueGan':
        conditionGetMethod = _bazi.getMonthGan();
      case 'yueZhi':
        conditionGetMethod = _bazi.getMonthZhi();
      case 'nianGan':
        conditionGetMethod = _bazi.getYearGan();
      case 'nianZhi':
        conditionGetMethod = _bazi.getYearZhi();
    }
    // 对应干支
    List<String> equivalentGetMethods = [];
    switch (equivalent) {
      case 'tianGan':
        equivalentGetMethods = [_bazi.getYearGan(), _bazi.getMonthGan(), _bazi.getDayGan(), _bazi.getTimeGan()];
      case 'diZhi':
        equivalentGetMethods = [_bazi.getYearZhi(), _bazi.getMonthZhi(), _bazi.getDayZhi(), _bazi.getTimeZhi()];
      case 'ganZhi':
        equivalentGetMethods = [_bazi.getYear(), _bazi.getMonth(), _bazi.getDay(), _bazi.getTime()];
    }
    // 日干在条件列表conditionsList中的索引a，与以下四柱地支在equivalentList中的索引b相等时，有此贵人
    int a = conditionsList.indexWhere((element) => element.contains(conditionGetMethod));
    if (a >= 0) {
      switch (whichPillar) {
        case 0:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[0]));
          conditionsMet = a == b;
        case 1:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[1]));
          conditionsMet = a == b;
        case 2:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[2]));
          conditionsMet = a == b;
        case 3:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[3]));
          conditionsMet = a == b;
      }
    }
    return conditionsMet;
  }

  /// 是否有神煞，以一查三则三柱都可能有的神煞
  /// [whichPillar]四柱0-3，[whichRule]神煞的拼音取其判断规则，[condition]条件干支，[equivalent]对应干支
  bool hasShenShaThreePillar(int whichPillar, String whichRule, String condition, String equivalent) {
    bool conditionsMet = false;
    List<String> conditionsList = (shenShaRules[whichRule]?['conditionsList'] as List<String>);
    List<String> equivalentList = (shenShaRules[whichRule]?['equivalentList'] as List<String>);
    // 条件干支
    String conditionGetMethod = '';
    // 对应干支
    List<String> equivalentGetMethods = [];
    switch (condition) {
      case 'riZhi':
        conditionGetMethod = _bazi.getDayZhi();
        switch (equivalent) {
          case '3Zhi': // 以一支查其余三支，本支置为字符串null'以排除本支
            equivalentGetMethods = [_bazi.getYearZhi(), _bazi.getMonthZhi(), 'null', _bazi.getTimeZhi()];
        }
      case 'yueZhi':
        conditionGetMethod = _bazi.getMonthZhi();
        switch (equivalent) {
          case '3Zhi':
            equivalentGetMethods = [_bazi.getYearZhi(), 'null', _bazi.getDayZhi(), _bazi.getTimeZhi()];
          case 'riGanZhi': // 四废日
            equivalentGetMethods = ['null', 'null', _bazi.getDay(), 'null'];
        }
      case 'nianZhi':
        conditionGetMethod = _bazi.getYearZhi();
        switch (equivalent) {
          case '3Zhi':
            equivalentGetMethods = ['null', _bazi.getMonthZhi(), _bazi.getDayZhi(), _bazi.getTimeZhi()];
        }
      case 'riKongWang': // 空亡
        // 把条件列表、比对列表、条件值都设置为日旬空getDayXunKong()，则a=0，然后判断b值即其余各支是否包含在日旬空中
        conditionsList = [_bazi.getDayXunKong()];
        equivalentList = [_bazi.getDayXunKong()];
        conditionGetMethod = _bazi.getDayXunKong();
        equivalentGetMethods = [_bazi.getYearZhi(), _bazi.getMonthZhi(), 'null', _bazi.getTimeZhi()];
      case 'nianKongWang': // 空亡
        conditionsList = [_bazi.getYearXunKong()];
        equivalentList = [_bazi.getYearXunKong()];
        conditionGetMethod = _bazi.getYearXunKong();
        equivalentGetMethods = ['null', _bazi.getMonthZhi(), _bazi.getDayZhi(), _bazi.getTimeZhi()];
    }
    // 日干在条件列表conditionsList中的索引a，与以下四柱地支在equivalentList中的索引b相等时，有此贵人
    // 当不存在时，a=-1
    int a = conditionsList.indexWhere((element) => element.contains(conditionGetMethod));
    if (a >= 0) {
      switch (whichPillar) {
        case 0:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[0]));
          conditionsMet = a == b;
        case 1:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[1]));
          conditionsMet = a == b;
        case 2:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[2]));
          conditionsMet = a == b;
        case 3:
          int b = equivalentList.indexWhere((element) => element.contains(equivalentGetMethods[3]));
          conditionsMet = a == b;
      }
    }
    return conditionsMet;
  }

  /// 仅单柱包含
  bool hasShenShaOnePillar(int pillarIndex, String whichRule, String condition) {
    bool conditionsMet = false;
    List<String> conditionsList = (shenShaRules[whichRule]?['conditionsList'] as List<String>);
    // 条件干支
    String conditionGetMethod = '';
    switch (condition) {
      case 'riGanZhi':
        conditionGetMethod = _bazi.getDay();
    }
    conditionsMet = conditionsList.indexWhere((element) => element.contains(conditionGetMethod)) >= 0;
    return conditionsMet;
  }

  /// 三奇贵人
  bool hasSanQiGuiRen() {
    bool conditionsMet = false;
    // 年月日时干
    String allGan = _bazi.getYearGan() + _bazi.getMonthGan() + _bazi.getDayGan() + _bazi.getTimeGan();
    List<String> conditionsList = (shenShaRules['sanQiGuiRen']?['conditionsList'] as List<String>);
    // 被测者年月日时干 包含 条件中的三个连续天干
    conditionsMet = conditionsList.indexWhere((element) => allGan.contains(element)) >= 0;
    return conditionsMet;
  }

  /// 统一获取神煞的方法
  List<List<String>> getShenSha() {
    // shenSha列表中含有4个子列表，分别存储四柱的神煞 yueZhi
    List<List<String>> tempShenSha = [[], [], [], []];
    List<List<String>> shenSha = [];
    // 根据神煞类型获取
    shenShaRules.forEach((key, value) {
      if (value['type'] == '4-Pillar') {
        for (int i = 0; i < 4; i++) {
          if (hasShenShaFourPillar(i, key, value['conditionsName'].toString(), value['equivalentName'].toString())) {
            tempShenSha[i].add(value['name'].toString());
          }
        }
      }
      if (value['type'] == '31-Pillar') {
        for (int i = 0; i < 4; i++) {
          if (hasShenShaThreePillar(i, key, value['conditionsName'].toString(), value['equivalentName'].toString())) {
            tempShenSha[i].add(value['name'].toString());
          }
        }
      }
      if (value['type'] == '10-Pillar') {
        int pillarIndex = int.parse(value['pillarIndex'].toString());
        if (hasShenShaOnePillar(pillarIndex, key, value['conditionsName'].toString())) {
          tempShenSha[pillarIndex].add(value['name'].toString());
        }
      }
      if (value['type'] == 'sanQiGuiRen') {
        if (hasSanQiGuiRen()) {
          tempShenSha[2].add(value['name'].toString()); // 在日柱神煞中添加三奇贵人
        }
      }
    });

    // 各柱神煞去重;
    for (var element in tempShenSha) {
      final uniqueElement = element.toSet().toList();
      shenSha.add(uniqueElement);
    }
    return shenSha;
  }

  /// 判断是阳男阴女，还是阴男阳女
  String isYYNN() {
    String isYY = '';
    String isNN = '';
    if (['甲', '丙', '戊', '庚', '壬'].contains(_bazi.getYearGan())) {
      isYY = '阳';
    } else {
      isYY = '阴';
    }
    if (_gender == 1) {
      isNN = '男';
    } else {
      isNN = '女';
    }
    return '$isYY$isNN';
  }

  /// 获取八字即10天干12地支的五行
  String wxForBz(item) {
    String wx = '';
    if (item == '甲' || item == '乙' || item == '寅' || item == '卯') {
      wx = '木';
    }
    if (item == '丙' || item == '丁' || item == '巳' || item == '午') {
      wx = '火';
    }
    if (item == '戊' || item == '己' || item == '丑' || item == '辰' || item == '未' || item == '戌') {
      wx = '土';
    }
    if (item == '庚' || item == '辛' || item == '申' || item == '酉') {
      wx = '金';
    }
    if (item == '壬' || item == '癸' || item == '子' || item == '亥') {
      wx = '水';
    }
    return wx;
  }

  /// 获取五行旺相休囚死，程序中[zhi]用月支，实际任意八字都可以计算其五旺衰
  List<String> getWxData(zhi) {
    List<String> result = ['', '', '', '', ''];
    int yueIndex = 0;
    for (int i = 0; i < wuXingWangShuai[0].length; i++) {
      if (wuXingWangShuai[0][i] == wxForBz(zhi)) {
        yueIndex = i + 1;
        break;
      }
    }

    List<String> wxAttr = wuXingWangShuai[yueIndex];
    const List<String> wx = ['旺', '相', '休', '囚', '死'];
    List<String> tmpwx = ['', '', '', '', ''];
    tmpwx[0] = '金${wxAttr[0]}';
    tmpwx[1] = '木${wxAttr[1]}';
    tmpwx[2] = '水${wxAttr[2]}';
    tmpwx[3] = '火${wxAttr[3]}';
    tmpwx[4] = '土${wxAttr[4]}';

    for (int i = 0; i < wx.length; i++) {
      for (int j = 0; j < tmpwx.length; j++) {
        if (tmpwx[j].substring(1, 2) == wx[i]) {
          result[i] = tmpwx[j];
          break;
        }
      }
    }
    return result;
  }

  /// 获取交运时间
  String getJiaoYunText() {
    // 起运年干，即交运年干
    final startYearGan = _daYun[1].getLiuNian()[0].getGanZhi()[0];
    // final startSolarMonth = _yun.getStartSolar().getMonth();
    // final startSolarDay = _yun.getStartSolar().getDay();
    JieQi prev = _yun.getStartSolar().getLunar().getPrevJie();
    // JieQi next = _yun.getStartSolar().getLunar().getNextJie();
    int prevDay = prev.getSolar().subtract(_yun.getStartSolar());
    // int nextDay = next.getSolar().subtract(_yun.getStartSolar());

    return '逢$startYearGan年${prev}后${prevDay.abs()}天交脱大运';
    // if('阳男阴女'.contains(isYYNN())){
    //   return '   每逢$startYearGan年${prev}后${prevDay.abs()}天交脱大运';
    // }else{
    //   return '   每逢$startYearGan年${prev}后${prevDay.abs()}天交脱大运';
    // }
    // return '   每逢$startYearGan年$startSolarMonth月$startSolarDay日前后交脱大运';
  }

  /// 获取起运时间
  String getQiYunText() {
    final startYear = _yun.getStartYear();
    final startMonth = _yun.getStartMonth();
    final startDay = _yun.getStartDay();
    final startHour = _yun.getStartHour();
    final startSolar = _yun.getStartSolar();
    // 使用 qiYunText 变量进行显示或其他操作
    String qiYunText = '出生后';
    if (startYear != 0) {
      qiYunText += '$startYear年';
    }
    if (startMonth != 0) {
      qiYunText += '$startMonth个月';
    }
    if (startDay != 0) {
      qiYunText += '$startDay天';
    }
    if (startHour != 0) {
      qiYunText += '$startHour小时';
    }
    // 起运具体公历日期
    // qiYunText += '起运';
    qiYunText += '【$startSolar】';

    return qiYunText;
  }

  /// @return 初始大运、流年索引所在位置，如果当前年在大运流年表中，则置为当前显示年
  List<int> getCurrentIndex() {
    int daYunIndex;
    int liuYearIndex;
    int liuMonthIndex;
    int liuDayIndex;
    // 当前年在大运列表中的起止年范围内，如果在则daYunIndex>=0,否则daYunIndex=-1
    daYunIndex = _daYun.indexWhere((element) => element.getStartYear() <= _now.year && element.getEndYear() >= _now.year);
    // 如果在，则获取当前年在流年中的索引
    if (daYunIndex >= 0) {
      liuYearIndex = _daYun[daYunIndex].getLiuNian().indexWhere((element) => element.getYear() == _now.year);
      liuMonthIndex = _daYun[daYunIndex]
          .getLiuNian()[liuYearIndex]
          .getLiuYue()
          .indexWhere((element) => element.getStartDate().isBefore(Solar.fromDate(_now)) && element.getEndDate().isAfter(Solar.fromDate(_now)));
      liuDayIndex = _daYun[daYunIndex]
          .getLiuNian()[liuYearIndex]
          .getLiuYue()[liuMonthIndex]
          .getLiuRi()
          .indexWhere((element) => element.getDateMonth() == '${_now.month}' && element.getDateDay() == '${_now.day}');
    } else {
      // 如果不存在，则显示大运索引为1的即大运列表中的第2列，流年索引为0的。因为大运列表中的第1列为小运，其个数可能=0或小于10，会显示有空表格
      daYunIndex = 1;
      liuYearIndex = 0;
      liuMonthIndex = 0;
      liuDayIndex = 0;
    }
    return [daYunIndex, liuYearIndex, liuMonthIndex, liuDayIndex];
  }

  /// @return 农历出生月在一年中的索引,大运、流年选择时，若是出生年，则默认选择月应等于出生月
  int getLiuYueIndex() {
    // print(_lunar.getMonthInChinese());
    // print(LunarUtil.MONTH.indexOf(_lunar.getMonthInChinese()));
    return LunarUtil.MONTH.indexOf(_lunar.getMonthInChinese());
  }

  /// @return 农历出生日在出生月中的索引,大运、流年、流月选择时，若是出生年月，则默认选择日应等于出生日
  int getLiuDayIndex() {
    return LunarUtil.DAY.indexOf(_lunar.getDayInChinese());
  }

  /// @return 农历出生时在出生日中的索引,大运、流年、流月、流日选择时，若是出生年月日，则默认选择时应等于出生时
  // int getLiuHourIndex(){
  //   return _lunar.getTimes().indexOf(_lunar.getTimeInGanZhi() as LunarTime);
  // }
  ///大运纳音
  String? getDaYunNaYin(int index) {
    if (index > 0) {
      return LunarUtil.NAYIN[_daYun[index].getGanZhi()];
    } else {
      return '';
    }
  }

  ///大运地势LunarUtil.ZHI[_yearZhiIndexExact + 1]
  String? getDaYunDiShi(int index) {
    if (_daYun[index].getGanZhi()[1].isEmpty) {
      return '';
    }
    if (LunarUtil.CHANG_SHENG_OFFSET[_daYun[index].getGanZhi()[1]] != null) {
      return LunarUtil.CHANG_SHENG[LunarUtil.CHANG_SHENG_OFFSET[_daYun[index].getGanZhi()[1]]!];
    } else {
      return '';
    }
  }

  /// 流年十神
  String? getLiuNianShiShen(daYunIndex, liuNianIndex) {
    return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[daYunIndex].getLiuNian()[liuNianIndex].getGanZhi().substring(0, 1)];
  }

  ///流年十神支--藏干
  List<String> getLiuNianShiShenHideGan(daYunIndex, liuNianIndex) {
    var dZhi = _daYun[daYunIndex].getLiuNian()[liuNianIndex].getGanZhi().substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuNianShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuNianShiShenHideGan.add(dHideGan[x]);
    }
    return liuNianShiShenHideGan;
  }

  ///流年十神支 --副星
  List<String> getLiuNianShiShenZhi(daYunIndex, liuNianIndex) {
    var dZhi = _daYun[daYunIndex].getLiuNian()[liuNianIndex].getGanZhi().substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuNianShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuNianShiShenHideGan.add('${LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + dHideGan[x]]}');
    }
    return liuNianShiShenHideGan;
  }

  /// 流月十神
  String? getLiuYueShiShen(daYunIndex, liuNianIndex, liuYueIndex) {
    return LunarUtil
        .SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[daYunIndex].getLiuNian()[liuNianIndex].getLiuYue()[liuYueIndex].getGanZhi().substring(0, 1)];
  }

  ///流月十神支--藏干
  List<String> getLiuYueShiShenHideGan(daYunIndex, liuNianIndex, liuYueIndex) {
    var dZhi = _daYun[daYunIndex].getLiuNian()[liuNianIndex].getLiuYue()[liuYueIndex].getGanZhi().substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuNianShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuNianShiShenHideGan.add(dHideGan[x]);
    }
    return liuNianShiShenHideGan;
  }

  ///流月十神支 --副星
  List<String> getLiuYueShiShenZhi(daYunIndex, liuNianIndex, liuYueIndex) {
    var dZhi = _daYun[daYunIndex].getLiuNian()[liuNianIndex].getLiuYue()[liuYueIndex].getGanZhi().substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuYueShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuYueShiShenHideGan.add('${LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + dHideGan[x]]}');
    }
    return liuYueShiShenHideGan;
  }

//
  /// 流日十神
  String? getLiuRiShiShen(daYunIndex, liuNianIndex, liuYueIndex, liuRiIndex) {
    var dZhi = getLiuRiDate(liuYueIndex, _daYun[daYunIndex].getLiuNian()[liuNianIndex].getYear().toString(), liuRiIndex)[2].substring(0, 1);
    return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + dZhi];
  }

  ///流日十神支--藏干
  List<String> getLiuRiShiShenHideGan(daYunIndex, liuNianIndex, liuYueIndex, liuRiIndex) {
    var dZhi = getLiuRiDate(liuYueIndex, _daYun[daYunIndex].getLiuNian()[liuNianIndex].getYear().toString(), liuRiIndex)[2].substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuRiShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuRiShiShenHideGan.add(dHideGan[x]);
    }
    return liuRiShiShenHideGan;
  }

  ///流日十神支 --副星
  List<String> getLiuRiShiShenZhi(daYunIndex, liuNianIndex, liuYueIndex, liuRiIndex) {
    var dZhi = getLiuRiDate(liuYueIndex, _daYun[daYunIndex].getLiuNian()[liuNianIndex].getYear().toString(), liuRiIndex)[2].substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuRiShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuRiShiShenHideGan.add('${LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + dHideGan[x]]}');
    }
    return liuRiShiShenHideGan;
  }

//
  /// 流时十神
  String? getLiuShiShiShen(daYunIndex, liuNianIndex, liuYueIndex, liuRiIndex, liuShiIndex) {
    var dZhi = getLiuShi(liuRiIndex, liuYueIndex, _daYun[daYunIndex].getLiuNian()[liuNianIndex].getYear().toString(), liuShiIndex)[0].substring(0, 1);
    return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + dZhi];
  }

  ///流时十神支--藏干
  List<String> getLiuShiShiShenHideGan(daYunIndex, liuNianIndex, liuYueIndex, liuRiIndex, liuShiIndex) {
    var dZhi = getLiuShi(liuRiIndex, liuYueIndex, _daYun[daYunIndex].getLiuNian()[liuNianIndex].getYear().toString(), liuShiIndex)[0].substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuShiShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuShiShiShenHideGan.add(dHideGan[x]);
    }
    return liuShiShiShenHideGan;
  }

  ///流时十神支 --副星
  List<String> getLiuShiShiShenZhi(daYunIndex, liuNianIndex, liuYueIndex, liuRiIndex, liuShiIndex) {
    var dZhi = getLiuShi(liuRiIndex, liuYueIndex, _daYun[daYunIndex].getLiuNian()[liuNianIndex].getYear().toString(), liuShiIndex)[0].substring(1);
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> liuShiShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      liuShiShiShenHideGan.add('${LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + dHideGan[x]]}');
    }
    return liuShiShiShenHideGan;
  }

  ///大运十神
  String? getDaYunShiShen(index) {
    // print(index);
    // print(_daYun[index]);
    // print(_daYun[index].getXiaoYun());
    // if (_daYun[0].getXiaoYun().isEmpty) {
    //   print('小运--空');
    //   return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[index + 1].getGanZhi().substring(0, 1)];
    // } else if (index > 0) {
    //   return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[index].getGanZhi().substring(0, 1)];
    // } else {
    //   return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[0].getXiaoYun()[0].getGanZhi().substring(0, 1)];
    // }
    if (index > 0) {
      return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[index].getGanZhi().substring(0, 1)];
    } else {
      return LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + _daYun[0].getXiaoYun()[0].getGanZhi().substring(0, 1)];
    }
  }

  ///大运十神支--藏干
  List<String> getDaYunShiShenHideGan(index) {
    var dZhi = '';
    if (_daYun[index].getXiaoYun().isEmpty) {
      dZhi = _daYun[index + 1].getGanZhi().substring(1);
    } else if (index > 0) {
      dZhi = _daYun[index].getGanZhi().substring(1);
    } else {
      dZhi = _daYun[0].getXiaoYun()[0].getGanZhi().substring(1);
    }
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> daYunShiShenHideGan = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      daYunShiShenHideGan.add(dHideGan[x]);
      // daYunShiShenHideGan.add('${dHideGan[x]}-${LunarUtil.SHI_SHEN_ZHI[_bazi.getDayGan()+dHideGan[x]]}');
    }
    return daYunShiShenHideGan;
  }

  ///大运十神支--副星
  List<String> getDaYunShiShenZhi(index) {
    var dZhi = '';
    if (index > 0) {
      dZhi = _daYun[index].getGanZhi().substring(1);
    } else {
      dZhi = _daYun[0].getXiaoYun()[0].getGanZhi().substring(1);
    }
    var dHideGan = LunarUtil.ZHI_HIDE_GAN[dZhi];
    List<String> dShiShenZhi = [];
    for (var x = 0; x < dHideGan!.length; x++) {
      dShiShenZhi.add('${LunarUtil.SHI_SHEN_GAN[_bazi.getDayGan() + dHideGan[x]]}');
    }
    return dShiShenZhi;
  }

  /// 计算实际年龄
  String getAge() {
    if (_dateTime.isAfter(_now)) {
      return '未出生';
    }

    int yearNow = _now.year; // 当前年份
    int monthNow = _now.month; // 当前月份
    int dayOfMonthNow = _now.day; // 当前日期

    int yearBirth = _dateTime.year;
    int monthBirth = _dateTime.month;
    int dayOfMonthBirth = _dateTime.day;

    // 计算整岁数
    int ageInYears = yearNow - yearBirth;

    // 如果当前月份小于出生月份，或者当前月份等于出生月份但当前日期在出生日期之前，年龄减一
    if (monthNow < monthBirth || (monthNow == monthBirth && dayOfMonthNow < dayOfMonthBirth)) {
      ageInYears--; // 当前日期在生日之前，年龄减一
    }

    if (ageInYears < 1) {
      // 年龄小于1岁
      Duration ageDifference = _now.difference(_dateTime);
      int ageInDays = ageDifference.inDays;

      return '$ageInDays天';
    } else if (ageInYears < 3) {
      // 年龄在1岁到3岁之间
      int remainingMonths = (yearNow - yearBirth) * 12 + monthNow - monthBirth;

      if (remainingMonths % 12 == 0) {
        return '${remainingMonths ~/ 12}岁';
      } else {
        return '${remainingMonths ~/ 12}岁${remainingMonths % 12}个月';
      }
    }
    return '$ageInYears岁';
  }

  /// 四柱 对应的 干支
  List<String> getGanZhi() => [_yearGan, _yearZhi, _monthGan, _monthZhi, _dayGan, _dayZhi, _hourGan, _hourZhi];

  /// 返回八字
  EightChar getBazi() => _bazi;

  /// 干支对应的五行颜色
  Color? getZhiColor(String text) {
    return wuXingColor[wuXingZhi[text[0]]];
  }

  Color? getGanColor(String text) {
    return wuXingColor[wuXingGan[text]];
  }

  /// 四柱干支 五行的颜色
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

  /// 生肖图标
  Icon? getShengXiaoIcon() => _shengxiaoIcon;

  /// 节气
  List<String> getJieQi() => [
        _prevJieQi,
        _prevJieQiDate,
        _nextJieQi,
        _nextJieQiDate,
      ];

  /// 十神-干
  List<String> getShiShenGan() => [_bazi.getYearShiShenGan(), _bazi.getMonthShiShenGan(), _bazi.getDayShiShenGan(), _bazi.getTimeShiShenGan()];

  /// 十神-支（藏干)
  List<dynamic> getShiShenZhi() => [
        _bazi.getYearShiShenZhi().toString(),
        _bazi.getMonthShiShenZhi().toString(),
        _bazi.getDayShiShenZhi().toString(),
        _bazi.getTimeShiShenZhi().toString()
      ];

  /// 藏干
  List<dynamic> getHideGan() =>
      [_bazi.getYearHideGan().toString(), _bazi.getMonthHideGan().toString(), _bazi.getDayHideGan().toString(), _bazi.getTimeHideGan().toString()];
  // 流月，用十二节划分月份
  // [ "甲", "寅", "2", "4", "立春", "劫", "劫" ]
  // ，'小寒'跨年在第二年时，用'XIAO_HAN'
  static final List<String> JIE_FOR_LIU_YUE = ['立春', '惊蛰', '清明', '立夏', '芒种', '小暑', '立秋', '白露', '寒露', '立冬', '大雪', '小寒', 'XIAO_HAN'];

  // 按八字子时流派显示 晚子时算当天还是明天 ？
  // 标注流时用，每天24个时辰的时间段，早晚子时之分，只使用12个时辰/晚子时算明天
  static final List<String> HOUR_FOR_LIU_SHI = [
    '23:00',
    '01:00',
    '03:00',
    '05:00',
    '07:00',
    '09:00',
    '11:00',
    '13:00',
    '15:00',
    '17:00',
    '19:00',
    '21:00',
    '23:00',
    '00:59',
    '02:59',
    '04:59',
    '06:59',
    '08:59',
    '10:59',
    '12:59',
    '14:59',
    '16:59',
    '18:59',
    '20:59',
    '22:59',
    '23:59'
  ];
  // 已作废，改写了lunar的获取流月方法，并为lunar添加了获取流日、流时的方法
  /// 获取十二节对应的公历日期 替代Lunar中的流月，.getMonthInChinese()指流年中每一月的干支排布。
  List<dynamic> getJieDate(int index, String year) {
    // 以当年农历正月初一为初始
    Lunar lunar = Lunar.fromYmd(int.parse(year), 1, 1);
    if (index == 11) {
      // 获取到的小寒日期在本年的年首，正确的小寒日期应在年尾，即跨年第二年的年首
      String tmpJie = JIE_FOR_LIU_YUE[11];
      var tmpJieDate = lunar.getJieQiTable()[tmpJie];
      // 大雪 日期
      String jie = JIE_FOR_LIU_YUE[10];
      var jieDate = lunar.getJieQiTable()[jie];
      // 判断，如果 小寒 日期 在 大雪 之前 ，则返回
      if (tmpJieDate!.isBefore(jieDate!)) {
        jie = JIE_FOR_LIU_YUE[12];
        jieDate = lunar.getJieQiTable()[jie];
        return [jie, jieDate, '${jieDate?.getMonth()}/${jieDate?.getDay()}'];
      }
    }
    String jie = JIE_FOR_LIU_YUE[index];
    var jieDate = lunar.getJieQiTable()[jie];
    return [jie, jieDate, '${jieDate?.getMonth()}/${jieDate?.getDay()}'];
  }

  // 已作废
  // 流日，从一个节到下一个节的所有日期
  // ["癸", "巳", "十四", "枭", "伤", "2023年2月4日", "2023年正月十四", "星期六", [ "壬寅", "癸丑", "癸巳", "壬子" ]]
  List<dynamic> getLiuRiDate(int yueIndex, String year, int index) {
    // 当前流月 对应节的公历日期
    var currentJieDate = getJieDate(yueIndex, year)[1];
    // 当前节 后几（index）天
    var currentDay = currentJieDate.nextDay(index);
    // 流日干支
    var l = Lunar.fromSolar(currentDay);
    var dayGanZhi = l.getDayInGanZhi();
    // print(dayGanZhi);
    // print(getGanColor(dayGanZhi.substring(0,1)));
    return [currentDay, '${currentDay?.getMonth()}/${currentDay?.getDay()}', dayGanZhi];
  }

  // 已作废
  // 流时-12时辰
  // [ "壬", "子", "23:00", "印", "枭" ]
  List<dynamic> getLiuShi(int riIndex, int yueIndex, String year, int index) {
    // 当前流时的日期、流日公历日期
    var currentShiDate = getLiuRiDate(yueIndex, year, riIndex)[0];
    // 获取当天的所有时辰对象，由于有早子时和晚子时，会返回13个对象，只使用12个时辰/晚子时算明天
    var l = Lunar.fromSolar(currentShiDate);
    var times = l.getTimes();
    return [times[index].getGanZhi()];
  }
}
