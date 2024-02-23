import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:bazi/common/classPersonData.dart';
import 'package:bazi/components/city_pickers-1.3.0/lib/modal/result.dart';

import 'package:bazi/pages/bazi_record/person_data_controller.dart';

class KnowledgePage extends StatelessWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    PersonDataController personDataController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('知识库'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('''寅午戌合火局 寅卯辰会东方木
        巳酉丑合金局 巳午未会南方火
        申子辰合水局 申酉戌会西方金
        亥卯未合木局 亥子丑会北方水

        子午冲 子丑化合土 午丑相害
        卯酉冲 寅亥化合木 子未相害
        寅申冲 卯戌化合火 寅巳相害
        巳亥冲 辰酉化合金 卯辰相害
        辰戌冲 巳申化合水 酉戌相害
        丑未冲 午未化合火土 申亥相害

        子刑卯,卯刑子,为无礼之刑
        寅刑巳,已刑申,申刑寅,为侍势之刑
        未刑丑,丑刑戌,戌刑未,为无恩之刑
        辰,酉,午,亥为自刑,即:辰辰自刑,酉酉自刑,午午自刑,亥亥自刑。

        天干五合:天干相冲:
        甲己合化土 甲庚冲
        乙庚合化金 乙辛冲
        丙辛合化水 王丙冲
        丁壬合化木 丁癸冲
        戊癸合化火'''),
          ],
        ),
      ),
    );
  }
}
