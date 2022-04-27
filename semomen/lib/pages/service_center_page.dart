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
      body: Center(
        child: Text(
          '고객센터: 123@gmail.com',
          style: TextStyle(fontSize: 20, color: Colors.blue),
        ),
      ),
    );
  }
}
