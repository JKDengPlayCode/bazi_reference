import '../../lunar.dart';
import '../IndexValue.dart';

/// 流日
/// 改写了lunar的获取流月方法，并为lunar添加了获取流日、流时的方法
/// @author djk
class LiuRi {
  /// 流日索引序数，不定值，取决于节令与下一节令之间的日期间隔，从流月传过来
  int _index;

  /// 流月
  LiuYue _liuYue;

  /// 本月中的所有公历日期
  Solar _solar;

  LiuRi(this._liuYue, this._index, this._solar);

  int getIndex() => _index;
  Solar getSolar() => _solar;
  Lunar getLunar() => Lunar.fromSolar(_solar);

  /// 返回流日的公历日期 月/日
  String getDate() {
    return '${_solar.getMonth()}.${_solar.getDay()}';
  }

  String getDateMonth() {
    return '${_solar.getMonth()}';
  }

  String getDateDay() {
    return '${_solar.getDay()}';
  }

  /// 返回流日的干支
  /// 获取精确的干支纪日（流派1，晚子时日柱算明天）
  /// 并且，需重新构造每日起始时刻为0点0分0秒，不能用23点，23点算第2天了
  String getGanZhi() {
    var s = Solar.fromYmdHms(_solar.getYear(), _solar.getMonth(), _solar.getDay(), 0, 0, 0);
    var l = Lunar.fromSolar(s);
    return l.getDayInGanZhiExact();
  }

  /// 返回流日的时辰干支的非空位置
  // int get

  String getXun() => LunarUtil.getXun(getGanZhi());

  String getXunKong() => LunarUtil.getXunKong(getGanZhi());

  /// 获取流日的流时列表，返回长度为12的时辰干支字符串列表，流月的首日和尾日可能会有空字符串
  List<String> getLiuShi() {
    // 每天12个时辰,流时列表的长度就是12,但首日和尾日有界限
    int n = 12;
    // 初始化流时列表
    List<String> l = <String>[];
    // 构造每日起始时刻为0点0分0秒，并获取当天的所有时辰对象，由于有早子时和晚子时，会返回13个对象，只取前12个。
    var solar = Solar.fromYmdHms(_solar.getYear(), _solar.getMonth(), _solar.getDay(), 0, 0, 0);
    var lunar = Lunar.fromSolar(solar);
    var times = lunar.getTimes();
    // 获取流日精确时刻的时干支，在流月的首日和尾日作为当日流时的<结尾>和<开始>
    String shiGanZhi = _solar.getLunar().getTimeInGanZhi();
    // 以节转换时刻的时干支作为界限
    // 当节转换时刻是23时，晚子时的limitIndex=12
    int limitIndex = times.indexWhere((element) => element.toString() == shiGanZhi);
    // 流日是当月起始日期时，本月开始那天的时刻从节转换那一时刻开始，所以第一天不存在节转换前的时辰，只有节转换时及其后的时辰
    if (_index == 0) {
      for (int i = 0; i < n; i++) {
        // i < limitIndex表示节转换前的时辰置为空，limitIndex=12时加入前times的12个时辰，否则会出现节转换时刻是23时的首日的12个时辰全为空的情况
        if (i < limitIndex && limitIndex != 12) {
          l.add('');
        } else {
          // 若是要使用流时对象，可以使用LiuShi类，l.add(LiuShi(this, _index, times[i].toString()));
          // 暂时不用LiuShi类
          l.add(times[i].toString());
        }
      }
    }
    // 流日是当月结束日期时，本月结束那天的时刻在下一节转换那一时刻结束，所以最后一天不存在节转换后的时辰，只有下一节转换时及其前的时辰
    else if (_index == _liuYue.getLiuRi().length - 1) {
      for (int i = 0; i < n; i++) {
        if (i <= limitIndex) {
          l.add(times[i].toString());
        } else {
          l.add('');
        }
      }
    }
    // 除本月起始日期和结束日期以外的中间所有日期，每天都有12个时辰
    else {
      for (int i = 0; i < n; i++) {
        l.add(times[i].toString());
      }
    }
    return l;
  }
}

// 获取流时的示例：
// 2017-01-05 11:55:42 // 二〇一六年腊月初八
// [庚子, 辛丑, 壬寅, 癸卯, 甲辰, 乙巳, 丙午, 丁未, 戊申, 己酉, 庚戌, 辛亥, 壬子]
// liuYue[10]的最后一天
// [庚子, 辛丑, 壬寅, 癸卯, 甲辰, 乙巳, 丙午, , , , , ]
// liuYue[11]的第一天
// [, , , , , , 丙午, 丁未, 戊申, 己酉, 庚戌, 辛亥]
// liuYue[11]中的第二天
// [壬子, 癸丑, 甲寅, 乙卯, 丙辰, 丁巳, 戊午, 己未, 庚申, 辛酉, 壬戌, 癸亥]
