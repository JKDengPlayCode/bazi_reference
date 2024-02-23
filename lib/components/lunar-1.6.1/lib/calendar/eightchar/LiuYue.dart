import '../../lunar.dart';
import '../IndexValue.dart';

/// 流月
/// 改写了lunar的获取流月方法，并为lunar添加了获取流日、流时的方法
/// @author 6tail
class LiuYue {
  /// 序数，0-9
  int _index;

  /// 流年
  LiuNian _liuNian;

  LiuYue(this._liuNian, this._index);

  String getMonthInChinese() => LunarUtil.MONTH[_index + 1];

  int getIndex() => _index;

  String getGanZhi() {
    int yearGanIndex = 0;
    IndexValue? iv = LunarUtil.find(_liuNian.getGanZhi(), LunarUtil.GAN);
    if (null != iv) {
      yearGanIndex = iv.getIndex() - 1;
    }
    int offset = [2, 4, 6, 8, 0][yearGanIndex % 5];
    String gan = LunarUtil.GAN[(_index + offset) % 10 + 1];
    String zhi = LunarUtil.ZHI[(_index + LunarUtil.BASE_MONTH_ZHI_INDEX) % 12 + 1];
    return gan + zhi;
  }

  String getXun() => LunarUtil.getXun(getGanZhi());

  String getXunKong() => LunarUtil.getXunKong(getGanZhi());

  // 以下获取流月下的流日，Author:djk
  // 流月，用十二节划分月份
  // 小寒位于阳历同一年，XIAO_HAN、LI_CHUN位于阳历下一年。
  static final List<String> JIE_FOR_LIU_YUE = ['立春', '惊蛰', '清明', '立夏', '芒种', '小暑', '立秋', '白露', '寒露', '立冬', '大雪', 'XIAO_HAN', 'LI_CHUN'];

  // 以节交接作为月份分隔的依据，本节令到下一节令之间的日期
  late final Lunar _lunar = Lunar.fromYmd(_liuNian.getYear(), 1, 1);
  late final Solar _startDate = _lunar.getJieQiSolar(JIE_FOR_LIU_YUE[_index]);
  late final Solar _endDate = _lunar.getJieQiSolar(JIE_FOR_LIU_YUE[_index + 1]);
  late final int _dayCounts = _endDate.subtract(_startDate) + 1;

  /// 返回流月的首日，若节令转换时刻是23点，则此首日不存在，向后偏移1天
  Solar getStartDate() => _startDate.getHour() == 23 ? _startDate.nextDay(1) : _startDate;

  /// 流月起始日期的字符串形式 月/日
  String getStartDateMonthAndDay() => '${_startDate.getMonth()}.${_startDate.getDay()}';

  /// 返回流月的尾日
  Solar getEndDate() => _endDate;
  String getEndDateMonthAndDay() => '${_endDate.getMonth()}.${_endDate.getDay()}';

  /// 返回流月的总天数，若节令转换时刻是23点，则此首日不存在，总天数减1
  int getDayCounts() => _startDate.getHour() == 23 ? _dayCounts - 1 : _dayCounts;

  /// 获取流日对象列表
  List<LiuRi> getLiuRi() {
    // Lunar lunar = Lunar.fromYmd(_liuNian.getYear(), 1, 1);
    // 以节交接作为月份分隔的依据，本节令到下一节令之间的日期
    // var startDate = lunar.getJieQiSolar(JIE_FOR_LIU_YUE[_index]);
    // var endDate = lunar.getJieQiSolar(JIE_FOR_LIU_YUE[_index + 1]);
    // int n = endDate.subtract(startDate) + 1;

    List<LiuRi> l = <LiuRi>[];
    for (int i = 0; i < _dayCounts; i++) {
      // 解决流月中的首日存在没有干支时辰的问题
      // 节令转换的时间在流月首日的23点至0点中间，此流日不应存在，故不加入流日列表
      // 若 _startDate.getHour() == 23，则索引0为空，后续索引要减1后再加入流日列表
      if (i == 0 && _startDate.getHour() != 23) {
        l.add(LiuRi(this, i, _startDate));
      } else if (i > 0 && i < _dayCounts - 1 && _startDate.getHour() != 23) {
        // 从起始日期开始，将每日加入到流日列表中，每日的具体时刻为开始日期即节令开始的精确时刻
        l.add(LiuRi(this, i, _startDate.nextDay(i)));
      } else if (i > 0 && i < _dayCounts - 1 && _startDate.getHour() == 23) {
        // 去掉不存在的首日，索引减1
        l.add(LiuRi(this, i - 1, _startDate.nextDay(i)));
      } else if (i == _dayCounts - 1 && _startDate.getHour() != 23) {
        // 最后加入结束日期及下一节令开始的精确时刻（获取流日的干支时，重新构造起始时刻为零点零分零秒）
        l.add(LiuRi(this, i, _endDate));
      } else if (i == _dayCounts - 1 && _startDate.getHour() == 23) {
        // 去掉不存在的首日，索引减1
        l.add(LiuRi(this, i - 1, _endDate));
      }
    }
    return l;
  }
}
