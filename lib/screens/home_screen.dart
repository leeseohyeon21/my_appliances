import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_appliances/constants/common_size.dart';
import 'package:my_appliances/screens/home/purchase_product_page.dart';
import 'package:my_appliances/screens/home/rental_product_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _bottomSelectedIndex = 0;  // 기본적으로 0번 인덱스(PurchaseProductScreen)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('나의 가전', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Row로 버튼 두 개 배치
          Padding(
            padding: const EdgeInsets.all(common_bg_padding),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bottomSelectedIndex = 0;  // 구매 제품 선택
                      });
                    },
                    child: Text('구매 제품'),
                  ),
                ),
                SizedBox(width: 10), // 버튼 간 간격
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bottomSelectedIndex = 1;  // 렌탈 제품 선택
                      });
                    },
                    child: Text('렌탈 제품'),
                  ),
                ),
              ],
            ),
          ),
          // 본문 내용
          Expanded(
            child: IndexedStack(
              index: _bottomSelectedIndex,
              children: [
                PurchaseProductPage(),  // 구매 제품 화면
                RentalProductPage(),    // 렌탈 제품 화면
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showOptionOverlay(context),
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}

// 커스텀 오버레이 표시
void _showOptionOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true, // 다이얼로그 외부를 클릭해도 닫힐 수 있도록 설정
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent, // 배경을 투명하게 설정
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '등록 방법 선택',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  context.push('/label_recognition'); // 라벨 스캔 화면으로 이동
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('제품 라벨로 등록하기'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  context.push('/register'); // 직접 등록 화면으로 이동
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('직접 등록하기'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
