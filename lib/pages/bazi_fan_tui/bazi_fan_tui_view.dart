import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../settings_page.dart';
import 'bazi_fan_tui_logic.dart';

class BaziFanTuiBottomSheet extends StatelessWidget {
  BaziFanTuiBottomSheet({super.key});

  final BaziFanTuiController baziFanTuiController = Get.put(BaziFanTuiController());
  final SettingsController settingsController = Get.find();
  /// 生成天干地支备选项列表
  TableRow generateOptionTable(BuildContext context, List<dynamic> optionList) {
    return TableRow(
      // 为整行设置圆角，背景色
      // decoration: const BoxDecoration(
      //   // color: Colors.grey,
      //   borderRadius: BorderRadius.all(Radius.circular(6)),
      // ),
      children: <Widget>[
        for (var i = 0; i < optionList.length; i++)
          GestureDetector(
            onTap: () {
              baziFanTuiController.onOptionSelected(optionList[i]);
            },
            child: Container(
              height: 40,
              alignment: AlignmentDirectional.center,
              // 为每个单元格设置圆角，背景色
              decoration: const BoxDecoration(
                color: Color(0xFFE6E1E5),
                // color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              // color: Colors.grey,
              child: Text(
                optionList[i],
                softWrap: true, // 允许自动换行
                textAlign: TextAlign.center,
                style: TextStyle(
                  // 干支两个字时，两个字自动换行时，行间距大小
                  height: 1.15,
                  fontSize: optionList[i].toString().length == 2 ? 14 : 16,
                  // color 取深色模式下的inverseSurface与onInverseSurface
                  // color: Theme.of(context).colorScheme.onInverseSurface,
                  color: const Color(0xFF313033),
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      // 这个theResult虽然没有用到，但在反查时，如果本轮甲子未找到时能正常显示结果Offstage
      var theResult = baziFanTuiController.getResult();
      return Container(
        // color: Theme.of(context).dialogBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Offstage(
              // offstage: baziFanTuiController.getResult().isEmpty,
              offstage: !baziFanTuiController.findSomething.value,
              child: ListTile(
                // tileColor: Colors.transparent,
                // tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
                dense: true,
                visualDensity: VisualDensity.compact,
                title: Text(
                  baziFanTuiController.getResult().value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // 点击列表将结果发送到‘生辰’输入框
                  // widget传值太麻烦，已用get重构bazi_info_page为bazi_info_view
                  baziFanTuiController.selectedResult();
                  Get.back();
                },
              ),
            ),

            Card(
              color: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    tooltip: '查找过去',
                    onPressed:
                        baziFanTuiController.pastJiaZiEnabled().value ? () => baziFanTuiController.pastJiaZi() : null,
                  ),
                  // 在查找最近按钮内部嵌入一个不明显的数字，显示当前甲子轮数jiaZiBeiShu
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Text(
                        baziFanTuiController.jiaZiBeiShu.value.toString(),
                        style: TextStyle(fontSize: 6, color: Theme.of(context).disabledColor),
                      ),
                      IconButton(
                        tooltip: '查找最近',
                        onPressed: baziFanTuiController.currentJiaZiEnabled().value
                            ? () => baziFanTuiController.currentJiaZi()
                            : null,
                        icon: const Icon(Icons.gps_not_fixed),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    tooltip: '查找未来',
                    onPressed: baziFanTuiController.futureJiaZiEnabled().value
                        ? () => baziFanTuiController.futureJiaZi()
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed:
                        baziFanTuiController.resetInputEnabled().value ? () => baziFanTuiController.resetInput() : null,
                    tooltip: '清空四柱',
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 16.0),
            // const Divider(),
            // 四柱标题：年柱、月柱、日柱、时柱
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (String pillarText in baziFanTuiController.siZhuList)
                  TextButton(
                    onPressed: () {},
                    child: Text(pillarText),
                  ),
              ],
            ),
            // const SizedBox(height: 16.0),
            // 干支选择的部分
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // 为年月日时干支圆圈添加旋转动画
                _buildAnimatedSwitcher(context,baziFanTuiController.yearGan.value,baziFanTuiController.selectedGanIndex.value,0,baziFanTuiController.selectYearGan),
                _buildAnimatedSwitcher(context,baziFanTuiController.monthGan.value,baziFanTuiController.selectedGanIndex.value,1,baziFanTuiController.selectMonthGanZhi),
                _buildAnimatedSwitcher(context,baziFanTuiController.dayGan.value,baziFanTuiController.selectedGanIndex.value,2,baziFanTuiController.selectDayGan),
                _buildAnimatedSwitcher(context,baziFanTuiController.hourGan.value,baziFanTuiController.selectedGanIndex.value,3,baziFanTuiController.selectHourGanZhi),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAnimatedSwitcher(context,baziFanTuiController.yearZhi.value,baziFanTuiController.selectedZhiIndex.value,0,baziFanTuiController.selectYearZhi),
                _buildAnimatedSwitcher(context,baziFanTuiController.monthZhi.value,baziFanTuiController.selectedZhiIndex.value,1,baziFanTuiController.selectMonthGanZhi),
                _buildAnimatedSwitcher(context,baziFanTuiController.dayZhi.value,baziFanTuiController.selectedZhiIndex.value,2,baziFanTuiController.selectDayZhi),
                _buildAnimatedSwitcher(context,baziFanTuiController.hourZhi.value,baziFanTuiController.selectedZhiIndex.value,3,baziFanTuiController.selectHourGanZhi),
              ],
            ),
            const SizedBox(height: 16.0),
            Table(
              border: TableBorder.all(
                color: isDark? Theme.of(context).colorScheme.onInverseSurface:Theme.of(context).colorScheme.background,
                width: 1.0, // 线宽对单元格圆角有影响
                // 为整个表格设置圆角
                // borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              children: <TableRow>[
                generateOptionTable(context, baziFanTuiController.optionList),
              ],
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      );
    });
  }

  /// 为八字显示圆圈添加旋转动画
  Widget _buildAnimatedSwitcher(BuildContext context,String valueKey,int selectedIndex,int compareIndex, void Function() function) =>
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
                child: RotationTransition(turns: Tween<double>(begin: 0.7, end: 1.0).animate(animation), child: child)),
        child: CustomCircleAvatar(
          key: ValueKey<String>(valueKey),
          text: valueKey,
          isSelected: selectedIndex == compareIndex,
          onPressed: () {
            function();
          },
        ),
      );
}

class CustomCircleAvatar extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function() onPressed;

  const CustomCircleAvatar({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 20,
        // backgroundColor: isDark ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.inverseSurface,
        backgroundColor: isSelected ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: isSelected ? Theme.of(context).colorScheme.onSecondary : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
