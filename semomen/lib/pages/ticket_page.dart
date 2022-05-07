import 'package:flutter/material.dart';
import 'package:semomen/pages/payment_page.dart';

class TicketPage extends StatefulWidget {
  TicketPage({Key? key}) : super(key: key);

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  //get menu => null;
  String a = '';
  //결제금액 변수
  String b = '';
  //클릭 색상 변경

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
            indicatorColor: Colors.black,
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
                SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            a = '1000';
                            b = '';
                          });
                        },
                        child: Container(
                          child: Center(
                            child: Text(
                              '1회권',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          width: 125,
                          height: 35,
                          decoration: b == ""
                              ? BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.black87,
                                )
                              : BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blue,
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Center(
                            child: Text(
                              '5회권',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          width: 125,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Center(
                            child: Text(
                              '10회권',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          width: 125,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ]),
                Spacer(),
                Container(
                  padding: const EdgeInsets.only(
                      top: 1.0, bottom: 1.0, left: 12, right: 12),
                  height: 60,
                  color: Color(00),
                  child: Text(
                    '부분환불은 불가하오니, 신중한 구매 부탁드립니다.',
                    style: TextStyle(
                      color: Colors.black, fontSize: 16,
                      //fontStyle
                    ),
                  ),
                  alignment: Alignment.topLeft,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 12.0, left: 12, right: 12),
                  height: 80,
                  color: Color.fromARGB(230, 5, 5, 15),
                  child: Row(
                    children: [
                      Text(
                        '결제금액',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white,
                          fontSize: 16,
                          //fontStyle
                        ),
                      ),
                      Spacer(),
                      Text(
                        '${a}원',
                        style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white,
                          fontSize: 16,
                          //fontStyle
                        ),
                      ),
                    ],
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
                    color: Colors.black,
                    child: Text(
                      '다 음',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white,
                        fontSize: 16,
                        //fontStyle
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ],
            ),
            // Column(
            //   children: [
            //     Spacer(),
            //     Container(
            //       padding: const EdgeInsets.only(
            //           top: 12.0, bottom: 12.0, left: 12, right: 12),
            //       height: 80,
            //       color: Colors.grey,
            //       child: Text(
            //         '결제금액',
            //         style: TextStyle(
            //             fontWeight: FontWeight.bold, color: Colors.white
            //             //fontStyle
            //             ),
            //       ),
            //       alignment: Alignment.centerLeft,
            //     ),
            //     GestureDetector(
            //       // onTap: () {
            //       //   Navigator.push(
            //       //     context,
            //       //     MaterialPageRoute(builder: (context) => PaymentPage()),
            //       //   );
            //       // },

            //       child: Container(
            //         height: 50,
            //         color: Colors.lightGreen,
            //         child: Text(
            //           '다 음',
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold, color: Colors.white
            //               //fontStyle
            //               ),
            //         ),
            //         alignment: Alignment.center,
            //       ),
            //     ),
            //   ],
            // ),
            Center(child: Text("준비중입니다")),
            Center(child: Text("준비중입니다")),
          ],
        ),
      ),
    );
  }
}
