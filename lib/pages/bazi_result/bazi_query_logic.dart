import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bazi/components/lunar-1.6.1/lib/lunar.dart';
import 'package:get_storage/get_storage.dart';

class BaziQueryController extends GetxController {
  final List<String> TIANGAN = ['未选择', '甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
  final List<String> DIZHI = ['未选择', '子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];
  final TextEditingController ganController = TextEditingController();
  final TextEditingController zhiController = TextEditingController();

  final getAll = Get.arguments[0];
  final ganZhi = Get.arguments[1];
  final tianGan = ''.obs;
  final diZhi = ''.obs;
  final daYunChecked = true.obs;
  final liuNianChecked = true.obs;
  final liuYueChecked = true.obs;
  // 初始流日、流时选项为否
  final liuRiChecked = false.obs;
  final liuShiChecked = false.obs;
  List<GanZhiMatch> matches = <GanZhiMatch>[].obs;

  // 获取大运排布列表
  late List<DaYun> daYun;

  @override
  void onInit() {
    super.onInit();
    tianGan.value = TIANGAN.indexOf(ganZhi) > 0 ? ganZhi : '未选择';
    diZhi.value = DIZHI.indexOf(ganZhi) > 0 ? ganZhi : '未选择';
    daYun = getAll.rt()['daYun'];
    // 在初始化时，从本地存储中读取设置项的值，并赋值给相应变量。
    // 如果不需要保存选项状态，删除以下相关代码即可。
    if (GetStorage().read('daYunChecked') != null) {
      daYunChecked.value = GetStorage().read('daYunChecked');
    }
    if (GetStorage().read('liuNianChecked') != null) {
      liuNianChecked.value = GetStorage().read('liuNianChecked');
    }
    if (GetStorage().read('liuYueChecked') != null) {
      liuYueChecked.value = GetStorage().read('liuYueChecked');
    }
    if (GetStorage().read('liuRiChecked') != null) {
      liuRiChecked.value = GetStorage().read('liuRiChecked');
    }
    if (GetStorage().read('liuShiChecked') != null) {
      liuShiChecked.value = GetStorage().read('liuShiChecked');
    }

    // 初始化界面时，是否对单击的八字干支进行查询？如果单击的八字干支没有意义，那么在初始化时进行查询也没有什么意义
    // 如果能有干支选择的逻辑，那么此处可以添加对应逻辑，并在初始化时进行查询
    queryResult(daYun, tianGan.value, diZhi.value);
  }

  /// 为 DropdownMenu 创建下拉列表项
  List<DropdownMenuEntry<String>> buildEntryList(List<String> data) {
    return data.map((String value) {
      return DropdownMenuEntry<String>(value: value, label: value);
    }).toList();
  }

  /// 当选择天干下拉列表中的天干时
  void onTianGanSelect(String value) {
    tianGan.value = value;
    queryResult(daYun, tianGan.value, diZhi.value);
  }

  /// 当选择地支下拉列表中的地支时
  void onDiZhiSelect(String value) {
    diZhi.value = value;
    queryResult(daYun, tianGan.value, diZhi.value);
  }

  /// 当切换搜索类型选项开关时
  /// 大运必选
  /// 流年、流月、流日、流时，后者依赖前者。选后者则必选前者，取消前者则必会取消后者。
  // 已固定大运为必选项
  void onDaYunChanged() {
    daYunChecked.value = !daYunChecked.value;
    // 如果不选流年则必选大运
    if (!liuNianChecked.value) {
      daYunChecked.value = true;
    }
    saveCheckedOptions();
    queryResult(daYun, tianGan.value, diZhi.value);
  }

  // 已固定流年为必选项
  void onLiuNianChanged() {
    liuNianChecked.value = !liuNianChecked.value;
    // 如果不选流年，则其后的流月、流日、流时都不选
    if (!liuNianChecked.value) {
      liuYueChecked.value = false;
      liuRiChecked.value = false;
      liuShiChecked.value = false;
    }
    saveCheckedOptions();
    queryResult(daYun, tianGan.value, diZhi.value);
  }

  void onLiuYueChanged() {
    liuYueChecked.value = !liuYueChecked.value;
    if (liuYueChecked.value) {
      liuNianChecked.value = true;
    }
    if (!liuYueChecked.value) {
      liuRiChecked.value = false;
      liuShiChecked.value = false;
    }
    saveCheckedOptions();
    queryResult(daYun, tianGan.value, diZhi.value);
  }

  void onLiuRiChanged() {
    liuRiChecked.value = !liuRiChecked.value;
    if (liuRiChecked.value) {
      liuYueChecked.value = true;
      liuNianChecked.value = true;
    }
    if (!liuRiChecked.value) {
      liuShiChecked.value = false;
    }
    saveCheckedOptions();
    queryResult(daYun, tianGan.value, diZhi.value);
  }

  void onLiuShiChanged() {
    liuShiChecked.value = !liuShiChecked.value;
    if (liuShiChecked.value) {
      liuRiChecked.value = true;
      liuYueChecked.value = true;
      liuNianChecked.value = true;
    }
    saveCheckedOptions();
    queryResult(daYun, tianGan.value, diZhi.value);
  }
  /// 保存选项的选择状态到本地存储，如果不需要保存，则可以不实现此方法。
  void saveCheckedOptions() {
    GetStorage().write('daYunChecked', daYunChecked.value);
    GetStorage().write('liuNianChecked', liuNianChecked.value);
    GetStorage().write('liuYueChecked', liuYueChecked.value);
    GetStorage().write('liuRiChecked', liuRiChecked.value);
    GetStorage().write('liuShiChecked', liuShiChecked.value);
  }
  /// 遍历嵌套的大运、流年、流月、流日、流时列表，并将所有天干为指定值（如“庚”）的完整时刻记录在 GanZhiMatch 对象中，并存入 matches 列表。
  void queryResult(List<DaYun> daYun, String queryGan, String queryZhi) {
    String queryGanZhi = '${queryGan == '未选择' ? '' : queryGan}${queryZhi == '未选择' ? '' : queryZhi}';

    matches.clear();
    /// 如果queryGanZhi为空，则退出方法
    if (queryGanZhi.isEmpty) {
      return;
    }
    for (var dy in daYun) {
      if (dy.getGanZhi().contains(queryGanZhi)) {
        // 如果未选择‘流年’选项，在此处加入找到的大运
        if (!liuNianChecked.value) {
          matches.add(GanZhiMatch(dy, null, null, null, null));
        }
        for (var ln in dy.getLiuNian()) {
          // 如果未选择‘流年’选项，在这里退出循环
          if (!liuNianChecked.value) {
            break;
          }
          if (ln.getGanZhi().contains(queryGanZhi)) {
            if (!liuYueChecked.value) {
              matches.add(GanZhiMatch(dy, ln, null, null, null));
            }
            for (var ly in ln.getLiuYue()) {
              if (!liuYueChecked.value) {
                break;
              }
              if (ly.getGanZhi().contains(queryGanZhi)) {
                if (!liuRiChecked.value) {
                  matches.add(GanZhiMatch(dy, ln, ly, null, null));
                }
                for (var lr in ly.getLiuRi()) {
                  if (!liuRiChecked.value) {
                    break;
                  }
                  if (lr.getGanZhi().contains(queryGanZhi)) {
                    // 如果未选择‘流时’选项，在此处加入找到的流日，但并不退出查找流日的循环，继续找到更多符合条件的流日
                    if (!liuShiChecked.value) {
                      matches.add(GanZhiMatch(dy, ln, ly, lr, null));
                    }
                    for (var lsh in lr.getLiuShi()) {
                      // 如果未选择‘流时’选项，在此处退出查找流时的循环
                      if (!liuShiChecked.value) {
                        break;
                      }
                      if (lsh.contains(queryGanZhi)) {
                        matches.add(GanZhiMatch(dy, ln, ly, lr, lsh));
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    // return matches;
    update();
  }
}

/// 定义GanZhiMatch 对象
class GanZhiMatch {
  final DaYun? daYun; // 大运
  final LiuNian? liuNian; // 流年
  final LiuYue? liuYue; // 流月
  final LiuRi? liuRi; // 流日
  final String? shiGanZhi; // 流时

  /// 构造函数
  GanZhiMatch(this.daYun, this.liuNian, this.liuYue, this.liuRi, this.shiGanZhi);
}
