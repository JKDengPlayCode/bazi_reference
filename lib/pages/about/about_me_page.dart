// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
//
// import 'package:bazi/common/constants.dart';
// import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';
// import 'package:bazi/components/offset_widget.dart';
//
// import 'package:bazi/components/circle_image.dart';
// import 'package:bazi/components/user_list_tile.dart';
// import 'package:bazi/pages/help_pages.dart';
//
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});
//
//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   final SettingsController settingsController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Theme.of(context).colorScheme.background,
//       // appBar: AppBar(
//       //   title: const Text('设置'),
//       //   elevation: 0,
//       // ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             children: [
//               Container(
//                 height: 180,
//                 width: MediaQuery.of(context).size.width,
//                 margin:const EdgeInsets.only(bottom: 50),
//                 child: Image.asset(
//                   'assets/images/sabar.webp',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               _buildBar(context),
//               Positioned(
//                   bottom: 0,
//                   left: 50,
//                   child: CircleImage(
//                     size: 100,
//                     shadowColor: Theme.of(context).primaryColor,
//                     image: const AssetImage('assets/images/icon_head.webp'),
//                   )),
//             ],
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
//               child: Stack(children: <Widget>[
//                 Positioned(
//                   right: 10,
//                   top: 0,
//                   child: Icon(Icons.help),
//                 ),
//                 _buildInfo()
//               ]),
//             ),
//           ),
//         ],
//       ),
//
//       // Center(
//       //   child: Padding(
//       //     padding: const EdgeInsets.all(8.0),
//       //     child: ListView(
//       //       children: [
//       //         // const Divider(),
//       //          Card(
//       //           child: _SingleSection(
//       //             // title: '我的',
//       //             children: [
//       //               UserListTile(user: User(name: '王子老师', email: 'dfjksdfk@dkfj.com', avatarUrl: ''),),
//       //               const _CustomListTile(
//       //                 title: '待开发功能',
//       //                 icon: Icons.person,
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //         Card(
//       //           child: _SingleSection(
//       //             title: '显示模式',
//       //             children: [
//       //               Obx(
//       //                 () {
//       //                   return _CustomListTile(
//       //                     title: '深色模式',
//       //                     icon: Icons.dark_mode,
//       //                     trailing: Checkbox(
//       //                       value: !settingsController.useLightMode.value,
//       //                       onChanged: (value) {
//       //                         settingsController.toggleTheme();
//       //                       },
//       //                     ),
//       //                   );
//       //                 },
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //         Card(
//       //           child: _SingleSection(
//       //               title: '主题颜色',
//       //               children: List.generate(ColorSeed.values.length, (index) {
//       //                 // ColorSeed currentColor = ColorSeed.values[index];
//       //                 return Obx(
//       //                   () {
//       //                     return _CustomListTile(
//       //                       title: ColorSeed.values[index].label,
//       //                       icon: index == settingsController.colorSeedIndex.value ? Icons.color_lens : Icons.color_lens_outlined,
//       //                       iconColor: ColorSeed.values[index].color,
//       //                       trailing: Radio(
//       //                         value: index,
//       //                         toggleable: index != settingsController.colorSeedIndex.value,
//       //                         onChanged: (value) {
//       //                           settingsController.toggleThemeColor(value!);
//       //                         },
//       //                         groupValue: settingsController.colorSeedIndex.value,
//       //                       ),
//       //                     );
//       //                   },
//       //                 );
//       //               })),
//       //         ),
//       //         // TODO: 暂时禁用流派选择，原因：作用域不清晰、有不一致的地方
//       //         // Card(
//       //         //   child: Obx(() {
//       //         //     return _SingleSection(
//       //         //       title: '子时流派',
//       //         //       children: [
//       //         //         _CustomListTile(
//       //         //           title: '晚子时日柱算明天',
//       //         //           icon: Icons.star_border,
//       //         //           trailing: Radio(
//       //         //             value: 1,
//       //         //             onChanged: (value) {
//       //         //               settingsController.toggleZiShiPai(value!);
//       //         //             },
//       //         //             groupValue: settingsController.selectedZiShiPai.value,
//       //         //           ),
//       //         //         ),
//       //         //         _CustomListTile(
//       //         //           title: '晚子时日柱算当天',
//       //         //           icon: Icons.star_half,
//       //         //           trailing: Radio(
//       //         //             value: 2,
//       //         //             onChanged: (value) {
//       //         //               settingsController.toggleZiShiPai(value!);
//       //         //             },
//       //         //             groupValue: settingsController.selectedZiShiPai.value,
//       //         //           ),
//       //         //         ),
//       //         //       ],
//       //         //     );
//       //         //   }),
//       //         // ),
//       //         // // const Divider(),
//       //         // Card(
//       //         //   child: Obx(() {
//       //         //     return _SingleSection(
//       //         //       title: '起运流派',
//       //         //       children: [
//       //         //         _CustomListTile(
//       //         //           title: '4320分=1年,360分=1月,12分=1天,1分=2小时',
//       //         //           icon: Icons.camera,
//       //         //           trailing: Radio(
//       //         //             value: 2,
//       //         //             onChanged: (value) {
//       //         //               settingsController.toggleQiYunPai(value!);
//       //         //             },
//       //         //             groupValue: settingsController.selectedQiYunPai.value,
//       //         //           ),
//       //         //         ),
//       //         //         _CustomListTile(
//       //         //           title: '3天=1年,1天=4月,1时辰=10天',
//       //         //           icon: Icons.camera_outlined,
//       //         //           trailing: Radio(
//       //         //             value: 1,
//       //         //             onChanged: (value) {
//       //         //               settingsController.toggleQiYunPai(value!);
//       //         //             },
//       //         //             groupValue: settingsController.selectedQiYunPai.value,
//       //         //           ),
//       //         //         ),
//       //         //       ],
//       //         //     );
//       //         //   }),
//       //         // ),
//       //         // // const Divider(),
//       //         // Card(
//       //         //   child: Obx(() {
//       //         //     return _SingleSection(
//       //         //       title: '干支纪年',
//       //         //       children: [
//       //         //         // const Divider(),
//       //         //         _CustomListTile(
//       //         //           title: '新年以立春节令交接的时刻起算\n新的一月以节交接准确时刻起算',
//       //         //           // icon: Icons.camera,
//       //         //           trailing: Radio(
//       //         //             value: 0,
//       //         //             onChanged: (value) {
//       //         //               settingsController.toggleGanZhiLi(value!);
//       //         //             },
//       //         //             groupValue: settingsController.selectedGanZhiLi.value,
//       //         //           ),
//       //         //         ),
//       //         //         const Divider(
//       //         //           indent: 18,
//       //         //           endIndent: 20,
//       //         //           color: Color.fromRGBO(128, 128, 128, 0.1),
//       //         //         ),
//       //         //         _CustomListTile(
//       //         //           title: '新年以立春零点起算\n新的一月以节交接准确时刻起算',
//       //         //           // icon: Icons.camera_outlined,
//       //         //           trailing: Radio(
//       //         //             value: 1,
//       //         //             onChanged: (value) {
//       //         //               settingsController.toggleGanZhiLi(value!);
//       //         //             },
//       //         //             groupValue: settingsController.selectedGanZhiLi.value,
//       //         //           ),
//       //         //         ),
//       //         //         const Divider(
//       //         //           indent: 18,
//       //         //           endIndent: 20,
//       //         //           color: Color.fromRGBO(128, 128, 128, 0.1),
//       //         //         ),
//       //         //         _CustomListTile(
//       //         //           title: '新年以正月初一起算\n新的一月以节交接当天零点起算',
//       //         //           // icon: Icons.camera_outlined,
//       //         //           trailing: Radio(
//       //         //             value: 2,
//       //         //             onChanged: (value) {
//       //         //               settingsController.toggleGanZhiLi(value!);
//       //         //             },
//       //         //             groupValue: settingsController.selectedGanZhiLi.value,
//       //         //           ),
//       //         //         ),
//       //         //       ],
//       //         //     );
//       //         //   }),
//       //         // ),
//       //         Card(
//       //           child: _SingleSection(
//       //             title: '其他',
//       //             children: [
//       //               const _CustomListTile(title: '分享', icon: Icons.share),
//       //               _CustomListTile(
//       //                 title: '帮助',
//       //                 icon: Icons.help_outline_rounded,
//       //                 onTap: () {
//       //                   Get.to(() => HelpPage());
//       //                 },
//       //               ),
//       //
//       //               const _CustomListTile(title: '关于应用', icon: Icons.info_outline_rounded),
//       //               const _CustomListTile(title: '版本信息', icon: Icons.data_saver_off_outlined),
//       //               // const _CustomListTile(title: '版本信息', icon: CupertinoIcons.share),
//       //               // _CustomListTile(title: '赞助', icon: Icons.coffee_outlined),
//       //             ],
//       //           ),
//       //         ),
//       //       ],
//       //     ),
//       //   ),
//       // ),
//     );
//   }
//   Widget _buildBar(BuildContext context) {
//     return Container(
//       height: kToolbarHeight,
//       margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//       child: Row(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () => Navigator.of(context).pop(),
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10),
//               child: Icon(
//                 Icons.arrow_back,
//                 size: 30,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ),
//           ),
//           const Spacer(),
//           const SizedBox(width: 20)
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('张风捷特烈',
//             style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 20),
//         const Divider(height: 18),
//         const Text('The King Of Coder. 「编程之王」', style: TextStyle(fontSize: 16)),
//         const SizedBox(height: 10),
//         const Text('海的彼岸有我未曾见证的风采。', style: TextStyle(fontSize: 16)),
//         const SizedBox(height: 10),
//         const Text(
//             '微信群: 编程技术交流圣地 -【Flutter群】\n'
//                 '愿青梅煮酒，与君天涯共话。',
//             style: TextStyle(color: Colors.grey)),
//         const SizedBox(height: 10),
//         Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: AspectRatio(
//                   aspectRatio: 1,
//                   child: Image.asset(
//                     'assets/images/wechat.webp',
//                     fit: BoxFit.fitWidth,
//                   )),
//             )),
//         const Center(
//           child: Text(
//             '我的微信',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
//
//
// }
//
// /// 自定义设置项ListTile样式
// class _CustomListTile extends StatelessWidget {
//   final String title;
//   final IconData? icon;
//   final Widget? trailing;
//   final Color? iconColor;
//   final Function()? onTap;
//
//   const _CustomListTile({
//     required this.title,
//     this.icon,
//     this.trailing,
//     this.iconColor,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       // dense: true,
//       visualDensity: VisualDensity.compact,
//       title: offsetWidget(14, Text(title)),
//       leading: offsetWidget(14, Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary)),
//       trailing: trailing ?? offsetWidget(-14, Icon(CupertinoIcons.forward, size: 18, color: Theme.of(context).colorScheme.primary)),
//       onTap: onTap,
//     );
//   }
// }
//
// /// 自定义设置单元Section样式
// class _SingleSection extends StatelessWidget {
//   final String? title;
//   final List<Widget> children;
//
//   const _SingleSection({
//     this.title,
//     required this.children,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(Radius.circular(7.0)),
//         ),
//         margin: const EdgeInsets.symmetric(vertical: 9.0), // 设置外边距
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (title != null)
//               Padding(
//                 // padding: const EdgeInsets.all(8.0),
//                 padding: const EdgeInsets.only(left: 18.0, top: 8, right: 8, bottom: 8),
//                 child: Text(
//                   title!,
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             Column(
//               children: children,
//             ),
//           ],
//         ));
//   }
// }
//
// /// 包含程序中各项设置：显示模式、 主题颜色、 流派设置
// class SettingsController extends GetxController {
//   // 使用ThemeController控制应用程序的brightness值
//   // 在main.dart中获取此值，并应用于brightness: themeController.useLightMode.value
//   /// 显示模式控制器：护眼/暗黑/节能/深色模式  / 浅色模式
//   final useLightMode = true.obs;
//
//   // 使用ColorController控制应用程序的主题颜色 colorSchemeSeed值
//   // 在main.dart中获取此值，并应用于colorSchemeSeed: colorController.colorSelected.value
//   /// 主题颜色有：默认紫、蓝、绿、红等
//   final colorSeedIndex = 0.obs;
//
//   // 三类流派设置
//   /// 初始默认子时流派1:晚子时算明天。影响八字排盘、四柱八字反推、万年历
//   final selectedZiShiPai = 1.obs;
//
//   /// 初始默认起运流派2
//   final selectedQiYunPai = 2.obs;
//
//   /// 部分神煞基准设定，默认0以日干为基准，1以年干为基准，2以日干年干为基准
//
//   /// 万年历干支历法选项，默认0：与八字相同：新年以立春节气交接的时刻起算，新的一月以节交接准确时刻起算
//   final selectedGanZhiLi = 0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     /// 在初始化时，从本地存储中读取设置项的值，并赋值给相应变量。
//     // 显示模式
//     var isLightMode = GetStorage().read('useLightMode');
//     if (isLightMode != null) {
//       useLightMode.value = isLightMode;
//     }
//     // 下面是错误用法：Unhandled Exception: type 'Null' is not a subtype of type 'bool'
//     // 不能直接用 useLightMode.value = GetStorage().read('useLightMode');
//     // 主题颜色
//     var selectedColorIndex = GetStorage().read('colorSeedIndex');
//     if (selectedColorIndex != null) {
//       colorSeedIndex.value = selectedColorIndex;
//     }
//     // 流派设置
//     var ziShiPai = GetStorage().read('selectedZiShiPai');
//     var qiYunPai = GetStorage().read('selectedQiYunPai');
//     var ganZhiLi = GetStorage().read('selectedGanZhiLi');
//     if (ziShiPai != null) {
//       selectedZiShiPai.value = ziShiPai;
//     }
//     if (qiYunPai != null) {
//       selectedQiYunPai.value = qiYunPai;
//     }
//     if (ganZhiLi != null) {
//       selectedGanZhiLi.value = ganZhiLi;
//     }
//   }
//
//   /// 给万年历背景图片一个透明度值，在0到24时，经过公式运算得到一个0.2至0.5之间的值，x取万年历的小时数（0~24时）
//   double calculateValue(int x) {
//     return 0.1 * sin(-pi / 12 * x) + 0.2;
//   }
//
//   /// 切换显示模式
//   void toggleTheme() {
//     useLightMode.value = !useLightMode.value;
//     GetStorage().write('useLightMode', useLightMode.value);
//   }
//
//   /// 切换主题颜色
//   void toggleThemeColor(int value) {
//     colorSeedIndex.value = value;
//     GetStorage().write('colorSeedIndex', colorSeedIndex.value);
//   }
//
//   /// 切换晚子时流派
//   void toggleZiShiPai(int value) {
//     selectedZiShiPai.value = value;
//     GetStorage().write('selectedZiShiPai', selectedZiShiPai.value);
//   }
//
//   /// 切换起运流派
//   void toggleQiYunPai(int value) {
//     selectedQiYunPai.value = value;
//     GetStorage().write('selectedQiYunPai', selectedQiYunPai.value);
//   }
//
//   /// 切换万年历干支历法
//   void toggleGanZhiLi(int value) {
//     selectedGanZhiLi.value = value;
//     GetStorage().write('selectedGanZhiLi', selectedGanZhiLi.value);
//   }
//
//   /// 为万年历页面提供干支历法年月日时
//   String ganZhiLiForWanNianLi(Lunar lunar, int option) {
//     switch (option) {
//       case 0:
//       // 使用与八字相同的方法getEightChar()，以及相同的子时流派设置
//       //0：'新年以立春节气交接的时刻起算\n新的一月以节交接准确时刻起算',与八字相同
//         EightChar ganZhiDate = lunar.getEightChar();
//         ganZhiDate.setSect(selectedZiShiPai.value);
//         return '${ganZhiDate.getYear()}年 ${ganZhiDate.getMonth()}月 ${ganZhiDate.getDay()}日 ${ganZhiDate.getTime()}时';
//     // 1：'新年以立春零点起算\n新的一月以节交接准确时刻起算',
//       case 1:
//         switch (selectedZiShiPai.value) {
//         // 流派1，晚子时日柱算明天
//           case 1:
//             return '${lunar.getYearInGanZhiByLiChun()}年 ${lunar.getMonthInGanZhiExact()}月 ${lunar.getDayInGanZhiExact()}日 ${lunar.getTimeInGanZhi()}时';
//         // 流派2，晚子时日柱算当天
//           case 2:
//           default:
//             return '${lunar.getYearInGanZhiByLiChun()}年 ${lunar.getMonthInGanZhiExact()}月 ${lunar.getDayInGanZhiExact2()}日 ${lunar.getTimeInGanZhi()}时';
//         }
//     // 2：'新年以正月初一起算\n新的一月以节交接当天零点起算',与农历匹配
//       case 2:
//       default:
//         return '${lunar.getYearInGanZhi()}年 ${lunar.getMonthInGanZhi()}月 ${lunar.getDayInGanZhi()}日 ${lunar.getTimeInGanZhi()}时';
//     }
//   }
// }
