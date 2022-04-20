import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';

class MyChatBox extends StatelessWidget {
  const MyChatBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(12.0),
          child: Text('asdasdaasdjkhas'),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.yellow,

          ),
        ),
      ],
    );
  }
}
