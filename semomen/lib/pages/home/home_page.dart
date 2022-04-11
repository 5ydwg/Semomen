import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/mentee_model.dart';
import 'package:semomen/model/post_model.dart';
import 'package:semomen/pages/detail_guide_info_page.dart';
import 'package:semomen/pages/guide_info_page.dart';
import 'package:semomen/providers/mentee_provider.dart';
import 'package:semomen/providers/post_provider.dart';

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
        centerTitle: true,
        title: Text('세상의 모든 멘토',style: TextStyle(
          fontWeight: FontWeight.bold,
          foreground: Paint()..shader = LinearGradient(colors: <Color>[
            mainBlueGreen,
            mainBlueGrotto
          ]).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 300.0)),
        ),),
      ),
      body: ListView(
        children: [
          _jobOfThisWeek(size), // 이주의 직업
          Divider(
            thickness: 5.0,
          ),
          // _recommendedGuide(size),  // 추천 가이드
          // Divider(
          //   thickness: 5.0,
          // ),
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
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) => FutureBuilder<PostModel>(
          future: postProvider.getJobOfThisWeek(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return SizedBox(
                  height: size.width * 0.625,
                  width: size.width,
                  child: Text("Something went wrong"));
            }
            if (snapshot.hasData && snapshot.data!.uid.isEmpty) {
              return SizedBox(
                  height: size.width * 0.625,
                  width: size.width,
                  child: Text("Document does not exist!!"));
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이 주의 직업', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                    SizedBox(height: 8.0,),
                    Container(
                      height: size.width * 0.625,
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0), color: mainBlueGrotto,
                        image: DecorationImage(
                          onError: (object, stackTrace) {

                          },
                          image: NetworkImage(
                              snapshot.data?.jobImgUrl ?? ''
                          ),
                          fit: BoxFit.cover
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 8.0,
                            bottom: 0.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(primary: Colors.white),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailGuideInfoPage(post: snapshot.data!)));
                              },
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
            return Container(
                padding: EdgeInsets.all(8.0),
                height: size.width * 0.625,
                width: size.width,
                child: Center(child: CircularProgressIndicator()));
          }
      ),
    );
  }

  Widget _popularGuide(Size size) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('인기 가이드', style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
            SizedBox(height: 8.0,),
            FutureBuilder<DocumentSnapshot>(
                future: postProvider.getPopularPost(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Container(
                        padding: EdgeInsets.all(8.0),
                        height: size.width * 0.625,
                        width: size.width,
                        color: Colors.grey,
                        child: Text("Something went wrong"));
                  }
                  if (snapshot.hasData && !snapshot.data!.exists) {
                    return Container(
                        padding: EdgeInsets.all(8.0),
                        height: size.width * 0.625,
                        width: size.width,
                        color: Colors.grey,
                        child: Text("Document does not exist!!"));
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    PostModel post = PostModel.fromDoc(snapshot.data!);
                    return Stack(
                      children: [
                        Container(
                          height: size.width * 0.625,
                          width: size.width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0), color: Colors.grey,
                            image: DecorationImage(
                              onError: (object, stackTrace) {

                              },
                              image: NetworkImage(
                                  post.jobImgUrl
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8.0,
                          bottom: 0.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailGuideInfoPage(post: post)));
                            },
                            child: Text(
                              '자세히',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Container(
                      padding: EdgeInsets.all(8.0),
                      height: size.width * 0.625,
                      width: size.width,
                      child: Center(child: CircularProgressIndicator()));
                }
            ),
          ],
        ),
      ));
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
    return Consumer<MenteeProvider>(
      builder: (context, menteeProvider, child) {
        return FutureBuilder<DocumentSnapshot>(
            future: menteeProvider.getMentee(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                MenteeModel mentee = MenteeModel.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                if(mentee.programId.isNotEmpty) {
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
                          itemCount: mentee.programId.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 한 행에 보여줄 item 수
                              childAspectRatio: 1 / 1.6, // item의 가로, 세로 비율
                              mainAxisSpacing: 8.0, // 수직 Padding
                              crossAxisSpacing: 8.0 // 수평 Padding
                          ),
                          itemBuilder: (context, index) => FutureBuilder<DocumentSnapshot>(
                              future: postRef.doc(mentee.programId[index]).get(),
                              builder: (context, postSnapshot) {
                                if (postSnapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                if (postSnapshot.hasData && !postSnapshot.data!.exists) {
                                  return Text("Document does not exist!!");
                                }

                                if (postSnapshot.connectionState == ConnectionState.done) {
                                  PostModel post = PostModel.fromDoc(postSnapshot.data!);
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailGuideInfoPage(post: post,)));
                                    },
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: size.width * 0.5 * 0.625,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.0), color: Colors.grey,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                onError: (object, stackTrace) {

                                                },
                                                image: NetworkImage(
                                                  postSnapshot.data?.get('job_img_url') ?? '',
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(post.job, style: TextStyle(fontWeight: FontWeight.bold),),
                                                Text(post.userName, style: TextStyle(fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(post.introTitle, style: TextStyle(fontWeight: FontWeight.bold),),
                                                SizedBox(height: 12.0,),
                                                Text(post.intro, style: TextStyle(color: Colors.grey), maxLines: 2,overflow: TextOverflow.ellipsis,),
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return Text('Loading');
                              }
                          ),
                        ),
                      ],),
                  );
                } else {
                  return SizedBox();
                }

              }

              return Text("loading");

            }
        );
      },
    );
  }
}
