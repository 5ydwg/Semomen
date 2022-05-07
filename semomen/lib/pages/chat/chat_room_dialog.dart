import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semomen/constants/db_constants.dart';

//page
import '../mentoring/chat_room_page.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({Key? key, @required this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    String current_uid = FirebaseAuth.instance.currentUser!.uid;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      child: Column(
        children: [
          DrawerHeader(
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: Text('멘토링 신청'),
            onTap: () {
              requestMentoring(data, current_uid);
              _showMentoringDialog(context, current_uid);
            },
          ),
          Spacer(),
          ListTile(
            title: Text(
              '이 방에서 나가기',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}

void requestMentoring(data, current_uid) async {
  print(data);
  //멘토와의 1대1 채팅방 생성!

  Map<String, dynamic> myData = {
    'profileImg': '',
    "speaker": '',
    'userName': '',
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc(current_uid)
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

  DocumentReference<Map<String, dynamic>> ref = await mentoringRef.add({
    'mentee': current_uid,
    'mentee_name': myData['userName'],
    'mentee_img': myData['profileImg'],
    'mentor': data['uid'],
    'mentor_img': data['profile_img'],
    'mentor_name': data['user_name'],
    'request_state': 'request',
  });

  //생성된 채팅방 db에 room_id 인젝
  ref.update(
    {'room_id': ref.id},
  );
}

Future<String?> _showMentoringDialog(BuildContext context, String current_uid) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => StreamBuilder<QuerySnapshot<Object?>>(
      stream: mentoringRef.where('mentee', isEqualTo: current_uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData) {
          Map<String, dynamic> roomData = {};
          snapshot.data!.docs.forEach((value) {
            roomData = value.data()! as Map<String, dynamic>;
          });

          if (roomData['request_state'] == 'request') {
            return AlertDialog(
              title: const Text('멘토링 요청 중'),
              content: const Text('멘토님의 응답을 기다리는 중입니다.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    //받아온 docs 를 삭제함
                    await mentoringRef.doc(roomData['room_id']).delete();
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('취소'),
                ),
              ],
            );
          } else if (roomData['request_state'] == 'denied') {
            return AlertDialog(
              title: const Text('멘토링 거절'),
              content: const Text('멘토님이 멘토링을 거절하셨습니다..'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    //받아온 docs 를 삭제함
                    await mentoringRef
                        .doc(roomData['room_id'])
                        .update({'reqeust_state': 'terminated'});
                    await mentoringRef.doc(roomData['room_id']).delete();
                    Navigator.pop(context);
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          } else if (roomData['request_state'] == 'accepted') {
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatRoomPage(data: roomData)));
            });
            return SizedBox();
          } else {
            return SizedBox();
          }
        } else {
          return Text('멘토링 신청 내용이 없습니다.');
        }
      },
    ),
  );
}
