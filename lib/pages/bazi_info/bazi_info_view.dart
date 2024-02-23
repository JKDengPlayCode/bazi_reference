import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:bazi/components/city_pickers-1.3.0/lib/city_pickers.dart';
import 'package:bazi/components/iconfont.dart';
import 'package:bazi/pages/bazi_fan_tui/bazi_fan_tui_view.dart';
import 'package:bazi/pages/bazi_record/bazi_record_page.dart';
import 'package:bazi/pages/bazi_info/bazi_info_logic.dart';

/// 使用get重构过的BaziInfoNewPage信息录入页面，可接受四柱八字反查结果
class BaziInfoNewPage extends StatelessWidget {
  BaziInfoNewPage({super.key});
  final BaziInforController baziInfoController = Get.put(BaziInforController());

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Theme.of(context).colorScheme.onInverseSurface : Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('信息录入'),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.f_cursive_circle),
          tooltip: '四柱八字反查',
          onPressed: () {
            Get.bottomSheet(
              BaziFanTuiBottomSheet(),
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.person_2_square_stack,
            ),
            tooltip: '历史记录',
            onPressed: () {
              Get.to(() => BaziRecordPage());
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () {
            return Column(
              children: <Widget>[
                const SizedBox(height: 24),
                TextFormField(
                  restorationId: 'name_field',
                  controller: baziInfoController.nameController,
                  textInputAction: TextInputAction.next,
                  focusNode: baziInfoController.nameFocusNode,
                  onTapOutside: (e) => baziInfoController.nameFocusNode.unfocus(),
                  decoration: InputDecoration(
                    // filled: true,
                    border: const OutlineInputBorder(),
                    icon: baziInfoController.selectedGender.value == 1
                        ? const Icon(TaiJiIconFont.nansheng) // 如果性别为男性，显示男性图标
                        : const Icon(TaiJiIconFont.nvsheng),
                    // 否则显示女性图标,
                    hintText: '输入姓名（选填）',
                    labelText: '姓名',
                    suffixIcon: IconButton(
                      icon: baziInfoController.selectedGender.value == 1
                          ? const Icon(Icons.male)
                          : const Icon(Icons.female),
                      onPressed: () {
                        baziInfoController.genderOnPressed();
                      },
                    ),
                    suffixText: baziInfoController.selectedGender.value == 1 ? '男' : '女',
                  ),
                  onSaved: (value) {
                    baziInfoController.nameFieldOnSaved();
                  },
                  maxLength: 5,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: baziInfoController.birthdayController,
                  restorationId: 'birthday_field',
                  focusNode: baziInfoController.birthdayFocusNode,
                  onTapOutside: (e) => baziInfoController.birthdayFocusNode.unfocus(),
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    filled: true,
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.today),
                    hintText: '年月日时分秒14位数字',
                    labelText: baziInfoController.birthDayLabel.value,
                    suffixIcon: IconButton(
                      icon: baziInfoController.selectedCalender.value == 1
                          ? const Icon(Icons.light_mode) // 公历阳历图标
                          : const Icon(Icons.dark_mode), // 农历阴历图标
                      onPressed: () {
                        baziInfoController.calenderOnPressed();
                      },
                    ),
                    suffixText: baziInfoController.selectedCalender.value == 1 ? '公历' : '农历',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    baziInfoController.birthdayFieldOnChange();
                  },
                  onSaved: (value) {
                    baziInfoController.birthdayFieldOnSaved();
                  },
                  maxLength: 14,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  validator: (value) {
                    if (baziInfoController.validateDateTime().isNotEmpty) {
                      return baziInfoController.validateDateTime();
                    } else {
                      return null;
                    }
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 24),
                Offstage(
                  offstage: baziInfoController.hideLeapMonth.value,
                  child: TextFormField(
                    restorationId: 'leap_month_field',
                    readOnly: true,
                    focusNode: baziInfoController.leapMonthFocusNode,
                    onTapOutside: (e) => baziInfoController.leapMonthFocusNode.unfocus(),
                    decoration: InputDecoration(
                      // filled: true,
                      border: const OutlineInputBorder(),
                      icon: baziInfoController.selectedLeapMonth.value
                          ? const Icon(Icons.join_right) // 闫月图标
                          : const Icon(Icons.join_left),
                      // 普通月图标
                      hintText: '是否闫月？',
                      labelText: '是否闫月？',
                      suffixIcon: Checkbox(
                        value: baziInfoController.selectedLeapMonth.value,
                        onChanged: (value) {
                          baziInfoController.leapMonthCheckChange();
                        },
                      ),
                    ),
                    onSaved: (value) {
                      baziInfoController.leapMonthFieldOnSaved();
                    },
                  ),
                ),
                baziInfoController.hideLeapMonth.value ? Container() : const SizedBox(height: 24),
                TextFormField(
                  controller: baziInfoController.locationController,
                  restorationId: 'birth_location_field',
                  readOnly: true,
                  focusNode: baziInfoController.locationFocusNode,
                  onTapOutside: (e) => baziInfoController.locationFocusNode.unfocus(),
                  decoration: InputDecoration(
                    // filled: true,
                    border: const OutlineInputBorder(),
                    icon: const Icon(Icons.location_on_outlined),
                    hintText: baziInfoController.locationController.text.isEmpty
                        ? '选择出生地时自动启用真太阳时'
                        : baziInfoController.locationController.text,
                    labelText: '出生地',
                    suffixIcon: IconButton(
                      icon: baziInfoController.birthLocationSet.value
                          ? const Icon(Icons.wrong_location_outlined)
                          : const Icon(Icons.add_location_alt_outlined),
                      onPressed: () async {
                        baziInfoController.locationFocusNode.requestFocus();
                        if (baziInfoController.locationController.text.isEmpty) {
                          Result? result = await CityPickers.showFullPageCityPicker(
                            context: context,
                          );
                          if (result != null) {
                            baziInfoController.setLocation(result);
                          }
                        } else {
                          baziInfoController.deleteLocation();
                        }
                      },
                    ),
                  ),
                  onSaved: (value) {
                    baziInfoController.birthLocationFieldOnSaved();
                  },
                ),
                const SizedBox(height: 24),
                // 重置、提交按钮
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.sync),
                        onPressed: () {
                          baziInfoController.resetForm();
                        },
                        label: const Text('重 置'),
                      ),
                      FilledButton.icon(
                        icon: const Icon(Icons.done),
                        onPressed: () {
                          if(baziInfoController.validateDateTime().isNotEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text('生辰不能为空且必须正确解析', textAlign: TextAlign.center),
                                dismissDirection: DismissDirection.down,
                              ),
                            );
                          }else{
                            baziInfoController.submitForm();
                          }
                        },
                        label: const Text('解 析'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}
