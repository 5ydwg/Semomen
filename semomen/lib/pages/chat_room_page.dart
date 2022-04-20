import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/widgets/my_chat_box.dart';
import 'package:semomen/widgets/opponent_chat_box.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({Key? key}) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  TextEditingController _messageController = TextEditingController();
  List<Widget> chatList = [
    MyChatBox(),
    OpponentChatBox(),
    Container(
      color: Colors.grey,
      margin: EdgeInsets.all(4.0),
      height: 60.0,
      child: Text('asdsadasd'),
    ),
    Container(
      color: Colors.grey,
      margin: EdgeInsets.all(4.0),
      height: 60.0,
      child: Text('asdsadasd'),
    ),
    Container(
      color: Colors.grey,
      margin: EdgeInsets.all(4.0),
      height: 60.0,
      child: Text('asdsadasd'),
    ),
    Container(
      color: Colors.grey,
      margin: EdgeInsets.all(4.0),
      height: 60.0,
      child: Text('asdsadasd'),
    ),
  ];

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
          'mentor name',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: mainBabyBlue,
                child: ListView(
                  children: [
                    ...chatList,
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              height: 90.0,
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
                            FocusScope.of(context).unfocus();
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
                      onChanged: (String text) {
                      },
                      onSubmitted: (String text) {
                        print(text);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
