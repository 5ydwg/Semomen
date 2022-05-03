import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/widgets/my_chat_box.dart';
import 'package:semomen/widgets/opponent_chat_box.dart';



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
