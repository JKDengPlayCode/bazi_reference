import 'package:bazi/pages/settings_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bazi/pages/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:bazi/common/constants.dart';
import 'package:bazi/pages/bazi_record/person_data_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(SettingsController());
  // 这个是不是插入的不是地方？全局？
  Get.put(PersonDataController());
  // Get.put(BaziFanTuiController());
  SystemChrome.setPreferredOrientations([
    // 仅支持竖屏正向
    DeviceOrientation.portraitUp,
  ]).then((_) => {runApp(const MyApp())});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // static const TextScaler noScaling = _LinearTextScaler(1.0);
  // static TextScaler textScalerOf(BuildContext context) => TextScaler.noScaling;

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return Obx(() {
      return GetMaterialApp(
        // 禁止程序字体大小随系统设置而改变，对系统设置中的字体大小起作用，对显示大小不起作用
        builder: (context, child) {
          final MediaQueryData mediaQueryData = MediaQuery.of(context);
          final modifiedMediaQueryData = mediaQueryData.copyWith(
            textScaler: TextScaler.noScaling,
          );
          return MediaQuery(
            data: modifiedMediaQueryData,
            child: child!,
          );
        },
        // 使日期选择器显示中文
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh', 'CH'),
          Locale('en', 'US'),
        ],
        locale: const Locale('zh'),
        debugShowCheckedModeBanner: false,
        title: '卜算子',
        themeMode: settingsController.themeMode.value,
        theme: ThemeData(
          colorSchemeSeed: ColorSeed.values[settingsController.colorSeedIndex.value].color,
          useMaterial3: true,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
            // toolbarHeight: 44,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            // shadowColor: Color(0x33F7F7F7),
            elevation: 0,
          ),
          scaffoldBackgroundColor: const Color(0xFFF0F0F0),
          cardTheme: const CardTheme(color: Colors.white, surfaceTintColor: Colors.transparent),
          dialogBackgroundColor: const Color(0xFFF0F0F0),
          dialogTheme: const DialogTheme(
            // backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
          // 因为ExpansionTile的折叠动画及颜色，不在这里固定tileColor
          listTileTheme: const ListTileThemeData(
            // tileColor: Colors.white,
            // tileColor: Theme.of(context).colorScheme.surface,
            // selectedTileColor: Colors.grey,
          ),
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: ColorSeed.values[settingsController.colorSeedIndex.value].color,
          useMaterial3: true,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            // toolbarHeight: 44,
            centerTitle: true,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
          ),
          // listTileTheme: ListTileThemeData(tileColor: Theme.of(context).colorScheme.inverseSurface),
          // listTileTheme: ListTileThemeData(tileColor: Theme.of(context).appBarTheme.backgroundColor),
        ),

        home: const HomePage(),
      );
    });
  }
}
