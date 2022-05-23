import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PurchasedGuidePage extends StatefulWidget {
  PurchasedGuidePage({Key? key}) : super(key: key);

  @override
  State<PurchasedGuidePage> createState() => _PurchasedGuidePageState();
}

List<Map<String, dynamic>> jobs = [
  {
    'imageUrl': '',
    'job': '항해사',
    'name': '김ㅇㅇ 멘토',
    'title': '어쩌구',
  },
  {
    'imageUrl': '',
    'job': '수의사',
    'name': '김ㅇㅇ 멘토',
    'title': '어쩌구',
  },
  {
    'imageUrl': '',
    'job': '부사제',
    'name': '김ㅇㅇ 멘토',
    'title': '어쩌구',
  },
  {
    'imageUrl': '',
    'job': '공군 장교',
    'name': '김ㅇㅇ 멘토',
    'title': '어쩌구',
  },
  {
    'imageUrl': '',
    'job': '약사',
    'name': '김ㅇㅇ 멘토',
    'title': '어쩌구',
  },
  {
    'imageUrl': '',
    'job': '피아니스트',
    'name': '김ㅇㅇ 멘토',
    'title': '어쩌구',
  },
];

class _PurchasedGuidePageState extends State<PurchasedGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //앱바
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '구매가이드',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //뒤로가기 색변경
        ),
      ),
      //구매가이드 리스트
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 3.7 / 5),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = jobs[index];
                String imageUrl = jobs[index]['imageUrl']!;
                String job = jobs[index]['job']!;
                String name = jobs[index]['name']!;
                String title = jobs[index]['title']!;
                return GuidItem(Jobs: data);
              },
            ),
          )
        ],
      ),
    );
  }
}

class GuidItem extends StatelessWidget {
  Map<String, dynamic> Jobs;

  GuidItem({Key? key, required this.Jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        margin: EdgeInsets.only(
          left: 5,
          right: 5,
          top: 10,
          bottom: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 1,
              spreadRadius: 1,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              //이미지
              child: Container(
                height: 120,
                width: double.infinity,
                color: Colors.amber,
              ),
            ),
            //소개란
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Jobs["job"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          Jobs["title"],
                        )
                      ],
                    ),
                    Spacer(),
                    Text(
                      Jobs["name"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
