import 'package:bazi/components/customGetXDialog.dart';
import 'package:flutter/material.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';

import 'package:bazi/common/constants.dart';
import 'package:bazi/pages/wan_nian_li/input_solar_date_dialog.dart';
import 'package:get/get.dart';
import 'package:bazi/pages/settings_page.dart';

import '../help_pages.dart';

// 老黄历
class LaoHuangLiPage extends StatefulWidget {
  const LaoHuangLiPage({super.key});

  @override
  State<LaoHuangLiPage> createState() => _LaoHuangLiPageState();
}

// Flutter 三种方式实现页面切换后保持原页面状态：AutomaticKeepAliveClientMixin
class _LaoHuangLiPageState extends State<LaoHuangLiPage> with AutomaticKeepAliveClientMixin {
  @override
  // 是否需要在页面切换后保持页面状态，即，在重新回到本页面时保持当前所选的日期时间，而不重置为当前日期时间
  bool get wantKeepAlive => true;
  // 本页面只有干支历法一处使用get包计算
  final SettingsController settingsController = Get.find();

  // 万年历的初始日期时间为当前日期时间
  DateTime? selectedDate = DateTime.now();

  Icon selectedIcon = ChangeDateType.day.icon; // 存储选择的图标，默认'日'为初始图标
  String selectedMenuItem = ChangeDateType.day.label; // 存储选择的菜单项，默认为 '日'
  /// 点击左右箭头改变日期的 选项，选择任意项后，修改leading的图标与所选项相同（年、月、日、时、周）
  void _updateSelectedOption(int index) {
    setState(() {
      selectedMenuItem = ChangeDateType.values[index].label; // 更新选择的菜单项
      selectedIcon = ChangeDateType.values[index].icon; // 更新选择的图标
    });
  }

  /// 点击左右箭头，根据选项改变日期，向前或向后一（年、月、日、时、周）
  /// 'add' 加时算当前，'subtract' 减时算上一年/月的天数，月减到1月份时年减1月为12
  /// TODO 在翻页时分隔线有虚影现象，改进后还有轻微bug，setState未及时更新？滑动页面虚影消失。原因可能是ListTile是一个有固定高度的widget，当其中的内容发生变化时，widget的高度没有及时更新，导致滑动时出现虚影现象
  void _changeDate(String operation) {
    setState(() {
      switch (selectedMenuItem) {
        case '年':
          selectedDate = operation == 'add'
              ? selectedDate?.add(Duration(days: SolarUtil.getDaysOfYear(selectedDate!.year)))
              : selectedDate?.subtract(Duration(days: SolarUtil.getDaysOfYear(selectedDate!.year - 1))); // 减一年时，应计算上一年的天数
          // : selectedDate?.subtract(Duration(days: SolarUtil.getDaysOfYear(SolarYear.fromDate(selectedDate!).next(-1).getYear()))); // 与上一句功能一样，但都不能解决遇到闫年时
          // 下一年到闫年少加1天，上一年到闫年少加1天。闫年到下一年多加1天，闫年到上一年多加1天。这应该是闫年2月多一天29导致的，暂时忽略。
          break;
        case '月':
          selectedDate = operation == 'add'
              ? selectedDate?.add(Duration(days: SolarUtil.getDaysOfMonth(selectedDate!.year, selectedDate!.month)))
              : selectedDate?.subtract(Duration(
                  days: SolarUtil.getDaysOfMonth(selectedDate!.month == 1 ? selectedDate!.year - 1 : selectedDate!.year,
                      selectedDate!.month == 1 ? 12 : selectedDate!.month - 1)));
          break;
        case '日':
          selectedDate = operation == 'add' ? selectedDate?.add(const Duration(days: 1)) : selectedDate?.subtract(const Duration(days: 1));
          break;
        case '小时':
          selectedDate = operation == 'add' ? selectedDate?.add(const Duration(hours: 1)) : selectedDate?.subtract(const Duration(hours: 1));
          break;
        case '周':
          selectedDate = operation == 'add' ? selectedDate?.add(const Duration(days: 7)) : selectedDate?.subtract(const Duration(days: 7));
          break;
        case '农历年':
          selectedDate = operation == 'add'
              ? selectedDate?.add(Duration(days: LunarYear.fromYear(Lunar.fromDate(selectedDate!).getYear()).getDayCount()))
              : selectedDate?.subtract(Duration(days: LunarYear.fromYear(Lunar.fromDate(selectedDate!).getYear() - 1).getDayCount()));
          break;
        case '农历月':
          // 搞了一堆代码，结果也不一定正确，先放放，就到这儿吧202401052229。另一个思路是提取当前年月日时，选择哪个切换就更改哪项，也要判断是否存在
          // 增减到闫月或从闫月增减均需计算要增减的天数
          // 需要计算月份天数的农历年，如果月份=1则年-1
          int currentYear = Lunar.fromDate(selectedDate!).getYear();
          int currentMonth = Lunar.fromDate(selectedDate!).getMonth();
          int lastYear = currentMonth == 1 ? currentYear - 1 : currentYear;
          int lastMonth = currentMonth == 1 ? 12 : currentMonth;

          // int currentMonth =
          //     Lunar.fromDate(selectedDate!).getMonth();//  == 1 ? 12 : Lunar.fromDate(selectedDate!).getMonth();
          // 查询这一年的闫月，获取闰月数字，1代表当年闰1月，0代表当年无闰月
          // 闫月的月份数 为 -1，平月的月份数为+1
          int isLeapMonthOfCurrentYear = LunarYear.fromYear(currentYear).getLeapMonth();
          int daysOfLastMonth = 0; // 上一月的天数
          int daysOfNextMonth = 0; // 下一月的天数
          if (isLeapMonthOfCurrentYear > 0) {
            if (currentMonth == -isLeapMonthOfCurrentYear) {
              daysOfNextMonth = LunarMonth.fromYm(currentYear, isLeapMonthOfCurrentYear + 1)!.getDayCount();
              daysOfLastMonth = LunarMonth.fromYm(lastYear, lastMonth)!.getDayCount();
            } else if (currentMonth == isLeapMonthOfCurrentYear || currentMonth == isLeapMonthOfCurrentYear + 1) {
              daysOfNextMonth = LunarMonth.fromYm(currentYear, isLeapMonthOfCurrentYear)!.getDayCount();
              daysOfLastMonth = LunarMonth.fromYm(lastYear, lastMonth)!.getDayCount();
            } else {
              daysOfNextMonth = LunarMonth.fromYm(currentYear, currentMonth)!.getDayCount();
              daysOfLastMonth = LunarMonth.fromYm(lastYear, lastMonth)!.getDayCount();
            }
          } else {
            daysOfNextMonth = LunarMonth.fromYm(currentYear, currentMonth)!.getDayCount();
            daysOfLastMonth = LunarMonth.fromYm(lastYear, lastMonth)!.getDayCount();
          }

          // 如果 闰月数字 leapMonthOfYear>0，则有闫月
          // 当前月为非闫月 到前一月（即闫月）时，当前月月份数 = 闰月数字leapMonthOfYear + 1 时，计算需要减去的天数：闫月的天数
          // 当前月为非闫月 到下一月（即闫月）时，当前月月份数 = 闰月数字leapMonthOfYear 时，计算需要增加的天数：闫月的天数
          // 当前月为闫月 到前一月时，当前月月份数 = 负的 闰月数字leapMonthOfYear 时，计算需要减去的天数：前一月的月份数是（闰月数字leapMonthOfYear）月 的天数
          // 当前月为闫月 到下一月时，当前月月份数 = 负的 闰月数字leapMonthOfYear 时，计算需要增加的天数：后一月的月份数是（闰月数字leapMonthOfYear+1）月 的天数
          // int leapMonthOfYear=LunarYear.fromYear(Lunar.fromDate(selectedDate!).getYear()).getLeapMonth();
          selectedDate =
              operation == 'add' ? selectedDate?.add(Duration(days: daysOfNextMonth)) : selectedDate?.subtract(Duration(days: daysOfLastMonth));
          /*
          selectedDate = operation == 'add'
              ? selectedDate?.add(Duration(
                  days: LunarMonth.fromYm(
                          Lunar.fromDate(selectedDate!).getYear(), Lunar.fromDate(selectedDate!).getMonth())!
                      .getDayCount()))
              : selectedDate?.subtract(Duration(
                  days: LunarMonth.fromYm(
                          Lunar.fromDate(selectedDate!).getYear(), Lunar.fromDate(selectedDate!).getMonth()<0?-Lunar.fromDate(selectedDate!).getMonth()-1:Lunar.fromDate(selectedDate!).getMonth()-1)!
                      .getDayCount()));
           */
          break;
        case '时辰':
          selectedDate = operation == 'add' ? selectedDate?.add(const Duration(hours: 2)) : selectedDate?.subtract(const Duration(hours: 2));
          break;
        case '节气':
          // getCurrentQi()获取当天节气，返回JieQi对象，当天无节气返回null。
          // 如果当天有节气，则对当天加减一天，否则获取不到上下一个节气
          // 获取到上下节气后的selectedDate，日期和时间会被赋值为此节气发生的时间
          selectedDate = operation == 'add'
              ? Lunar.fromDate(selectedDate!).getCurrentJieQi() == null
                  ? DateTime.parse(Lunar.fromDate(selectedDate!).getNextJieQi().getSolar().toYmdHms())
                  : DateTime.parse(Lunar.fromDate(selectedDate!.add(const Duration(days: 1))).getNextJieQi().getSolar().toYmdHms())
              : Lunar.fromDate(selectedDate!).getCurrentJieQi() == null
                  ? DateTime.parse(Lunar.fromDate(selectedDate!).getPrevJieQi().getSolar().toYmdHms())
                  : DateTime.parse(Lunar.fromDate(selectedDate!.subtract(const Duration(days: 1))).getPrevJieQi().getSolar().toYmdHms());
          break;
        default:
          selectedDate = operation == 'add' ? selectedDate?.add(const Duration(days: 1)) : selectedDate?.subtract(const Duration(days: 1));
          break;
      }
    });
  }

  late List<String> _leadingList = [];
  late List<String> _leadingInfo = [];
  late List<String> _titleList = [];

  DateTime _stringToDateTime(String value) {
    String date = value.substring(0, 8);
    String time = value.substring(8, 14);
    return DateTime.parse('${date}T$time');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // String image = isDark ? 'wnl_header_dark.webp' : 'wnl_header.webp';
    // MyLunar myLunar = MyLunar.computeTheDay(selectedDate!);
    // solarDate 公历；lunarDate 农历； ganZhiDate 干支历。
    Lunar lunarDate = Lunar.fromDate(selectedDate!);
    LunarYear ly = LunarYear.fromYear(lunarDate.getYear());
    Solar solarDate = Solar.fromDate(selectedDate!);
    var jiuxing = lunarDate.getDayNineStar();
    // 由于八字涉及的信息较多，Lunar已经越来越臃肿，故将八字单独提出，所有八字相关内容请使用EightChar。
    // https://6tail.cn/calendar/api.html#lunar.chongsha.html
    // 干支历 使用与八字的方法getEightChar()，以及相同的子时流派设置，已移到settings_page中使用get包返回
    // EightChar ganZhiDate = lunarDate.getEightChar();
    // print(paiController.selectedZiShiPai.value);
    // ganZhiDate.setSect(paiController.selectedZiShiPai.value);
    // 正文 ListTile 的 leading 部分的内容，空格是为了对齐
    _leadingList = [
      '      宜      ',
      '      忌      ',
      '上一节气',
      '下一节气',
      '佛        历',
      '道        历',
      '纳        音',
      '儒  略  日',
      '月        名',
      '月        相',
      '物        候',
      '三元九运',
      '治        水',
      '分        饼',
      '耕        田',
      '得        金',
      '日        禄',
      '六        曜',
      '彭祖百忌',
      '吉神宜趋',
      '凶煞宜忌',
      '相        冲',
      '日        煞',
      '七        曜',
      '星        宿',
      '星宿歌诀',
      '贵神方位',
      '喜神方位',
      '福神方位',
      '财神方位',
      '本月胎神',
      '今日胎神',
      '太岁方位',
      '值        星',
      '十二天神',
      '空亡所值',
      '九        星',
      '九星歌诀',
      '节        日',
      '纪  念  日',
      '数        九',
      '三        伏',
    ];

    // 老黄历各词条的解释
    _leadingInfo = [
      '''
      今日适合做的事情。''',
      '''
      今日不宜做的事情。''',
      '''
      二十四节气包括十二节（立春、惊蛰、清明、立夏、芒种、小暑、立秋、白露、寒露、立冬、大雪、小寒）和十二气（雨水、春分、谷雨、小满、夏至、大暑、处暑、秋分、霜降、小雪、冬至、大寒）。''',
      '''
      节气先后顺序为以冬至开始，以大雪结束，通常冬至位于阳历的上一年。
      冬至到大雪为一个节气周期，大雪和冬至位于阳历上一年，小寒到冬至位于阳历同一年，小寒、大寒、立春、雨水和惊蛰位于阳历下一年。''',
      '''
      佛历是历法的一种。以释迦牟尼涅槃后一年为纪元元年，比世界通用的公历早五百四十四年。''',
      '''
      “上元混沌甲子之岁、日月合璧、五星联珠、七曜齐元。”
      公元前2697年黄帝即位的那一天，正逢以上天象一起出现，那天恰逢冬至及朔旦日，所以黄帝制历并且以那天为道历的起算点，即：甲子年甲子月甲子日甲子时。
      以黄帝六十甲子纪年，传说黄帝时代的大臣大挠“深五行之情，占年纲所建，于是作甲乙以名日，谓之干；作子丑以名日，谓之枝，干支相配以成六旬。”始作甲、乙、丙、丁、戊、己、庚、辛、壬、癸此十天干，及子、丑、寅、卯、辰、巳、午、未、申、酉、戌、亥此十二地支，相互配合成六十甲子用为纪历之符号。''',
      '''
      天干有天干的五行，地支有地支的五行，天干与地支配合后会变成新的五行，称为“纳音五行”。''',
      '''
      儒略日是指由公元前4713年1月1日，协调世界时中午12时开始所经过的天数，多为天文学家采用，用以作为天文学的单一历法，把不同历法的年表统一起来。
      如果计算相隔若干年的两个日期之间间隔的天数，利用儒略日就比较方便。''',
      '''
      孟春、仲春、季春，孟夏、仲夏、季夏，孟秋、仲秋、季秋，孟冬、仲冬、季冬，依次是农历的1~12月（正月至腊月）。''',
      '''
      月相，是天文学中对于地球上看到的月球被太阳照明部分的称呼。
      随着月亮每天在星空中自东向西移动一大段距离，它的形状也在不断地变化着，这就是月亮位相变化，叫做月相。''',
      '''
      七十二候，是我国古代用来指导农事活动的历法补充。它是根据黄河流域的地理、气候、和自然界的一些景象编写而成，以五日为候，三候为气，六气为时，四时为岁，一年“二十四节气”共七十二候。各候均以一个物候现象相应，称“候应”。其中植物候应有植物的幼芽萌动、开花、结实等；动物候应有动物的始振、始鸣、交配、迁徙等；非生物候应有始冻、解冻、雷始发声等。七十二候“候应”的依次变化，反映了一年中物候和气候变化的一般情况。
      每个节气持续15天左右，每隔5天为一候，因此从节气日开始，分别为初候、二候、三候。''',
      '''
      古人把黄帝元年(公元前2697年)定位始元，这一年是甲子年，此后，每过60年为一个甲子周期，称为一元或一大运。
      每过3个甲子，即为三元，分为上元、中元、下元。三元共计180年。
      每一元，划分为3个小运，每个小运20年。
      上元包括一运、二运、三运；中元包括四运、五运、六运；下元包括七运、八运、九运。''',
      '''
      灶马头是一本奇书，是我国古人智慧的结晶。
      几龙治水：
      治水靠龙，龙对应辰，因此正月第1个辰日是初几，就是几龙治水。
      民间有“龙多旱涝不均，龙少风调雨顺”的说法。类似三个和尚没水喝。''',
      '''
      几人分饼：
      丙与饼谐音，因此正月第1个丙日是初几，就是几人分饼。''',
      '''
      几牛耕田：
      耕田用牛，牛对应丑，因此正月第1个丑日是初几，就是几牛耕田，牛多象征着收成好。''',
      '''
      几日得金：
      有诗云：“天龙治水望丰年，神牛下界好耕田；人少饼多吃喝厚，得辛金重有余钱”。
      得金，也叫得辛，正月第1个辛日是初几，就是几日得金。得金的日子越多，说明钱越好挣。''',
      '''
      禄神为四柱神煞之一，是民间信仰中的主司官禄之神。
      甲禄在寅，乙禄在卯，丙戊禄在巳，丁己禄在午，庚禄在申，辛禄在酉，壬禄在亥，癸禄在子。
      禄在年支叫岁禄，禄在月支叫建禄，禄在日支叫专禄（也叫日禄），禄在时支叫归禄。''',
      '''
      六曜，又称孔明六曜星或小六壬，是中国传统历法中的一种附注。它包括先胜、友引、 先负、佛灭、大安和赤口六个词汇，分别表示当天宜行何事，用以作为判定每日凶吉的参考。''',
      '''
      彭祖百忌指的是在天干地支记日中的某日或当日里的某时不要做某事否则会发生某事。
      彭祖，道家先驱，是中国远古道家的重要人物，他以善养生而长寿。
      彭祖创作了一首打油诗，对应10天干和12地支，说明要忌讳的事情。''',
      '''
      吉神宜趋、凶神宜忌，分别是指值年太岁和流年太岁在当天的立位。
      吉神或凶神通称为神煞，一般代表的是天干地支特殊组合的关系，有年、月、日、时四类神煞。
      吉神宜趋：宜接近，会有吉利的神明。
      宜：今日适合做的事情。
      古时候，人们相信有神的存在，所以在吉神多的日子的话就可以增加顺利的程度，还有可以增添吉祥的意义。''',
      '''
      吉神宜趋、凶神宜忌，分别是指值年太岁和流年太岁在当天的立位。
      吉神或凶神通称为神煞，一般代表的是天干地支特殊组合的关系，有年、月、日、时四类神煞。
      凶神宜忌：应远离，会有冲犯不好的事发生的神明。
      忌：今日不宜做的事情。
      黄历中的凶神是指“神煞”中的“煞”，是导致凶险的根源，宜是适合做某事，忌是不适合做某事。''',
      '''
      冲煞分为冲和煞。
      冲包括天干冲和地支冲，地支冲包括：子午相冲，丑未相冲，寅申相冲，辰戌相冲，卯酉相冲，巳亥相冲。由于地支对应十二生肖，也就对应了生肖相冲。
      天干相冲分为无情之克（阳克阳，阴克阴）和有情之克（阳克阴，阴克阳）。
      煞则指不好的方位，根据地支，逢巳、酉、丑必煞东；亥、卯、未必煞西；申、子、辰必煞南；寅、午、戌必煞北。''',
      '''
      冲煞分为冲和煞。
      冲包括天干冲和地支冲，地支冲包括：子午相冲，丑未相冲，寅申相冲，辰戌相冲，卯酉相冲，巳亥相冲。由于地支对应十二生肖，也就对应了生肖相冲。
      天干相冲分为无情之克（阳克阳，阴克阴）和有情之克（阳克阴，阴克阳）。
      煞则指不好的方位，根据地支，逢巳、酉、丑必煞东；亥、卯、未必煞西；申、子、辰必煞南；寅、午、戌必煞北。''',
      '''
      七曜，又称七政、七纬、七耀等。
      “七曜日”分别代表一周七天的叫法最早出现于两河流域的古巴比伦文明。公元前七百年左右，古巴比伦出现了一个星期分为七天的制度，四星期合为一个月。
      在日本、韩国和朝鲜，一星期中的各天并不是按数字顺序，而是有着特定的名字，是以“七曜”来分别命名的。土曜日是星期六，日曜日是星期天，月曜日是星期一，火曜日是星期二，水曜日是星期三，木曜日是星期四，金曜日是星期五。
      在中国，起初也是以七曜命名一星期中的各天，将日（太阳）、月（太阴）、金（太白）太白金星是不是很耳熟？、木（岁星）、水（辰星）、火（荧惑）、土（填星、镇星）等称为七曜，到清末才逐渐改为现在“星期”的叫法。''',
      '''
      二十八宿，是黄道附近的二十八组星象总称。上古时代人们根据日月星辰的运行轨迹和位置，把黄道附近的星象划分为二十八组，俗称二十八宿。
      二十八宿包括：
      东方七宿：角、亢、氐、房、心、尾、箕；
      北方七宿：斗、牛、女、虚、危、室、壁；
      西方七宿：奎、娄、胃、昴、毕、觜、参；
      南方七宿：井、鬼、柳、星、张、翼、轸。''',
      '''
      二十八星宿与七政（日、月、金、木、水、火、土）和28种动物分别对应：\n角-木-蛟，斗-木-獬，奎-木-狼，井-木-犴\n亢-金-龙，牛-金-牛，娄-金-狗，鬼-金-羊\n女-土-蝠，氐-土-貉，胃-土-彘，柳-土-獐\n房-日-兔，虚-日-鼠，昴-日-鸡，星-日-马\n心-月-狐，危-月-燕，毕-月-乌，张-月-鹿\n尾-火-虎，室-火-猪，觜-火-猴，翼-火-蛇\n箕-水-豹，壁-水-獝，参-水-猿，轸-水-蚓''',
      '''
      吉神包括：喜神、阳贵神、阴贵神、福神、财神。
      《阳贵神歌》：甲戊坤艮位，乙己是坤坎，庚辛居离艮，丙丁兑与乾，震巽属何日，壬癸贵神安。
      《阴贵神歌》：甲戊见牛羊，乙己鼠猴乡，丙丁猪鸡位，壬癸蛇兔藏，庚辛逢虎马，此是贵神方。''',
      '''
      吉神包括：喜神、阳贵神、阴贵神、福神、财神。
      《喜神方位歌》：甲己在艮乙庚乾，丙辛坤位喜神安。丁壬只在离宫坐，戊癸原在在巽间。''',
      '''
      吉神包括：喜神、阳贵神、阴贵神、福神、财神。
      《福神方位歌》有两个流派，这里采用了流派2。
      流派1为：甲乙东南是福神，丙丁正东是堪宜，戊北己南庚辛坤，壬在乾方癸在西。
      流派2为：甲己正北是福神，丙辛西北乾宫存，乙庚坤位戊癸艮，丁壬巽上好追寻。''',
      '''
      吉神包括：喜神、阳贵神、阴贵神、福神、财神。
      《财神方位歌》：甲乙东北是财神，丙丁向在西南寻，戊己正北坐方位，庚辛正东去安身，壬癸原来正南坐，便是财神方位真。''',
      '''
      胎神顾名思意是掌管胎儿的低神，比较接近人性，所以犯之则会对胎儿报仇，轻则胎儿出胎斑胎痣，重则流产及难产，除了对胎儿不利外，也会对母亲不利。
      现代太多人不懂看通胜，于是说成怀孕期间不能刻意动土、移床、敲打及鑽洞等等事情，实则应该先看通胜是否有冲突才动工。
      逐月胎神占（闰月无）：正月 占房床，二月 占户窗，三月 占门堂，四月 占厨灶，五月 占房床，六月 占床仓，七月 占碓磨，八月 占厕户，九月 占门房，十月 占房床，十一月 占灶炉，十二月 占房床。''',
      '''
      胎神顾名思意是掌管胎儿的低神，比较接近人性，所以犯之则会对胎儿报仇，轻则胎儿出胎斑胎痣，重则流产及难产，除了对胎儿不利外，也会对母亲不利。
      现代太多人不懂看通胜，于是说成怀孕期间不能刻意动土、移床、敲打及鑽洞等等事情，实则应该先看通胜是否有冲突才动工。
      逐月胎神占（闰月无）：正月 占房床，二月 占户窗，三月 占门堂，四月 占厨灶，五月 占房床，六月 占床仓，七月 占碓磨，八月 占厕户，九月 占门房，十月 占房床，十一月 占灶炉，十二月 占房床。''',
      '''
      四库全书收录的《御定月令辑要》曰：“太岁者，主宰一岁之尊神。凡吉事勿冲之，凶事勿犯之，凡修造方向等事尤宜慎避。太岁所在之方不宜兴工动土，否则必有灾祸。”
      经常听说的太岁头上动土，就出自这里。
      本命年，也就是值太岁。''',
      '''
      十二值星，也称建除十二神，中国民俗信仰中的十二位神明，分别为建、除、满、平、定、执、破、危、成、收、开、闭。
      这十二位神明每日轮值，周而复始，负责保护凡间人民的平安。在传统农民历中，二十八宿下，通常会依序在每日标注上今日轮值神名，作为择日吉凶的参考，称为十二建除日。''',
      '''
      十二天神择日法，又名大黄道择日法，有十二位星神轮流值日，其名称及排列顺序依次为：青龙、明堂、天刑；朱雀、金贵、天德；白虎、玉堂、天牢；玄武、司命、勾陈。
      为便于记忆，古人编为口诀，诗曰：青龙明堂与天刑，朱雀金贵天德神；白虎玉堂天牢黑，玄武司命惊勾陈。
      逢青龙、明堂、金贵、天德、玉堂、司命六神值日为黄道日；逢天刑、朱雀、白虎、天牢、玄武、勾陈六神值日为黑道日。
      为便于记忆黄道日与黑道日，古人有诀曰：道远几时通达，路遥何日还乡。黄道主吉，黑道主凶。
      我们经常在电视中听到选一个黄道吉日做什么的说法，就是从这里来的。''',
      '''
      天干从甲开始，每十天干一轮，叫一旬。也就是说，一旬代表10年。我们常听说的六旬老人，也就是60岁的老人。
      每旬中的十个干支，都以领头这个干支作为旬的名称，例如：甲子、乙丑，它们所在的旬，都叫甲子旬。
      旬空，也叫空亡。由于十天干和十二地支搭配，每旬总会多出来两个地支。这两个地支就叫旬空。''',
      '''
      九星指北斗九星，我们熟知的北斗七星，在古代实际上有9颗。分别称为：天枢、天璇、天玑、天权、玉衡、开阳、摇光、洞明、隐元。''',
      '''
      太乙（太乙神数）、奇门（奇门遁甲）、六壬，并称“三式”，是中国术数三大绝学。太乙以天元为主，测国事；奇门以地元为主，测集体事；六壬以人元为主，测人事。
      而太乙、奇门、玄空（玄空风水）中都有与北斗九星相关的内容，其中九数、七色、五行、后天八卦方位都是相通的。''',
      '''
      包括常见的国内国际节日。
      如，元旦节、国庆节等，也包括母亲节、父亲节、感恩节、圣诞节等，有可能同一天有多个，也可能没有。''',
      '''
      包括常见的国内国际纪念日。
      如，中国青年志愿者服务日、世界抗癌日、香港回归纪念日等，有可能同一天有多个，也可能没有。''',
      '''
      数九，又称冬九九，是中国民间一种计算寒天与春暖花开日期的方法。一般“三九、四九”是一年中最冷的时段。当数到九个“九天”（九九八十一天），便春深日暖、万物生机盎然，是春耕的时候了。
      民谚云：“夏至三庚入伏，冬至逢壬数九”。数九即是从冬至逢壬日算起，每九天算一“九”。但是大部分人都不知道壬日是哪一天，就干脆采用按冬至日作为一九的开始了。
      还记得小时候学的数九歌吗？
      一九二九不出手，三九四九冰上走，五九六九沿河看柳，七九河开，八九燕来，九九加一九，耕牛遍地走。''',
      '''
      三伏，是初伏、中伏和末伏的统称，是一年中最热的时节。
      民谚云：“夏至三庚入伏，冬至逢壬数九。”
      三伏即是从夏至后第3个庚日算起，初伏为10天，中伏为10天或20天，末伏为10天。当夏至与立秋之间出现4个庚日时中伏为10天，出现5个庚日则为20天。''',
    ];

    // 节气带星期显示 '${lunarDate.getPrevJieQi().getName()}   ${lunarDate.getPrevJieQi().getSolar().toYmdHms()}   星期${lunarDate.getPrevJieQi().getSolar().getWeekInChinese()}',
    // 正文 ListTile 的 title 部分的内容
    _titleList = [
      lunarDate.getDayYi().join(' '),
      lunarDate.getDayJi().join(' '),
      '${lunarDate.getPrevJieQi().getName()}   ${lunarDate.getPrevJieQi().getSolar().toYmdHms()}',
      '${lunarDate.getNextJieQi().getName()}   ${lunarDate.getNextJieQi().getSolar().toYmdHms()}',
      lunarDate.getFoto().toFullString(),
      lunarDate.getTao().toFullString(),
      lunarDate.getBaZiNaYin().join('  '),
      lunarDate.getSolar().getJulianDay().toStringAsFixed(3),
      lunarDate.getSeason(),
      lunarDate.getYueXiang(),
      '${lunarDate.getHou()}，${lunarDate.getWuHou()}',
      '${ly.getYuan()} ${ly.getYun()}',
      ly.getZhiShui(),
      ly.getFenBing(),
      ly.getGengTian(),
      ly.getDeJin(),
      lunarDate.getDayLu().replaceAll(',', '，'),
      lunarDate.getLiuYao(),
      '${lunarDate.getPengZuGan()} ${lunarDate.getPengZuZhi()}',
      lunarDate.getDayJiShen().join(' '),
      lunarDate.getDayXiongSha().join(' '),
      '${lunarDate.getDayShengXiao()}日 冲${lunarDate.getDayChongDesc()}',
      lunarDate.getDaySha(),
      lunarDate.getZheng(),
      '${lunarDate.getGong()}方 ${lunarDate.getXiu()}${lunarDate.getZheng()}${lunarDate.getAnimal()} (${lunarDate.getXiuLuck()})',
      lunarDate.getXiuSong(),
      '阳贵神-${lunarDate.getPositionYangGuiDesc()}  阴贵神-${lunarDate.getPositionYinGuiDesc()}',
      lunarDate.getPositionXiDesc(),
      lunarDate.getPositionFuDesc(),
      lunarDate.getPositionCaiDesc(),
      lunarDate.getMonthPositionTai(),
      lunarDate.getDayPositionTai(),
      lunarDate.getDayPositionTaiSuiDesc(),
      lunarDate.getZhiXing(),
      '${lunarDate.getDayTianShen()}(${lunarDate.getDayTianShenType()}) ${lunarDate.getDayTianShenLuck()}',
      '年-${lunarDate.getYearXunKong()}   月-${lunarDate.getMonthXunKong()}   日-${lunarDate.getDayXunKong()}',
      '${jiuxing.getNumber()}${jiuxing.getColor()} - ${jiuxing.getNameInTaiYi()}星(${jiuxing.getWuXing()}) - ${jiuxing.getTypeInTaiYi()}',
      jiuxing.getSongInTaiYi(),
      lunarDate.getFestivals().join('/') + solarDate.getFestivals().join('/'),
      lunarDate.getOtherFestivals().join('/') + solarDate.getOtherFestivals().join('/'),
      lunarDate.getShuJiu() != null ? lunarDate.getShuJiu()!.toFullString() : '',
      lunarDate.getFu() != null ? lunarDate.getFu()!.toFullString() : '',
    ];

    //  设置  ListTile 的 leading 标题 的样式及内容
    leadingWidget(int index) {
      switch (index) {
        case 2 || 3:
          return TextButton(
            // 点击标题显示对话框
            onPressed: () async {
              customCuDialog(context, '二十四节气', _leadingInfo[index]);
            },
            child: Text(_leadingList[index], style: const TextStyle(fontSize: 15)),
          );

        default:
          return TextButton(
            onPressed: () async {
              customCuDialog(context, _leadingList[index], _leadingInfo[index]);
            },
            child: Text(
              _leadingList[index],
              style: TextStyle(
                  fontSize: 15,
                  color: index == 0
                      ? Colors.green
                      : index == 1
                          ? Colors.red
                          : null),
            ),
          );
      }
    }

    //  设置  正文 ListTile 的 title 的样式
    titleWidget(int index) {
      switch (index) {
        case 0: //宜
          return const TextStyle(
            color: Colors.green,
            fontSize: 15,
          );
        case 1: //忌
          return const TextStyle(
            color: Colors.red,
            fontSize: 15,
          );
        // case isOdd:
        //   return const TextStyle(color: Colors.red);
        default:
          return TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 15,
          );
      }
    }

    return Scaffold(
      // 可以独立设置每个页面的背景颜色，也可以在main主题中设置
      // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        // foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        // shadowColor: Theme.of(context).shadowColor,
        title: GestureDetector(
          child: const Text("万年历"),
          onTap: () {
            Get.to(() => HelpPage());
          },
        ),
        leading: PopupMenuButton(
          tooltip: '更改翻页类型',
            position:PopupMenuPosition.under,
          itemBuilder: (context) {
            // 使用枚举重构changeDateType选择项
            return List.generate(ChangeDateType.values.length, (index) {
              ChangeDateType changeDateType = ChangeDateType.values[index];
              return PopupMenuItem(
                value: index,
                enabled: changeDateType.label != selectedMenuItem,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: changeDateType.icon,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(changeDateType.label),
                    ),
                  ],
                ),
              );
            });
          },
          onSelected: (value) {
            _updateSelectedOption(value);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: selectedIcon, // 修改为与选择相同的图标
          ),
        ),
        actions: [
          IconButton(
            tooltip: '特定日期查询',
            icon: const Icon(
              Icons.edit_calendar_outlined,
              // color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SolarInputDialog(
                    onConfirmPressed: (value) {
                      setState(() {
                        // 从日期时间对话框中传来的文本转换为日期时间类型
                        selectedDate = _stringToDateTime(value);
                      });
                    },
                    // 把万年历页面中的当前日期时间传递给给对话框的日期输入框
                    currentSelectedDateTime: selectedDate!,
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.event_repeat_outlined,
              // color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: '返回今天',
            onPressed: () {
              setState(() {
                selectedDate = DateTime.now();
              });
            },
          ),
        ],
      ),

      /// TODO 双击状态栏返回列表顶端
      body: CustomScrollView(
        slivers: <Widget>[
          // 固定在顶部
          SliverPersistentHeader(
            pinned: true,
            delegate: _MyHeader(
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    // color: Theme.of(context).colorScheme.background,
                    image: DecorationImage(
                      image: AssetImage("assets/images/ubg4.webp"),
                      fit: BoxFit.cover,
                      // 在深色模式下不显示背景图片，设置其透明度为0，浅色模式下透明度经计算公式得到0.2~0.5
                      // opacity: settingsController.useLightMode.value ? settingsController.calculateValue(selectedDate!.hour) : 0,
                      // 不进行计算透明度，固定浅色模式下透明度为0.1，显示图片中场景的大概轮廓。再清晰一点就会干扰视图
                      // opacity: settingsController.useLightMode.value ? 0.1 : 0,
                      // 在深色模式下也显示图片，统一设置成透明度0.1
                      opacity: 0.1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        // ${ld.getSolar().getXingZuo()}座',
                        '${selectedDate?.year}年${selectedDate?.month}月${selectedDate?.day}日 ${selectedDate?.hour}时${selectedDate?.minute}分 周${lunarDate.getWeekInChinese()}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0, top: 8.0, right: 0, bottom: 8.0),
                        // padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              tooltip: '上一$selectedMenuItem',
                              onPressed: () {
                                setState(() {
                                  // 不存在公历日期15821005-1014，1015的前一天会跳到1004
                                  if (selectedDate?.year == 1582 && selectedDate?.month == 10 && selectedDate!.day == 15) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text('公元 1582年10月14日 不存在', textAlign: TextAlign.center),
                                        dismissDirection: DismissDirection.down,
                                      ),
                                    );
                                    selectedDate = DateTime(1582, 10, 4);
                                  } else {
                                    _changeDate('subtract'); // 点击按钮后更新日期
                                  }
                                });
                              },
                              icon: const Icon(Icons.arrow_back_ios_new_rounded),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Badge(
                              // 农历年，若有闫月则带徽章显示，颜色看上去并不明显
                              label: Text(
                                '${LunarYear.fromYear(lunarDate.getYear()).getLeapMonth()}',
                                style: const TextStyle(fontSize: 8),
                              ),
                              isLabelVisible: LunarYear.fromYear(lunarDate.getYear()).getLeapMonth() > 0,
                              offset: const Offset(8, -1),
                              textColor: Theme.of(context).highlightColor,
                              backgroundColor: Colors.transparent,

                              child: Text(
                                // 农历月日 大字号
                                '${lunarDate.getYearInChinese()}年',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  // 随着系统字体缩放比例改变文本大小
                                  // fontSize: 22* MediaQuery.of(context).textScaleFactor,
                                  fontFamily: 'chineseFont',
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            Text(
                              // 农历月日 大字号
                              '${lunarDate.getMonthInChinese()}月${lunarDate.getDayInChinese()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                fontFamily: 'chineseFont',
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            IconButton(
                                tooltip: '下一$selectedMenuItem',
                                onPressed: () {
                                  setState(() {
                                    // 1004的后一天会跳到1015
                                    if (selectedDate?.year == 1582 && selectedDate?.month == 10 && selectedDate!.day == 4) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text('公元 1582年10月5日 不存在', textAlign: TextAlign.center),
                                          dismissDirection: DismissDirection.down,
                                        ),
                                      );
                                      selectedDate = DateTime(1582, 10, 15);
                                    } else {
                                      _changeDate('add');
                                    }
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward_ios_rounded),
                                color: Theme.of(context).colorScheme.primary),
                          ],
                        ),
                      ),
                      Obx(
                        () {
                          return Text(
                              // 年月日时干支，分为 1. 新年以正月初一起算 2. 新年以立春零点起算 3. 新年以立春节气交接的时刻起算 // 新的一月以节交接准确时刻起算 // 流派1，晚子时日柱算明天 流派2，晚子时日柱算当天
                              settingsController.ganZhiLiForWanNianLi(lunarDate, settingsController.selectedGanZhiLi.value),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                shadows: isDark
                                    ? [const BoxShadow(color: Colors.black87, offset: Offset(2.0, 2.0), blurRadius: 3.0)]
                                    : [const BoxShadow(color: Colors.white70, offset: Offset(2.0, 2.0), blurRadius: 3.0)],
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 可滚动的行
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // 构建ListTile和分隔线
                return Container(
                  decoration: BoxDecoration(
                    // 装饰ListTile
                    border: Border.all(
                      // color: fpDataList[index].gender == 1 ? Colors.blueAccent : Colors.pinkAccent, // 边框颜色
                      color: Colors.grey.withAlpha(90), // 边框颜色，这个效果很好
                      // color: const Color.fromRGBO(128, 128, 128, 0.1), // 边框颜色
                      // color: Theme.of(context).colorScheme.outline, // 边框颜色
                      width: 0.1, // 边框宽度
                    ),
                  ),
                  child: ListTile(
                    // tileColor: Colors.white,
                    tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
                    // minLeadingWidth : 10,
                    // visualDensity: VisualDensity.comfortable,
                    // ListTile的高度,最大和最小值是4和-4
                    visualDensity: const VisualDensity(vertical: -4),
                    // dense: true,
                    // 是否可以调整leading所占的宽度，或向左移，以给title更大的宽度
                    contentPadding: const EdgeInsets.only(left: 8.0, right: 10.0),
                    // Adjust leading's width
                    leading: leadingWidget(index),
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Text(_titleList[index]),
                    ),
                    titleTextStyle: titleWidget(index),
                  ),
                );
              },
              // 计算childCount时需要考虑Divider的数量
              childCount: _titleList.length,
            ),
          )
        ],
      ),
    );
  }
}

// 固定在页面顶部的部分，不会随页面滚动
class _MyHeader extends SliverPersistentHeaderDelegate {
  final Widget child;

  _MyHeader({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(2), // 圆角影响背景图片的展示效果
      // shadowColor: const Color(0xFFF7F7F7),
      child: child,
    );
  }

  // 上下滑动时，高度变化范围，相等则不变
  @override
  double get maxExtent => 130.0;

  @override
  double get minExtent => 130.0;

  @override
  bool shouldRebuild(_MyHeader oldDelegate) {
    return true;
  }
}
