Map<String, String> transformData(Set<Map<String, String>> input) {
  Map<String, String> result = {};

  for (var item in input) {
    if (item.containsKey('title') && item.containsKey('name')) {
      result[item['title']!] = item['name']!;
    }
  }

  return result;
}

String convertKeywordToKorean(String keyword) {
  Map<String, String> keywordMap = {
    'types': '종류별',
    'scenarios': '상황별',
    'themes': '기본 / 테마별',
    'times': '시간별',
    'flavors': '맛 별',
  };

  return keywordMap[keyword] ?? keyword;
}
