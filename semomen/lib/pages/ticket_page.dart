import 'package:flutter/material.dart';
import 'package:semomen/pages/payment_page.dart';

class TicketPage extends StatefulWidget {
  TicketPage({Key? key}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  //get menu => null;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "이용권 선택",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          backgroundColor: Colors.white,

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
            Column(
              children: [
                Spacer(),
                Container(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 12, right: 12),
                  height: 80,
                  color: Colors.grey,
                  child: Text(
                    '결제금액',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white
                        //fontStyle
                        ),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  },
                  child: Container(
                    height: 50,
                    color: Colors.lightGreen,
                    child: Text(
                      '다 음',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white
                          //fontStyle
                          ),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            Center(child: Text("나만의 메뉴")),
            Center(child: Text("홀케이크 예약")),
          ],
        ),
      ),
    );
  }
}
