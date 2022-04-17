import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/post_model.dart';
import 'package:semomen/pages/capability_gude_page.dart';
import 'package:semomen/pages/review_page.dart';
import 'package:semomen/providers/review_provider.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:flutter_html/flutter_html.dart';

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
    final DocumentSnapshot ds = await menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).get();
    List<dynamic> recentlyViewedPostIds = ds.get('recently_viewed_posts');
    if(recentlyViewedPostIds.contains(widget.post.postId)) {
      menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).update({'recently_viewed_posts': FieldValue.arrayRemove([widget.post.postId])});
      menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).update({'recently_viewed_posts': FieldValue.arrayUnion([widget.post.postId])});
    } else {
      menteeRef.doc(FirebaseAuth.instance.currentUser!.uid).update({'recently_viewed_posts': FieldValue.arrayUnion([widget.post.postId])});
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
                  '2022년 4월 11일',
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
                        padding: const EdgeInsets.only(left: 8.0,right: 8.0,top:12.0,bottom: 24.0),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainNavyBlue,
        onPressed: () {
        },
        child: Icon(Icons.chat_outlined),
      ),
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CapabilityGuidePage(post: widget.post,)));
                },
                child: Text(
                  '역량 가이드 보기',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
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
        future: context.read<ReviewProvider>().getReviews(postId: widget.post.postId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return context.watch<ReviewProvider>().reviews.isEmpty ? Column(children: [
              Text('리뷰가 없습니다'),

            ],)
                : Consumer<ReviewProvider>(
                builder: (context, reviewProvider, child) => Column(
                  children: [
                    Text(
                      '리뷰',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    _reviewStars(reviewProvider.getRating()),
                    Text(
                      '${reviewProvider.getRating()}',
                      style: TextStyle(
                          color: Colors.yellow[600], fontWeight: FontWeight.bold),
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
                          style: ElevatedButton.styleFrom(primary: mainBlueGreen),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
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
        }
    );
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
            child: Row(
              children: [
                widget.post.profileImg != '' ? ClipOval(
                  child: Container(
                    width: size.width * 0.2,
                    height: size.width * 0.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey[200],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        onError: (object, stackTrace) {

                        },
                        image: NetworkImage(
                          widget.post.profileImg,
                        ),
                      ),
                    ),
                  ),
                ) : ClipOval(
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
                SizedBox(
                  width: 12.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [Text(widget.post.userName), Text(widget.post.job)],
                ),
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
