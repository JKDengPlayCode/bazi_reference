import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';

import 'package:bazi/pages/bazi_info/bazi_info_logic.dart';

import 'package:bazi/pages/settings_page.dart';


class BaziFanTuiController extends GetxController {
  final SettingsController settingsController = Get.find();
  // 不变项或不反映在界面上的可变项的声明，变则用.obs
  List<String> siZhuList = ['年柱', '月柱', '日柱', '时柱'];
  List<String> tianGanList = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  List<String> diZhiList = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  /// 在用户选择了四柱干支中的一项后提供可选的输入列表
  final optionList = [''].obs;
  // 四柱八字圈上的值：初始化默认值及最终输入的八字
  RxString yearGan = '干'.obs;
  RxString yearZhi = '支'.obs;
  RxString monthGan = '干'.obs;
  RxString monthZhi = '支'.obs;
  RxString dayGan = '干'.obs;
  RxString dayZhi = '支'.obs;
  RxString hourGan = '干'.obs;
  RxString hourZhi = '支'.obs;

  // 四柱八字圈待输入项，即当前被选中项
  RxInt selectedGanIndex = 0.obs;
  RxInt selectedZhiIndex = 99.obs;

  // 四柱八字圈是否已被赋值，只有前置项被赋值，才能点选并修改后置项，修改前置项会触发后置项进行检验
  // RxBool isAllSet = false.obs;
  bool yearGanSet = false;
  bool yearZhiSet = false;
  // 月干月支会同时被赋值
  bool monthGanZhiSet = false;
  bool dayGanSet = false;
  bool dayZhiSet = false;
  // 时干时支会同时被赋值
  bool hourGanZhiSet = false;

  // 是否显示动画效果，提醒用户输入
  // RxBool yearGanSelectAnimate = false.obs;
  // RxBool dayGanSelectAnimate = false.obs;
  // 年偏移量的甲子倍数，用于yearOffset
  RxInt jiaZiBeiShu = 0.obs;
  // 是否找到结果
  RxBool findSomething = false.obs;

  @override
  void onInit() {
    // 初始化时，选择年柱天干，并提供10天干作为输入选项
    optionList.value = tianGanList;
    super.onInit();
  }

  // 年干圈被选中时，不选中任何支圈，备选项为天干列表
  void selectYearGan() {
    selectedGanIndex.value = 0;
    selectedZhiIndex.value = 99;
    optionList.value = tianGanList;
  }

  // 年支被选中时，备选项为 根据当前选择的年干返回的列表
  void selectYearZhi() {
    if (yearGanSet) {
      selectedGanIndex.value = 99;
      selectedZhiIndex.value = 0;
      optionList.value = ganZhiPei(yearGan.value);
    }
  }

  // 月干/月支被同时选中，备选项为 根据当前选择的年干返回的五虎遁列表，含月干和月支
  void selectMonthGanZhi() {
    if (yearGanSet) {
      selectedGanIndex.value = 1;
      selectedZhiIndex.value = 1;
      optionList.value = wuHuDun(yearGan.value);
    }
  }

  // 日干被选中时，备选项为天干列表
  void selectDayGan() {
    selectedGanIndex.value = 2;
    selectedZhiIndex.value = 99;
    optionList.value = tianGanList;
  }

  // 日支被选中时，备选项为 根据当前选择的日干返回的列表
  void selectDayZhi() {
    if (dayGanSet) {
      selectedGanIndex.value = 99;
      selectedZhiIndex.value = 2;
      optionList.value = ganZhiPei(dayGan.value);
    }
  }

  // 时干/时支被同时选中，备选项为 根据当前选择的日干返回的五鼠遁列表，含时干和时支
  void selectHourGanZhi() {
    if (dayGanSet) {
      selectedGanIndex.value = 3;
      selectedZhiIndex.value = 3;
      optionList.value = wuShuDun(dayGan.value);
    }
  }

  // 当表格/optionList中的选项被点击后
  void onOptionSelected(String optionsValue) {
    // 获取当前被选中项是哪个干哪个支
    int ganIndex = selectedGanIndex.value;
    int zhiIndex = selectedZhiIndex.value;
    switch (ganIndex) {
      // 年干圈被选中，赋值给年干，自动选中到下一个圈
      case 0:
        // 把所选年干值赋值给年干圈
        yearGan.value = optionsValue;
        // 标记年干圈已被赋值
        yearGanSet = true;
        // 对后置项进行检验
        // 如果年支已被赋值，但新选年干与现有年支不匹配
        if (yearZhiSet && !yearGanZhiCheck()) {
          yearZhi.value = '支';
          yearZhiSet = false;
        }
        // 如果月干支已被赋值，但新选年干与现有月干支不匹配
        if (monthGanZhiSet && !wuHuDunCheck()) {
          monthGan.value = '干';
          monthZhi.value = '支';
          monthGanZhiSet = false;
        }
        // 自动点选年支圈
        selectYearZhi();
      case 1:
        monthGan.value = optionsValue[0];
        monthZhi.value = optionsValue[1];
        monthGanZhiSet = true;
        selectDayGan();
      case 2:
        dayGan.value = optionsValue;
        dayGanSet = true;
        // 对后置项进行检验
        // 如果日支已被赋值，但新选日干与现有日支不匹配
        if (dayZhiSet && !dayGanZhiCheck()) {
          dayZhi.value = '支';
          dayZhiSet = false;
        }
        if (hourGanZhiSet && !wuShuDunCheck()) {
          hourGan.value = '干';
          hourZhi.value = '支';
          hourGanZhiSet = false;
        }
        selectDayZhi();
      case 3:
        hourGan.value = optionsValue[0];
        hourZhi.value = optionsValue[1];
        hourGanZhiSet = true;
        selectedGanIndex.value = 99;
        selectedZhiIndex.value = 99;
    }
    switch (zhiIndex) {
      case 0:
        // 把值赋给年支
        yearZhi.value = optionsValue;
        yearZhiSet = true;
        // 自动点选月干支圈
        selectMonthGanZhi();
      case 1:
        monthGan.value = optionsValue[0]; // 把备选项中的天干赋值给月干
        monthZhi.value = optionsValue[1]; // 把备选项中的地支赋值给月支
        monthGanZhiSet = true;
        selectDayGan();
      case 2:
        dayZhi.value = optionsValue;
        dayZhiSet = true;
        selectHourGanZhi();
      case 3:
        hourGan.value = optionsValue[0];
        hourZhi.value = optionsValue[1];
        hourGanZhiSet = true;
        selectedGanIndex.value = 99;
        selectedZhiIndex.value = 99;
    }
    // print(
    //     '${yearGan.value}${yearZhi.value} ${monthGan.value}${monthZhi.value} ${dayGan.value}${dayZhi.value} ${hourGan.value}${hourZhi.value}');
  }

  /// 是否已经全部赋值，用来决定‘查询’按钮是否可用。当全部赋值后，程序自动查询本轮甲子/过去中最近的一个匹配项
  RxBool isAllSet() {
    if (yearGanSet && yearZhiSet && monthGanZhiSet && dayGanSet && dayZhiSet && hourGanZhiSet) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  // 四个功能按钮的可用状态
  /// 在过去甲子中查找 按钮的可用状态
  RxBool pastJiaZiEnabled() {
    if (isAllSet().value) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  /// 在当前甲子中查找 按钮的可用状态
  RxBool currentJiaZiEnabled() {
    if (jiaZiBeiShu.value == 0) {
      return false.obs;
    } else {
      return true.obs;
    }
  }

  /// 在未来甲子中查找 按钮的可用状态
  RxBool futureJiaZiEnabled() {
    if (isAllSet().value) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  /// 清空输入 按钮的可用状态
  RxBool resetInputEnabled() {
    if (yearGanSet || yearZhiSet || monthGanZhiSet || dayGanSet || dayZhiSet || hourGanZhiSet) {
      return true.obs;
    } else {
      return false.obs;
    }
  }

  /// 八字反查结果，返回查询到的公历/农历日期时间字符串
  /// 每个.getEightChar()后面都要跟一个晚子时流派设置.setSect(1)
  RxString getResult() {
    // print('甲子倍数：$jiaZiBeiShu');
    // 当输入完成后，自动执行。
    if (isAllSet().value) {
      //sect = (1 == sect) ? 1 : 2; // 读取并设置晚子时流派
      //  今天现在时刻的农历日期，现在是节有影响吗？
      Lunar nowLunarDate = Lunar.fromDate(DateTime.now());
      int nowLunarYear = nowLunarDate.getYear();
      // 获取今天的 八字
      EightChar nowEightChar = nowLunarDate.getEightChar();
      nowEightChar.setSect(1);
      // 以八字规则 立春交接时刻起 今天的年干支及在60甲子列表中的索引
      String nowYearGanZhi = nowEightChar.getYear();
      int nowYearGanZhiIndex = LunarUtil.JIA_ZI.indexOf(nowYearGanZhi);

      // 待查询八字
      String queryYearGanZhi = '${yearGan.value}${yearZhi.value}';
      String queryMonthGanZhi = '${monthGan.value}${monthZhi.value}';
      String queryDayGanZhi = '${dayGan.value}${dayZhi.value}';
      String queryTimeGanZhi = '${hourGan.value}${hourZhi.value}';
      // print('待查询八字：$queryYearGanZhi $queryMonthGanZhi $queryDayGanZhi $queryTimeGanZhi');
      // 待查 年柱 在甲子表中的索引
      int queryYearGanZhiIndex = LunarUtil.JIA_ZI.indexOf(queryYearGanZhi);

      //  计算偏移年数，获取与待查年柱相同的年份。在当前一个甲子内未找到，则偏移+-60
      int yearOffset = nowYearGanZhiIndex - queryYearGanZhiIndex;
      int tempYear = nowLunarYear - (yearOffset + 60 * jiaZiBeiShu.value);
      // print('两者相差: $yearOffset 年');
      // print('查: $tempYear 年');
      // Lunar包/公元前的查不了，到公元前时，自动返回当前甲子轮，公元1万年以后也查不了
      if (tempYear < 0 || tempYear > 9000) {
        currentJiaZi();
      }
      // 以这一年的农历正月初一为基准，查当年节气大表，如不作此日期设定可能会查到下一年的节气大表
      Lunar tempYearLunarDate = Lunar.fromYmd(tempYear, 1, 1); // 农历正月初一，还是设置立春交接时刻？
      // EightChar tempEightChar = tempLunarDate.getEightChar();
      // tempEightChar.setSect(1);
      // 待查 月柱 的位序
      int queryMonthGanZhiIndex = MONTH_ZHI_LIST.indexOf(queryMonthGanZhi[1]);
      // 查月柱 对应的 十二节 具体时刻
      String queryMonthJie = JIE_FOR_MONTH[queryMonthGanZhiIndex];
      Solar? queryMonthJieTime = tempYearLunarDate.getJieQiTable()[queryMonthJie];
      // 节交接具体时刻的 八字
      Lunar tempLunaDate1 = Lunar.fromSolar(queryMonthJieTime!);
      EightChar tempEightChar1 = tempLunaDate1.getEightChar();
      tempEightChar1.setSect(1);
      // print('本月开始节交接:$queryMonthJieTime 八字: $tempEightChar1');
      // 如果 节交接具体时刻的八字 与待查八字相同，则直接返回结果
      if (tempEightChar1.getYear() == queryYearGanZhi &&
          tempEightChar1.getMonth() == queryMonthGanZhi &&
          tempEightChar1.getDay() == queryDayGanZhi &&
          tempEightChar1.getTime() == queryTimeGanZhi) {
        findSomething.value = true;
        return '$tempLunaDate1   ${queryMonthJieTime.toYmdHms()}'.obs;
      }
      // 从节气大表中获取 下一节
      Map<String, Solar> jieQi = tempYearLunarDate.getJieQiTable(); // 这是个Map<String, Solar> Function()
      // 将节气的key值转为列表
      List<String> jieQiKeysList = jieQi.keys.toList();
      // 待查 月柱 对应节在列表中的索引 +1
      int queryMonthJieIndex = jieQiKeysList.indexOf(queryMonthJie);
      String tempMonthNextJie = jieQiKeysList[queryMonthJieIndex + 2];
      Solar? tempMonthNextJieTime = jieQi[tempMonthNextJie];
      // print('下月开始节交接:$tempMonthNextJieTime');
      // 下一节 减去 这一节 相差的天数
      int tempDayCount = tempMonthNextJieTime!.subtract(queryMonthJieTime) + 1;

      /// 特殊处理：下一节那天从子时开始的时刻 到 下一节开始的时刻：当天前面的时辰还属于这期间
      /// 正常处理：从这一节开始时刻开始查找 \n 逐一比对【这一节开始时刻 到 下一节那天同一时刻】 期间每天的干支
      for (int i = 0; i < tempDayCount; i++) {
        // 第i=0天 待验日期的时间是这一节开始的精准时刻
        // 以后第i>0天，尤其是下一节交接那天，设定从23点开始计算
        Lunar tempLunarDate;
        EightChar tempGanZhi;
        int tempSolarDay;
        int tempSolarMonth;
        int tempSolarYear;
        if (i == 0) {
          tempSolarYear = queryMonthJieTime.getYear();
          tempSolarMonth = queryMonthJieTime.getMonth();
          tempSolarDay = queryMonthJieTime.getDay();
          tempLunarDate = Lunar.fromSolar(queryMonthJieTime); // 取节接的精确时刻
          tempGanZhi = tempLunarDate.getEightChar();
          tempGanZhi.setSect(1);
          // print('111查 $i ：$tempGanZhi');
        } else {
          // 节的下一天，但考虑到节交接的精确时刻前后月干支会改变，所以用i-1=0对节这天重新判断
          Solar tempSolarDate = queryMonthJieTime.nextDay(i-1);
          tempSolarYear = tempSolarDate.getYear();
          tempSolarMonth = tempSolarDate.getMonth();
          tempSolarDay = tempSolarDate.getDay();
          // 把时辰设置为公历的子时23点，实际上是干支的第二天
          tempLunarDate = Lunar.fromSolar(Solar.fromYmdHms(tempSolarYear, tempSolarMonth, tempSolarDay, 23, 0, 0));
          tempGanZhi = tempLunarDate.getEightChar();
          tempGanZhi.setSect(1);
          // print('222查 $i ：$tempGanZhi $tempSolarYear-$tempSolarMonth-$tempSolarDay');
        }
        // print('333查 $i ：$tempGanZhi $tempSolarYear-$tempSolarMonth-$tempSolarDay');
        String tempYearGanZhi = tempGanZhi.getYear();
        String tempMonthGanZhi = tempGanZhi.getMonth();
        String tempDayGanZhi = tempGanZhi.getDay();
        // String tempTimeGanZhi = tempGanZhi.getTime();
        // Lunar findTheDayLunarDate = Lunar.fromSolar(queryMonthJieTime.nextDay(i));
        // Solar findTheDaySolarDate = queryMonthJieTime.nextDay(i);
        if (tempYearGanZhi == queryYearGanZhi &&
            tempMonthGanZhi == queryMonthGanZhi &&
            tempDayGanZhi == queryDayGanZhi) {
          // 再找到时柱对应的时辰就OK了          // int findSolarDay = queryMonthJieTime.nextDay(i).getDay();
          int findTime = HOUR_FOR_TIME[TIME_ZHI_LIST.indexOf(queryTimeGanZhi[1])];

          // 构造 公历/农历 结果，由于前面把时辰设置为公历的子时23点，实际上是干支的第二天，所以nexDay(1)，不能直接day+1否则会出现day=32号的错误
          // 如果是子时 或 节 当天，日期不加1
          Solar findTheDaySolarDate;
          if(i==0 || findTime==23){
            findTheDaySolarDate =
                Solar.fromYmdHms(tempSolarYear, tempSolarMonth, tempSolarDay, findTime, 0, 0);
          }else{
            findTheDaySolarDate = Solar.fromYmdHms(tempSolarYear, tempSolarMonth, tempSolarDay, findTime, 0, 0).nextDay(1);
          }

          // Solar findTheDaySolarDate =
          //     Solar.fromYmdHms(tempSolarYear, tempSolarMonth, tempSolarDay, findTime, 0, 0).nextDay(1);
          Lunar findTheDayLunarDate = Lunar.fromSolar(findTheDaySolarDate);
          EightChar findGanZhi = findTheDayLunarDate.getEightChar();
          findGanZhi.setSect(1);
          // 没有必要再判断时柱是否相同？晚子时流派设置正确 与23点为一天的开始相对应 getEightChar().setSect(1)
          // print('$i : $findGanZhi => $findTheDayLunarDate / ${findTheDaySolarDate.toYmdHms()}');
          // 以农历/公历样式显示结果
          findSomething.value = true;
          return '$findTheDayLunarDate   ${findTheDaySolarDate.toYmdHms()}'.obs;
        }
      }
      findSomething.value = false;
      // 当未找到结果时，默认自动向过去寻找直到找到一个结果
      while (!findSomething.value && isPastButtonClick) {
        jiaZiBeiShu++;
        getResult();
      }
      while (!findSomething.value && !isPastButtonClick) {
        jiaZiBeiShu--;
        getResult();
      }
    } else {
      jiaZiBeiShu.value = 0;
      findSomething.value = false;
      return ''.obs;
    }
    return ''.obs;
  }

  /// 点击反查结果，将结果的公历日期时间发送给生辰输入框(没必要提供农历、公历两种显示形式)
  void selectedResult() {
    // 定义 输出给生辰输入框的格式。格式中的大小写代表含义不同结果也不同
    DateFormat outputYMDFormat = DateFormat('yyyyMMddHHmmss');
    // DateFormat outputBirthdayLabelFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    // 取结果中的公历日期，按格式输出并赋值给生辰框
    // print(getResult());
    String theSolarDateString = getResult().split('   ')[1];
    String birthday = outputYMDFormat.format(DateTime.parse(theSolarDateString));
    // String birthdayLabel = outputBirthdayLabelFormat.format(DateTime.parse(theSolarDateString));
    BaziInforController baziInforController = Get.find();
    baziInforController.birthdayController.text = birthday;
    // 调用生辰输入框的内容改动方法，自动给生辰框的标签赋值
    baziInforController.birthdayFieldOnChange();
  }

  // 手动点击了向前、向后按钮？ 默认向前寻找
  bool isPastButtonClick = true;

  /// 向前查 按钮
  void pastJiaZi() {
    isPastButtonClick = true;
    jiaZiBeiShu.value++;
    getResult();
  }

  /// 返回当前甲子 按钮
  void currentJiaZi() {
    // 当前甲子中找不到结果的话，也向前寻找
    isPastButtonClick = true;
    jiaZiBeiShu.value = 0;
    getResult();
  }

  /// 向后查 按钮
  void futureJiaZi() {
    isPastButtonClick = false;
    jiaZiBeiShu.value--;
    getResult();
  }

  /// 重置按钮
  void resetInput() {
    yearGan.value = monthGan.value = dayGan.value = hourGan.value = '干';
    yearZhi.value = monthZhi.value = dayZhi.value = hourZhi.value = '支';
    yearGanSet = yearZhiSet = monthGanZhiSet = dayGanSet = dayZhiSet = hourGanZhiSet = false;
    optionList.value = tianGanList;
    selectedGanIndex.value = 0; // 选中年干
    selectedZhiIndex.value = 99; // 99不存在，即不选中任何支
    // 将甲子倍数置为0
    jiaZiBeiShu.value = 0;
    isPastButtonClick = true;
    findSomething.value = false;
  }

  /// 五虎遁：从年干获取月干支列表   年干决定月干，12月支固定从寅月开始
  List<String> wuHuDun(String yearGan) {
    switch (yearGan) {
      case '甲':
      case '己':
        return ['丙寅', '丁卯', '戊辰', '己巳', '庚午', '辛未', '壬申', '癸酉', '甲戌', '乙亥', '丙子', '丁丑'];
      case '乙':
      case '庚':
        return ['戊寅', '己卯', '庚辰', '辛巳', '壬午', '癸未', '甲申', '乙酉', '丙戌', '丁亥', '戊子', '己丑'];
      case '丙':
      case '辛':
        return ['庚寅', '辛卯', '壬辰', '癸巳', '甲午', '乙未', '丙申', '丁酉', '戊戌', '己亥', '庚子', '辛丑'];
      case '丁':
      case '壬':
        return ['壬寅', '癸卯', '甲辰', '乙巳', '丙午', '丁未', '戊申', '己酉', '庚戌', '辛亥', '壬子', '癸丑'];
      case '戊':
      case '癸':
      default:
        return ['甲寅', '乙卯', '丙辰', '丁巳', '戊午', '己未', '庚申', '辛酉', '壬戌', '癸亥', '甲子', '乙丑'];
    }
  }

  /// 五鼠遁：从日干获取时干支列表   日干决定时干，12时支固定从子时开始
  List<String> wuShuDun(String dayGan) {
    switch (dayGan) {
      case '甲':
      case '己':
        return ['甲子', '乙丑', '丙寅', '丁卯', '戊辰', '己巳', '庚午', '辛未', '壬申', '癸酉', '甲戌', '乙亥'];
      case '乙':
      case '庚':
        return ['丙子', '丁丑', '戊寅', '己卯', '庚辰', '辛巳', '壬午', '癸未', '甲申', '乙酉', '丙戌', '丁亥'];
      case '丙':
      case '辛':
        return ['戊子', '己丑', '庚寅', '辛卯', '壬辰', '癸巳', '甲午', '乙未', '丙申', '丁酉', '戊戌', '己亥'];
      case '丁':
      case '壬':
        return ['庚子', '辛丑', '壬寅', '癸卯', '甲辰', '乙巳', '丙午', '丁未', '戊申', '己酉', '庚戌', '辛亥'];
      case '戊':
      case '癸':
      default:
        return ['壬子', '癸丑', '甲寅', '乙卯', '丙辰', '丁巳', '戊午', '己未', '庚申', '辛酉', '壬戌', '癸亥'];
    }
  }

  ///干支阴阳配：可获取年干对应的年支 及日干对应的日支 //阴配阴阳配阳，奇对奇偶对偶
  List<String> ganZhiPei(String gan) {
    switch (gan) {
      case '甲':
      case '丙':
      case '戊':
      case '庚':
      case '壬':
        return ['子', '寅', '辰', '午', '申', '戌'];
      case '乙':
      case '丁':
      case '己':
      case '辛':
      case '癸':
      default:
        return ['丑', '卯', '巳', '未', '酉', '亥'];
    }
  }

  /// 当月干已被赋值，年干被重新赋值时，根据五虎遁判断月干支是否正确
  bool wuHuDunCheck() {
    if (wuHuDun(yearGan.value).contains('${monthGan.value}${monthZhi.value}')) {
      return true;
    } else {
      return false;
    }
  }

  /// 当时干已被赋值，日干被重新赋值时，根据五鼠遁判断时干支是否正确
  bool wuShuDunCheck() {
    if (wuShuDun(dayGan.value).contains('${hourGan.value}${hourZhi.value}')) {
      return true;
    } else {
      return false;
    }
  }

  /// 年干被重新赋值时，根据干支阴阳配判断年支是否正确
  bool yearGanZhiCheck() {
    if (ganZhiPei(yearGan.value).contains(yearZhi.value)) {
      return true;
    } else {
      return false;
    }
  }

  /// 日干被重新赋值时，根据干支阴阳配判断日支是否正确
  bool dayGanZhiCheck() {
    if (ganZhiPei(dayGan.value).contains(dayZhi.value)) {
      return true;
    } else {
      return false;
    }
  }

  /// 用十二节划分月份
  static final List<String> JIE_FOR_MONTH = [
    '立春',
    '惊蛰',
    '清明',
    '立夏',
    '芒种',
    '小暑',
    '立秋',
    '白露',
    '寒露',
    '立冬',
    '大雪',
    'XIAO_HAN'
  ];

  /// 日支顺序列表
  static final List<String> TIME_ZHI_LIST = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  /// 月支顺序列表，每一个干支年的第一个干支纪月：总是寅月
  static final List<String> MONTH_ZHI_LIST = ['寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥', '子', '丑'];

  /// 按时柱查找的时辰，取每个时辰的起始时刻。不用下一行的中间一个整点时刻。如从23时到1时，对应子时
  static final List<int> HOUR_FOR_TIME = [
    23, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19, 21,
    // 0,2,4,6,8,10,12,14,16,18,20,22,
  ];
}
