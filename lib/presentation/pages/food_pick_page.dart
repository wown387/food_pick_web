import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_state.dart';
import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:firebase_auth_demo/utils/data_revised_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class FoodPickPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(currentIndex: 0, child: FoodPickScreen()
        // FoodPickPage(),
        );
  }
}

class FoodPickScreen extends StatefulWidget {
  @override
  _FoodPickScreenState createState() => _FoodPickScreenState();
}

class _FoodPickScreenState extends State<FoodPickScreen> {
  final ScrollController _scrollController = ScrollController();
  // Map<String, String?> selectedItems = {
  //   '상황': null,
  //   '시간': null,
  //   '메뉴': null,
  // };

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
    final currentState = context.read<DailyFoodsCubit>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${currentState.state.recommendedFood?.name} 음식과의 궁합'),
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
          print("food pick state ${state}");
          if (state is DailyFoodsInitial) {
            return Center(child: Text("로그인이 필요합니다"));
          } else if (state is DailyFoodsLoaded ||
              state is SingleRecommendedFoodLoaded ||
              state is foodCompatibilityLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Column(
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
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
                                        if (state is foodCompatibilityLoaded) {
                                          showSelectedTastes(
                                              "${state.foodCompatibility?.foodCompatibility}");
                                          return;
                                        }
                                        final object1 = state.selectedFoodType;
                                        final object2 = {
                                          "name": state.recommendedFood!.name
                                        };
                                        // print(object);
                                        final mergedObject = {
                                          ...object1,
                                          ...object2,
                                        };
                                        print("mergedObject ${mergedObject}");
                                        context
                                            .read<DailyFoodsCubit>()
                                            .getFoodCompatibility(mergedObject);
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
                          if (state.recommendedFood == null &&
                              selectedTastes.isEmpty == true)
                            // if (state.recommendedFood == null )
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
                          Row(
                            children: [],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  state.metaData!.metaData.keys.map((metaKey) {
                                // return Text("${metaKey}");
                                return _buildFoodCategorySection(metaKey,
                                    state.metaData!.metaData['${metaKey}']!);
                              }).toList()),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _scrollToTop();
                    final trnasformedInput = transformData(selectedTastes);
                    print("transform input ${trnasformedInput}");
                    print("previous answer ${state.previousAnswer}");
                    final mergedObject = {
                      ...trnasformedInput,
                      "previousAnswer": state.previousAnswer == null
                          ? ""
                          : state.previousAnswer![0]
                    };
                    print("mergedObject ${mergedObject}");
                    context
                        .read<DailyFoodsCubit>()
                        .getSingleRecommendedFood(mergedObject);
                    // resetTastes();
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
                SizedBox(height: 32),
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
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: selectedTastes
                          .map((taste) => ThemeCircle(
                                imageUrl: taste['image']!,
                                label: taste['name']!,
                                onRemove: () => toggleTaste(taste),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 16),
                  ]),
              ],
            );
          } else {
            // return Text("food pick page");
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildFoodCategorySection(String title, List<MetaItem> foods) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth < 400 ? 10 : (screenWidth - (400)) / 2;

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                convertKeywordToKorean(title), // 중앙 텍스트
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue),
          child: Wrap(
            spacing: 10,
            runSpacing: 8,
            children: foods
                .map((taste) => TasteCircle(
                      taste: {
                        "name": taste.name,
                        "image": taste.image,
                        "title": "title",
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
        ),
        SizedBox(height: 40),
      ],
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
          // CircleAvatar(
          //   radius: 30,
          //   backgroundImage: NetworkImage(taste['image']!),
          //   child: isSelected
          //       ? const Icon(Icons.check, color: Colors.white)
          //       : null,
          // ),

          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(taste['image']!),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isSelected)
                  Container(
                    width: 60, // diameter = 2 * radius
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.5), // 반투명한 검은색 오버레이
                    ),
                  ),
                if (isSelected) Icon(Icons.check, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            taste['name']!,
            style: TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

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
              radius: 20,
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
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
