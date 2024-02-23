class BAZI {
  /// 人元司令分野
  List<Map<String, Object>> renYuanSiLingFenYe = [
    {
      'jie': '立春',
      'yueLing': '寅',
      'tianShu': [15, 8, 1],
      'dangLing': ['甲', '丙', '戊']
    },
    {
      'jie': '惊蛰',
      'yueLing': '卯',
      'tianShu': [11, 1],
      'dangLing': ['乙', '甲']
    },
    {
      'jie': '清明',
      'yueLing': '辰',
      'tianShu': [15, 10, 1],
      'dangLing': ['戊', '癸', '乙']
    },
    {
      'jie': '立夏',
      'yueLing': '巳',
      'tianShu': [15, 6, 1],
      'dangLing': ['丙', '庚', '戊']
    },
    {
      'jie': '芒种',
      'yueLing': '午',
      'tianShu': [20, 11, 1],
      'dangLing': ['丁', '己', '丙']
    },
    {
      'jie': '小暑',
      'yueLing': '未',
      'tianShu': [13, 10, 1],
      'dangLing': ['己', '乙', '丁']
    },
    {
      'jie': '立秋',
      'yueLing': '申',
      'tianShu': [14, 11, 8, 1],
      'dangLing': ['庚', '壬', '戊', '己']
    },
    {
      'jie': '白露',
      'yueLing': '酉',
      'tianShu': [11, 1],
      'dangLing': ['辛', '庚']
    },
    {
      'jie': '寒露',
      'yueLing': '戌',
      'tianShu': [13, 10, 1],
      'dangLing': ['戊', '丁', '辛']
    },
    {
      'jie': '立冬',
      'yueLing': '亥',
      'tianShu': [13, 8, 1],
      'dangLing': ['壬', '甲', '戊']
    },
    {
      'jie': '大雪',
      'yueLing': '子',
      'tianShu': [11, 1],
      'dangLing': ['癸', '壬']
    },
    {
      'jie': '小寒',
      'yueLing': '丑',
      'tianShu': [13, 10, 1],
      'dangLing': ['己', '辛', '癸']
    },
  ];
  String getRenYuanSiLingFenYe(String jie, int tianShu) {
    // function 人元司令分野(节, 天数){}
    int index = renYuanSiLingFenYe.indexWhere((element) => element['jie'] == jie);
    List<int> lll = renYuanSiLingFenYe[index]['tianShu'] as List<int>;
    int lllIndex = lll.indexWhere((element) => tianShu >= element);
    List<String> ddd = renYuanSiLingFenYe[index]['dangLing']  as List<String>;
    return ddd[lllIndex];
  }
}
