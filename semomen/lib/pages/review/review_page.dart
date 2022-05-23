import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/review_model.dart';
import 'package:semomen/pages/review/create_review_page.dart';
import 'package:semomen/providers/review_provider.dart';

class ReviewPage extends StatelessWidget {
  final String postId; // post의 모든 review 정보
  ReviewPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //화면을 세로 방향으로 고정하기
    Size size = MediaQuery.of(context).size; //화면의 size 가져오기
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            '리뷰',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 48.0),
                child: ListView(
                  children: [
                    reviewSummary(size, reviewProvider), // 리뷰 요약
                    Divider(
                      height: 40.0,
                    ),
                    _reviewList(reviewProvider, size, postId), // 리뷰 리스트
                  ],
                ),
              ),
              _createReviewButton(context, size), // 리뷰 작성 버튼
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewSummary(Size size, ReviewProvider reviewProvider) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${reviewProvider.getRating()}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            SizedBox(
              width: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _reviewStars(reviewProvider.getRating(), 24.0),
                Text(
                  '${reviewProvider.reviews.length}개의 평가',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        _reviewProgressIndicator(size, '5점', reviewProvider.getScorePercent(5)),
        _reviewProgressIndicator(size, '4점', reviewProvider.getScorePercent(4)),
        _reviewProgressIndicator(size, '3점', reviewProvider.getScorePercent(3)),
        _reviewProgressIndicator(size, '2점', reviewProvider.getScorePercent(2)),
        _reviewProgressIndicator(size, '2점', reviewProvider.getScorePercent(1)),
      ],
    );
  }

  Widget _reviewStars(double averageScore, double iconSize) {
    return RatingBar.builder(
        initialRating: averageScore,
        allowHalfRating: true,
        itemCount: 5,
        ignoreGestures: true,
        itemSize: iconSize,
        itemBuilder: (context, _) =>
            Icon(Icons.star, color: Colors.yellow[600]),
        onRatingUpdate: (rating) {
          debugPrint(rating.toString());
        });
  }

  Widget _reviewProgressIndicator(Size size, String score, double value) {
    return Row(
      children: [
        SizedBox(
            width: size.width * 0.1,
            child: Center(
                child: Text(
              score,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey.withOpacity(0.2),
              value: value,
              minHeight: 10,
              valueColor: AlwaysStoppedAnimation<Color>(
                mainBlueGrotto,
              ),
            ),
          ),
        ),
        SizedBox(
            width: size.width * 0.15,
            child: Center(
                child: Text(
              '${(value * 100).toInt()}%',
              style: TextStyle(fontWeight: FontWeight.bold),
            ))),
      ],
    );
  }

  Widget _reviewList(ReviewProvider reviewProvider, Size size, String postId) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              reviewProvider.reviews.length.toString() + '개의 리뷰',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: reviewProvider.reviews.length,
            itemBuilder: (context, index) {
              ReviewModel review = reviewProvider.reviews[index];
              DateFormat formatter = DateFormat('yyyy-MM-dd');
              String time = formatter.format(review.uploadTime);
              return !review.report.contains(uid)
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Container(
                                  width: size.width * 0.1,
                                  height: size.width * 0.1,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: Colors.grey,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      onError: (object, stackTrace) {},
                                      image: NetworkImage(
                                        review.profileImg,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        review.review,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _reviewStars(
                                            review.star.toDouble(), 14.0),
                                        Text(
                                          time,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12.0),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              review.uid != uid
                                  ? GestureDetector(
                                      onTap: () {
                                        _showReportDialog(
                                            context, postId, review);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        child: Text('🚨'),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Card(
                      child: Container(
                        width: size.width * 0.1,
                        height: size.height * 0.1,
                        child: Center(
                            child: Text(
                          '신고 된 리뷰입니다.',
                          style: TextStyle(color: Colors.grey[400]),
                        )),
                      ),
                    );
            }),
      ],
    );
  }

  Widget _createReviewButton(BuildContext context, Size size) {
    return FutureBuilder<bool>(
        future: context.read<ReviewProvider>().existMyReview(postId: postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!) {
              return Positioned(
                  bottom: 30.0,
                  child: SizedBox(
                      width: size.width - 24.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: mainNavyBlue,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateReviewPage(postId: postId)));
                          },
                          child: Text('수정하기'))));
            } else {
              return Positioned(
                  bottom: 30.0,
                  child: SizedBox(
                      width: size.width - 24.0,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: mainNavyBlue,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreateReviewPage(postId: postId)));
                          },
                          child: Text('작성하기'))));
            }
          }
          return Text('loading');
        });
  }

  Future<String?> _showReportDialog(
      BuildContext context, String postId, ReviewModel review) {
    TextEditingController _reportReasonController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('신고'),
          content: Container(
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(review.userName + ' 님을 신고하시겠습니까.'),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: TextField(
                    controller: _reportReasonController,
                    decoration: InputDecoration(hintText: '신고 사유를 입력해 주세요'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                clickReport(postId, review);
                Navigator.pop(context);
              },
              child: const Text('신고'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void clickReport(postId, review) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    List report = [];
    if (review.report != null) {
      report = [...review.report, uid];
    } else {
      report = [uid];
    }

    await postRef
        .doc(postId)
        .collection('reviews')
        .doc(review.uid + 'r')
        .update({'report': report});
  }
}
