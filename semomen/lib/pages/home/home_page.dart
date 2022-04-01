import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semomen/pages/detail_guide_info_page.dart';
import 'package:semomen/pages/guide_info_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //화면을 세로 방향으로 고정하기
    Size size = MediaQuery.of(context).size; //화면의 size 가져오기
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          _jobOfThisWeek(size), // 이주의 직업
          Divider(
            thickness: 5.0,
          ),
          _recommendedGuide(size),  // 추천 가이드
          Divider(
            thickness: 5.0,
          ),
          _popularGuide(size),  // 인기 가이드
          Divider(
            thickness: 5.0,
          ),
          _newGuide(size),  // 신규 등록 가이드
          Divider(
            thickness: 5.0,
          ),
          _recentGuide(size), // 최근 본 가이드
          Divider(
            thickness: 5.0,
          ),
          _purchasedGuide(size),  // 나의 구매 가이드
        ],
      ),
    );
  }

  Widget _jobOfThisWeek(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('이 주의 직업', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        SizedBox(height: 8.0,),
        Container(
          padding: EdgeInsets.all(8.0),
          height: size.width * 0.625,
          width: size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0), color: Colors.grey),
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                bottom: 0.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  onPressed: () {},
                  child: Text(
                    '자세히',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],),
    );
  }
  Widget _recommendedGuide(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text('추천 가이드', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
        SizedBox(height: 8.0,),
        SizedBox(
          height: size.width * 0.6 * 0.625,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => SizedBox(
              width: 8.0,
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => GuideInfoPage()));
              },
              child: Container(
                width: size.width * 0.6,
                height: size.width * 0.6 * 0.625,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.grey),
                padding: EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0.0,
                      child: SizedBox(
                        width: size.width * 0.6 * 0.25,
                        height: size.width * 0.6 * 0.25 * 0.5,
                        child: ElevatedButton(
                          onPressed: () {},
                          style:
                          ElevatedButton.styleFrom(primary: Colors.white),
                          child: Text(
                            '자세히',
                            style:
                            TextStyle(fontSize: 8.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],),
    );
  }
  Widget _popularGuide(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('인기 가이드', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
          SizedBox(height: 8.0,),
          Container(
            padding: EdgeInsets.all(8.0),
            height: size.width * 0.625,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0), color: Colors.grey),
            child: Stack(
              children: [
                Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    onPressed: () {},
                    child: Text(
                      '자세히',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],),
    );
  }
  Widget _newGuide(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('신규 등록 가이드', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
              Icon(Icons.chevron_right),
            ],
          ),
          SizedBox(height: 8.0,),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            separatorBuilder: (context, index) => SizedBox(
              height: 8.0,
            ),
            itemBuilder: (context, index) => Card(
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4.0)
                        ),
                      ),
                      SizedBox(width: 12.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                          Text('mento name', style: TextStyle(fontSize: 14.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                          Text('Description', style: TextStyle(fontSize: 14.0, color: Colors.grey,),),
                          Text('⭐⭐⭐⭐⭐ 5.0', style: TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],),
    );
  }
  Widget _recentGuide(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('최근 본 가이드', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
          SizedBox(height: 8.0,),
          SizedBox(
            height: size.width * 0.6 * 0.625,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => SizedBox(
                width: 8.0,
              ),
              itemBuilder: (context, index) => Container(
                width: size.width * 0.6,
                height: size.width * 0.6 * 0.625,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: Colors.grey),
                padding: EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0.0,
                      child: SizedBox(
                        width: size.width * 0.6 * 0.25,
                        height: size.width * 0.6 * 0.25 * 0.5,
                        child: ElevatedButton(
                          onPressed: () {},
                          style:
                          ElevatedButton.styleFrom(primary: Colors.white),
                          child: Text(
                            '자세히',
                            style:
                            TextStyle(fontSize: 8.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],),
    );
  }
  Widget _purchasedGuide(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('나의 구매 가이드', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
              Icon(Icons.chevron_right),
            ],
          ),
          SizedBox(height: 8.0,),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 2,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 행에 보여줄 item 수
                childAspectRatio: 1 / 1.6, // item의 가로, 세로 비율
                mainAxisSpacing: 8.0, // 수직 Padding
                crossAxisSpacing: 8.0 // 수평 Padding
            ),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailGuideInfoPage()));
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.width * 0.5 * 0.625,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Job', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Name', style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title', style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('Description', style: TextStyle(color: Colors.grey),),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],),
    );
  }
}
