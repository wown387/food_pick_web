import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SignUpScreen(),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    // return

    // BlocBuilder<AuthCubit, AuthState>(
    //   builder: (context, state) {
    //   print("signupPage${state}");

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        print("signup BlocListenerBlocListener ${state}");
        if (state is AuthRegistered) {
          // 회원가입이 완료되었을 때 다이얼로그 표시
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('회원가입 완료'),
              content: Text('회원가입이 완료되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    // 확인 버튼을 누르면 로그인 페이지로 이동
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                    Navigator.pushReplacementNamed(
                        context, '/login'); // 로그인 페이지로 이동
                  },
                  child: Text('확인'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '회원가입',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  label: '이 메 일',
                  controller: emailController,
                  hasButton: true,
                  onDuplicateCheck: () async {
                    // 여기에 중복 확인 로직을 구현합니다.
                    String username = emailController.text;
                    bool isDuplicate = await checkDuplicate(username);
                    if (isDuplicate) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('이미 사용 중인 사용자 이름입니다.')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('사용 가능한 사용자 이름입니다.')),
                      );
                    }
                  },
                ),
                CustomTextField(
                  label: '비밀번호',
                  controller: passwordController,
                ),
                CustomTextField(
                  label: '이  름',
                  controller: nameController,
                ),
                CustomDropdownField(
                  label: '생년월일',
                  onChanged: (year, month, day) {
                    setState(() {
                      selectedYear = year;
                      selectedMonth = month;
                      selectedDay = day;
                    });
                  },
                ),
                CustomGenderField(
                  onChanged: (gender) {
                    setState(() {
                      selectedGender = gender;
                    });
                  },
                ),
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '푸드픽 이용약관 전체동의',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_circle, size: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: const Color(0xFFFB9A79),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 130, vertical: 15),
                    ),
                    onPressed: () {
                      _printSignUpData();
                      final body = {
                        "birth": "$selectedYear-$selectedMonth-$selectedDay",
                        "email": "${emailController.text}",
                        "name": "${nameController.text}",
                        "password": "${passwordController.text}",
                        "sex": "${selectedGender}"
                      };
                      context.read<AuthCubit>().signUp(body);
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        //   );
        // }
      ),
    );
  }

  Future<bool> checkDuplicate(String email) async {
    // 여기에 실제 중복 확인 로직을 구현합니다.
    // 예를 들어, API 호출을 통해 서버에서 중복 여부를 확인할 수 있습니다.
    // 이 예제에서는 간단히 'admin'이라는 이름이 이미 사용 중이라고 가정합니다.
    final result =
        await context.read<AuthCubit>().signupUseCase.checkEmail(email);
    print("checkDuplicate ${result.isSuccess}");
    if (result.isSuccess) {
      return false;
    } else {
      return true;
    }
    // return result.isSuccess;
    // await Future.delayed(Duration(seconds: 1)); // 네트워크 지연 시뮬레이션

    // return username.toLowerCase() == 'admin';
  }

  void _printSignUpData() {
    print('이메일: ${emailController.text}');
    print('비밀번호: ${passwordController.text}');
    print('이름: ${nameController.text}');
    print('생년월일: $selectedYear-$selectedMonth-$selectedDay');
    print('성별: $selectedGender');
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final bool hasButton;
  final TextEditingController controller;
  final Future<void> Function()? onDuplicateCheck; // 추가된 콜백 함수

  const CustomTextField({
    required this.label,
    required this.controller,
    this.hasButton = false,
    this.onDuplicateCheck, // 콜백 함수 추가
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: label == "비밀번호", // 레이블이 "비밀번호"일 때 텍스트를 가림
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                border: const UnderlineInputBorder(),
              ),
            ),
          ),
          if (hasButton)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  backgroundColor: Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                ),
                onPressed: () async {
                  if (onDuplicateCheck != null) {
                    await onDuplicateCheck!(); // 콜백 함수 호출
                  }
                  // 중복 확인 버튼의 로직을 여기에 작성하세요
                },
                child: const Text(
                  '중복확인',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomDropdownField extends StatefulWidget {
  final String label;
  final Function(String?, String?, String?) onChanged;

  const CustomDropdownField({
    required this.label,
    required this.onChanged,
    super.key,
  });

  @override
  _CustomDropdownFieldState createState() => _CustomDropdownFieldState();
}

class _CustomDropdownFieldState extends State<CustomDropdownField> {
  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(widget.label),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedYear,
                    items: List.generate(100,
                            (index) => (DateTime.now().year - index).toString())
                        .map((year) =>
                            DropdownMenuItem(value: year, child: Text(year)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                      widget.onChanged(
                          selectedYear, selectedMonth, selectedDay);
                    },
                    hint: const Text('년도'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedMonth,
                    items: List.generate(12,
                            (index) => (index + 1).toString().padLeft(2, '0'))
                        .map((month) =>
                            DropdownMenuItem(value: month, child: Text(month)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                      widget.onChanged(
                          selectedYear, selectedMonth, selectedDay);
                    },
                    hint: const Text('월'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedDay,
                    items: List.generate(31,
                            (index) => (index + 1).toString().padLeft(2, '0'))
                        .map((day) =>
                            DropdownMenuItem(value: day, child: Text(day)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDay = value;
                      });
                      widget.onChanged(
                          selectedYear, selectedMonth, selectedDay);
                    },
                    hint: const Text('일'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomGenderField extends StatefulWidget {
  final Function(String) onChanged;

  const CustomGenderField({required this.onChanged, super.key});

  @override
  _CustomGenderFieldState createState() => _CustomGenderFieldState();
}

class _CustomGenderFieldState extends State<CustomGenderField> {
  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Text('성  별'),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = 'female';
                    });
                    widget.onChanged(selectedGender!);
                  },
                  child: Row(
                    children: [
                      Icon(
                        selectedGender == 'female'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: selectedGender == 'female'
                            ? Colors.orange
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '여자',
                        style: TextStyle(
                          color: selectedGender == 'female'
                              ? Colors.orange
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGender = 'male';
                    });
                    widget.onChanged(selectedGender!);
                  },
                  child: Row(
                    children: [
                      Icon(
                        selectedGender == 'male'
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: selectedGender == 'male'
                            ? Colors.orange
                            : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '남자',
                        style: TextStyle(
                          color: selectedGender == 'male'
                              ? Colors.orange
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
