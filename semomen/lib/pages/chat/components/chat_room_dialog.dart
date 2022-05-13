import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semomen/constants/db_constants.dart';

//page
import '../../mentoring/chat_room_page.dart';

class ChatDrawer extends StatefulWidget {
  const ChatDrawer(
      {Key? key,
      @required this.data,
      @required this.mentorState,
      @required this.roomId})
      : super(key: key);

  final data;
  final String? mentorState;
  final roomId;

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  @override
  Widget build(BuildContext context) {
    String current_uid = FirebaseAuth.instance.currentUser!.uid;
    Size size = MediaQuery.of(context).size; //

    return FutureBuilder<DocumentSnapshot>(
        future: mentorRef.doc(widget.data['uid']).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData) {
            Map<String, dynamic> menteeDatas =
                snapshot.data!.data() as Map<String, dynamic>;
            List menteeList = menteeDatas['mentee'];
            String mentorUid = widget.data['uid'];
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Column(
                children: [
                  DrawerHeader(
                    child: Text('Drawer Header'),
                  ),
                  widget.mentorState == 'online'
                      ? ListTile(
                          title: Text('멘토링 신청'),
                          onTap: () async {
                            bool descMentoring = await requestMentoring(
                                context, widget.data, current_uid);

                            if (descMentoring == true) {
                              _showMentoringDialog(context, current_uid);
                            }
                            ;
                          },
                        )
                      : ListTile(
                          title: Text('현재 멘토님은 로그아웃 중이십니다.'),
                        ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: menteeList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map menteeData = menteeList[index] as Map;
                        return ListTile(
                          leading: ClipOval(
                              child: Image.network(
                            menteeData['profile_img'],
                            fit: BoxFit.cover,
                            width: size.width * 0.1,
                            height: size.width * 0.1,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: size.width * 0.2,
                              width: size.width * 0.2,
                              color: Colors.grey,
                            ),
                          )),
                          title: Text('${menteeData['mentee_name']}'),
                          trailing: GestureDetector(
                            onTap: () {
                              _showReportDialog(context, menteeList, index,
                                  mentorUid, widget.roomId);
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              child: Text('🚨'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
          } else {
            return GestureDetector(
              child: Text('참여 멘티가 없습니다'),
            );
          }
        });
  }
}

Future<bool> requestMentoring(context, data, current_uid) async {
  //멘토와의 1대1 채팅방 생성!
  Map<String, dynamic> myData = {
    'profileImg': '',
    "speaker": '',
    'userName': '',
  };
  // 지금 내 user 정보 받아오기
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

  //mentor 멘토링 중인지 확인
  QuerySnapshot<Object?> isRoom =
      await mentoringRef.where('mentor', isEqualTo: data['uid']).get();
  if (isRoom.docs.length != 0) {
    _mentoringExist(context);
    return false;
  } else {
    //mentoring 데이터 생성
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
    return true;
  }
}

Future<String?> _showMentoringDialog(BuildContext context, String current_uid) {
  return showDialog<String>(
    barrierDismissible: false,
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

Future<void> _mentoringExist(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('멘토링증'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('현재 멘토님이 멘토링 중입니다.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<String?> _showReportDialog(
    BuildContext context, menteeList, index, mentorUid, roomId) {
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
              const Text('해당 유저를 신고 하시겠습니까?'),
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
                _clickMethod(menteeList, index, mentorUid,
                    _reportReasonController.text, roomId);
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

void _clickMethod(menteeList, index, mentorUid, reportReason, roomId) {
  String current_uid = FirebaseAuth.instance.currentUser!.uid;
  if (menteeList[index]['reported'] != null) {
    menteeList[index]['reported'] = menteeList[index]['reported'] + 1;
  } else {
    menteeList[index]['reported'] = 1;
  }
  Map<String, dynamic> reportData = {
    'reporter': current_uid,
    'criminal': menteeList[index]['uid'],
    'name': menteeList[index]['mentee_name'],
    'reason': reportReason,
  };
  reportRef.add(reportData);
}
