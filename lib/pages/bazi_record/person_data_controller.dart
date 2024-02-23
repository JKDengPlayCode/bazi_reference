import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bazi/common/classPersonData.dart';
import 'package:bazi/components/city_pickers-1.3.0/lib/modal/result.dart';

/// 利用GetX包，在录入界面提交时将人员信息保存到本地
/// 在历史记录页面读取本地存储的人员信息，并控制人员信息列表的增删查改
class PersonDataController extends GetxController {
  RxList<PersonData> personDataList = <PersonData>[].obs; // 本地存储的全部人员信息列表
  RxString searchText = ''.obs; // 搜索姓名文本框中的文本
  RxList<PersonData> filteredList = <PersonData>[].obs; // 搜索姓名过滤后的人员信息列表
  RxList<PersonData> selectedList = <PersonData>[].obs; // 长按选中后的人员信息列表
  RxBool isSelected = false.obs; // 该人员是否被选中
  RxBool isSelectedExist = false.obs; // 是否有被长按选中的人员，若有则显示底部功能按钮
  RxBool manageRecordByUser = false.obs; // 是否用户主动打开批量删除，若是则显示底部功能按钮
  // selectedList.length 用来统计有多少人员被选中，若有则显示在删除按钮的角标上
  // 姓名搜索框的文本编辑控制器和焦点
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void onInit() {
    loadPersonDataFromLocal();
    // ever() 方法是GetX状态管理库提供的一个函数，它用于监听一个 Rx 变量，并在该变量改变时执行特定的操作
    ever(searchText, (_) => filterSearchResults(searchText.value));
    super.onInit();
  }

  /// 从本地存储中读取已经保存的人员信息
  void loadPersonDataFromLocal() {
    // List<String> keys = GetStorage().getKeys();
    List<String> keys = GetStorage().getKeys().toList();
    List<PersonData> loadedPersonDataList = [];

    for (String key in keys) {
      if (key.startsWith('personData_')) {
        String? jsonStr = GetStorage().read(key);
        // print('打印读取的记录内容: $jsonStr'); // 打印读取的记录内容
        if (jsonStr != null) {
          Map<String, dynamic> personDataMap = jsonDecode(jsonStr);

          // Convert Map back to PersonData object
          PersonData personData = PersonData(
            // Map keys must match the PersonData properties
            id: personDataMap['id'],
            name: personDataMap['name'],
            gender: personDataMap['gender'] as int,
            birthday: personDataMap['birthday'],
            birthLocation: Result.fromJson(jsonDecode(personDataMap['birthLocation'])),
            solarOrLunar: personDataMap['solarOrLunar'] as int,
            leapMonth: personDataMap['leapMonth'] as bool,
          );

          loadedPersonDataList.add(personData);
        }
      }
    }
    // 按录入时间顺序倒序排列，输入晚的在最上面。
    loadedPersonDataList.sort((a, b) => int.parse(b.id.substring(11)).compareTo(int.parse(a.id.substring(11))));

    // 更新 personDataList 和 filteredList
    personDataList.assignAll(loadedPersonDataList);
    filteredList.assignAll(loadedPersonDataList);
    // 在数据变动时，如编辑人员信息后，重新搜索
    filterSearchResults(searchText.value);
  }

  /// 在新建或编辑人员且提交表单以后，将人员存储/更新到本地存储中
  void savePersonData(PersonData person) {
    try {
      // 生成唯一标识符，比如基于时间戳
      String uniqueKey = 'personData_${DateTime.now().millisecondsSinceEpoch}';
      // 将 PersonData 实例转换为 Map
      Map<String, dynamic> personDataMap = {
        'id': uniqueKey,
        'name': person.name,
        'gender': person.gender,
        'birthday': person.birthday,
        // 'birthLocation':person.birthLocation.toString(),
        'birthLocation': person.birthLocation.toString(), // 检查并设置默认值
        'solarOrLunar': person.solarOrLunar,
        'leapMonth': person.leapMonth,
      };

      // 获取指定键的值
      dynamic value = GetStorage().read(person.id);

      if (value != null) {
        // 如果已经存在该人员 id，即已经存储于本地，编辑该人员信息时，
        // 首先移除该人员旧的信息，然后以新的 uniqueKey 存储，
        // 这样，新建或编辑人员信息都会排列在记录列表的最上方
        GetStorage().remove(person.id);
      }

      // 存储新的人员信息
      GetStorage().write(uniqueKey, jsonEncode(personDataMap));
      loadPersonDataFromLocal();
    } catch (e) {
      // 处理异常情况
      // print("Error while saving data: $e");
    }
  }

  /// 从本地存储中删除一个人员信息，同时也从各列表中删除
  void removePersonData(String personId) {
    GetStorage().remove(personId);
    personDataList.removeWhere((person) => person.id == personId);
    filteredList.removeWhere((person) => person.id == personId);
    selectedList.removeWhere((person) => person.id == personId);
    // 从本地删除某一项（或几项）时，页面中显示的列表会重新加载
    // 是否存在被选中项
    bool exit = false;
    // 对两类列表都进行查询，如果有选中的则exit为true
    for (PersonData p in personDataList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    for (PersonData p in filteredList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    isSelectedExist.value = exit;
  }

  /// 搜索历史记录列表中的姓名
  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      // 搜索文本不为空时，清空selectedList已选列表
      // selectedList.clear(); 不能清空，有一种情况，用户在所有人员中选择，然后可能会通过搜索再选择
      List<PersonData> filtered = personDataList.where((person) {
        return person.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredList.assignAll(filtered);
    } else {
      filteredList.assignAll(personDataList);
    }
  }

  /// 清除搜索文本框中的搜索文本内容
  void clearSearchText() {
    searchText.value = '';
    searchController.clear();
    searchFocusNode.unfocus();
    filteredList.clear();
  }

  /// 切换用户主动打开批量删除manageRecordByUser以决定是否显示底部功能按钮
  void toggleManageRecordByUser(){
    manageRecordByUser.value = !manageRecordByUser.value;
    // 当手动关闭时，如果存在被选中项，则执行‘取消’按钮的方法清空所有被选项，隐藏底部功能按钮
    if(!manageRecordByUser.value){
      if(isSelectedExist.value){
        cancelSelectOperation();
      }
    }
  }

  /// 长按切换是否选中，传入操作的列表，list可能是personDataList或filteredList
  void toggleSelection(List<PersonData> list, PersonData person) {
    // 切换选中状态
    person.isSelected.value = !person.isSelected.value;
    // 如果该人员被选中，则列表中存在被选中人员，将该人员加入被选列表
    if (person.isSelected.value) {
      isSelectedExist.value = true;
      selectedList.add(person);
    } else {
      selectedList.remove(person);
    }
    bool exit = false;
    // 对两类列表都进行查询，如果有选中的则exit为true
    for (PersonData p in personDataList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    for (PersonData p in filteredList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    isSelectedExist.value = exit;
    manageRecordByUser.value = exit;
  }

  /// 全选按钮，将当前显示列表中的项全部加入已选列表selectedList
  void selectAll() {
    // 如果filteredList有值，则对filteredList操作，为空则对personDataList操作
    List<PersonData> listToSelect = filteredList.isEmpty ? personDataList : filteredList;
    bool exit = false;
    for (PersonData p in listToSelect) {
      // 如果该项未被选中，即不存在于selectedList列表中，则加入，否则不重复加入
      if (!selectedList.contains(p)) {
        p.isSelected.value = true;
        selectedList.add(p);
      }
    }
    // 对两类列表都进行查询，如果有选中的则exit为true
    for (PersonData p in personDataList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    for (PersonData p in filteredList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    isSelectedExist.value = exit;
  }

  /// 取消按钮，清空所有选中项，清空selectedList
  void cancelSelectOperation() {
    List<PersonData> listToSelect = filteredList.isEmpty ? personDataList : filteredList;

    // 对两类列表都进行查询，如果有选中的则exit为true
    for (PersonData p in personDataList) {
      p.isSelected.value = false;
    }
    for (PersonData p in filteredList) {
      p.isSelected.value = false;
    }
    selectedList.clear();
    isSelectedExist.value = false;
    manageRecordByUser.value =false;
  }

  /// 反选按钮，切换当前显示列表中的项的选中状态，已选变未选，未选变选中
  /// 被选中的加入selectedList，被取消选中的从selectedList中移除
  void reverseSelected() {
    List<PersonData> listToSelect = filteredList.isEmpty ? personDataList : filteredList;
    for (PersonData p in listToSelect) {
      // 切换选中状态
      p.isSelected.value = !p.isSelected.value;
      // 加入或移除项 selectedList
      if (p.isSelected.value) {
        selectedList.add(p);
      } else {
        selectedList.remove(p);
      }
    }
    bool exit = false;
    // 对两类列表都进行查询，如果有选中的则exit为true
    for (PersonData p in personDataList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    for (PersonData p in filteredList) {
      if (p.isSelected.value) {
        exit = true;
        break;
      }
    }
    isSelectedExist.value = exit;
    manageRecordByUser.value =exit;
    // 如果不存在被选中项，则将 manageRecordByUser置为 false，隐藏底部功能按钮
    if(!isSelectedExist.value){
      manageRecordByUser.value = false;
    }
  }

  /// 删除所有选中项，不分显示列表，从本地删除进入selectedList的所有项，同时也从各列表中删除
  void deleteSelected() {
    for (PersonData p in selectedList) {
      GetStorage().remove(p.id);
      personDataList.removeWhere((person) => person.id == p.id);
      filteredList.removeWhere((person) => person.id == p.id);
      // selectedList.removeWhere((person) => person.id == p.id);
    }
    // 所有列表中的被选项都被删除了，那肯定不存在被选项了
    selectedList.clear();
    isSelectedExist.value = false;
  }

  /// 当删除选中项时，在确认删除对话框中显示至多5项被删除人员的姓名
  String returnSelectedPersonNames() {
    List<String> nameList = [];
    String names = '';
    for (PersonData p in selectedList) {
      nameList.add(p.name);
    }
    names = nameList.length >= 6 ? '\n${nameList.slice(0, 5).join('\n')}\n......' : '\n${nameList.join('\n')}';
    return names;
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.onClose();
  }
}
