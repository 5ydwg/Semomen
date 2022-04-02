import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semomen/pages/constants/constant.dart';
import 'package:semomen/pages/create_review_page.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({Key? key}) : super(key: key);

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
                  reviewSummary(size),  // 리뷰 요약
                  Divider(height: 40.0,),
                  _reviewList(),  // 리뷰 리스트
                ],
              ),
            ),
            _createReviewButton(context, size),  // 리뷰 작성 버튼
          ],
        ),
      ),
    );
  }

  Widget reviewSummary(Size size) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '5.0',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            SizedBox(
              width: 8.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow[600],
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[600],
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[600],
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[600],
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[600],
                    ),
                  ],
                ),
                Text(
                  '153개의 평가',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 8.0,),
        _reviewProgressIndicator(size, '5점', 1),
        _reviewProgressIndicator(size, '4점', 0),
        _reviewProgressIndicator(size, '3점', 0),
        _reviewProgressIndicator(size, '2점', 0),
        _reviewProgressIndicator(size, '1점', 0),
      ],
    );
  }

  Widget _reviewList() {
    return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          '100개의 리뷰',
                          style:
                          TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) => Card(
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
                                  SizedBox(width: 8.0,),
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('user name', style: TextStyle(fontWeight: FontWeight.bold),),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Text(
                                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[600],
                                                  size: 14.0,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[600], size: 14.0,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[600],
                                                  size: 14.0,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[600],
                                                  size: 14.0,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow[600],
                                                  size: 14.0,
                                                ),
                                              ],
                                            ),
                                            Text('2022.03.09', style: TextStyle(color: Colors.grey, fontSize: 12.0),)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ],
                );
  }

  Widget _createReviewButton(BuildContext context,Size size) {
    return Positioned(
              bottom: 30.0,
              child: SizedBox(
                  width: size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: mainNavyBlue,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateReviewPage()));
                      }, child: Text('작성하기'))));
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
