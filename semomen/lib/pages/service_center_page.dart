import 'package:flutter/material.dart';

class ServiceCenterPage extends StatefulWidget {
  ServiceCenterPage({Key? key}) : super(key: key);

  @override
  State<ServiceCenterPage> createState() => _ServiceCenterPageState();
}

class _ServiceCenterPageState extends State<ServiceCenterPage> {
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
          '고객센터',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
      body: Center(
        child: Text('이메일 문의만 가능합니다.\nl5ydwgl@yonsei.ac.kr',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            )),
      ),
    );
  }
}
