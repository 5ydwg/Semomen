import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/db_constants.dart';

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
        elevation: 0.5,
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            _reportBox(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('이메일 : l5ydwgl@yonsei.ac.kr',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportBox() {
    return Card(
      child: ListTile(
        onTap: () {
          _showReportDialog(context);
        },
        leading: Text(
          '신고하기',
          style: TextStyle(color: Colors.red[700]),
        ),
        dense: true,
      ),
    );
  }
}

Future<String?> _showReportDialog(BuildContext context) {
  TextEditingController _reportReasonController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('신고'),
        content: Container(
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('신고 내용을 입력해주세요.'),
              SizedBox(
                height: 30,
              ),
              Container(
                child: TextField(
                  controller: _reportReasonController,
                  decoration: InputDecoration(hintText: '신고 사유를 입력해 주세요'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_reportReasonController.text != '') {
                _clickMethod(_reportReasonController.text);
              }
              Navigator.pop(context);
            },
            child: const Text('신고'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('취소'),
          ),
        ],
      );
    },
  );
}

void _clickMethod(reportReason) {
  String current_uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> reportData = {
    'reporter': current_uid,
    'reason': reportReason,
  };
  reportRef.add(reportData);
}
