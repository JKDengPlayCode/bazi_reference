import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:bazi/common/constants.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';
import 'package:bazi/components/offset_widget.dart';

import 'package:bazi/components/circle_image.dart';
import 'package:bazi/pages/help_pages.dart';

import '../components/radius_no_div_expansion_tile.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final SettingsController settingsController = Get.find();

  @override
  Widget build(BuildContext context) {
    // 根据深浅模式改变背景图片
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // backgroundColor: !isDark ?  const Color(0xFFF0F0F0) : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              // height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // colors: [Theme.of(context).colorScheme.primary.withOpacity(0.5), Colors.transparent],
                  // colors: [Theme.of(context).colorScheme.primary.withOpacity(0.5), Theme.of(context).colorScheme.primary.withOpacity(0.09)],
                  colors: [Theme.of(context).colorScheme.primary.withOpacity(0.5), Theme.of(context).colorScheme.surface],
                ),
                // borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              // 在这里添加你的头部内容（如：标题、Logo等）
              child: Column(
                children: [
                  /*顶部信息：头像+昵称+编辑资料*/
                  topInfo(context),
                  //用户数据：关注+收藏+点赞+历史
                  userDate(),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // 常用功能
                commonFunction(context, isDark),

                Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8), // 设置圆角
                  ),
                  child: const _CustomListTile(
                    title: '待开发会员功能：黄金广告位',
                    icon: Icons.person,
                  ),
                ),
                _ItemContainer(
                  child: Obx(() {
                    return RadiusNoBorderExpansionTile(
                        subListTileRadius: 8.0,
                        leading: Icon(
                            // Icon(Icons.light_mode) Icon(Icons.dark_mode) Icon(Icons.style)
                            Icons.style,
                            color: Theme.of(context).colorScheme.primary),
                        // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                        // title: const Text('显示模式',style: TextStyle(fontWeight: FontWeight.w600),),
                        title: const Text('显示模式'),
                        children: <Widget>[
                          _CustomListTile(
                            title: '跟随系统',
                            icon: Icons.phonelink_setup_outlined,
                            trailing: offsetWidget(
                              18,
                              Transform.scale(
                                scale: 0.7,
                                child: CupertinoSwitch(
                                  activeColor: Theme.of(context).colorScheme.primary,
                                  value: settingsController.followSystem.value,
                                  onChanged: (value) {
                                    settingsController.toggleFollowSystem();
                                  },
                                ),
                              ),
                            ),
                          ),
                          _CustomListTile(
                            title: '浅色模式',
                            icon: Icons.light_mode_outlined,
                            trailing: Offstage(
                              // 当跟随系统模式时，不显示
                              offstage: settingsController.followSystem.value,
                              child: offsetWidget(
                                13,
                                Radio(
                                  value: true,
                                  onChanged: (value) {
                                    !settingsController.followSystem.value ? settingsController.toggleTheme() : null;
                                  },
                                  groupValue: settingsController.useLightMode.value,
                                ),
                              ),
                            ),
                          ),
                          _CustomListTile(
                            title: '深色模式',
                            icon: Icons.dark_mode_outlined,
                            trailing: Offstage(
                              offstage: settingsController.followSystem.value,
                              child: offsetWidget(
                                13,
                                Radio(
                                  value: false,
                                  onChanged: (value) {
                                    !settingsController.followSystem.value ? settingsController.toggleTheme() : null;
                                  },
                                  groupValue: settingsController.useLightMode.value,
                                ),
                              ),
                            ),
                          ),
                        ]);
                  }),
                ),
                _ItemContainer(
                  child: RadiusNoBorderExpansionTile(
                    leading: Icon(
                      Icons.color_lens,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('主题颜色'),
                    subListTileRadius: 8.0,
                    children: List.generate(ColorSeed.values.length, (index) {
                      // ColorSeed currentColor = ColorSeed.values[index];
                      return Obx(() {
                        return _CustomListTile(
                          title: ColorSeed.values[index].label,
                          icon: index == settingsController.colorSeedIndex.value ? Icons.color_lens : Icons.color_lens_outlined,
                          // iconColor: ColorSeed.values[index].color,
                          // 根据所选颜色以及当前显示模式，显示图标颜色，以匹配不同颜色在浅色、深色模式下的不同显示效果
                          iconColor: isDark
                              ? ColorScheme.fromSeed(seedColor: ColorSeed.values[index].color).inversePrimary
                              : ColorScheme.fromSeed(seedColor: ColorSeed.values[index].color).primary,
                          // .isBlank ? Icon(CupertinoIcons.forward, size: 18, color: Theme.of(context).colorScheme.primary):offsetWidget(-14,trailing )
                          trailing: offsetWidget(
                              12,
                              Radio(
                                value: index,
                                toggleable: index != settingsController.colorSeedIndex.value,
                                onChanged: (value) {
                                  settingsController.toggleThemeColor(value!);
                                },
                                groupValue: settingsController.colorSeedIndex.value,
                              )),
                        );
                      });
                    }),
                  ),
                ),
                _ItemContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _CustomListTile(title: '分享', icon: Icons.share),
                      _CustomListTile(
                        title: '帮助',
                        icon: Icons.help_outline_rounded,
                        onTap: () {
                          Get.to(() => HelpPage());
                        },
                      ),

                      const _CustomListTile(title: '关于应用', icon: Icons.info_rounded),
                      const _CustomListTile(title: '版本信息', icon: Icons.data_saver_off_outlined),
                      // const _CustomListTile(title: '版本信息', icon: CupertinoIcons.share),
                      // _CustomListTile(title: '赞助', icon: Icons.coffee_outlined),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*顶部信息：头像+昵称+编辑资料*/
  Padding topInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 80, 10, 20),
      child: Row(
        children: [
          GestureDetector(
            child: CircleImage(
              size: 60,
              shadowColor: Theme.of(context).primaryColor.withAlpha(33),
              // image: NetworkImage(state.user.userAvatar),
              /// todo 如何实现点击头像可以选择相册中的图片或者使用摄像头拍摄照片作为头像
              image: const AssetImage(
                "assets/images/logo.webp",
              ),
            ),
            onTap: () {},
          ),
          const Padding(padding: EdgeInsets.fromLTRB(16, 0, 100, 0), child: Text('ID: 1234567890', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))),
        ],
      ),
    );
  }

  /*用户数据：关注+收藏+历史*/
  Container userDate() {
    return Container(
        margin: const EdgeInsets.only(top: 8,bottom: 8),
        height: 50,
        // width: 360,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //主轴方向（横向）间距
          children: [
            Column(
              children: [
                Text('66', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text('关注'),
              ],
            ),
            Column(
              children: [
                Text('101', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text('收藏'),
              ],
            ),
            Column(
              children: [
                Text('278', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text('点赞'),
              ],
            ),
            Column(
              children: [
                Text('579', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text('历史'),
              ],
            ),
          ],
        ));
  }

  /*常用功能*/
  Container commonFunction(context, bool isDark) {
    return Container(
        margin: const EdgeInsets.only(top: 10, left: 6, right: 6, bottom: 5),
        height: 90,
        // width: 360,
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8), // 设置圆角
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, //垂直方向平分
          children: [
            // const Align(
            //   alignment: Alignment.topLeft,
            //   child: Text('  常用功能', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, //主轴方向（横向）间距
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.message),
                      onPressed: () {},
                      color: Colors.blue,
                    ),
                    const Text('消息'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.directions_boat),
                      onPressed: () {},
                      color: Colors.redAccent,
                    ),
                    const Text('动态'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
                      color: Colors.green,
                    ),
                    const Text('设置'),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.output),
                      onPressed: () {},
                      color: Colors.deepOrangeAccent,
                    ),
                    const Text('退出'),
                  ],
                )
              ],
            )
          ],
        ));
  }
}

/// 自定义我的/设置界面各项的容器
class _ItemContainer extends StatelessWidget {
  final Widget child;

  const _ItemContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8), // 设置圆角
      ),
      child: child,
    );
  }
}

/// 自定义设置项ListTile样式
class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final Color? iconColor;
  final Function()? onTap;

  const _CustomListTile({
    required this.title,
    this.icon,
    this.trailing,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      // dense: true,
      // tileColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
      // tileColor: isDark? null : Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      visualDensity: VisualDensity.compact,
      title: Text(title),
      leading: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary),
      trailing: trailing ?? Icon(Icons.navigate_next, color: Theme.of(context).colorScheme.primary),
      onTap: onTap,
    );
  }
}

/// 包含程序中各项设置：显示模式、 主题颜色、 流派设置
class SettingsController extends GetxController {
  /// 显示模式控制器：护眼/暗黑/节能/深色模式  / 浅色模式
  final useLightMode = true.obs;
  final followSystem = false.obs;
  final themeMode = ThemeMode.light.obs;

  // 使用ColorController控制应用程序的主题颜色 colorSchemeSeed值
  // 在main.dart中获取此值，并应用于colorSchemeSeed: colorController.colorSelected.value
  /// 主题颜色有：默认紫、蓝、绿、红等
  final colorSeedIndex = 0.obs;

  // 三类流派设置
  /// 初始默认子时流派1:晚子时算明天。影响八字排盘、四柱八字反推、万年历
  final selectedZiShiPai = 1.obs;

  /// 初始默认起运流派2
  final selectedQiYunPai = 2.obs;

  /// 部分神煞基准设定，默认0以日干为基准，1以年干为基准，2以日干年干为基准

  /// 万年历干支历法选项，默认0：与八字相同：新年以立春节气交接的时刻起算，新的一月以节交接准确时刻起算
  final selectedGanZhiLi = 0.obs;

  @override
  void onInit() {
    super.onInit();

    /// 在初始化时，从本地存储中读取设置项的值，并赋值给相应变量。

    // 显示模式 跟随系统模式
    // 在启动时从存储中读取并还原主题模式
    var whichThemeString = GetStorage().read<String>('themeMode');
    if (whichThemeString != null) {
      switch (whichThemeString) {
        case 'light':
          themeMode.value = ThemeMode.light;
          break;
        case 'dark':
          themeMode.value = ThemeMode.dark;
          break;
        case 'system':
          themeMode.value = ThemeMode.system;
          break;
        default:
          // 如果存储的字符串不匹配任何 ThemeMode，则可以设置默认值
          themeMode.value = ThemeMode.light;
      }
    }
    // 在启动时从存储中读取并还原主题模式
    var isSystemMode = GetStorage().read('followSystem');
    if (isSystemMode != null) {
      followSystem.value = isSystemMode;
      if (followSystem.value) {
        // 如果跟随系统模式
        themeMode.value = ThemeMode.system;
      } else {
        // 显示模式 深色模式/浅色模式
        var isLightMode = GetStorage().read('useLightMode');
        if (isLightMode != null) {
          useLightMode.value = isLightMode;
          if (useLightMode.value) {
            themeMode.value = ThemeMode.light;
          } else {
            themeMode.value = ThemeMode.dark;
          }
        }
      }
    }

    // 主题颜色
    var selectedColorIndex = GetStorage().read('colorSeedIndex');
    if (selectedColorIndex != null) {
      colorSeedIndex.value = selectedColorIndex;
    }
    // 流派设置
    var ziShiPai = GetStorage().read('selectedZiShiPai');
    var qiYunPai = GetStorage().read('selectedQiYunPai');
    var ganZhiLi = GetStorage().read('selectedGanZhiLi');
    if (ziShiPai != null) {
      selectedZiShiPai.value = ziShiPai;
    }
    if (qiYunPai != null) {
      selectedQiYunPai.value = qiYunPai;
    }
    if (ganZhiLi != null) {
      selectedGanZhiLi.value = ganZhiLi;
    }
  }

  /// 给万年历背景图片一个透明度值，在0到24时，经过公式运算得到一个0.2至0.5之间的值，x取万年历的小时数（0~24时）
  double calculateValue(int x) {
    return 0.1 * sin(-pi / 12 * x) + 0.2;
  }

  /// 切换显示模式是否跟随系统
  void toggleFollowSystem() {
    followSystem.value = !followSystem.value;
    GetStorage().write('followSystem', followSystem.value);
    if (followSystem.value) {
      themeMode.value = ThemeMode.system;
    } else {
      themeMode.value = useLightMode.value ? ThemeMode.light : ThemeMode.dark;
    }
    // 将 ThemeMode 转换为字符串进行存储
    GetStorage().write('themeMode', themeMode.value.toString());
  }

  /// 切换浅色/深色显示模式
  void toggleTheme() {
    useLightMode.value = !useLightMode.value;
    GetStorage().write('useLightMode', useLightMode.value);
    themeMode.value = useLightMode.value ? ThemeMode.light : ThemeMode.dark;
    GetStorage().write('themeMode', themeMode.value.toString());
  }

  /// 切换主题颜色
  void toggleThemeColor(int value) {
    colorSeedIndex.value = value;
    GetStorage().write('colorSeedIndex', colorSeedIndex.value);
  }

  /// 切换晚子时流派
  void toggleZiShiPai(int value) {
    selectedZiShiPai.value = value;
    GetStorage().write('selectedZiShiPai', selectedZiShiPai.value);
  }

  /// 切换起运流派
  void toggleQiYunPai(int value) {
    selectedQiYunPai.value = value;
    GetStorage().write('selectedQiYunPai', selectedQiYunPai.value);
  }

  /// 切换万年历干支历法
  void toggleGanZhiLi(int value) {
    selectedGanZhiLi.value = value;
    GetStorage().write('selectedGanZhiLi', selectedGanZhiLi.value);
  }

  /// 为万年历页面提供干支历法年月日时
  String ganZhiLiForWanNianLi(Lunar lunar, int option) {
    switch (option) {
      case 0:
        // 使用与八字相同的方法getEightChar()，以及相同的子时流派设置
        //0：'新年以立春节气交接的时刻起算\n新的一月以节交接准确时刻起算',与八字相同
        EightChar ganZhiDate = lunar.getEightChar();
        ganZhiDate.setSect(selectedZiShiPai.value);
        return '${ganZhiDate.getYear()}年 ${ganZhiDate.getMonth()}月 ${ganZhiDate.getDay()}日 ${ganZhiDate.getTime()}时';
      // 1：'新年以立春零点起算\n新的一月以节交接准确时刻起算',
      case 1:
        switch (selectedZiShiPai.value) {
          // 流派1，晚子时日柱算明天
          case 1:
            return '${lunar.getYearInGanZhiByLiChun()}年 ${lunar.getMonthInGanZhiExact()}月 ${lunar.getDayInGanZhiExact()}日 ${lunar.getTimeInGanZhi()}时';
          // 流派2，晚子时日柱算当天
          case 2:
          default:
            return '${lunar.getYearInGanZhiByLiChun()}年 ${lunar.getMonthInGanZhiExact()}月 ${lunar.getDayInGanZhiExact2()}日 ${lunar.getTimeInGanZhi()}时';
        }
      // 2：'新年以正月初一起算\n新的一月以节交接当天零点起算',与农历匹配
      case 2:
      default:
        return '${lunar.getYearInGanZhi()}年 ${lunar.getMonthInGanZhi()}月 ${lunar.getDayInGanZhi()}日 ${lunar.getTimeInGanZhi()}时';
    }
  }
}
