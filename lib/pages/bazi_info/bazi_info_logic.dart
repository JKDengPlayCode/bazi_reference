import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bazi/components/city_pickers-1.3.0/lib/city_pickers.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';

import 'package:bazi/common/classPersonData.dart';
import 'package:bazi/pages/bazi_record/person_data_controller.dart';
import 'package:bazi/pages/bazi_result/bazi_result_page.dart';

class BaziInforController extends GetxController {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController birthdayController = TextEditingController();
  late TextEditingController locationController = TextEditingController();
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late PersonData person = PersonData(
    id: '',
    name: '',
    gender: 1,
    birthday: '',
    birthLocation: Result(),
    solarOrLunar: 1,
    leapMonth: false,
  );

  late FocusNode nameFocusNode = FocusNode();
  late FocusNode birthdayFocusNode = FocusNode();
  late FocusNode locationFocusNode = FocusNode();
  late FocusNode leapMonthFocusNode = FocusNode();

  var name = ''.obs;
  var selectedGender = 1.obs;
  var selectedCalender = 1.obs;
  var selectedLeapMonth = false.obs;
  var hideLeapMonth = true.obs;
  var birthDay = ''.obs;
  var birthDayLabel = '生辰*'.obs;
  var birthLocation = Result().obs;
  var birthLocationSet = false.obs;
  // 临时存储，如选择闫月则赋值给leapMonthBirthDayLabel
  String leapMonthBirthDayLabel = '';
  String solarBirthDayLabel = '';
  String lunarBirthDayLabel = '';
  bool hideLeapMonthField = true;

  @override
  void onInit() {
    super.onInit();
    nameFocusNode = FocusNode();
    birthdayFocusNode = FocusNode();
    leapMonthFocusNode = FocusNode();
    locationFocusNode = FocusNode();
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    locationController = TextEditingController();
    person = PersonData(
      id: '',
      name: name.value,
      gender: selectedGender.value,
      birthday: birthDay.value,
      birthLocation: birthLocation.value,
      solarOrLunar: selectedCalender.value,
      leapMonth: selectedLeapMonth.value,
    );
  }

  /// 点击性别切换按钮
  void genderOnPressed() {
    // 点击suffixIcon图标时使TextFormField自动获取焦点
    nameFocusNode.requestFocus();
    selectedGender.value = selectedGender.value == 1 ? 0 : 1; // 切换性别;
  }

  /// 保存姓名、性别
  void nameFieldOnSaved() {
    person.name = nameController.text.isEmpty ? '未知' : nameController.text;
    person.gender = selectedGender.value;
  }

  /// 保存生辰
  void birthdayFieldOnSaved() {
    person.birthday = birthdayController.text;
    person.solarOrLunar = selectedCalender.value;
  }

  /// 修改姓名
  void nameFieldOnChange() {
    name.value = nameController.text;
  }

  /// 修改生辰
  void birthdayFieldOnChange() {
    birthDay.value = birthdayController.text;
    if (validateDateTime().isEmpty) {
      if (selectedCalender.value == 1) {
        hideLeapMonth.value = true;
        birthDayLabel.value = solarBirthDayLabel;
      } else {
        hideLeapMonth.value = hideLeapMonthField;
        birthDayLabel.value = lunarBirthDayLabel;
      }
    } else {
      birthDayLabel.value = '生辰*';
    }
  }

  /// 保存是否闫月
  void leapMonthFieldOnSaved() {
    person.leapMonth = selectedLeapMonth.value;
  }

  /// 保存出生地
  void birthLocationFieldOnSaved() {
    person.birthLocation = birthLocation.value;
  }

  /// 点击切换公历/农历按钮\进行生辰数据校验
  void calenderOnPressed() {
    birthdayFocusNode.requestFocus();
    selectedCalender.value = selectedCalender.value == 1 ? 0 : 1;
    if (validateDateTime().isEmpty) {
      if (selectedCalender.value == 1) {
        selectedLeapMonth.value = false;
        hideLeapMonth.value = true;
        birthDayLabel.value = solarBirthDayLabel;
      } else {
        hideLeapMonth.value = hideLeapMonthField;
        birthDayLabel.value = lunarBirthDayLabel;
      }
    } else {
      birthDayLabel.value = '生辰*';
    }
  }

  /// 点击切换是否闫月
  void leapMonthCheckChange() {
    selectedLeapMonth.value = !selectedLeapMonth.value;
    // 选择闫月，则显示先前存储的临时 leapMonthBirthDayLabel
    birthDayLabel.value = selectedLeapMonth.value ? leapMonthBirthDayLabel : lunarBirthDayLabel;
  }

  /// 点击增加出生地图标 选择出生地
  void setLocation(Result result) async {
    birthLocationSet.value = true;
    locationController.text = '${result.provinceName!} ${result.cityName!} ${result.areaName!}';
    birthLocation.value = result;
  }

  /// 点击删除出生地图标 清空出生地
  void deleteLocation() {
    // 删除出生地内容时，清空
    birthLocation.value = Result();
    // person.birthLocation = birthLocation.value;
    locationController.text = '';
    birthLocationSet.value = false;
  }

  /// 在点击切换公历、农历按钮及输入、修改生辰时进行数据校验
  /// 在此方法中不能操作obs变量，即不能直接修改涉及界面变化的元素
  String validateDateTime() {
    String? value = birthdayController.text;
    if (value.isEmpty) {
      hideLeapMonthField = true;
      return '生辰不能为空';
    }
    // 格式校验,位数
    final dateTimeExp =
        RegExp(r'^(\d{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])([01][0-9]|2[0-3])([0-5][0-9])([0-5][0-9])$');
    if (!dateTimeExp.hasMatch(value)) {
      // 格式不正确时，不显示闫月选择框，且置为非闫月
      // hideLeapMonth.value = true;
      // selectedLeapMonth.value = false;
      hideLeapMonthField = true;
      return '日期时间不存在或格式不正确';
    }
    if (value.length == 14) {
      // 合法性校验
      int year = int.parse(value.substring(0, 4));
      int month = int.parse(value.substring(4, 6));
      int day = int.parse(value.substring(6, 8));
      DateTime dt = DateTime.parse(value.substring(0, 8));
      String hour = value.substring(8, 10);
      String minute = value.substring(10, 12);
      String second = value.substring(12, 14);
      if (dt.day == day && dt.month != month && dt.year != year) {
        hideLeapMonthField = true;
        return '日期时间不存在或格式不正确';
      }
      try {
        // 以下3项，任一项若获取不到则报错
        if (selectedCalender.value == 1) {
          // 公历时，不显示闫月选择框，且置为非闫月
          hideLeapMonthField = true;
          // 1.用Solar获取输入所代表的公历日期
          Solar sd = Solar.fromYmd(year, month, day);
          solarBirthDayLabel = '$sd $hour:$minute:$second';
        } else {
          // 2.用Lunar获取输入所代表的农历日期
          Lunar ld = Lunar.fromYmd(year, month, day);
          // 3.再获取该农历日期所代表的公历日期
          ld.getSolar();
          lunarBirthDayLabel = '$ld $hour:$minute:$second';
          int lpMonth = LunarYear.fromYear(year).getLeapMonth();
          // 是闫月且闫月该日期存在才显示，闫月的天数不一定，小月没有三十
          if (lpMonth == month) {
            Lunar lpd = Lunar.fromYmd(year, -lpMonth, day);
            // 闫月该日期的公历存在
            lpd.getSolar();
            // 才显示闫月选择框
            hideLeapMonthField = false;
            // 临时存储，如选择闫月则赋值给_birthDayLabel
            leapMonthBirthDayLabel = '$lpd $hour:$minute:$second';
          }
        }
      } catch (e) {
        hideLeapMonthField = true;
        return '日期时间不存在或格式不正确';
      }
    } else {
      hideLeapMonthField = true;
      return '日期时间不存在或格式不正确';
    }
    return '';
  }

  /// 提交表单
  Future<void> submitForm() async {
    // 调试时用：看看都提交了什么内容，看完就注释掉！
    // print('birthLocation:$_birthLocation');
    // print('person-birthLocation:${person.birthLocation}');
    person.name = nameController.text.isEmpty ? '未知' : nameController.text;
    person.gender = selectedGender.value;
    person.birthday = birthdayController.text;
    person.solarOrLunar = selectedCalender.value;
    person.leapMonth = selectedLeapMonth.value;
    person.birthLocation = birthLocation.value;
    // 用Get在本地存储person的信息
    PersonDataController personDataController = Get.find<PersonDataController>();
    // 将人员基本信息加入到排盘记录中，本地存储
    personDataController.savePersonData(person);
    Get.to(() => BaziResultPage(person: person));
  }

  // 重置表单内容
  void resetForm() {
    // _formKey.currentState?.reset();
    birthdayController.clear();
    nameController.text = '';
    birthDayLabel.value = '生辰*';
    birthLocation.value = Result();
    birthLocationSet.value = false;
    locationController.text = '';
    selectedGender.value = 1;
    selectedCalender.value = 1;
    selectedLeapMonth.value = false;
    hideLeapMonth.value = true;
  }
}
