// import 'package:firebase_auth_demo/domain/entities/food/food.dart';
// import 'package:firebase_auth_demo/domain/entities/food/metadata.dart';

// class MetadataModel extends Metadata {
//   MetadataModel({
//     required List<Food> flavors,
//     required List<Food> scenarios,
//     required List<Food> themes,
//     required List<Food> times,
//     required List<Food> types,
//   }) : super(
//           flavors: flavors,
//           scenarios: scenarios,
//           themes: themes,
//           times: times,
//           types: types,
//         );

//   factory MetadataModel.fromJson(Map<String, dynamic> json) {
//     return MetadataModel(
//       flavors: _parseItems(json['metaData']['flavors']),
//       scenarios: _parseItems(json['metaData']['scenarios']),
//       themes: _parseItems(json['metaData']['themes']),
//       times: _parseItems(json['metaData']['times']),
//       types: _parseItems(json['metaData']['types']),
//     );
//   }

//   static List<Food> _parseItems(List<dynamic> foodList) {
//     return foodList.map((food) => Food.fromJson(food)).toList();
//   }
// }

class MetaDataModel {
  final Map<String, List<MetaItem>> metaData;
  final List<String> metaKeys;

  MetaDataModel({required this.metaData, required this.metaKeys});

  factory MetaDataModel.fromJson(Map<String, dynamic> json) {
    Map<String, List<MetaItem>> metaData = {};

    (json['metaData'] as Map<String, dynamic>).forEach((key, value) {
      metaData[key] =
          (value as List).map((item) => MetaItem.fromJson(item)).toList();
    });

    return MetaDataModel(
      metaData: metaData,
      metaKeys: List<String>.from(json['metaKeys']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metaData': metaData.map((key, value) =>
          MapEntry(key, value.map((item) => item.toJson()).toList())),
      'metaKeys': metaKeys,
    };
  }
}

class MetaItem {
  final String image;
  final String name;

  MetaItem({required this.image, required this.name});

  factory MetaItem.fromJson(Map<String, dynamic> json) {
    return MetaItem(
      image: json['image'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
    };
  }
}
