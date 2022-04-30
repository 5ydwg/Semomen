import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';

class MyChatBox extends StatelessWidget {
  MyChatBox({Key? key, required this.message}) : super(key: key);

  Map<String, dynamic> message;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          constraints: BoxConstraints(maxWidth: 200),
          child: Text(
            message['message'],
            softWrap: true,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.yellow,
          ),
        ),
      ],
    );
  }
}
