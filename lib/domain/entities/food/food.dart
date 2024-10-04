class Food {
  final String name;
  final String image;
  final int? rank; // 랭킹 정보 (null 가능)

  Food({required this.name, required this.image, this.rank});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      image: json['image'],
    );
  }
}

class DailyFoods {
  final List<Food> foods;

  DailyFoods({required this.foods});

  factory DailyFoods.fromJson(Map<String, dynamic> json) {
    var foodList = json['dilayFoods'] as List;
    // print("foodlistfoodlistfoodlistfoodlistfoodlist");
    // print(foodList);

    List<Food> foods =
        foodList.map((foodJson) => Food.fromJson(foodJson)).toList();
    return DailyFoods(foods: foods);
  }
}
