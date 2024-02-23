import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:bazi/pages/bazi_record/person_data_controller.dart';

/// 当历史记录页面中的列表项被长按选中时，底部出现此BottomAppBar，用于从本地/列表中选择、删除项
class BaziRecordBottomAppBar extends StatelessWidget {
  BaziRecordBottomAppBar({super.key});

  final PersonDataController personDataController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Semantics(
        sortKey: const OrdinalSortKey(1),
        container: true,
        child: BottomAppBar(
          // shape: shape,
          child: Row(
            children: [
              IconButton(
                tooltip: '全选',
                icon: const Row(
                  children: [
                    Icon(Icons.library_add_check_outlined),
                    Text('全选'),
                  ],
                ),
                onPressed: () {
                  personDataController.selectAll();
                },
              ),
              // const Text('全选'),
              const Spacer(),
              IconButton(
                tooltip: '反选',
                icon: const Row(
                  children: [
                    Icon(Icons.flaky),
                    Text('反选'),
                  ],
                ),
                onPressed: () {
                  personDataController.reverseSelected();
                },
              ),
              const Spacer(),
              IconButton(
                tooltip: '删除${personDataController.selectedList.length}项',
                onPressed: () async {
                  bool confirmDelete = await showCupertinoDialog(
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: Text('确认删除${personDataController.selectedList.length}项记录吗?'),
                        content: Text(
                          personDataController.returnSelectedPersonNames(),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            // 是否销毁按钮，true则文字变为红色
                            // isDestructiveAction: true,
                            onPressed: () {
                              Navigator.of(context).pop(false); // 取消删除
                            },
                            child: const Text('取消'),
                          ),
                          CupertinoDialogAction(
                            // 是否默认按钮，true字体加粗
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop(true); // 确认删除
                            },
                            child: const Text('删除'),
                          ),
                        ],
                      );
                    }, context: context,
                  );
                  if (confirmDelete == true) {
                    personDataController.deleteSelected();
                  }
                },
                icon: Row(
                  children: [
                    Badge(
                      label: Text(personDataController.selectedList.length.toString()),
                      child: const Icon(CupertinoIcons.trash,),
                    ),
                    const Text('删除'),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: '取消',
                icon: const Row(
                  children: [
                    Icon(CupertinoIcons.multiply_circle),
                    Text('取消'),
                  ],
                ),
                onPressed: () {
                  personDataController.cancelSelectOperation();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
