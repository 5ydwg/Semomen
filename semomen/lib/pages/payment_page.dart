import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  //get menu => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //앱바
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          '구매하기',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      body: Column(
        children: [
          Spacer(),
          Container(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0, left: 12, right: 12),
            height: 20,
            color: Colors.grey.shade100,
            child: Text(
              '전체동의',
              style: TextStyle(color: Colors.black
                  //fontStyle
                  ),
            ),
            alignment: Alignment.topLeft,
          ),
          Divider(
            height: 0.0,
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 1.0, bottom: 1.0, left: 12, right: 12),
            height: 60,
            color: Colors.grey.shade100,
            child: Text(
              '동의1',
              style: TextStyle(color: Colors.black
                  //fontStyle
                  ),
            ),
            alignment: Alignment.topLeft,
          ),
          Container(
            padding: const EdgeInsets.only(
                top: 12.0, bottom: 12.0, left: 12, right: 12),
            height: 80,
            color: Colors.grey,
            child: Text(
              '결제금액',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white
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
                '결제하기',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white
                        //fontStyle
                        ),
              ),
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
