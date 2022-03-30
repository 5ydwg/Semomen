import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semomen/pages/constants/constant.dart';

class GuideInfoPage extends StatefulWidget {
  const GuideInfoPage({Key? key}) : super(key: key);

  @override
  _GuideInfoPageState createState() => _GuideInfoPageState();
}

class _GuideInfoPageState extends State<GuideInfoPage> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //화면을 세로 방향으로 고정하기
    Size size = MediaQuery.of(context).size; //화면의 size 가져오기
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '가이드 제목',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('직업 소개', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
          ),
          Container(
            width: size.width,
            height: size.width * 0.625,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0), color: mainBabyBlue),
            child: Center(
              child: Icon(Icons.play_circle_outline, color: Colors.grey,),
            ),
          ),
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: (size.width-24.0) * 0.5,
                    height: (size.width) * 0.625 * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0), color: mainBabyBlue),
                  ),
                  SizedBox(width: 12.0,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('항해사가 걸어온 길', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 8.0,),
                        Text('항해사가 어떤 일을 하는지 궁금하시지 않나요? 항해사가 하는 일과 항해사가 되기위한 길 A-Z까지 모두 알려드립니다!\n\n필요한 정보를 지속적으로 알려주기 위한채팅 기능도 개설되어 있습니다! ')
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(height: 20.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('멘토', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),)),
              IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.0,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(
                        width: 12.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Text('김OO'), Text('항해사')],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('이력', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    Text('- A', style: TextStyle(color: Colors.grey),),
                    Text('- B', style: TextStyle(color: Colors.grey),),
                    Text('- C', style: TextStyle(color: Colors.grey),),
                  ],
                ),
              )
            ],
          ),
          Divider(height: 20.0,),
          Column(
            children: [
              Text('리뷰', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
              Text(
                '⭐⭐⭐⭐⭐',
                style: TextStyle(
                    color: Colors.yellow[600], fontWeight: FontWeight.bold),
              ),
              Text(
                '5.0',
                style: TextStyle(
                    color: Colors.yellow[600], fontWeight: FontWeight.bold),
              ),
              Text(
                '155개의 평가',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: size.width * 0.3,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: mainBlueGreen),
                    onPressed: () {},
                    child: Text('더보기')),
              ),
            ],
          ),
          Divider(height: 20.0,),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('역량 가이드', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
          ),
          Stack(
            children: [
              ExpansionPanelList.radio(
                expandedHeaderPadding: EdgeInsets.all(0.0),
                children: [
                  _capabilitiesGuideItem(size, 0),
                  _capabilitiesGuideItem(size, 1),
                  _capabilitiesGuideItem(size, 2),
                  _capabilitiesGuideItem(size, 3),
                ],
              ),
              Container(
                height: 700.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0,-1),
                        end: Alignment(0,-0.8),
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                          Theme.of(context).scaffoldBackgroundColor
                        ]
                    ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('더 자세한 길을 알고 싶다면', style: TextStyle(fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('가이드 구매를 통해 알아보세요.', style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: mainNavyBlue
                          ),
                          onPressed: () {}, child: Text('구매하기')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanelRadio _capabilitiesGuideItem(Size size, int index) {
    return ExpansionPanelRadio(
      value: index,
      headerBuilder: (context, isExpanded) {
        return IntrinsicHeight(
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    margin: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: mainBlueGreen),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        'Description',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      'https://www.kmou.ac.kr',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
