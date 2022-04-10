import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/model/review_model.dart';
import 'package:semomen/pages/create_review_page.dart';

class ReviewPage extends StatelessWidget {
  final List<ReviewModel> reviews; // post의 모든 review 정보
  ReviewPage({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //화면을 세로 방향으로 고정하기
    Size size = MediaQuery.of(context).size; //화면의 size 가져오기
    return Scaffold(
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
                  reviewSummary(size), // 리뷰 요약
                  Divider(
                    height: 40.0,
                  ),
                  _reviewList(), // 리뷰 리스트
                ],
              ),
            ),
            _createReviewButton(context, size), // 리뷰 작성 버튼
          ],
        ),
      ),
    );
  }

  double averageReviewScore(List<ReviewModel> reviews) {
    List<int> star = reviews.map((e) {
      int star = e.star;
      return star;
    }).toList();
    int sum = star.reduce((value, element) => value + element);
    double average = (sum / reviews.length).toDouble();

    return double.parse(average.toStringAsFixed(1));  // 소수점 1자리까지 출력
  }

  Widget _reviewStars(double averageScore) {
    return RatingBar.builder(
        initialRating: averageScore,
        allowHalfRating: true,
        itemCount: 5,
        ignoreGestures: true,
        itemSize: 24.0,
        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow[600]),
        onRatingUpdate: (rating) {
          debugPrint(rating.toString());
        });
  }

  Widget reviewSummary(Size size) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${averageReviewScore(reviews)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            SizedBox(
              width: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _reviewStars(averageReviewScore(reviews)),
                Text(
                  '${reviews.length}개의 평가',
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
        _reviewProgressIndicator(size, '5점', getScorePercent(5)),
        _reviewProgressIndicator(size, '4점', getScorePercent(4)),
        _reviewProgressIndicator(size, '3점', getScorePercent(3)),
        _reviewProgressIndicator(size, '2점', getScorePercent(2)),
        _reviewProgressIndicator(size, '1점', getScorePercent(1)),
      ],
    );
  }

  // 리뷰 평점 별 인원 수의 double값 반환하는 함수
  double getScorePercent(int score) {
    final int num = reviews.where((element) => element.star == score).length; // score 점수를 준 인원 수

    return num / reviews.length;  // score 점수를 준 인원 수 / 전체 리뷰의 수
  }

  Widget _reviewList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Text(
              '${reviews.length}개의 리뷰',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              ReviewModel review = reviews[index];
              DateFormat formatter = DateFormat('yyyy-MM-dd');
              String time = formatter.format(review.uploadTime);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundColor: Colors.grey,
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'user name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  // review['review'],
                                  review.review,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Row(
                                  //   children: [
                                  //     ...reviewStars(review)
                                  //         .map((e) => Icon(
                                  //               Icons.star,
                                  //               color: Colors.yellow[600],
                                  //               size: 14.0,
                                  //             ))
                                  //         .toList(),
                                  //   ],
                                  // ),
                                  Text(
                                    time,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget _createReviewButton(BuildContext context, Size size) {
    return Positioned(
        bottom: 30.0,
        child: SizedBox(
            width: size.width,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: mainNavyBlue,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateReviewPage()));
                },
                child: Text('작성하기'))));
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
}
