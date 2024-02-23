import 'package:bazi/pages/bazi_detail/bazi_detail_page.dart';
import 'package:bazi/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:bazi/pages/bazi_result/bazi_lunar.dart';
import 'package:bazi/components/city_pickers-1.3.0/lib/modal/result.dart';
import 'package:bazi/common/classPersonData.dart';
import 'package:get/get.dart';

import 'package:bazi/common/shen_sha_static.dart';
import 'package:bazi/components/customGetXDialog.dart';
import 'package:bazi/pages/bazi_result/bazi_query_page.dart';

/// 命盘，对信息进行初步处理显示
class BaziResultPage extends StatefulWidget {
  const BaziResultPage({super.key, required this.person});

  final PersonData person;

  @override
  State<BaziResultPage> createState() => _BaziResultPageState();
}

class _BaziResultPageState extends State<BaziResultPage> {
  late PersonData personData;
  final SettingsController settingsController = Get.find();
  // DateTime? selectedDate = DateTime.now();
  // 大运索引，用于和流年、流月、流日、流时联动
  int currentDaYunIndex = 1;
  int currentLiuYearIndex = 0;
  int currentLiuMonthIndex = 0;
  int currentLiuDayIndex = 0;
  int currentLiuHourIndex = -1; //
  late MyLunar getAll;

  @override
  void initState() {
    super.initState();
    // 初始化person各项信息、自定义类进行运算
    personData = widget.person;
    getAll = MyLunar.getAll(personData, settingsController.selectedZiShiPai.value, settingsController.selectedQiYunPai.value);
    // 初始化大运、流年索引所在位置，如果当前年在大运流年表中，则置为当前显示大运、流年。若在build()方法中定义则不能点选！
    currentDaYunIndex = getAll.rt()['getCurrentIndex'][0];
    currentLiuYearIndex = getAll.rt()['getCurrentIndex'][1];
    currentLiuMonthIndex = getAll.rt()['getCurrentIndex'][2];
    currentLiuDayIndex = getAll.rt()['getCurrentIndex'][3];
  }

  @override
  Widget build(BuildContext context) {
    // tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
    // ListTileThemeData(tileColor: Theme.of(context).colorScheme.surface);
    // 定义person各项信息
    // 简单的在这取，复杂的在MyLunar类中运算
    String name = personData.name;
    int gender = personData.gender;
    Result birthLocation = personData.birthLocation;

    // 大运 Table
    TableRow buildDaYunTableRow(String title, String Function(int) getValue, dynamic titleColor, int corner) {
      // int daYunLength = getAll.rt()['daYun'].length;
      // print(getAll.rt()['daYun'][0].toString());
      return TableRow(
        children: <Widget>[
          // _titleContainer(title),
          for (var i = 0; i < 10; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  currentDaYunIndex = i;
                  currentLiuYearIndex = 0;
                  currentLiuMonthIndex = 0;
                  currentLiuDayIndex = 0;
                  currentLiuHourIndex = -1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: currentDaYunIndex == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onInverseSurface,
                  // 给表格中的四角单元格一个圆角,[corner]=1代表第一行，=2代表最后一个行，=0代表中间行不设置返回null。[currentLiuYearIndex]=0第一列，length-1是最后一列
                  borderRadius: currentDaYunIndex == 0 && corner == 1 //第1列左上角
                      ? const BorderRadius.only(topLeft: Radius.circular(6.0))
                      : currentDaYunIndex == 9 && corner == 1
                      ? const BorderRadius.only(topRight: Radius.circular(6.0))
                      : currentDaYunIndex == 0 && corner == 2
                      ? const BorderRadius.only(bottomLeft: Radius.circular(6.0))
                      : currentDaYunIndex == 9 && corner == 2
                      ? const BorderRadius.only(bottomRight: Radius.circular(6.0))
                      : null,
                ),
                child: Text(
                  getValue(i) == '' ? '小运' : getValue(i),
                  textAlign: TextAlign.center,
                  // 文字颜色，选中时是红色，标题或特殊标注时，给定颜色参数titleColor，无特殊情况给null
                  style: TextStyle(fontSize: 12, color: currentDaYunIndex == i ? Theme.of(context).colorScheme.onPrimary : titleColor),
                ),
              ),
            ),
        ],
      );
    }

    /// 流年 Table
    /// [title] 表头（不使用，仅标识）；[getValue]获取要显示的字符串；[titleColor]字符颜色； [corner]控制边角圆角；
    /// [changFontColor]点击选中时是否改变字符颜色，这里控制的是选中流年时，其小运的显示颜色不变
    TableRow buildLiuYearTableRow(String title, String Function(int) getValue, dynamic titleColor, int corner, bool changFontColor) {
      int liuNianLength = getAll.rt()['daYun'][currentDaYunIndex].getLiuNian().length;
      return TableRow(
        children: <Widget>[
          // _titleContainer(title),
          for (var i = 0; i < liuNianLength; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  currentLiuYearIndex = i;
                  currentLiuMonthIndex = 0;
                  currentLiuDayIndex = 0;
                  currentLiuHourIndex = -1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: currentLiuYearIndex == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onInverseSurface,
                  // 给表格中的四角单元格一个圆角,[corner]=1代表第一行，=2代表最后一个行。
                  // [currentLiuYearIndex]=0第一列，liuNianLength - 1是流年的最后一列，9是表格的最后一列
                  borderRadius: currentLiuYearIndex == 0 && corner == 1 //第1列左上角
                      ? const BorderRadius.only(topLeft: Radius.circular(6.0))
                      : currentLiuYearIndex == 9 && corner == 1
                      ? const BorderRadius.only(topRight: Radius.circular(6.0))
                      : currentLiuYearIndex == 0 && corner == 2
                      ? const BorderRadius.only(bottomLeft: Radius.circular(6.0))
                      : currentLiuYearIndex == 9 && corner == 2
                      ? const BorderRadius.only(bottomRight: Radius.circular(6.0))
                      : null,
                ),
                child: Text(
                  getValue(i),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: changFontColor
                          ? currentLiuYearIndex == i
                          ? Theme.of(context).colorScheme.onPrimary
                          : titleColor
                          : titleColor),
                ),
              ),
            ),
          // 流年小于10，留空，如起运前的小运年数可能是1到10不等
          for (var j = 0; j < 10 - liuNianLength; j++) Container(),
        ],
      );
    }

    // 流月 Table
    TableRow buildLiuMonthTableRow(String title, String Function(int) getValue, dynamic titleColor, int corner) {
      return TableRow(
        children: <Widget>[
          // _titleContainer(title),
          for (var i = 0; i < 12; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  currentLiuMonthIndex = i;
                  currentLiuDayIndex = 0;
                  currentLiuHourIndex = -1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: currentLiuMonthIndex == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onInverseSurface,
                  // 给表格中的四角单元格一个圆角,[corner]=1代表第一行，=2代表最后一个行。
                  // [currentLiuYearIndex]=0第一列，liuNianLength - 1是流年的最后一列，9是表格的最后一列
                  borderRadius: currentLiuMonthIndex == 0 && corner == 1 //第1列左上角
                      ? const BorderRadius.only(topLeft: Radius.circular(6.0))
                      : currentLiuMonthIndex == 11 && corner == 1
                      ? const BorderRadius.only(topRight: Radius.circular(6.0))
                      : currentLiuMonthIndex == 0 && corner == 2
                      ? const BorderRadius.only(bottomLeft: Radius.circular(6.0))
                      : currentLiuMonthIndex == 11 && corner == 2
                      ? const BorderRadius.only(bottomRight: Radius.circular(6.0))
                      : null,
                ),
                child: Text(
                  getValue(i),
                  softWrap: true, // 允许自动换行
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: currentLiuMonthIndex == i ? Theme.of(context).colorScheme.onPrimary : titleColor),
                ),
              ),
            ),
        ],
      );
    }

    /// 流日 Table [iCount]从第iCount-10开始显示，每行显示10个日期 ;;显示当月的流日
    TableRow buildLiuDayTableRow2(String title, String Function(int) getValue, int iCount, dynamic titleColor, int corner) {
      int dayCounts = getAll.liuYue(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex).getDayCounts();

      return TableRow(
        children: <Widget>[
          // _titleContainer(title),
          // 每10个日期占一行
          for (var i = 0; i < 10; i++)
          // 当流日表格序号在流月范围内时，可点击选中
            if (iCount + i < dayCounts)
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentLiuDayIndex = iCount + i;
                    currentLiuHourIndex = -1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: currentLiuDayIndex == iCount + i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onInverseSurface,
                    // 给表格中的四角单元格一个圆角,[corner]=1代表第一行top，=2代表最后一个行bottom，=0时不应用圆角。
                    // 指定圆角的位置，如topLeft bottomRight
                    // [currentLiuDayIndex]=0 第1列第1个，=9 第1列最后1个
                    borderRadius: currentLiuDayIndex == 0 && corner == 1 //第1列左上角
                        ? const BorderRadius.only(topLeft: Radius.circular(6.0))
                        : currentLiuDayIndex == 9 && corner == 1
                        ? const BorderRadius.only(topRight: Radius.circular(6.0))
                        : currentLiuDayIndex == 30 && corner == 2
                        ? const BorderRadius.only(bottomLeft: Radius.circular(6.0))
                        : currentLiuDayIndex == 20 && corner == 2
                        ? const BorderRadius.only(bottomLeft: Radius.circular(6.0))
                        : currentLiuDayIndex == 29 && corner == 2
                        ? const BorderRadius.only(bottomRight: Radius.circular(6.0))
                        : null,
                  ),
                  child: Text(
                    iCount + i < dayCounts ? getValue(iCount + i) : '',
                    softWrap: true, // 允许自动换行
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: currentLiuDayIndex == iCount + i ? Theme.of(context).colorScheme.onPrimary : titleColor),
                  ),
                ),
              )
            // 当流日表格序号不在流月范围内时，返回空格，不能点击
            else if (iCount + i >= dayCounts)
              Container(),
        ],
      );
    }

    // 流时 Table
    TableRow buildLiuHourTableRow(String title, String Function(int) getValue, dynamic titleColor, double fontSize, int corner) {
      // 获取时辰空干支的索引，可能不存在空干支则都=-1，i值[0~11]肯定都大于-1，为真
      // 可能存在7～11 0～5，在i小于emptyStartIndex=7或大于emptyEndIndex=5时，为真
      int emptyStartIndex = getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, currentLiuDayIndex).getLiuShi().indexOf('');
      int emptyEndIndex = getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, currentLiuDayIndex).getLiuShi().lastIndexOf('');
      return TableRow(
        children: <Widget>[
          // _titleContainer(title),
          for (var i = 0; i < 12; i++)
          // 给非空干支的时辰添加手势，可点击选中
            if (i < emptyStartIndex || i > emptyEndIndex)
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentLiuHourIndex = i;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: currentLiuHourIndex == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onInverseSurface,
                    // 给表格中的四角单元格一个圆角,[corner]=1代表第一行，=2代表最后一个行，=0时不应用圆角。
                    // [currentLiuDayIndex]=0 第1列第1个，=9 第1列最后1个
                    borderRadius: currentLiuHourIndex == 0 && corner == 1 //第1列左上角
                        ? const BorderRadius.only(topLeft: Radius.circular(6.0))
                        : currentLiuHourIndex == 11 && corner == 1
                        ? const BorderRadius.only(topRight: Radius.circular(6.0))
                        : currentLiuHourIndex == 0 && corner == 2
                        ? const BorderRadius.only(bottomLeft: Radius.circular(6.0))
                        : currentLiuHourIndex == 11 && corner == 2
                        ? const BorderRadius.only(bottomRight: Radius.circular(6.0))
                        : null,
                  ),
                  child: Text(
                    getValue(i),
                    softWrap: true, // 允许自动换行
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: fontSize, color: currentLiuHourIndex == i ? Theme.of(context).colorScheme.onPrimary : titleColor),
                  ),
                ),
              )
            else
              Container(
                color: currentLiuHourIndex == i ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onInverseSurface,
                child: Text(
                  getValue(i),
                  softWrap: true, // 允许自动换行
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: fontSize, color: currentLiuHourIndex == i ? Theme.of(context).colorScheme.onPrimary : titleColor),
                ),
              ),
        ],
      );
    }

    // 根据 hideGan 中的值设置对应的文本样式 藏干
    Container richTextContainer(List<String> myList) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            for (String text in myList)
              Text(
                text,
                style: TextStyle(
                  // fontFamily: 'chineseFont',
                  // 藏干 要颜色还是不要颜色
                  color: getAll.getColorForValue(text),
                  // color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 13,
                  // fontWeight: FontWeight.w500,
                ),
              ) // 获取每个值对应的颜色)
          ],
        ),
      );
    }

    /// 根据 纳音 最后一个五行，获取颜色 // 暗八字 颜色
    GestureDetector naYinContainerMatchColor(text) {
      return GestureDetector(
        onTap: () async {
          var naYinTip = naYinTips.where((item) => item['name'] == text).toList();
          customCuDialog(context, text, '${naYinTip[0]['tip']}\n\n${naYinTip[0]['book1']}');
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              // fontFamily: 'chineseFont',
              // 要不要颜色？
              // color: getAll.getColorForNaYinValue(text),
              fontSize: 13,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    /// 地势、自坐行，带提示
    GestureDetector diShiContainer(String text) {
      return GestureDetector(
        onTap: () async {
          var zhangShengTip = zhangShengTips.where((item) => item['name'] == text).toList();
          customCuDialog(context, text, '${zhangShengTip[0]['shijue']}\n\n${zhangShengTip[0]['chafa']}');
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    /// 表格-五行旺相休囚死
    Container wangShuaiRowContainer(String text) {
      return Container(
        alignment: Alignment.center,
        // 扩展垂直方向的高度，也可用合适的 height:30
        // color: getAll.getColorForNaYinValue(text),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: getAll.getColorForNaYinValue(text[0]),
            )),
      );
    }

    Text textMatchColor(text) {
      return Text(
        text,
        style: TextStyle(
          fontFamily: 'chineseFont',
          color: getAll.getColorForNaYinValue(text),
          // fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    /// 地支带颜色 [ganZhi]可传入单柱干支，这里只显示地支：ganZhi[1]
    /// 点击时给‘流运干支查询’传递参数：这里只传地支ganZhi[1]
    GestureDetector containerZhiColor(ganZhi) {
      return GestureDetector(
        onTap: () {
          Get.to(() => BaziQueryPage(), arguments: [getAll, ganZhi[1]]);
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          // height: 80,
          child: Text(
            ganZhi[1],
            style: TextStyle(
              color: getAll.getZhiColor(ganZhi[1]),
              fontFamily: 'chineseFont',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    /// 天干带颜色
    /// 点击时给‘流运干支查询’传递参数：这里只传天干ganZhi[0]
    GestureDetector containerGanColor(ganZhi) {
      return GestureDetector(
        onTap: () {
          Get.to(() => BaziQueryPage(), arguments: [getAll, ganZhi[0]]);
        },
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            ganZhi[0],
            style: TextStyle(
              color: getAll.getGanColor(ganZhi[0]),
              fontFamily: 'chineseFont',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    /// 十神 行
    GestureDetector containerWithShiShenTips(String title) {
      return GestureDetector(
        onTap: () async {
          var shishen = shiShenTips.where((item) => item['name'] == title).toList();
          customCuDialog(context, title, '${shishen[0]['gujue']}\n\n${shishen[0]['tip']}');
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    /// 行前标题
    Text customLeadingText(String title) {
      return Text(title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ));
    }

    /// 间隔
    Divider myDivider() {
      return const Divider(
        height: 0.1,
        thickness: 0.4,
        // color: Theme.of(context).colorScheme.inversePrimary,
      );
    }

    /// 占位
    SizedBox mySizedBox(double h) {
      return SizedBox(
        height: h,
      );
    }

    /// 表格-标题行
    GestureDetector titleRowContainer(String text) {
      var titleTip = titleTips.where((item) => item['name'] == text).toList();
      return GestureDetector(
        onTap: () async {
          customCuDialog(context, text, '${titleTip[0]['tip']}');
        },
        child: Container(
          alignment: Alignment.center,
          // 扩展垂直方向的高度，也可用合适的 height:30
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              )),
        ),
      );
    }

    /// 表格-八字标题列，比上面字体稍大一点点
    Container titleColumnContainerForBazi(String text) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    /// 普通行
    Container container(String text) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    /// 神煞行
    Container shenShaColumnContainer(List<String> shenShaList) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            for (var shenSha in shenShaList)
              GestureDetector(
                onTap: () async {
                  var shenShaTip = shenShaTips.where((item) => item['name'] == shenSha).toList();
                  customCuDialog(context, shenSha, '${shenShaTip[0]['tip']}\n\n${shenShaTip[0]['gujue']}');
                },
                child: Container(
                  // padding: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  child: Text(
                    shenSha,
                    style: const TextStyle(
                      fontSize: 13,
                      // color: Color(0xFFb2955d),
                      color: Color(0xFF8b6d03),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      );
    }
    // 是否是深色主题，控制 非列表信息用ListTile 的颜色
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    ListTile customListTile(String leadingInfo,String title) {
      return ListTile(
        tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: customLeadingText(leadingInfo),
        title: Text(title),
      );
  }

    // 布局
    return Scaffold(
      appBar: AppBar(
        title: const Text("基本命盘"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.auto_fix_high,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: '命盘详情',
            onPressed: () {
              // 将getAll传递给BaziDetailPage页面
              Get.to(() => const BaziDetailPage(), arguments: getAll);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          // padding: const EdgeInsets.all(0.0),
          padding: const EdgeInsets.only(top: 1.0),
          child: ListView(
            children: <Widget>[
              customListTile('  信息','$name     ${gender == 1 ? '男' : '女'}     ${getAll.rt()['age']}    ${getAll.rt()['xingZuo']}座',),
              myDivider(),
              customListTile('  公历', getAll.rt()['solar']),
              myDivider(),
              customListTile('  农历', getAll.rt()['lunar']),
              myDivider(),
              // 如果输入了出生地，则启用真太阳时，则显示此部分内容。为null否不显示
              Offstage(
                // 如果provinceName == ''则不显示出生地
                offstage: birthLocation.provinceId == '' || birthLocation.provinceId == null,
                child: Column(
                  children: [
                    customListTile('  出生', birthLocation.provinceName != null ? '${birthLocation.provinceName} ${birthLocation.cityName} ${birthLocation.areaName}' : ''),
                    myDivider(),
                  ],
                ),
              ),
              mySizedBox(3.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
                    child: Table(
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                        // color: Colors.grey.withAlpha(98),
                        width: 0.5,
                        style: BorderStyle.solid,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        // 0: IntrinsicColumnWidth(),
                        0: FixedColumnWidth(56),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          decoration: const BoxDecoration(
                            // color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6.0),
                              topRight: Radius.circular(6.0),
                            ),
                          ),
                          children: <Widget>[
                            // 各项按照此顺序排列/流时/流日/流月/流年/大运//年柱/月柱/日柱/时柱
                            titleColumnContainerForBazi(gender == 1 ? '乾造' : '坤造'),
                            titleColumnContainerForBazi('年  柱'),
                            titleColumnContainerForBazi('月  柱'),
                            titleColumnContainerForBazi('日  柱'),
                            titleColumnContainerForBazi('时  柱'),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('十神'),
                            containerWithShiShenTips(getAll.rt()['yearShiShenGan']),
                            containerWithShiShenTips(getAll.rt()['monthShiShenGan']),
                            container('日主'),
                            containerWithShiShenTips(getAll.rt()['timeShiShenGan']),
                            // _container(getAll.rt()['timeShiShenGan']),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('天干'),
                            // 这里使用getAll.getBazi()获取年的天干和地支，在containerGanColor()方法取天干，是为了给BaziQueryPage单柱传输干支
                            containerGanColor(getAll.getBazi().getYear()),
                            containerGanColor(getAll.getBazi().getMonth()),
                            containerGanColor(getAll.getBazi().getDay()),
                            containerGanColor(getAll.getBazi().getTime()),
                            // containerGanColor(getAll.getGanZhi()[0]),
                            // containerGanColor(getAll.getGanZhi()[2]),
                            // containerGanColor(getAll.getGanZhi()[4]),
                            // containerGanColor(getAll.getGanZhi()[6]),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('地支'),
                            containerZhiColor(getAll.getBazi().getYear()),
                            containerZhiColor(getAll.getBazi().getMonth()),
                            containerZhiColor(getAll.getBazi().getDay()),
                            containerZhiColor(getAll.getBazi().getTime()),
                            // containerZhiColor(getAll.getGanZhi()[1]),
                            // containerZhiColor(getAll.getGanZhi()[3]),
                            // containerZhiColor(getAll.getGanZhi()[5]),
                            // containerZhiColor(getAll.getGanZhi()[7]),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('藏干'),
                            Row(
                              // 可以把单元格分成两列
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 藏干
                                richTextContainer(getAll.rt()['yearHideGan']),
                                // 两列之间的空格
                                const Text('  '),
                                // 藏干对应的十神
                                Column(
                                  children: [
                                    for (String text in getAll.rt()['yearShiShenZhi']) containerWithShiShenTips(text),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              // 可以把单元格分成两列
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                richTextContainer(getAll.rt()['monthHideGan']),
                                const Text('  '),
                                Column(
                                  children: [
                                    for (String text in getAll.rt()['monthShiShenZhi']) containerWithShiShenTips(text),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              // 可以把单元格分成两列
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                richTextContainer(getAll.rt()['dayHideGan']),
                                const Text('  '),
                                Column(
                                  children: [
                                    for (String text in getAll.rt()['dayShiShenZhi']) containerWithShiShenTips(text),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              // 可以把单元格分成两列
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                richTextContainer(getAll.rt()['timeHideGan']),
                                const Text('  '),
                                Column(
                                  children: [
                                    for (String text in getAll.rt()['timeShiShenZhi']) containerWithShiShenTips(text),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('纳音'),
                            naYinContainerMatchColor(getAll.rt()['naYin'][0]),
                            naYinContainerMatchColor(getAll.rt()['naYin'][1]),
                            naYinContainerMatchColor(getAll.rt()['naYin'][2]),
                            naYinContainerMatchColor(getAll.rt()['naYin'][3]),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('地势'),
                            diShiContainer(getAll.rt()['diShi'][0]),
                            diShiContainer(getAll.rt()['diShi'][1]),
                            diShiContainer(getAll.rt()['diShi'][2]),
                            diShiContainer(getAll.rt()['diShi'][3]),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('自坐'),
                            diShiContainer(getAll.rt()['ziZuo'][0]),
                            diShiContainer(getAll.rt()['ziZuo'][1]),
                            diShiContainer(getAll.rt()['ziZuo'][2]),
                            diShiContainer(getAll.rt()['ziZuo'][3]),
                          ],
                        ),

                        /// TODO 继续更多命盘基础数据，界面简洁大方清晰明了
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('空亡'),
                            container(getAll.rt()['yearXunKong']),
                            container(getAll.rt()['monthXunKong']),
                            container(getAll.rt()['dayXunKong']),
                            container(getAll.rt()['timeXunKong']),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('神煞'),
                            shenShaColumnContainer(getAll.rt()['shenSha'][0]),
                            shenShaColumnContainer(getAll.rt()['shenSha'][1]),
                            shenShaColumnContainer(getAll.rt()['shenSha'][2]),
                            // 原神煞行，不能查看提示 _shenShaContainer(getAll.rt()['shenSha'][3].join('\n')),
                            shenShaColumnContainer(getAll.rt()['shenSha'][3]),
                          ],
                        ),
                        // 五行旺相休囚死
                        TableRow(
                          children: <Widget>[
                            wangShuaiRowContainer(getAll.rt()['wxWangShuai'][0]),
                            wangShuaiRowContainer(getAll.rt()['wxWangShuai'][1]),
                            wangShuaiRowContainer(getAll.rt()['wxWangShuai'][2]),
                            wangShuaiRowContainer(getAll.rt()['wxWangShuai'][3]),
                            wangShuaiRowContainer(getAll.rt()['wxWangShuai'][4]),
                          ],
                        ),
                        // 命理三垣
                        TableRow(
                          // decoration: BoxDecoration(
                          //   color: Theme.of(context).colorScheme.background,
                          // ),
                          children: <Widget>[
                            titleRowContainer('命理三垣'),
                            titleRowContainer('胎元'),
                            titleRowContainer('命宫'),
                            titleRowContainer('身宫'),
                            titleRowContainer('胎息'),
                          ],
                        ),
                        TableRow(
                          children: <Widget>[
                            titleRowContainer('暗八字'),
                            // 不带颜色的 \n 换行
                            // _container('${getAll.rt()['sanHuan'][0]}\n${getAll.rt()['sanHuanNaYin'][0]}'),
                            // _container('${getAll.rt()['sanHuan'][1]}\n${getAll.rt()['sanHuanNaYin'][1]}'),
                            // _container('${getAll.rt()['sanHuan'][2]}\n${getAll.rt()['sanHuanNaYin'][2]}'),
                            // _container('${getAll.rt()['sanHuan'][3]}\n${getAll.rt()['sanHuanNaYin'][3]}'),
                            // 下面是带颜色的 Column 换行
                            Column(
                              // 可以把单元格分成两行
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                container(getAll.rt()['sanHuan'][0]),
                                naYinContainerMatchColor(getAll.rt()['sanHuanNaYin'][0]),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                container(getAll.rt()['sanHuan'][1]),
                                naYinContainerMatchColor(getAll.rt()['sanHuanNaYin'][1]),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                container(getAll.rt()['sanHuan'][2]),
                                naYinContainerMatchColor(getAll.rt()['sanHuanNaYin'][2]),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  container(getAll.rt()['sanHuan'][3]),
                                  naYinContainerMatchColor(getAll.rt()['sanHuanNaYin'][3]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              mySizedBox(6.0),
              myDivider(),
              customListTile('起运', getAll.rt()['qiYun']),
              myDivider(),
              customListTile('交运', getAll.rt()['jiaoYun']),
              myDivider(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    '大运（起始公历年 起始年龄 干支）',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                      // color: Colors.grey.withAlpha(98),
                      width: 0.5,
                      style: BorderStyle.solid,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      // 0: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      buildDaYunTableRow('大运', (index) => getAll.rt()['daYun'][index].getStartYear().toString(), Colors.orange, 1),
                      buildDaYunTableRow('年龄', (index) => getAll.rt()['daYun'][index].getStartAge().toString(), null, 0),
                      buildDaYunTableRow('干支', (index) => getAll.rt()['daYun'][index].getGanZhi(), null, 2),
                    ],
                  ),
                ),
              ),
              // _mySizedBox(context),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '流年（公历年 年龄 干支 小运）',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                      width: 0.5,
                      style: BorderStyle.solid,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      // 0: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      buildLiuYearTableRow(
                          '流年', (index) => getAll.liuNian(currentDaYunIndex, index).getYear().toString(), Colors.orange, 1, true),
                      buildLiuYearTableRow(
                          '年龄', (index) => getAll.liuNian(currentDaYunIndex, index).getAge().toString(), null, 0, true),
                      buildLiuYearTableRow('干支', (index) => getAll.liuNian(currentDaYunIndex, index).getGanZhi(), null, 0, true),
                      buildLiuYearTableRow(
                          '小运', (index) => getAll.rt()['daYun'][currentDaYunIndex].getXiaoYun()[index].getGanZhi(), Colors.grey, 2, false),
                    ],
                  ),
                ),
              ),
              // _mySizedBox(context),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '流月（节令 起始公历日期 干支）',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                      width: 0.5,
                      style: BorderStyle.solid,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      // 0: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      buildLiuMonthTableRow('流月', (index) => '${index+1}', Colors.grey, 1),
                      buildLiuMonthTableRow('流月', (index) => MyLunar.JIE_FOR_LIU_YUE[index], Colors.orange, 0),
                      buildLiuMonthTableRow(
                          '日期', (index) => getAll.liuYue(currentDaYunIndex, currentLiuYearIndex, index).getStartDateMonthAndDay(), null, 0),
                      buildLiuMonthTableRow('干支', (index) => getAll.liuYue(currentDaYunIndex, currentLiuYearIndex, index).getGanZhi(), null, 2),
                    ],
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '流日（公历日期 干支）',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                      width: 0.5,
                      style: BorderStyle.solid,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      // 0: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      buildLiuDayTableRow2(
                          '流日', // 从一个节到下一个节的日期
                              (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getDate(),
                          0,
                          Colors.orange,
                          1),
                      buildLiuDayTableRow2(
                          '干支', (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getGanZhi(), 0, null, 0),
                      // buildLiuDayTableRow2(
                      // '序号', (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getIndex().toString(), 0, null, 0),
                      buildLiuDayTableRow2(
                          '流日', // 从一个节到下一个节的日期
                              (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getDate(),
                          10,
                          Colors.orange,
                          0),
                      buildLiuDayTableRow2('干支',
                              (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getGanZhi(), 10, null, 0),
                      buildLiuDayTableRow2(
                          '流日', // 从一个节到下一个节的日期
                              (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getDate(),
                          20,
                          Colors.orange,
                          0),
                      buildLiuDayTableRow2(
                          '干支',
                              (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getGanZhi(),
                          20,
                          null,
                          getAll.liuYue(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex).getDayCounts() > 30 ? 0 : 2),
                      if (getAll.liuYue(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex).getDayCounts() > 30)
                        buildLiuDayTableRow2(
                            '流日', // 从一个节到下一个节的日期
                                (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getDate(),
                            30,
                            Colors.orange,
                            0),
                      if (getAll.liuYue(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex).getDayCounts() > 30)
                        buildLiuDayTableRow2(
                            '干支',
                                (index) => getAll.liuRi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, index).getGanZhi(),
                            30,
                            null,
                            2), // 每10个日期占一行
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    '流时（起止时间 干支）',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                      width: 0.5,
                      style: BorderStyle.solid,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      // 0: IntrinsicColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      // 十二时辰
                      buildLiuHourTableRow('流时', (index) => MyLunar.HOUR_FOR_LIU_SHI[index], Colors.grey, 8, 1),
                      buildLiuHourTableRow(
                          '干支',
                              (index) => getAll.liuShi(currentDaYunIndex, currentLiuYearIndex, currentLiuMonthIndex, currentLiuDayIndex, index),
                          null,
                          12,
                          0),
                      buildLiuHourTableRow('流时', (index) => MyLunar.HOUR_FOR_LIU_SHI[index + 13], Colors.grey, 8, 2),
                    ],
                  ),
                ),
              ),
              mySizedBox(16.0),
            ],
          ),
        ),
      ),
    );
  }
}

// 暂时不用或过时的组件，在用组件已迁移到上方页面类内部
Container _containerWithColor(String text, Color color) {
  return Container(
    alignment: Alignment.center,
    // height: 80,
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'chineseFont',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Container _titleContainerWithColor(String text, Color color) {
  return Container(
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
        color: color,
        fontFamily: 'chineseFont',
        // fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

/// 原神煞行
Container _shenShaContainer(String text) {
  return Container(
    padding: const EdgeInsets.all(4.0),
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFFb2955d),
      ),
      textAlign: TextAlign.center,
    ),
  );
}

/// 表格-标题列
Container _titleColumnContainer(BuildContext context, String text) {
  return Container(
    alignment: Alignment.center,
    child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
  );
}

// 根据 hideGan 中的值对应的颜色设置 shiShenZhi 中的文本样式
Container richTextContainerMatch(BuildContext context, List<String> myList, List<String> matchingList) {
  return Container(
    // 垂直方向留空
    padding: const EdgeInsets.symmetric(vertical: 5.0),
    alignment: Alignment.center,
    // child: Text(
    //   myList.join('\n'),
    //   style: TextStyle(
    //     // fontFamily: 'chineseFont',
    //     // color: getAll.getColorForValue(matchingList[i]),
    //     color: Theme.of(context).colorScheme.onBackground,
    //     fontSize: 13,
    //     // fontWeight: FontWeight.bold,
    //   ),
    // ),
    child: RichText(
      text: TextSpan(
        children: [
          for (var i = 0; i < myList.length; i++)
            TextSpan(
              text: '${myList[i]}${i != myList.length - 1 ? '\n' : ''}',
              style: TextStyle(
                // fontFamily: 'chineseFont',
                // color: getAll.getColorForValue(matchingList[i]),
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 13,
                // fontWeight: FontWeight.bold,
              ), // 获取每个值对应的颜色
            ),
        ],
      ),
    ),
  );
}

// 根据 纳音 最后一个五行，获取颜色 // 暗八字 颜色
Container containerMatchColor(text) {
  return Container(
    alignment: Alignment.center,
    child: Text(
      text,
      style: const TextStyle(
        // fontFamily: 'chineseFont',
        // 要不要颜色？
        // color: getAll.getColorForNaYinValue(text),
        fontSize: 13,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );
}
