import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bazi/pages/bazi_result/bazi_lunar.dart';

import 'package:bazi/pages/bazi_result/bazi_query_logic.dart';

const rowDivider = SizedBox(width: 20);
const colDivider10 = SizedBox(height: 10);
const colDivider16 = SizedBox(height: 16);

class BaziQueryPage extends StatelessWidget {
  BaziQueryPage({super.key});

  final BaziQueryController baziQueryController = Get.put(BaziQueryController());

  /// 检索结果列表
  TableRow buildQueryResultTableRow(context, var match, int index) {
    return TableRow(
      decoration: BoxDecoration(
        color: (index + 1).isEven ? Theme.of(context).colorScheme.background : null,
      ),
      children: <Widget>[
        // 使用传递进来的索引作为序号
        titleContainer('${index + 1}', context),
        ganZhiContainer(match.daYun == null ? '' : '${match.daYun?.getGanZhi()}',
            match.daYun == null ? '' : '${match.daYun?.getStartYear()}\n${match.daYun?.getEndYear()}'),
        ganZhiContainer(match.liuNian == null ? '' : '${match.liuNian?.getGanZhi()}',
            match.liuNian == null ? '' : '${match.liuNian?.getYear()}年\n${match.liuNian?.getAge()}岁'),
        ganZhiContainer(match.liuYue == null ? '' : '${match.liuYue?.getGanZhi()}',
            match.liuYue == null ? '' : '${match.liuYue?.getStartDateMonthAndDay()}\n${match.liuYue?.getEndDateMonthAndDay()}'),
        ganZhiContainer(match.liuRi == null ? '' : '${match.liuRi?.getGanZhi()}',
            match.liuRi == null ? '' : '${match.liuRi?.getDateMonth()}月\n${match.liuRi?.getDateDay()}日'),
        ganZhiContainer(match.shiGanZhi == null ? '' : '${match.shiGanZhi}',
            match.shiGanZhi == null ? '' : '${getShiRange(match.shiGanZhi)[0]}\n${getShiRange(match.shiGanZhi)[1]}'),
      ],
    );
  }

  /// 根据时辰的天干返回时辰的范围
  List<String> getShiRange(String shiGanZhi) {
    int index = baziQueryController.DIZHI.indexOf(shiGanZhi[1]);
    return [MyLunar.HOUR_FOR_LIU_SHI[index - 1], MyLunar.HOUR_FOR_LIU_SHI[index + 12]];
  }

  /// 标题单元格
  Container titleContainer(String text, context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  /// 结果干支单元格
  Container ganZhiContainer(String textGanZhi, String textInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            textGanZhi,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              // color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            textInfo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              // fontWeight: FontWeight.bold,
              // color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
  /// todo 输入框样式 想把获得焦点时的样式应用到正常状态
  InputDecorationTheme copyWith({
    InputBorder? focusedBorder,
    InputBorder? enabledBorder,
    InputBorder? disabledBorder,
    InputBorder? border,
    BorderSide? activeIndicatorBorder,
    BorderSide? outlineBorder,
  }) {
    return InputDecorationTheme(
      // focusedBorder: focusedBorder ?? this.focusedBorder,
      // enabledBorder: enabledBorder ?? focusedBorder,
      enabledBorder: focusedBorder,
      disabledBorder: focusedBorder,

      // border: focusedBorder,
      // activeIndicatorBorder: activeIndicatorBorder ?? activeIndicatorBorder,
      // outlineBorder: activeIndicatorBorder,
      // focusedBorder: focusedBorder ?? inputDecorationTheme.focusedBorder,
      // focusedErrorBorder: focusedErrorBorder ?? inputDecorationTheme.focusedErrorBorder,
      // disabledBorder: disabledBorder ?? inputDecorationTheme.disabledBorder,
      // enabledBorder: enabledBorder ?? inputDecorationTheme.enabledBorder,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('流运干支查询'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return ListView(
              children: [
                // colDivider10,
                ListTile(
                  shape: RoundedRectangleBorder(
                    // side: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.only(left: 12.0, right: 12.0),
                  tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DropdownMenu<String>(
                          // enabled: false,
                          // menuHeight: 300,
                          initialSelection: baziQueryController.tianGan.value,
                          controller: baziQueryController.ganController,
                          label: const Text('天干'),
                          dropdownMenuEntries: baziQueryController.buildEntryList(baziQueryController.TIANGAN),
                          onSelected: (tiangan) {
                            baziQueryController.onTianGanSelect(tiangan!);
                          },
                          textStyle: TextStyle(color: baziQueryController.tianGan.value == '未选择' ? Colors.grey : null),
                          menuStyle: const MenuStyle(visualDensity: VisualDensity.compact),
                          // inputDecorationTheme: InputDecorationTheme(),
                        ),
                        DropdownMenu<String>(
                          // menuHeight: 300,
                          initialSelection: baziQueryController.diZhi.value,
                          controller: baziQueryController.zhiController,
                          label: const Text('地支'),
                          dropdownMenuEntries: baziQueryController.buildEntryList(baziQueryController.DIZHI),
                          onSelected: (dizhi) {
                            baziQueryController.onDiZhiSelect(dizhi!);
                          },
                          textStyle: TextStyle(color: baziQueryController.diZhi.value == '未选择' ? Colors.grey : null),
                          menuStyle: const MenuStyle(visualDensity: VisualDensity.compact),
                        ),
                      ],
                    ),
                  ),
                ),
                colDivider16,
                ListTile(
                    dense: true,
                    shape: RoundedRectangleBorder(
                      // side: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: const EdgeInsets.only(left: 14.0, right: 14.0),
                    tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
                    title: Container(
                      padding: const EdgeInsets.only(top: 0, bottom: 6),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('大运'),
                                Text('流年'),
                                Text('流月'),
                                Text('流日'),
                                Text('流时'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // 固定大运、流年选项为真
                                const Checkbox(
                                  value: true,
                                  onChanged: null,
                                ),
                                // 若需要改变大运流年选项
                                Checkbox(
                                    value: baziQueryController.liuNianChecked.value,
                                    onChanged: (value) {
                                      baziQueryController.onLiuNianChanged();
                                    }),
                                Checkbox(
                                    value: baziQueryController.liuYueChecked.value,
                                    onChanged: (value) {
                                      baziQueryController.onLiuYueChanged();
                                    }),
                                Checkbox(
                                    value: baziQueryController.liuRiChecked.value,
                                    onChanged: (value) {
                                      baziQueryController.onLiuRiChanged();
                                    }),
                                Checkbox(
                                    value: baziQueryController.liuShiChecked.value,
                                    onChanged: (value) {
                                      baziQueryController.onLiuShiChanged();
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                colDivider10,
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Table(
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.onBackground.withAlpha(80),
                        // color: Colors.grey.withAlpha(98),
                        width: 0.5,
                        style: BorderStyle.solid,
                        borderRadius: const BorderRadius.all(Radius.circular(6)),
                      ),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FixedColumnWidth(40),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(6.0),
                              topRight: Radius.circular(6.0),
                            ),
                          ),
                          children: <Widget>[
                            titleContainer('序号', context),
                            titleContainer('大运', context),
                            titleContainer('流年', context),
                            titleContainer('流月', context),
                            titleContainer('流日', context),
                            titleContainer('流时', context),
                          ],
                        ),
                        ...List.generate(
                          baziQueryController.matches.length, // 根据匹配项的数量生成TableRow
                          (index) => buildQueryResultTableRow(context, baziQueryController.matches[index], index),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
