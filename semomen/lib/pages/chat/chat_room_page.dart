import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';

import '../../constants/db_constants.dart';

//page
import 'chat_area.dart';
import './chat_room_dialog.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key, required this.data}) : super(key: key);
  final data;
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawerEnableOpenDragGesture: true,
      endDrawer: Drawer(
        child: ChatDrawer(data : widget.data),
      ),
      appBar: AppBar(
        backgroundColor: mainBabyBlue.withOpacity(1),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.data['user_name']}',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              CupertinoIcons.circle_fill,
              color: Colors.limeAccent[400],
              size: 15,
            )
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
      body: Column(
        children: [
          Expanded(
            child: ChatArea(
                messageController: _messageController,
                data: widget.data,
                size: size),
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
    );
  }
}

// chat 메시지 전달 함수
void ChatSubmit(data, message) async {
  //현재 내 uid 정보 받아오기
  String uid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic> myData = {
    'profileImg': '',
    "speaker": '',
    'userName': '',
  };

  // user컬렉션의 내 uid 정보 받아오기
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      Map<String, dynamic>? userDoc =
          documentSnapshot.data() as Map<String, dynamic>?;

      myData = {
        'profileImg': userDoc?['profile_img'],
        "speaker": userDoc?['uid'],
        'userName': userDoc?['user_name'],
      };
    }
    ;
  });

  //현재 시간 받아오기
  DateTime currentTime = DateTime.now(); //DateTime
  Timestamp timestampNow = Timestamp.fromDate(currentTime);
  if (message != null) {
    await groupChatRef.doc(data['uid']).collection('messages').add({
      'created_at': timestampNow,
      'message': message,
      'profile_img': myData['profileImg'],
      "speaker": myData['speaker'],
      'user_name': myData['userName'],
    }).then(((value) => print('작성완료!')));

    await groupChatRef.doc(data['uid']).update({
      'recent_message': message,
      'recent_message_created_at': timestampNow,
      'recent_message_reader': [myData['speaker']]
    }).then((value) => print('최신 메시지 업데이트 완료'));
  }
}
