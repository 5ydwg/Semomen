import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/pages/home/home_page.dart';
import '../../constants/db_constants.dart';
import 'dart:async';

//page
import 'chat_area.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.data}) : super(key: key);
  final data;
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController _messageController = TextEditingController();
  Timer? _timer;
  var time = 0;

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  void dispose() {
    exit();
    _timer?.cancel();
    _messageController.dispose();
    super.dispose();
  }

  void exit() async {
    await mentoringRef.doc(widget.data['room_id']).delete();
    Navigator.popUntil(
        context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  //10분뒤 나가지기
  void start() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {
        time++;
      });
      if (time == 600) {
        exit();
      }
    });
  }

  void pause() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.data);
    return WillPopScope(
      onWillPop: () async {
        bool cancel = false;
        await _showCancelDialog(context, exit, cancel);
        // Navigator.pop(context);
        print(cancel);
        return false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: mainBabyBlue.withOpacity(1),
          elevation: 0.0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.data['mentor_name']}',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          actions: [
            Builder(builder: (context) {
              return IconButton(
                color: Colors.black,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: Icon(CupertinoIcons.ellipsis_vertical),
              );
            })
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ChatArea(
                  messageController: _messageController,
                  data: widget.data,
                  size: size,
                  time: time,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                height: 50.0,
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            splashRadius: 1.0,
                            onPressed: () {
                              String message = _messageController.text;
                              ChatSubmit(widget.data, message);
                              setState(() {
                                _messageController.text = '';
                              });
                            },
                            icon: Icon(
                              Icons.send_outlined,
                              color: mainBlueGrotto,
                            ),
                          ),
                          hintText: '메시지 입력해주세요.',
                          filled: true,
                          fillColor: Color(0xfff6f6fd),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onChanged: (String text) {},
                        onSubmitted: (String text) {
                          String message = _messageController.text;
                          ChatSubmit(widget.data, message);
                          setState(() {
                            _messageController.text = '';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// chat 메시지 전달 함수
void ChatSubmit(data, message) async {
  //현재 내 uid 정보 받아오기
  //현재 시간 받아오기
  DateTime currentTime = DateTime.now(); //DateTime
  Timestamp timestampNow = Timestamp.fromDate(currentTime);
  if (message != null) {
    await mentoringRef.doc(data['room_id']).collection('messages').add({
      'created_at': FieldValue.serverTimestamp(),
      'message': message,
      'profile_img': data['mentee_img'],
      "speaker": data['mentee'],
      'user_name': data['mentee_name'],
    }).then(((value) => print('작성완료!')));
  }
}

Future<String?> _showCancelDialog(BuildContext context, exit, cancel) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('멘토링 나가기'),
        content: const Text('멘토링을 종료 하시겠습니까?.'),
        actions: [
          TextButton(
            onPressed: () {
              exit();
            },
            child: const Text('나가기'),
          ),
          TextButton(
            onPressed: () async {
              cancel = false;
              Navigator.pop(context, 'Cancel');
            },
            child: const Text('취소'),
          ),
        ],
      );
    },
  );
}






// 나중 개발 계획 !
// 1. initState() 에서 이용권 1회 차감을 결정한다.
// 2. 시간이 다되면 연장여부 Dialong를 띄워준다.