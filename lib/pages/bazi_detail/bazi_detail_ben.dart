import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaziDetailBenPage extends StatelessWidget {
  const BaziDetailBenPage({super.key});

  @override
  Widget build(BuildContext context) {
    final getAll = Get.arguments;
    print(getAll.rt()['age']);
    return const Placeholder();
  }
}
