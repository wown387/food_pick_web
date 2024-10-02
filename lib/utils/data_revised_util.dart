Map<String, String> transformData(Set<Map<String, String>> input) {
  Map<String, String> result = {};
  
  for (var item in input) {
    if (item.containsKey('title') && item.containsKey('name')) {
      result[item['title']!] = item['name']!;
    }
  }
  
  return result;
}