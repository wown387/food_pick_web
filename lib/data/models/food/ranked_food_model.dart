// class RankedFood {
//   final String name;
//   final int rank;
//   final String rankChange;

//   RankedFood({
//     required this.name,
//     required this.rank,
//     required this.rankChange,
//   });

//   factory RankedFood.fromJson(Map<String, dynamic> json) {
//     return RankedFood(
//       name: json['name'] as String,
//       rank: json['rank'] as int,
//       rankChange: json['rankChange'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'rank': rank,
//       'rankChange': rankChange,
//     };
//   }
// }

// class RankedFoodListModel {
//   final List<RankedFood> rankedFoodList;

//   RankedFoodListModel({required this.rankedFoodList});

//   factory RankedFoodListModel.fromJson(Map<String, dynamic> json) {
//     print("jsonjsonjsonjson ${json}");
//     if (json['foods'] == null) {
//       return RankedFoodListModel(rankedFoodList: []);
//     }
//     var foodList = json['foods'] as List;
//     List<RankedFood> rankedFoodList = foodList
//         .map((rankedFoodJson) => RankedFood.fromJson(rankedFoodJson))
//         .toList();
//     return RankedFoodListModel(rankedFoodList: rankedFoodList);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'rankedFoodList': rankedFoodList.map((food) => food.toJson()).toList(),
//     };
//   }
// }

class RankedFood {
  final String name;
  final int rank;
  final String? rankChange; // String?로 변경하여 null을 허용

  RankedFood({
    required this.name,
    required this.rank,
    this.rankChange, // required 키워드 제거
  });

  factory RankedFood.fromJson(Map<String, dynamic> json) {
    return RankedFood(
      name: json['name'] as String,
      rank: json['rank'] as int,
      rankChange: json['rankChange'] as String?, // as String?로 변경
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rank': rank,
      if (rankChange != null) 'rankChange': rankChange, // null이 아닐 때만 포함
    };
  }
}

class RankedFoodListModel {
  final List<RankedFood> rankedFoodList;

  RankedFoodListModel({required this.rankedFoodList});

  factory RankedFoodListModel.fromJson(Map<String, dynamic> json) {
    print("jsonjsonjsonjson $json");
    if (json['foods'] == null) {
      return RankedFoodListModel(rankedFoodList: []);
    }
    var foodList = json['foods'] as List;
    List<RankedFood> rankedFoodList = foodList
        .map((rankedFoodJson) => RankedFood.fromJson(rankedFoodJson))
        .toList();
    return RankedFoodListModel(rankedFoodList: rankedFoodList);
  }

  Map<String, dynamic> toJson() {
    return {
      'rankedFoodList': rankedFoodList.map((food) => food.toJson()).toList(),
    };
  }
}
