import 'package:flutter/material.dart';

class MyCouponPage extends StatefulWidget {
  MyCouponPage({Key? key}) : super(key: key);

  @override
  State<MyCouponPage> createState() => _MyCouponPageState();
}

//더미
List<Map<String, dynamic>> dataList = [
  // {
  //   "title": "가이드 구매 할인 쿠폰",
  //   "subtitle": "5000원",
  //   "subtitle1": "사용기간 2022/05/09까지"
  // },
  // {
  //   "title": "가이드 구매 할인 쿠폰",
  //   "subtitle": "30%",
  //   "subtitle1": "사용기간 2022/04/09까지"
  // },
  {"title": "준비중입니다", "subtitle": "100%", "subtitle1": "사용기간 2099/12/31까지"},
];

class _MyCouponPageState extends State<MyCouponPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //앱바
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          '쿠폰함',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //뒤로가기 색변경
        ),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> data = dataList[index];
          String title = data["title"];
          String subtitle = data["subtitle"];
          String subtitle1 = data["subtitle1"];
          return CouponList(data: data);
        },
      ),
    );
  }
}

//쿠폰 리스트
class CouponList extends StatelessWidget {
  Map<String, dynamic> data;
  CouponList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(7),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(children: [
          Icon(
            Icons.confirmation_num_outlined,
            color: Colors.blue[300],
            size: 30,
          ),
          SizedBox(
            width: 12.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  data['subtitle'],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                data['subtitle1'],
                style: TextStyle(color: Colors.grey, fontSize: 13),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
