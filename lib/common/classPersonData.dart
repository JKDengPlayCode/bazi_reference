import 'dart:convert';
import 'package:get/get.dart';
import 'package:bazi/components/city_pickers-1.3.0/lib/modal/result.dart';

class PersonData {
  String id;
  String name;
  int gender;
  String birthday;
  Result birthLocation;
  int solarOrLunar;
  bool leapMonth;
  RxBool isSelected=false.obs; // 用于在历史记录页面，临时表示是否选中该项，不存入本地数据
  // int? ziShiPai;
  // int? qiYunPai;

  PersonData({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthday,
    required this.birthLocation,
    required this.solarOrLunar,
    required this.leapMonth,
    // this.selected=false,
    // required this.ziShiPai,
    // required this.qiYunPai,
  });

  // 如果有需要，你可以添加一个 fromJson 方法来将 Map 转换为 PersonData 对象
  factory PersonData.fromJson(Map<String, dynamic> json) {
    // print(json['birthLocation']);
    // print(json['birthLocation'].runtimeType);
    return PersonData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? 1,
      birthday: json['birthday'] ?? '',
      // birthLocation: json['birthLocation'],
      // birthLocation: Result.fromJson(json['birthLocation']),
      // birthLocation: Result.fromJson(jsonDecode(json['birthLocation'])),
      // birthLocation: json['birthLocation'] != null ? Result.fromJson(json['birthLocation']) : null,
      birthLocation: Result.fromJson(jsonDecode(json['birthLocation'] ?? '{}')),
      solarOrLunar: json['solarOrLunar'] ?? 1,
      leapMonth: json['leapMonth'] ?? false,
      // ziShiPai: json['ziShiPai'] ?? 2,
      // qiYunPai: json['qiYunPai'] ?? 2,
    );
  }
}

// class PersonData {
//   // 顾客ID
//   String id='';
//   // 顾客姓名或代号
//   String name = '';
//   // gender(数字)为性别，1为男，0为女
//   int gender = 1;
//   // 出生辰期时间字符串，如19760820112233
//   String birthday = '';
//   // 出生地 {"provinceName":"北京市","provinceId":"110000","cityName":"北京市城区","cityId":"110100","areaName":"朝阳区","areaId":"110105"}
//   Result? birthLocation;
//   //solarOrLunar(数字)为所用历法，1为阳历，0为阴历
//   int solarOrLunar = 1;
//   //ziShiPai(数字)为所用子时流派，1代表流派1，2代表流派2，这里Lunar.dart中一致，默认采用流派2
//   int ziShiPai = 2;
//   //qiYunPai(数字)为起运流派，1为流派1，2为流派2，这里默认使用流派2，与热卜算法一致。而在Lunar.dart中默认采用流派1
//   int qiYunPai = 2;
//   // leapMonth农历某年月有闫月，false 为选前面的 某月，或认为不存在闫月，true为有闫月且选后面的 闫某月，为true时month取负
//   bool leapMonth = false;
//   // 备注其他信息
//   // String? memo = '';
//
// }
