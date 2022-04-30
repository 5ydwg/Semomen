import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//package
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// youtube player
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

//webview
import 'package:flutter_html/flutter_html.dart';

//constant
import 'package:semomen/constants/constant.dart';
import 'package:semomen/constants/db_constants.dart';

//model
import 'package:semomen/model/post_model.dart';

//page
import 'package:semomen/pages/capability_gude_page.dart';
import 'package:semomen/pages/create_review_page.dart';
import 'package:semomen/pages/review_page.dart';

// provider
import 'package:semomen/providers/review_provider.dart';
import 'package:provider/provider.dart';
import 'package:semomen/providers/mentee_provider.dart';

class DetailGuideInfoPage extends StatefulWidget {
  final PostModel post;

  const DetailGuideInfoPage({Key? key, required this.post}) : super(key: key);

  @override
  _DetailGuideInfoPageState createState() => _DetailGuideInfoPageState();
}

class _DetailGuideInfoPageState extends State<DetailGuideInfoPage> {
  late YoutubePlayerController _youtubePlayerController;
  late String profileImageUrl;

  @override
  void initState() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId:
          YoutubePlayerController.convertUrlToId(widget.post.jobVideoUrl) ?? '',
      params: const YoutubePlayerParams(
        loop: false,
        color: 'transparent',
        strictRelatedVideos: true,
        showFullscreenButton: !kIsWeb,
      ),
    );
    profileImageUrl = widget.post.profileImg;
    updateRecentlyViewedPosts();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateRecentlyViewedPosts() async {
    final DocumentSnapshot ds =
        await menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    List<dynamic> recentlyViewedPostIds = ds.get('recently_viewed_posts');
    if (recentlyViewedPostIds.contains(widget.post.postId)) {
      menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'recently_viewed_posts': FieldValue.arrayRemove([widget.post.postId])
      });
      menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'recently_viewed_posts': FieldValue.arrayUnion([widget.post.postId])
      });
    } else {
      menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'recently_viewed_posts': FieldValue.arrayUnion([widget.post.postId])
      });
    }
  }

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
          '가이드',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
            child: Text(
              widget.post.introTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.post.userName} 멘토',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text(
                  '${widget.post.dateTime}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ],
            ),
          ),
          widget.post.jobVideoUrl.isNotEmpty ? _detailVideo(size) : SizedBox(),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 12.0, bottom: 24.0),
                        child: Text(
                          '멘토 한마디',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(widget.post.intro),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Divider(),
          ),
          _jobIntroduction(size),
          Divider(
            height: 20.0,
          ),
          // _capabilitiesGuide(size),
          _mentorInformation(size),
          Divider(
            height: 20.0,
          ),
          _reviews(size),
          Divider(
            height: 20.0,
          ),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),

      // 멘토링 시작 후 활성화
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: mainNavyBlue,
      //   onPressed: () {},
      //   child: Icon(Icons.chat_outlined),
      // ),
    );
  }

  Widget _jobIntroduction(Size size) {
    String desc = widget.post.jobDesc;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '직업 소개',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CapabilityGuidePage(
                        post: widget.post,
                      ),
                    ),
                  );
                },
                child: Text(
                  '역량 가이드 보기',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Html(
          data: desc,
        ), // use flutter_html: ^2.2.1
      ],
    );
  }

  double averageReviewScore(List<QueryDocumentSnapshot<Object?>> reviews) {
    List<int> star = reviews.map((e) {
      int star = e.get('star');
      return star;
    }).toList();
    int sum = star.reduce((value, element) => value + element);
    double average = (sum / reviews.length).toDouble();

    return double.parse(average.toStringAsFixed(1)); // 소수점 1자리까지 출력
  }

  Widget _reviews(Size size) {
    return FutureBuilder<void>(
        future: context
            .read<ReviewProvider>()
            .getReviews(postId: widget.post.postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return context.watch<ReviewProvider>().reviews.isEmpty
                ? Column(
                    children: [
                      Text('리뷰가 없습니다'),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: mainNavyBlue,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreateReviewPage(
                                    postId: widget.post.postId)));
                          },
                          child: Text('작성하기'))
                    ],
                  )
                : Consumer<ReviewProvider>(
                    builder: (context, reviewProvider, child) => Column(
                          children: [
                            Text(
                              '리뷰',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            _reviewStars(reviewProvider.getRating()),
                            Text(
                              '${reviewProvider.getRating()}',
                              style: TextStyle(
                                  color: Colors.yellow[600],
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${reviewProvider.reviews.length}개의 평가',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.3,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: mainBlueGreen),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => ReviewPage(
                                                  postId: widget.post.postId,
                                                )));
                                  },
                                  child: Text('더보기')),
                            ),
                          ],
                        ));
          }
          return CircularProgressIndicator();
        });
  }

  Widget _reviewStars(double averageScore) {
    return RatingBar.builder(
        initialRating: averageScore,
        allowHalfRating: true,
        itemCount: 5,
        ignoreGestures: true,
        itemSize: 24.0,
        itemBuilder: (context, _) =>
            Icon(Icons.star, color: Colors.yellow[600]),
        onRatingUpdate: (rating) {
          debugPrint(rating.toString());
        });
  }

  Widget _mentorInformation(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          '멘토',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        )),
        IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      widget.post.profileImg != ''
                          ? ClipOval(
                              child: Container(
                                width: size.width * 0.2,
                                height: size.width * 0.2,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.grey[200],
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    onError: (object, stackTrace) {},
                                    image: NetworkImage(
                                      widget.post.profileImg,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ClipOval(
                              child: Container(
                                width: size.width * 0.2,
                                height: size.width * 0.2,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.grey[200],
                                ),
                              ),
                            ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.post.userName),
                          Text(widget.post.job)
                        ],
                      ),
                      Spacer(),
                      _requestMentoringButton(context, size)
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '현재 멘토링은 준비중에 있습니다.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '이력',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...widget.post.career.map((e) => Text(
                    '- ' + e,
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  // 멘토링 요청 함수
  Widget _requestMentoringButton(BuildContext context, Size size) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return SizedBox(
      width: size.width * 0.24,
      child: StreamBuilder<DocumentSnapshot>(
        stream: menteeRef.doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading');
          }
          //mentor 컬렉션 내 mentee_uid에 필요한 데이터 객체 생성
          Map<String, dynamic>? myData = {};
          Map<String, dynamic>? mentorData = {
            'uid': widget.post.uid,
            'profile_img': widget.post.profileImg,
            'user_name': widget.post.userName,
          };
          //내 정보 받아오기
          FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              Map<String, dynamic>? userDoc =
                  documentSnapshot.data() as Map<String, dynamic>?;
              //mentor 컬렉션 내 mentee_uid에 필요한 데이터 객체 생성
              myData = {
                'birth': userDoc?['birth'],
                'desc': '',
                'email': userDoc?['email'],
                'job': userDoc?['job'],
                'mentee_name': userDoc?['user_name'],
                'profile_img': userDoc?['profile_img'],
                'uid': userDoc?['uid']
              };
            }
          });

          List<dynamic> menteeInMentor = [];
          // mentor 컬렉션의 mentee 받아오기
          FirebaseFirestore.instance
              .collection('mentors')
              .doc(widget.post.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              final List data = documentSnapshot.get('mentee');
              data.forEach((element) {
                //더미데이터 제거
                print(element);
                if (element['uid'] != null) {
                  menteeInMentor.add(element);
                }
              });
            }
          });

          List mentorList = [];
          //mentee 컬렉션의 mentor들 받아오기
          List<dynamic> mentor = snapshot.data!.get('mentor');
          mentor.forEach((element) {
            //더미데이터 제거
            if (element['uid'] != null) {
              mentorList.add(element);
            }
          });

          // mentee 컬렉션 내 mentor 필드에 mentor 있는지 확인하기

          List exist = mentor
              .where((element) => element['uid'] == mentorData['uid'])
              .toList();

          return exist.isEmpty == true
              //내가 현재 멘토를 멘토 선정 하지 않았을 때
              ? ElevatedButton(
                  onPressed: () {
                    // 이전 mentee컬렉션 내 지금 mentorData 추가할 데이터
                    List<dynamic> setMentor = [...mentorList, mentorData];

                    //mentee 컬렉션에 mentorData 추가
                    menteeRef.doc(uid).update({'mentor': setMentor}).then(
                        (value) => print('세팅완료!!'));

                    // 이전 mentor 컬렉션에 내 데이터  추가
                    List<dynamic> setMenteeInMentor = [
                      ...menteeInMentor,
                      myData,
                    ];

                    //mentor 컬렉션에 내 데이터 추가
                    FirebaseFirestore.instance
                        .collection('mentors')
                        .doc(widget.post.uid)
                        .update({'mentee': setMenteeInMentor}).then(
                            (value) => print('mentor 세팅 완료!'));
                  },
                  child: Text('단체방 \n 입장 '))

              // 내가 현재 멘토를 선정 하였을 때
              : ElevatedButton(
                  onPressed: () async {
                    // 이전 mentee 컬렉션에 mentor 빼기
                    List<dynamic> setMentor = [...mentorList];
                    setMentor
                        .removeWhere((item) => item['uid'] == widget.post.uid);

                    // 이후 mentee 컬렉션에 mentor 빼기
                    menteeRef.doc(uid).update({'mentor': setMentor}).then(
                        (value) => print('세팅완료!!'));

                    //mentor 컬렉션에 넣을 mentee 데이터 만들기
                    List<dynamic> setMenteeInMentor = [...menteeInMentor];
                    setMenteeInMentor.removeWhere((item) => item['uid'] == uid);

                    // 이후 mentor 컬렉션에 mentee uid 빼기
                    FirebaseFirestore.instance
                        .collection('mentors')
                        .doc(widget.post.uid)
                        .update({'mentee': setMenteeInMentor}).then(
                            (value) => print('mentor remove 세팅 완료!'));
                  },
                  child: Text('멘토링\n 취소'));
        },
      ),
    );
  }

  // use youtube_player_iframe 2.2.2
  Container _detailVideo(Size size) {
    return Container(
      width: size.width,
      height: size.width * 0.625,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0), color: Colors.grey[100]),
      child: YoutubePlayerControllerProvider(
        controller: _youtubePlayerController,
        child: YoutubePlayerIFrame(
          controller: _youtubePlayerController,
        ),
      ),
    );
  }
}
