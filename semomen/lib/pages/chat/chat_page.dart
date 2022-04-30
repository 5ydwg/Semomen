import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semomen/pages/chat_room_page.dart';
import '../../constants/db_constants.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: menteeRef.doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            List data = snapshot.data!.get('mentor');

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  '채팅',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: ListView.separated(
                    itemBuilder: (context, index) =>
                        data[index]['uid'] != 'undefined'
                            ? ChatList(data: data[index], uid: uid)
                            : SizedBox(),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: data.length),
              ),
            );
          }
        });
  }
}

class ChatList extends StatelessWidget {
  const ChatList({
    Key? key,
    required this.data,
    required this.uid,
  }) : super(key: key);

  final Map data;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Object?>>(
        stream: groupChatRef.doc(data['uid']).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('데이터가 없습니다');
          }
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            Map<String, dynamic> chat_data =
                snapshot.data!.data() as Map<String, dynamic>;

            List chatDataReader = chat_data['recent_message_reader'];

            bool isReaded = chatDataReader.contains(uid);

            return GestureDetector(
              onTap: () async {
                print('test');

                if (!chatDataReader.contains(uid)) {
                  await groupChatRef.doc(data['uid']).update({
                    'recent_message_reader': [...chatDataReader, uid]
                  });
                }
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatRoomPage(data: data)));
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(
                      data['profile_img'] == null ? '' : data['profile_img']),
                  backgroundColor: Colors.transparent,
                ),
                title:
                    Text(data['user_name'] == null ? ' ' : data['user_name']),
                subtitle: Text(
                  chat_data['recent_message'] == null
                      ? ''
                      : chat_data['recent_message'],
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isReaded == false
                        ? Container(
                            width: 16.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: Color(0xff189ab4),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '!',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12.0),
                            ),
                          )
                        : SizedBox(),
                    SizedBox()
                  ],
                ),
              ),
            );
          }
        });
  }
}
