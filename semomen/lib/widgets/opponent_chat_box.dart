import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';

class OpponentChatBox extends StatelessWidget {
  OpponentChatBox({Key? key, required this.message}) : super(key: key);

  Map<String, dynamic> message;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                  child: Image.network(
                message['profile_img'],
                fit: BoxFit.cover,
                width: size.width * 0.1,
                height: size.width * 0.1,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: size.width * 0.2,
                  width: size.width * 0.2,
                  color: mainBabyBlue,
                ),
              )),
            ],
          ),
          SizedBox(
            width: 8.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['user_name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 200),
                padding: EdgeInsets.all(12.0),
                child: Text(
                  message['message'],
                  softWrap: true,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
