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
                        ChatList(data: data[index]),
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
  }) : super(key: key);

  final Map data;

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
            return GestureDetector(
              onTap: () {
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
                  'last conversation',
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '10분 전',
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                    Container(
                      width: 16.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Color(0xff189ab4),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontSize: 12.0),
                      ),
                    ),
                    SizedBox()
                  ],
                ),
              ),
            );
          }
        });
  }
}
