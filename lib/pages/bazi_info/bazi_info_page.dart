import 'package:get/get.dart';
import 'package:bazi/pages/bazi_result/bazi_result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';
import 'package:bazi/components/iconfont.dart';

// 使用自己修改的city_pickers，FullPage界面及数据
import 'package:bazi/components/city_pickers-1.3.0/lib/city_pickers.dart';
import 'package:bazi/common/classPersonData.dart';
import 'package:bazi/pages/bazi_record/person_data_controller.dart';

/// 原BaziInforPage页面，仅保留BaziInforForm部分，用于修改信息对话框
class BaziInforForm extends StatefulWidget {
  const BaziInforForm({super.key, this.personData, this.isOpenedDialogForm});
  final PersonData? personData;
  final bool? isOpenedDialogForm;

  @override
  State<BaziInforForm> createState() => BaziInforFormState();
}

// class BaziInforFormState extends State<BaziInforForm> with RestorationMixin {
class BaziInforFormState extends State<BaziInforForm> with RestorationMixin {
  late PersonData person;
  // final BaziFanTuiController baziFanTuiController = Get.find();
  late FocusNode _nameFocusNode, _birthdayFocusNode, _locationFocusNode, _leapMonthFocusNode;

  late String _birthDayLabel = '生辰*';
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _birthdayController = TextEditingController();
  late final TextEditingController _locationController = TextEditingController();

  // 这里初始化的值决定了DropdownButtonFormField的DropdownMenuItem的默认选项
  int _selectedGender = 1; // 初始默认性别1为男性，0为女性
  int _selectedCalender = 1; // 初始默认历法1为阳历，0为阴历
  // 本页仅仅提交人员基本信息，在这里不获取或设置流派值，在设置页面进行设置并存储到本地，解析时调用
  // int _selectedZiShiPai = 2; // 初始默认子时流派2
  // int _selectedQiYunPai = 2; // 初始默认起运流派2
  bool _selectedLeapMonth = false; // 初始默认农历普通月，true农历闫月
  bool _showLeapMonth = true; // true 不显示闫月确认框 offstage: _showLeapMonth,
  String _tempBirthDayLabel = ''; // 临时存储标签，用在闫月检测通过后，如选择闫月则赋值给标签
  Result _birthLocation = Result(); // 出生地
  // Result _birthLocation = {'provinceName':'','provinceId':'','cityName':'','cityId':'','areaName':'','areaId':''};

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _birthdayFocusNode = FocusNode();
    _leapMonthFocusNode = FocusNode();
    _locationFocusNode = FocusNode();

    // 从历史记录传过来的person，或新建一个person
    person = widget.personData ??
        PersonData(
          id: '',
          name: '',
          gender: 1,
          birthday: '',
          birthLocation: Result(),
          solarOrLunar: 1,
          leapMonth: false,
        );

    // 为表单各项赋值
    _nameController.text = person.name;
    _birthdayController.text = person.birthday;
    _birthLocation = Result();
    _locationController.text = person.birthLocation.provinceName == '' || person.birthLocation.provinceName == null
        ? ''
        : '${person.birthLocation.provinceName} ${person.birthLocation.cityName} ${person.birthLocation.areaName}';
    _selectedGender = person.gender;
    _selectedCalender = person.solarOrLunar;
    _selectedLeapMonth = person.leapMonth;
    // 是否显示闫月选择框，如果选择了leapMonth=true则肯定是闫月，那么就显示闫月选择框并勾选闫月
    // 如果选择了leapMonth=false则肯定不是闫月，那么也要显示闫月选择框，但不勾选闫月，所以是否显示闫月框应由下面的日期验证方法确定
    // _showLeapMonth = !person.leapMonth;
    _birthLocation = person.birthLocation.provinceName == '' ? Result() : person.birthLocation;
    //调用日期验证_validateDateTime方法，程序自行决定是否显示或勾选闫月
    _validateDateTime(_birthdayController.text);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthdayController.dispose();
    _locationController.dispose();
    _nameFocusNode.dispose();
    _birthdayFocusNode.dispose();
    _leapMonthFocusNode.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }

  @override
  String get restorationId => 'information_input';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_autoValidateModeIndex, 'autovalidate_mode');
  }

  final RestorableInt _autoValidateModeIndex = RestorableInt(AutovalidateMode.disabled.index);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // 提交表单内容
  Future<void> _handleSubmitted() async {
    // 使键盘消失
    FocusScope.of(context).unfocus();
    _onPressedValidateDateTime(_birthdayController.text, _selectedCalender);
    final form = _formKey.currentState!;
    if (!form.validate()) {
      _autoValidateModeIndex.value = AutovalidateMode.always.index; // Start validating on every change.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('生辰不能为空且必须正确解析', textAlign: TextAlign.center),
          dismissDirection: DismissDirection.down,
        ),
      );
    } else {
      // 调试时用：看看都提交了什么内容，看完就注释掉！
      // print('birthLocation:$_birthLocation');
      // print('person-birthLocation:${person.birthLocation}');
      form.save();
      // 用Get在本地存储person的信息
      PersonDataController personDataController = Get.find<PersonDataController>();
      // 将人员基本信息加入到排盘记录中，本地存储
      personDataController.savePersonData(person);

      // 根据 widget.isOpenedDialogForm 的值执行不同的操作
      // 如果显示在对话框模式下，则说明其来自于历史记录页面的编辑后提交按钮。
      if (widget.isOpenedDialogForm == true) {
        // 清空/重置 历史记录中的已选项列表
        personDataController.selectedList.clear();
        personDataController.isSelectedExist.value = false;
        // 点击提交按钮时关闭对话框，并提交修改
        Navigator.of(context).pop();
        Get.to(() => BaziResultPage(person: person));
        // Get.to(() => BaziResultNewPage(),arguments: {'person':person});
      } else {
        // 提交信息并重置表单，重置有点多余，返回以后用户可以手动点一下重置按钮
        Get.to(() => BaziResultPage(person: person));
        // _resetForm();
      }
    }
  }

  // 重置表单内容
  void _resetForm() {
    _formKey.currentState?.reset();
    _birthdayController.clear();
    setState(() {
      // 重置为初始值
      _nameController.text = '';
      _birthDayLabel = '生辰*';
      _birthLocation = Result();
      _locationController.text = '';
      _selectedGender = 1;
      _selectedCalender = 1;
      _selectedLeapMonth = false;
      _showLeapMonth = true;
    });
  }

  // 校验姓名，不能为空
  // String? _validateName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return '必须填写姓名';
  //   }
  //   return null;
  // }

  // 在数据发生变化时，进行格式校验和日期真实存在合法性检验
  // 格式必须正确且日期时间的各部分数值必须在允许的范围内，如月不能大于12，时不能大于24
  // 日期有效性，如2月有28或29天、农历每月有没有三十，甚至日期是否存在等问题，可以根据Lunar返回值去判断

  String? _validateDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return '生辰不能为空';
    }
    // 格式校验,位数
    final dateTimeExp =
        RegExp(r'^(\d{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])([01][0-9]|2[0-3])([0-5][0-9])([0-5][0-9])$');
    if (!dateTimeExp.hasMatch(value)) {
      // 格式不正确时，不显示闫月选择框，且置为非闫月
      _showLeapMonth = true;
      _selectedLeapMonth = false;
      return '日期时间不存在或格式不正确';
    }

    // 合法性校验
    int year = int.parse(value.substring(0, 4));
    int month = int.parse(value.substring(4, 6));
    int day = int.parse(value.substring(6, 8));
    DateTime dt = DateTime.parse(value.substring(0, 8));
    String hour = value.substring(8, 10);
    String minute = value.substring(10, 12);
    String second = value.substring(12, 14);
    if (dt.day != day || dt.month != month || dt.year != year) {
      return '日期时间不存在或格式不正确';
    }

    try {
      // 以下3项，任一项若获取不到则报错
      if (_selectedCalender == 1) {
        // 1.用Solar.fromYmd()获取输入所代表的公历日期，如15821005不存在则触发错误
        Solar sd = Solar.fromYmd(year, month, day);
        _birthDayLabel = '$sd $hour:$minute:$second';
      } else {
        // 2.用Lunar获取输入所代表的农历日期
        Lunar ld = Lunar.fromYmd(year, month, day);
        // 3.再获取该农历日期所代表的公历日期
        ld.getSolar();
        _birthDayLabel = '$ld $hour:$minute:$second';
        int lpMonth = LunarYear.fromYear(year).getLeapMonth();
        if (lpMonth == month) {
          Lunar lpd = Lunar.fromYmd(year, -lpMonth, day);
          // 闫月该日期的公历存在
          lpd.getSolar();
          // 才显示闫月选择框
          _showLeapMonth = false;
          // 临时存储，如选择闫月则赋值给_birthDayLabel
          _tempBirthDayLabel = '$lpd $hour:$minute:$second';
        }
      }
    } catch (e) {
      _birthDayLabel = '生辰*';
      return '日期时间不存在或格式不正确';
    }
    return null;
  }

  // 在点击切换公历、农历按钮时进行数据校验
  void _onPressedValidateDateTime(String? value, int liFa) {
    if (value!.length == 14) {
      // 合法性校验
      int year = int.parse(value.substring(0, 4));
      int month = int.parse(value.substring(4, 6));
      int day = int.parse(value.substring(6, 8));
      DateTime dt = DateTime.parse(value.substring(0, 8));
      String hour = value.substring(8, 10);
      String minute = value.substring(10, 12);
      String second = value.substring(12, 14);
      if (dt.day == day && dt.month != month && dt.year != year) {
        _birthDayLabel = '生辰*';
      }
      try {
        // 以下3项，任一项若获取不到则报错
        if (liFa == 1) {
          // 公历时，不显示闫月选择框，且置为非闫月
          _showLeapMonth = true;
          _selectedLeapMonth = false;
          // 1.用Solar获取输入所代表的公历日期
          Solar sd = Solar.fromYmd(year, month, day);
          _birthDayLabel = '$sd $hour:$minute:$second';
        } else {
          // 2.用Lunar获取输入所代表的农历日期
          Lunar ld = Lunar.fromYmd(year, month, day);
          // 3.再获取该农历日期所代表的公历日期
          ld.getSolar();
          _birthDayLabel = '$ld $hour:$minute:$second';
          int lpMonth = LunarYear.fromYear(year).getLeapMonth();
          // 是闫月且闫月该日期存在才显示，闫月的天数不一定，小月没有三十
          if (lpMonth == month) {
            Lunar lpd = Lunar.fromYmd(year, -lpMonth, day);
            // 闫月该日期的公历存在
            lpd.getSolar();
            // 才显示闫月选择框
            _showLeapMonth = false;
            // 临时存储，如选择闫月则赋值给_birthDayLabel
            _tempBirthDayLabel = '$lpd $hour:$minute:$second';
          }
        }
      } catch (e) {
        _birthDayLabel = '生辰*';
      }
    } else {
      _birthDayLabel = '生辰*';
    }
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.values[_autoValidateModeIndex.value],
      child: Scrollbar(
        child: SingleChildScrollView(
          restorationId: 'information_input',
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              sizedBoxSpace,
              TextFormField(
                restorationId: 'name_field',
                controller: _nameController,
                textInputAction: TextInputAction.done,
                focusNode: _nameFocusNode,
                onTapOutside: (e)=>_nameFocusNode.unfocus(),
                decoration: InputDecoration(
                  // filled: true,
                  border: const OutlineInputBorder(),
                  icon: _selectedGender == 1
                      ? const Icon(TaiJiIconFont.nansheng) // 如果性别为男性，显示男性图标
                      // ? const Icon(Icons.man) // 如果性别为男性，显示男性图标
                      : const Icon(TaiJiIconFont.nvsheng), // 否则显示女性图标,
                  // : const Icon(Icons.woman), // 否则显示女性图标,
                  hintText: '输入姓名（选填）',
                  labelText: '姓名',
                  suffixIcon: IconButton(
                    icon: _selectedGender == 1
                        ? const Icon(Icons.male) // 如果性别为男性，显示男性图标
                        : const Icon(Icons.female), // 否则显示女性图标
                    onPressed: () {
                      // 点击suffixIcon图标时使TextFormField自动获取焦点
                      _nameFocusNode.requestFocus();
                      setState(() {
                        _selectedGender = _selectedGender == 1 ? 0 : 1; // 切换性别
                      });
                    },
                  ),
                  suffixText: _selectedGender == 1 ? '男' : '女',
                ),
                onSaved: (value) {
                  person.name = value == null || value.isEmpty ? '未知' : value;
                  person.gender = _selectedGender;
                },
                maxLength: 5,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
              ),
              sizedBoxSpace,
              TextFormField(
                controller: _birthdayController,
                restorationId: 'birthday_field',
                focusNode: _birthdayFocusNode,
                onTapOutside: (e)=>_birthdayFocusNode.unfocus(),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  filled: true,
                  border: const OutlineInputBorder(),
                  icon: const Icon(Icons.today),
                  hintText: '年月日时分秒14位数字',
                  labelText: _birthDayLabel,
                  suffixIcon: IconButton(
                    icon: _selectedCalender == 1
                        ? const Icon(Icons.light_mode) // 公历阳历图标
                        : const Icon(Icons.dark_mode), // 农历阴历图标
                    onPressed: () {
                      _birthdayFocusNode.requestFocus();
                      setState(() {
                        _selectedCalender = _selectedCalender == 1 ? 0 : 1; // 切换历法
                        _onPressedValidateDateTime(_birthdayController.text, _selectedCalender);
                      });
                    },
                  ),
                  suffixText: _selectedCalender == 1 ? '公历' : '农历',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    String? validationResult = _validateDateTime(value);
                    if (validationResult != null) {
                      _birthDayLabel = '生辰*'; // 如果输入不符合格式，则显示 '生辰*'
                    }
                  });
                },
                onSaved: (value) {
                  person.birthday = value!;
                  person.solarOrLunar = _selectedCalender;
                },
                maxLength: 14,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                validator: _validateDateTime,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              sizedBoxSpace,
              Offstage(
                offstage: _showLeapMonth,
                child: TextFormField(
                  restorationId: 'leap_month_field',
                  readOnly: true,
                  focusNode:_leapMonthFocusNode,
                  onTapOutside: (e)=>_leapMonthFocusNode.unfocus(),
                  decoration: InputDecoration(
                    // filled: true,
                    border: const OutlineInputBorder(),
                    icon: _selectedLeapMonth
                        ? const Icon(Icons.join_right) // 闫月图标
                        : const Icon(Icons.join_left), // 普通月图标
                    hintText: '是否闫月？',
                    labelText: '是否闫月？',
                    suffixIcon: Checkbox(
                      value: _selectedLeapMonth,
                      onChanged: (value) {
                        setState(() {
                          _selectedLeapMonth = !_selectedLeapMonth;
                          // 选择闫月，则显示先前存储的临时_tempBirthDayLabel
                          _birthDayLabel = _selectedLeapMonth ? _tempBirthDayLabel : _birthDayLabel;
                        });
                      },
                    ),
                  ),
                  onSaved: (value) {
                    person.leapMonth = _selectedLeapMonth;
                  },
                ),
              ),
              _showLeapMonth ? Container() : sizedBoxSpace,
              TextFormField(
                controller: _locationController,
                restorationId: 'birth_location_field',
                readOnly: true,
                focusNode: _locationFocusNode,
                onTapOutside: (e)=>_locationFocusNode.unfocus(),
                decoration: InputDecoration(
                  // filled: true,
                  border: const OutlineInputBorder(),
                  icon: const Icon(Icons.location_on_outlined),
                  hintText: _locationController.text == '' ? '选择出生地时自动启用真太阳时' : _locationController.text,
                  labelText: '出生地',
                  suffixIcon: IconButton(
                    icon: _locationController.text == ''
                        ? const Icon(Icons.add_location_alt_outlined)
                        : const Icon(Icons.wrong_location_outlined),
                    onPressed: () async {
                      _locationFocusNode.requestFocus();
                      if (_locationController.text == '') {
                        Result? result = await CityPickers.showFullPageCityPicker(
                          context: context,
                        );
                        if (result != null) {
                          setState(() {
                            _locationController.text =
                                '${result.provinceName!} ${result.cityName!} ${result.areaName!}';
                            _birthLocation = result;
                          });
                        }
                      } else {
                        setState(() {
                          // 删除出生地内容时，清空
                          _birthLocation = Result();
                          _locationController.text = '';
                        });
                      }
                    },
                  ),
                ),
                onSaved: (value) {
                  person.birthLocation = _birthLocation;
                },
              ),
              sizedBoxSpace,
              // 重置、提交按钮
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.sync),
                      onPressed: _resetForm,
                      label: const Text('重 置'),
                    ),
                    FilledButton.icon(
                      icon: const Icon(Icons.done),
                      onPressed: _handleSubmitted,
                      label: const Text('解 析'),
                    ),
                  ],
                ),
              ),
              sizedBoxSpace,
            ],
          ),
        ),
      ),
    );
  }
}
