import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_state.dart';
import 'package:firebase_auth_demo/presentation/pages/food_pick_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
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
          return Container(); // 이 부분은 실행되지 않아야 합니다.
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
    return BlocBuilder<DailyFoodsCubit, DailyFoodsState>(
        //   listener: (context, state) {
        //   debugPrint(' ${state} main page listener');
        //   if (state is Unauthenticated) {
        //     Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (_) => LoginPage()),
        //     );
        //   }
        // },
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
                // Text('Welcome, ${state}!'),
                // ElevatedButton(
                //   child: Text('Sign Out'),
                //   onPressed: () => context.read<AuthCubit>().logout(),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DailyFoodsWidget(dailyFoods: state.dailyFoods)
                    // DailyFoodsWidget(dailyFoods: state.dailyFood,)
                    // Column(
                    //   children: [
                    //     Container(
                    //       width: 100,
                    //       height: 100,
                    //       decoration: BoxDecoration(
                    //         color: Colors.black,
                    //         borderRadius: BorderRadius.circular(16),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 8),
                    //     const Text('비오는날엔\n해물파전', textAlign: TextAlign.center),
                    //   ],
                    // ),
                    // Column(
                    //   children: [
                    //     Container(
                    //       width: 100,
                    //       height: 100,
                    //       decoration: BoxDecoration(
                    //         color: Colors.black,
                    //         borderRadius: BorderRadius.circular(16),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 8),
                    //     const Text('복잡한건 싫어\n볶음밥', textAlign: TextAlign.center),
                    //   ],
                    // ),
                    // Column(
                    //   children: [
                    //     Container(
                    //       width: 100,
                    //       height: 100,
                    //       decoration: BoxDecoration(
                    //         color: Colors.black,
                    //         borderRadius: BorderRadius.circular(16),
                    //       ),
                    //     ),
                    //     const SizedBox(height: 8),
                    //     const Text('사케와 찰떡궁합\n연어회', textAlign: TextAlign.center),
                    //   ],
                    // ),
                  ],
                ),
                const SizedBox(height: 40),
                const Text(
                  '🏅 랭킹순위 🏅',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
                        }).toList()
                        //  [
                        // state.rankedFoods.rankedFoodList.map()
                        // RankingItem(
                        //     rank: state.rankedFoods.rankedFoodList[0].rank,
                        //     name: state.rankedFoods.rankedFoodList[0].name,
                        //     change: state.rankedFoods.rankedFoodList[0].rankChange),
                        // RankingItem(
                        //     rank: 2,
                        //     name: '파전',
                        //     change: '5↑',
                        //     changeColor: Colors.red),
                        // RankingItem(
                        //     rank: 3,
                        //     name: '물냉면',
                        //     change: '1↓',
                        //     changeColor: Colors.blue),
                        // RankingItem(rank: 4, name: '스시', change: '-'),
                        // RankingItem(
                        //     rank: 5,
                        //     name: '순대국밥',
                        //     change: '2↓',
                        //     changeColor: Colors.blue),
                        // ],
                        ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.rankedFoods.rankedFoodList
                            .sublist(5, state.rankedFoods.rankedFoodList?.length)
                            .map((food) {
                          return RankingItem(
                            rank: food.rank,
                            name: food.name,
                            change: food.rankChange,
                          );
                        }).toList()
                        // const [
                        // RankingItem(
                        //     rank: 6,
                        //     name: '파스타',
                        //     change: '1↓',
                        //     changeColor: Colors.blue),
                        // RankingItem(
                        //     rank: 7,
                        //     name: '피자',
                        //     change: 'NEW',
                        //     changeColor: Colors.green),
                        // RankingItem(
                        //     rank: 8,
                        //     name: '샐러드',
                        //     change: '1↑',
                        //     changeColor: Colors.red),
                        // RankingItem(
                        //     rank: 9,
                        //     name: '샌드위치',
                        //     change: '2↑',
                        //     changeColor: Colors.red),
                        // RankingItem(
                        //     rank: 10,
                        //     name: '타코야끼',
                        //     change: '2↑',
                        //     changeColor: Colors.red),
                        // ],
                        ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            FoodPickPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return child; // 전환 애니메이션 없이 페이지를 표시합니다.
                        },
                      ),
                      // MaterialPageRoute(builder: (context) => MainPage()),
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
  final String change;
  final Color? changeColor;

  const RankingItem({
    super.key,
    required this.rank,
    required this.name,
    required this.change,
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
          Text(
            change,
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
