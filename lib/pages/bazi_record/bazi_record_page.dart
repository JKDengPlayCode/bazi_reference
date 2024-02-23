import 'package:get/get.dart';
import 'package:bazi/pages/bazi_info/bazi_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bazi/components/iconfont.dart';
import 'package:bazi/common/classPersonData.dart';
import 'package:bazi/pages/bazi_result/bazi_result_page.dart';
import 'package:bazi/pages/bazi_result/bazi_lunar.dart';
import 'package:bazi/pages/bazi_record/person_data_controller.dart';

import 'package:bazi/pages/bazi_record/bazi_record_bottom_app_bar.dart';

import 'package:bazi/common/constants.dart';

import 'package:bazi/pages/settings_page.dart';

class BaziRecordPage extends StatelessWidget {
  BaziRecordPage({super.key});

  final PersonDataController personDataController = Get.find();
  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    // TODO：键盘显示颜色模式与当前应用一致？

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('历史记录'),
          actions: [
            IconButton(
              icon: const Icon(Icons.assignment_returned_outlined),
              tooltip: '导入示例',
              onPressed: () {
                for (PersonData p in tempPersonDataList) {
                  personDataController.savePersonData(p);
                }
              },
            ),
            IconButton(
              icon: Icon(personDataController.manageRecordByUser.value
                  ? Icons.assignment_turned_in
                  : Icons.assignment_turned_in_outlined),
              tooltip: '批量删除',
              onPressed: () {
                personDataController.toggleManageRecordByUser();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                return TextField(
                  controller: personDataController.searchController,
                  focusNode: personDataController.searchFocusNode,
                  textInputAction: TextInputAction.search,
                  maxLength: 5,
                  onChanged: (value) {
                    personDataController.searchText.value = value;
                  },
                  // 点击组件外部时=>失去焦点
                  onTapOutside: (e) => {
                    personDataController.searchFocusNode.unfocus(),
                  },
                  decoration: InputDecoration(
                    hintText: '搜索姓名',
                    // 设置了最大长度maxLength: 5,但不显示字符计数，给counterText一个空值即可
                    counterText: '',
                    border: InputBorder.none,
                    // border: const UnderlineInputBorder(),
                    prefixIcon: const Icon(Icons.person_search),
                    suffixIcon: personDataController.searchText.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              personDataController.clearSearchText();
                            },
                          )
                        : null,
                  ),
                    // keyboardAppearance:themeBrightness,只能用在ios上，android上无效
                );
              }),
            ),
            Expanded(
              child: Obx(() {
                final List<PersonData> displayedList = personDataController.searchText.isEmpty
                    ? personDataController.personDataList
                    : personDataController.filteredList;

                return SlidableAutoCloseBehavior(
                  child: ListView.builder(
                    itemCount: displayedList.isEmpty ? 1 : displayedList.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (displayedList.isEmpty || index == displayedList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              '以下没有更多记录了',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return _buildSlidableItem(context, displayedList, index);
                      }
                    },
                  ),
                );
              }),
            ),
          ],
        ),
        // 是否显示底部功能按钮，取决于是否长按选择了记录 或 主动点击了批量删除按钮
        bottomNavigationBar: personDataController.isSelectedExist.value || personDataController.manageRecordByUser.value
            ? BaziRecordBottomAppBar()
            : null,
      );
    });
  }

  /// 生成排盘记录人员信息的列表项，分为本地存储和搜索过滤两类List
  Widget _buildSlidableItem(BuildContext context, List<PersonData> fpDataList, int index) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        // 装饰ListTile
        border: Border.all(
          color: fpDataList[index].gender == 1 ? Colors.blueAccent : Colors.pinkAccent, // 边框颜色
          // color: Colors.grey.withAlpha(90), // 底色
          width: 0.1, // 边框宽度
        ),
      ),
      // 右滑列表项出现的菜单
      child: Slidable(
        key: ValueKey("$index"),
        // 把所有Slidable归类到一个组, 保证同时只出现一个滑动的效果
        groupTag: 'bsz',
        startActionPane: ActionPane(
          // 默认值下，三个按钮的label不能显示，可以调整extentRatio最大到1占据所有空间extentRatio: 0.65,
          // extentRatio: 0.65,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              // borderRadius: BorderRadius.circular(8.0),
              onPressed: (context) async {
                bool confirmDelete = await showCupertinoDialog(
                  // 是否可点击背景关闭对话框，相当于点击取消，但会导致confirmDelete： type 'Null' is not a subtype of type 'bool'
                  // barrierDismissible:true,
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text('确认删除这项记录吗?'),
                      content: Text(
                        '\n${getShareOrDelInfo(fpDataList[index])}',
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          // 是否销毁按钮，true则文字变为红色
                          // isDestructiveAction: true,
                          onPressed: () {
                            Navigator.of(context).pop(false); // 取消删除
                          },
                          child: const Text('取消'),
                        ),
                        CupertinoDialogAction(
                          // 是否默认按钮，true字体加粗
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.of(context).pop(true); // 确认删除
                          },
                          child: const Text('删除'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmDelete == true) {
                  personDataController.removePersonData(fpDataList[index].id);
                }
              },
              // backgroundColor: ThemeData().colorScheme.background,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Colors.red,
              icon: CupertinoIcons.trash,
              // label: '删除',
            ),
            SlidableAction(
              autoClose: true,
              // borderRadius: BorderRadius.circular(8.0),
              onPressed: (context) {
                // 分享 TODO 分享更多内容，如一张图片、链接、含APP下载和此用户信息的二维码
                // FlutterShareMe flutterShareMe = FlutterShareMe();
                String msg = '卜算子 ${getShareOrDelInfo(fpDataList[index])}';
                // flutterShareMe.shareToSystem(msg: msg);
                Share.share(msg);
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Colors.green,
              icon: Icons.share,
              // label: '分享',
            ),
            SlidableAction(
              autoClose: true,
              // 点击编辑按钮可以以对话框的形式打开BaziInforForm
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      // title: Text('编辑信息'),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0), // 设置圆角半径
                      ),
                      insetPadding: const EdgeInsets.all(6),
                      child: BaziInforForm(
                        // !统一基本信息录入页面 和 历史记录页面弹出的 基本信息编辑对话框。常见APP录入和编辑页面是分开的--这不是没有原因的
                        // child: BaziInforDialog(
                        personData: fpDataList[index],
                        isOpenedDialogForm: true,
                      ), // 传递选中的人员信息给编辑表单
                    );
                  },
                );
                // 弹出编辑按钮后/重新搜索 保持搜索结果状态
                personDataController.filterSearchResults(personDataController.searchText.value);
              },
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              foregroundColor: Colors.blue,
              icon: Icons.edit,
              // label: '编辑',
            )
          ],
        ),
        child: Obx(() {
          return ListTile(
            tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: fpDataList[index].gender == 1
                ? Icon(
                    TaiJiIconFont.nansheng,
                    color: settingsController.useLightMode.value ? const Color(0xBE3290D7): const Color(0xBEB6CEE0),
                    // color: Colors.lightBlue,
                  ) // 如果性别为男性，显示男性图标
                : Icon(
                    TaiJiIconFont.nvsheng,
                    color: settingsController.useLightMode.value ? const Color(0xF1E16969) :const Color(0xF1EEC5C5),//: Color(0xF1E16969),
                  ),
            title: Text(
              // 标题：姓名
              fpDataList[index].name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                // color: Theme.of(context).primaryColor,
              ),
            ),
            subtitle: Text(
              // 副标题：生辰
              getBirthDay(fpDataList[index]),
              style: const TextStyle(
                // fontStyle: FontStyle.italic,
                // fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            trailing: Column(
              // end可使其垂直居中
              mainAxisAlignment: MainAxisAlignment.end,
              // mainAxisSize : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 客户年龄
                    Text(
                      getAge(fpDataList[index]),
                      style: const TextStyle(
                        fontSize: 13,
                        // color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 2),
                    // 客户省份，如果有则显示
                    Text(
                      getProvinceName(fpDataList[index]),
                      style: const TextStyle(
                        fontSize: 13,
                        // color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 录入时间 // 八字
                    Text(
                      // '${getInputTime(fpDataList[index])}录入',
                      getEightChar(fpDataList[index]),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        // color: Theme.of(context).highlightColor,
                        // fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

              ],
            ),
            onTap: () {
              // 在这里处理点击列表项的逻辑，比如跳转到详情页
              // Navigator.push(context, MaterialPageRoute(builder: (context) => BaziResultPage(person: fpDataList[index])));
              // 路由问题：刷新BaziRecordPage的页面，已在BaziInforForm通过isOpenedDialogForm解决
              // Get.off(BaziResultPage(person: fpDataList[index]));
              personDataController.searchFocusNode.unfocus();
              Get.to(() => BaziResultPage(person: fpDataList[index]));
              // 跳转以后再重新搜索 保持搜索结果状态
              personDataController.filterSearchResults(personDataController.searchText.value);
            },
            selected: fpDataList[index].isSelected.value,
            // 设置被选中的ListTile背景色
            selectedTileColor: Theme.of(context).splashColor,
            onLongPress: () {
              personDataController.toggleSelection(fpDataList, fpDataList[index]);
            },
          );
        }),
      ),
    );
  }
}

/// 分享的客户文字信息
String getShareOrDelInfo(person) {
  String personName = person.name;
  String personGender = person.gender == 1 ? '男' : '女';
  String personBirthDay = getBirthDay(person);
  String personBirthLocation = getBirthLocation(person);
  String personAge = getAge(person);
  return '$personName  ($personGender)  $personAge \n$personBirthDay $personBirthLocation';
}

/// 在记录列表中显示经过计算的生辰
String getBirthDay(person) {
  if (person.solarOrLunar == 1) {
    return MyLunar.getBirthday(person).infoForRecord()['solar'];
  } else {
    return MyLunar.getBirthday(person).infoForRecord()['lunar'];
  }
}

/// 在记录列表中显示 年龄
String getAge(person) {
  return MyLunar.getBirthday(person).infoForRecord()['age'];
}
/// 在记录列表中显示八字
String getEightChar(person) {
  return MyLunar.getBirthday(person).infoForRecord()['bazi'];
}

/// 在记录列表中获取录入日期时间
String getInputTime(person) {
  DateTime now = DateTime.now();
  DateTime inputTime = DateTime.fromMillisecondsSinceEpoch(int.parse(person.id.substring(11)));
  DateFormat outputYMDFormat = DateFormat('yyyy/MM/dd');
  DateFormat outputMDFormat = DateFormat('MM/dd');

  // 比较年月日是否相同
  if (now.year == inputTime.year && now.month == inputTime.month && now.day == inputTime.day) {
    return '今天';
  }

  // 比较年月日是否相差一天
  DateTime yesterday = now.subtract(const Duration(days: 1));
  if (yesterday.year == inputTime.year && yesterday.month == inputTime.month && yesterday.day == inputTime.day) {
    return '昨天';
  }

  // 其他情况返回日期
  if (now.year != inputTime.year) {
    return outputYMDFormat.format(inputTime);
  } else {
    return outputMDFormat.format(inputTime);
  }
}

/// 在记录列表中获取出生地
String getProvinceName(person) {
  if (person.birthLocation.provinceName == null) {
    return '';
  }
  String provinceName = person.birthLocation.provinceName;
  if (provinceName != '') {
    if (provinceName != '黑龙江省') {
      return provinceName.substring(0, 2);
    } else {
      return provinceName.substring(0, 3);
    }
  } else {
    return '';
  }
}

/// 在分享信息时获取出生地
String getBirthLocation(person) {
  String provinceName = person.birthLocation.provinceName;
  String cityName = person.birthLocation.cityName;
  String areaName = person.birthLocation.areaName;
  if (provinceName != '') {
    return '\n$provinceName $cityName $areaName';
  } else {
    return '';
  }
}
