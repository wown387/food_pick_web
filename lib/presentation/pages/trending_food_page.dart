import 'package:firebase_auth_demo/presentation/blocs/food_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_state.dart';
import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingFoodPage extends StatefulWidget {
  @override
  State<TrendingFoodPage> createState() => _TrendingFoodPageState();
}

class _TrendingFoodPageState extends State<TrendingFoodPage> {
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
        builder: (context, state) {
      print("TrendingFoodPage state ${state}");
      if (state is DailyFoodsInitial || state is DailyFoodsLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is DailyFoodsLoaded) {
        return MainLayout(
          currentIndex: 1, // BottomNavigationBar의 현재 선택된 인덱스 설정
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Text(
                  '급상승 검색 푸드',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.rankedFoods.rankedFoodList.map((food) {
                      return TrendingFoodItem(
                        rank: food.rank,
                        name: food.name,
                        change: food.rankChange.toUpperCase(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container();
        // return Center(child: CircularProgressIndicator());
      }
    });
  }
}

class TrendingFoodItem extends StatelessWidget {
  final int rank;
  final String name;
  final String change;

  TrendingFoodItem({
    required this.rank,
    required this.name,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 30, // 너비를 20으로 고정
            child: Text(
              '$rank',
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis, // 텍스트가 길면 "..."으로 표시
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            change,
            style: TextStyle(
              fontSize: 20,
              color: _getChangeColor(change),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getChangeColor(String change) {
    if (change.contains('↑')) {
      return Colors.red;
    } else if (change.contains('↓')) {
      return Colors.blue;
    } else if (change == 'NEW') {
      return Colors.green;
    } else {
      return Colors.black;
    }
  }
}

const List<String> _foodNames = [
  '짜장면',
  '파전',
  '물냉면',
  '스시',
  '순대국밥',
  '파스타',
  '피자',
  '샐러드',
  '샌드위치',
  '타코야끼',
];

const List<String> _foodChanges = [
  '-',
  '5↑',
  '1↓',
  '-',
  '2↓',
  '1↓',
  'NEW',
  '1↑',
  '2↑',
  '2↑',
];
