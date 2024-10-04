import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_state.dart';
import 'package:firebase_auth_demo/presentation/pages/food_pick_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("mainPage");
    // print(context.read<AuthCubit>().state);
    return Scaffold(body: FoodPickScreen());
  }
}

class DailyFoodsScreen extends StatefulWidget {
  @override
  _DailyFoodsScreenState createState() => _DailyFoodsScreenState();
}

class _DailyFoodsScreenState extends State<DailyFoodsScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 생성될 때 데이터를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<DailyFoodsCubit>().getDailyFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('오늘의 추천 음식'),
      ),
      body: BlocBuilder<DailyFoodsCubit, DailyFoodsState>(
        builder: (context, state) {
          if (state is DailyFoodsInitial || state is DailyFoodsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DailyFoodsLoaded) {
            return RefreshIndicator(
              onRefresh: () => context.read<DailyFoodsCubit>().getDailyFoods(),
              child: GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: state.dailyFoods!.foods.length,
                itemBuilder: (context, index) {
                  final food = state.dailyFoods!.foods[index];
                  return FoodCard(food: food);
                },
              ),
            );
          } else if (state is DailyFoodsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('오류: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<DailyFoodsCubit>().getDailyFoods(),
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Text("page error"),
          ); // 이 부분은 실행되지 않아야 합니다.
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<DailyFoodsCubit>().getDailyFoods(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                food.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Icons.error));
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              food.name,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class FoodPickScreen extends StatefulWidget {
  const FoodPickScreen({super.key});

  @override
  State<FoodPickScreen> createState() => _FoodPickScreenState();
}

class _FoodPickScreenState extends State<FoodPickScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 생성될 때 데이터를 불러옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyFoodsCubit>().getDailyFoods();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = (screenWidth - 370) / 2;
    return BlocBuilder<DailyFoodsCubit, DailyFoodsState>(
        builder: (context, state) {
      if (state is DailyFoodsLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is DailyFoodsLoaded) {
        print("state.metaData ${state.dailyFoods}");
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  '오늘의 랜덤 푸드 PICK',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingValue),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DailyFoodsWidget(dailyFoods: state.dailyFoods),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ranking_icon.png',
                      width: 20,
                      // height: 200,
                      fit: BoxFit.cover, // BoxFit을 사용하여 이미지 비율 유지하며 잘라냄
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      '랭킹순위',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Image.asset(
                      'assets/images/ranking_icon.png',
                      width: 20,
                      // height: 200,
                      fit: BoxFit.cover, // BoxFit을 사용하여 이미지 비율 유지하며 잘라냄
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.rankedFoods.rankedFoodList
                            .sublist(0, 5)
                            .map((food) {
                          return RankingItem(
                            rank: food.rank,
                            name: food.name,
                            change: food.rankChange,
                          );
                        }).toList()),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.rankedFoods.rankedFoodList
                            .sublist(
                                5, state.rankedFoods.rankedFoodList?.length)
                            .map((food) {
                          return RankingItem(
                            rank: food.rank,
                            name: food.name,
                            change: food.rankChange,
                          );
                        }).toList()),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    print("navigator push");
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FoodPickPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child; // 전환 애니메이션 없이 페이지를 표시합니다.
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Color(0xFFFB9A79),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        '메뉴추천 받을래요!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
        // return DailyFoodsWidget(dailyFoods: state.dailyFoods);
      } else if (state is DailyFoodsError) {
        return Center(child: Text('Error: ${state.message}'));
      }
      return Center(child: Text('No data available'));
    });
  }
}

class RankingItem extends StatelessWidget {
  final int rank;
  final String name;
  final String? change; // optional로 변경
  final Color? changeColor;

  const RankingItem({
    super.key,
    required this.rank,
    required this.name,
    this.change, // required 제거
    this.changeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$rank',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          if (change != null) // change가 null이 아닐 때만 표시
            Text(
              change!,
              style: TextStyle(
                fontSize: 18,
                color: changeColor ?? Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}

class DailyFoodsWidget extends StatelessWidget {
  final DailyFoods dailyFoods;

  const DailyFoodsWidget({Key? key, required this.dailyFoods})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: dailyFoods.foods
            .take(3)
            .map((food) => _buildFoodItem(food))
            .toList(),
      ),
    );
  }

  Widget _buildFoodItem(Food food) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: food.image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          food.name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
