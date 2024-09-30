import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_state.dart';
import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FoodPickPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
        currentIndex: 0, // BottomNavigationBar의 현재 선택된 인덱스 설정
        child: FoodPickScreen()

        // Column(
        //   children: [
        //     // 고정된 위젯
        //     Container(
        //       height: 100,
        //       color: Colors.blue,
        //       child: Center(child: Text('Fixed Widget')),
        //     ),
        //     // 스크롤 가능한 콘텐츠
        //     Expanded(
        //       child: FoodPickScreen(),
        //     ),
        //   ],
        // )
        );
  }
}

class FoodPickScreen extends StatefulWidget {
  @override
  _FoodPickScreenState createState() => _FoodPickScreenState();
}

class _FoodPickScreenState extends State<FoodPickScreen> {
  final ScrollController _scrollController = ScrollController();
  Map<String, String?> selectedItems = {
    '상황': null,
    '시간': null,
    '메뉴': null,
  };

  // final Set<String> selectedTastes = {};

  // void toggleTaste(String taste) {
  //   setState(() {
  //     if (selectedTastes.contains(taste)) {
  //       selectedTastes.remove(taste);
  //     } else {
  //       selectedTastes.add(taste);
  //     }
  //   });
  // }

  // void showSelectedTastes() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('선택된 맛'),
  //         content: Text(selectedTastes.isEmpty
  //             ? '선택된 맛이 없습니다.'
  //             : selectedTastes.join(', ')),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('확인'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  final Set<Map<String, String>> selectedTastes = {};
  void resetTastes() {
    setState(() {
      selectedTastes.clear();
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0, // 스크롤을 0 위치로 이동 (제일 위)
      duration: Duration(milliseconds: 500), // 애니메이션 지속 시간
      curve: Curves.easeInOut, // 애니메이션 곡선
    );
  }

  void toggleTaste(Map<String, String> taste) {
    setState(() {
      if (selectedTastes.any((t) => t['name'] == taste['name'])) {
        selectedTastes.removeWhere((t) => t['name'] == taste['name']);
      } else if (selectedTastes.any((t) => t['title'] == taste['title'])) {
        final existingTaste =
            selectedTastes.firstWhere((t) => t['title'] == taste['title']);
        selectedTastes.remove(existingTaste);
        selectedTastes.add(taste);
      } else {
        selectedTastes.add(taste);
      }
    });
  }

  void showSelectedTastes(String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('선택된 맛'),
          content: Text(description),

          // Text(selectedTastes.isEmpty
          //     ? '선택된 맛이 없습니다.'
          //     : selectedTastes.map((taste) => taste['name']).join(', ')),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DailyFoodsCubit, DailyFoodsState>(
      listenWhen: (previous, current) {
        // 이전 상태가 foodCompatibilityLoaded가 아니고
        // 현재 상태가 foodCompatibilityLoaded일 때만 true를 반환
        return previous is! foodCompatibilityLoaded &&
            current is foodCompatibilityLoaded;
      },
      listener: (context, state) {
        if (state is foodCompatibilityLoaded) {
          showSelectedTastes("${state.foodCompatibility?.foodCompatibility}");
        }
      },
      child: BlocBuilder<DailyFoodsCubit, DailyFoodsState>(
        builder: (context, state) {
          if (state is DailyFoodsInitial) {
            return Center(child: Text("로그인이 필요합니다"));
          } else if (state is DailyFoodsLoaded ||
              state is SingleRecommendedFoodLoaded ||
              state is foodCompatibilityLoaded) {
            print("${state.foodCompatibility?.foodCompatibility}");

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            "원하는 테마 선택",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '선택에 맞게 메뉴를 찾아드려요',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          if (state.recommendedFood != null)
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 300,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.network(
                                    state.recommendedFood!.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.recommendedFood!.name,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '(이랑)',
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        // final object = selectedTastes;
                                        final object = {
                                          "flavor": "매운맛",
                                          "name": state.recommendedFood!.name,
                                          "scenario": "혼밥",
                                          "theme": "스트레스 해소",
                                          "time": "점심",
                                          "type": "한식"
                                        };
                                        // final object2 = {
                                        //   "name": state.recommendedFood!.name
                                        // };
                                        // print(object);
                                        // final mergedObject = {
                                        //   ...object,
                                        //   ...object2,
                                        // };
                                        // print("mergedObject ${mergedObject}");
                                        context
                                            .read<DailyFoodsCubit>()
                                            .getFoodCompatibility(object);
                                        // showSelectedTastes();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          '궁합보기',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          if (state.recommendedFood == null)
                            Center(
                              child: Container(
                                width: 300,
                                height: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/banner_sample.png'), // 배경 이미지 경로 설정
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '광고 배너\n(음식추천) ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                          SizedBox(height: 16),
                          // _buildFoodCategorySection(
                          //     "테마별", state.metaData.themes),
                          Row(
                            children: [],
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildFoodCategorySection(
                                  "맛별", state.metaData!.flavors),
                              _buildFoodCategorySection(
                                  "기본/테마별", state.metaData!.themes),
                              _buildFoodCategorySection(
                                  "시나리오", state.metaData!.scenarios),
                              _buildFoodCategorySection(
                                  "시간별", state.metaData!.times),
                              _buildFoodCategorySection(
                                  "종류별", state.metaData!.types),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),

                          // _buildFoodCategorySection("타입", [
                          //   Food(
                          //       name: "한식",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "한식",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "한식",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "한식",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "한식",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "한식",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "한식",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          // ]),
                          // _buildFoodCategorySection("시간별", [
                          //   Food(
                          //       name: "아침",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "점심",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          //   Food(
                          //       name: "저녁",
                          //       image:
                          //           "https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI"),
                          // ]),

                          // _buildCategorySection('상황', Colors.orange, [
                          //   '전체',
                          //   '혼밥',
                          //   '친구',
                          //   '연인',
                          //   '가족',
                          //   '회식',
                          // ]),
                          // _buildCategorySection('시간', Colors.green, [
                          //   '전체',
                          //   '아침',
                          //   '점심',
                          //   '저녁',
                          //   '간식',
                          //   '야식',
                          // ]),
                          // _buildCategorySection('메뉴', Colors.blue, [
                          //   '전체',
                          //   '한식',
                          //   '중식',
                          //   '양식',
                          //   '일식',
                          //   '분식',
                          // ]),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 선택된 항목들을 보여줌 (로직에 따라 서버에 저장하거나 다른 페이지로 넘길 수 있음)
                    // print("선택된 항목들: $selectedItems");
                    // showSelectedTastes();
                    // context
                    //     .read<DailyFoodsCubit>()
                    //     .getSingleRecommendedFood(selectedItems);
                    // print("selectedItems ${selectedTastes}");
                    context.read<DailyFoodsCubit>().getSingleRecommendedFood({
                      "flavor": "매운맛",
                      "previousAnswer": "김치찌개 떡볶이 치킨",
                      "scenario": "혼밥",
                      "theme": "스트레스 해소",
                      "time": "점심",
                      "type": "한식"
                    });
                    _scrollToTop();
                    resetTastes();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFB9A79),
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                    textStyle: TextStyle(fontSize: 18, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    '푸드 PICK !',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                if (selectedTastes.isNotEmpty)
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.grey, // 선 색상 설정
                              thickness: 1, // 선 두께 설정
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "픽한 테마", // 중앙 텍스트
                              style: TextStyle(
                                fontSize: 14, // 글자 크기
                                fontWeight: FontWeight.bold, // 글자 굵기
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey, // 선 색상 설정
                              thickness: 1, // 선 두께 설정
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: selectedTastes
                          .map((taste) => ThemeCircle(
                                imageUrl: taste['image']!,
                                label: taste['name']!,
                                onRemove: () => toggleTaste(taste),
                              ))
                          .toList(),
                      // state.metaData.scenarios
                      //     .map((taste) => TasteCircle(
                      //           taste: {"name": taste.name, "image": taste.image},
                      //           onTap: () => toggleTaste(
                      //               {"name": taste.name, "image": taste.image}),
                      //           isSelected: selectedTastes
                      //               .any((t) => t['name'] == taste.name),
                      //         ))
                      //     .toList(),
                      // selectedTastes
                      //     .map((taste) => ThemeCircle(
                      //           imageUrl:
                      //               'https://fastly.picsum.photos/id/809/200/300.jpg?hmac=jC-cQrqqx-NPPfMItPjmHx8XKCKi5WRG46ds3qYReKI',
                      //           label: taste,
                      //           onRemove: () => toggleTaste(taste),
                      //         ))
                      //     .toList(),
                    ),
                    SizedBox(height: 16),
                  ]),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCategoryCircle(String text, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
        ),
        SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryImage(String text, String image
      // Map<String, String> taste,
      // void onTap,
      // bool isSelected
      ) {
    return Column(
      children: [
        // TasteCircle(
        //     taste: taste,
        //     isSelected: isSelected,
        //     onTap: () => toggleTaste(taste)),
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(image),

          // backgroundColor: color,
        ),
        SizedBox(height: 4),
        // Text(
        //   text,
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 12,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildFoodCategorySection(String title, List<Food> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Colors.grey, // 선 색상 설정
                thickness: 1, // 선 두께 설정
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title, // 중앙 텍스트
                style: TextStyle(
                  fontSize: 14, // 글자 크기
                  fontWeight: FontWeight.bold, // 글자 굵기
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey, // 선 색상 설정
                thickness: 1, // 선 두께 설정
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: foods
                  .map((taste) => TasteCircle(
                        taste: {
                          "name": taste.name,
                          "image": taste.image,
                          "title": title
                        },
                        onTap: () => toggleTaste({
                          "name": taste.name,
                          "image": taste.image,
                          "title": title
                        }),
                        isSelected:
                            selectedTastes.any((t) => t['name'] == taste.name),
                      ))
                  .toList(),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCategorySection(String title, Color color, List<String> items) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Column과 Center를 space-between으로 배치
          children: [
            Column(
              children: [
                SizedBox(width: 16),
                Icon(Icons.restaurant, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(color: color, fontSize: 18),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 270,
                child: Wrap(
                  children: items
                      .map((item) => SizedBox(
                            width: 90,
                            child: ChoiceChip(
                              label: Text(
                                item,
                                style: TextStyle(
                                  color: color, // 선택되지 않은 경우 텍스트 색상
                                  fontSize: 15,
                                ),
                              ),
                              selected: selectedItems[title] == item,
                              onSelected: (isSelected) {
                                setState(() {
                                  if (isSelected) {
                                    selectedItems[title] = item;
                                  } else {
                                    selectedItems[title] = null;
                                  }
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: color.withOpacity(0.2),
                              shape: StadiumBorder(
                                side: BorderSide(color: color),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TasteCircle extends StatelessWidget {
  final Map<String, String> taste;
  final VoidCallback onTap;
  final bool isSelected;

  const TasteCircle({
    required this.taste,
    required this.onTap,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(taste['image']!),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            taste['name']!,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// class TasteCircle extends StatelessWidget {
//   final String image;
//   final String label;
//   final VoidCallback onTap;

//   const TasteCircle(
//       {required this.image,
//       required this.label,
//       required this.onTap,
//       super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(radius: 30, backgroundImage: NetworkImage(image)),
//           const SizedBox(height: 8),
//           Text(label),
//         ],
//       ),
//     );
//   }
// }

class ThemeCircle extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onRemove;

  const ThemeCircle(
      {required this.imageUrl,
      required this.label,
      required this.onRemove,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                onTap: onRemove,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.grey,
                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
