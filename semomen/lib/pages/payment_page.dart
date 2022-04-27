import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  get menu => null;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "이용권 선택",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.search_outlined, color: Colors.grey),
              onPressed: () {
                print("Pay 우측 상단 아이콘 클릭 됨");
              },
            ),
          ],

          /// Tip : AppBar 하단에 TabBar를 만들어 줍니다.
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.lightGreen,
            indicatorWeight: 4,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(text: "횟수권"),
              Tab(text: "정기권"),
              Tab(text: "패키지"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(),

            // Positioned(
            //   bottom: 18,
            //   left: 24,
            //   right: 24,
            //   child: GestureDetector(
            //     onTap: () {
            //       print("예약하기 클릭 됨");
            //     },
            //     child: Container(
            //       width: double.infinity,
            //       height: 58,
            //       color: Colors.red,
            //       alignment: Alignment.center,
            //       child: Text(
            //         "예약하기",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 13,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            Center(child: Text("나만의 메뉴")),

            Center(child: Text("홀케이크 예약")),
          ],
        ),
      ),
    );
  }
}
