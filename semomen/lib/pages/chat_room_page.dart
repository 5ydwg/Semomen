import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/widgets/my_chat_box.dart';
import 'package:semomen/widgets/opponent_chat_box.dart';

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
      appBar: AppBar(
        backgroundColor: mainBabyBlue.withOpacity(0.5),
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '${widget.data['user_name']}',
          style: TextStyle(color: Colors.black),
        ),
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
                    onSubmitted: (String text) {},
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

class ChatArea extends StatelessWidget {
  const ChatArea(
      {Key? key,
      required TextEditingController messageController,
      required this.data,
      required this.size})
      : _messageController = messageController,
        super(key: key);

  final TextEditingController _messageController;
  final Map data;
  final Size size;

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return StreamBuilder<QuerySnapshot<Object?>>(
        stream: groupChatRef
            .doc(data['uid'])
            .collection('messages')
            .orderBy('created_at')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData) {
            Timer(
                Duration(milliseconds: 500),
                () => _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent));
            //받아올 chatMessage
            List chatMessages = [];
            //firebase에서 데이터 받아오기
            snapshot.data!.docs.forEach((value) {
              chatMessages = [...chatMessages, value.data()!];
            });
            //사용할 현재 uid 값 받아오기
            String uid = FirebaseAuth.instance.currentUser!.uid;

            return Container(
              decoration: BoxDecoration(
                color: mainBabyBlue,
              ),
              child: GestureDetector(
                onTap: () {
                  print(data['uid']);
                  print(chatMessages);
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: chatMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> message = chatMessages[index];

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: message['speaker'] == uid
                          ? MyChatBox(message: message)
                          : OpponentChatBox(message: message),
                    );
                  },
                ),
              ),
            );
          } else {
            return Text('채팅 내용이 없습니다.');
          }
        });
  }
}

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
