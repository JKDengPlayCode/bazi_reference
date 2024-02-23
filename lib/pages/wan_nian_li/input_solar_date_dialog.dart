import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';

class SolarInputDialog extends StatefulWidget {
  const SolarInputDialog({super.key, required this.onConfirmPressed, required this.currentSelectedDateTime});
  final Function(String) onConfirmPressed;
  final DateTime  currentSelectedDateTime;

  @override
  State<SolarInputDialog> createState() => SolarInputDialogState();
}

class SolarInputDialogState extends State<SolarInputDialog> {
  late FocusNode _solarInputFocusNode;
  late String _solarInputLabel = '公历日期时间';
  late final TextEditingController _solarInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _solarInputFocusNode = FocusNode();
    // 从万年历页面传过来的当前日期时间赋值给输入框
    _solarInputController.text = dateTimeToString(widget.currentSelectedDateTime);
  }

  @override
  void dispose() {
    _solarInputFocusNode.dispose();
    _solarInputController.dispose();
    super.dispose();
  }
  /// 把从万年历页面传过来的当前日期时间转换为String，用于在初始化对话框时赋值给日期时间输入框
  String dateTimeToString(DateTime dateTime) {
    // 对传过来的时间进行处理 '2024-01-07 15:41:09.856874' 使之返回14位数字 20240107154109
    String dateTimeString = dateTime.toString();
    int thePointIndex = dateTimeString.indexOf('.');

    if (thePointIndex >= 0) {
      String result = dateTimeString.substring(0, thePointIndex).replaceAll(RegExp(r'[ :\\-]+'), '');
      return result;
    } else {
      // 处理找不到 '.' 的情况
      return '';
    }
  }

  /// 验证输入的日期时间
  String? _validateDateTime(String? value) {
    if (value == null || value.isEmpty) {
      return '日期时间不存在或格式不正确';
    }
    // 格式校验,位数
    final dateTimeExp =
        RegExp(r'^(\d{4})(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])([01][0-9]|2[0-3])([0-5][0-9])([0-5][0-9])$');
    if (!dateTimeExp.hasMatch(value)) {
      // 格式不正确时
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
      Solar sd = Solar.fromYmd(year, month, day);
      _solarInputLabel = '$sd $hour:$minute:$second';
    } catch (e) {
      _solarInputLabel = '公历日期时间';
      return '日期时间不存在或格式不正确';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

    return Dialog(
      // insetPadding: EdgeInsets.zero,// 全屏幕无留白
      insetPadding: const EdgeInsets.all(6.0),// Adjust width here
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width, // Adjust width here
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sizedBoxSpace,
            TextFormField(
              controller: _solarInputController,
              restorationId: 'birthday_field',
              focusNode: _solarInputFocusNode,
              autofocus: true,
              onTapOutside: (e)=>_solarInputFocusNode.unfocus(),
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: true,
                border: const OutlineInputBorder(),
                hintText: '年月日时分秒14位数字',
                labelText: _solarInputLabel,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  String? validationResult = _validateDateTime(value);
                  if (validationResult != null) {
                    _solarInputLabel = '公历日期时间';
                  }
                });
              },
              maxLength: 14,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              validator: _validateDateTime,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            // sizedBoxSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.sync),
                  onPressed: () {
                    setState(() {
                      _solarInputController.clear();
                      _solarInputLabel = '公历日期时间';
                      _solarInputFocusNode.requestFocus();
                    });
                  },
                  label: const Text('重 置'),
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    // 如果验证通过
                    if (_validateDateTime(_solarInputController.text) == null) {
                      // 传递日期时间
                      widget.onConfirmPressed(_solarInputController.text);
                      // 关闭对话框
                      Navigator.of(context).pop();
                    } else {
                      // doNothing
                    }
                  },
                  label: const Text('确 定'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
