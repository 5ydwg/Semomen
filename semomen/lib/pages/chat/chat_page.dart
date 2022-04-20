import 'package:flutter/material.dart';
import 'package:semomen/pages/chat_room_page.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
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
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatRoomPage()));
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                  NetworkImage("https://cdn.pixabay.com/photo/2016/11/21/12/42/beard-1845166_1280.jpg"),
                  backgroundColor: Colors.transparent,
                ),
                title: Text('mento name $index'),
                subtitle: Text('last conversation', overflow: TextOverflow.ellipsis,),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('10분 전', style: TextStyle(color: Colors.grey, fontSize: 12.0),),
                    Container(
                      width: 16.0,
                      height: 16.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Color(0xff189ab4),
                      ),
                      alignment: Alignment.center,
                      child: Text('1', style: TextStyle(color: Colors.white, fontSize: 12.0),),
                    ),
                    SizedBox()
                  ],
                ),
                  ),
            ),
            separatorBuilder: (context, index) => Divider(),
            itemCount: 3),
      ),
    );
  }
}
