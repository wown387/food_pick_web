import 'package:firebase_auth_demo/presentation/blocs/food_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_state.dart';
import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingFoodPage extends StatelessWidget {
  const TrendingFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,
      child: TrendingFoodScreen(),
    );
  }
}

class TrendingFoodScreen extends StatefulWidget {
  @override
  State<TrendingFoodScreen> createState() => _TrendingFoodPageState();
}

class _TrendingFoodPageState extends State<TrendingFoodScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 생성될 때 데이터를 불러옵니다.
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<DailyFoodsCubit>().getDailyFoods();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyFoodsCubit, DailyFoodsState>(
        builder: (context, state) {
      print("TrendingFoodPage state ${state}");
      if (state is DailyFoodsInitial || state is DailyFoodsLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Padding(
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
                  children: state.rankedFoods!.rankedFoodList.map((food) {
                    return TrendingFoodItem(
                      rank: food.rank,
                      name: food.name,
                      change: food.rankChange != null ? food.rankChange : "",
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class TrendingFoodItem extends StatelessWidget {
  final int rank;
  final String name;
  final String? change;

  TrendingFoodItem({
    required this.rank,
    required this.name,
    this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 30, // 너비를 30으로 고정
            child: Text(
              '$rank',
              style: TextStyle(
                color: rank <= 3 ? Color(0xFFFB9A79) : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold, // 숫자는 항상 볼드체
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
                fontWeight: rank <= 3
                    ? FontWeight.bold
                    : FontWeight.normal, // 음식 이름은 일반 글씨체
                color: Colors.black, // 음식 이름은 검은색
              ),
            ),
          ),
          if (change != null) // change가 null이 아닐 때만 표시
            Text(
              change!,
              style: TextStyle(
                fontSize: 20,
                color: _getChangeColor(change),
                fontWeight: FontWeight.normal, // 변화량은 일반 글씨체
              ),
            ),
        ],
      ),
    );
  }

  Color _getChangeColor(String? change) {
    if (change == null) return Colors.transparent;
    if (change.startsWith('+')) return Colors.green;
    if (change.startsWith('-')) return Colors.red;
    return Colors.grey;
  }
}
