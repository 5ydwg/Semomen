import 'package:flutter/material.dart';
import 'package:semomen/constants/constant.dart';

class OpponentChatBox extends StatelessWidget {
  const OpponentChatBox({Key? key}) : super(key: key);

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
                    'https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_1280.png',
                    fit: BoxFit.cover,
                    width: size.width * 0.1,
                    height: size.width * 0.1,
                    errorBuilder: (context, error, stackTrace) => Container(height: size.width * 0.2, width:size.width * 0.2,color: mainBabyBlue,),
                  )
              ),
            ],
          ),
          SizedBox(width: 8.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('opponent name', style: TextStyle(fontWeight: FontWeight.bold),),
              Container(
                padding: EdgeInsets.all(12.0),
                child: Text('asdasdaasdjkhas'),
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
