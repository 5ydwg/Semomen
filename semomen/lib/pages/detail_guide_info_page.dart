import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/model/post_model.dart';
import 'package:semomen/model/review_model.dart';
import 'package:semomen/pages/review_page.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailGuideInfoPage extends StatefulWidget {
  final PostModel post;

  const DetailGuideInfoPage({Key? key, required this.post}) : super(key: key);

  @override
  _DetailGuideInfoPageState createState() => _DetailGuideInfoPageState();
}

class _DetailGuideInfoPageState extends State<DetailGuideInfoPage> {
  late YoutubePlayerController _youtubePlayerController;

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
    super.initState();
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
          widget.post.jobVideoUrl.isNotEmpty ? _detailVideo(size) : SizedBox(),
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '멘토 한마디',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(widget.post.intro),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _jobIntroduction(size),
          Divider(
            height: 20.0,
          ),
          _capabilitiesGuide(size),
          Divider(
            height: 20.0,
          ),
          _mentorInformation(size),
          Divider(
            height: 20.0,
          ),
          _review(size),
          Divider(
            height: 20.0,
          ),
          //_detailVideo(size),
          // Divider(
          //   height: 20.0,
          // ),
          //_recommendedBook(context, size),
          SizedBox(
            height: 100.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainNavyBlue,
        onPressed: () {},
        child: Icon(Icons.chat_outlined),
      ),
    );
  }

  Widget _jobIntroduction(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '직업 소개',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        Container(
          height: 500.0,
          color: mainBabyBlue,
          alignment: Alignment.center,
          child: Text('blog'),
        ),
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

    return double.parse(average.toStringAsFixed(1));  // 소수점 1자리까지 출력
  }


  Widget _review(Size size) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post.uid)
            .collection('reviews')
            .where('uid',
                isNotEqualTo:
                    widget.post.uid.substring(0, widget.post.uid.length - 1))
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.hasData && !snapshot.data!.docs.isNotEmpty) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            final reviews = snapshot.data!.docs;  // 해당 포스트의 모든 리뷰(포스트 작성자는 제외)
            final double averageScore = averageReviewScore(reviews);
            
            List<ReviewModel> postReviews =
                reviews.map((e) => ReviewModel.fromDoc(e) ).toList();
            return Column(
              children: [
                Text(
                  '리뷰',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                _reviewStars(averageScore),
                Text(
                  '${averageScore}',
                  style: TextStyle(
                      color: Colors.yellow[600], fontWeight: FontWeight.bold),
                ),
                Text(
                  '${reviews.length}개의 평가',
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
                                  reviews: postReviews,
                                )));
                      },
                      child: Text('더보기')),
                ),
              ],
            );
          }

          return Text("loading");
        });
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
                ClipOval(
                  child: Container(
                    width: size.width * 0.2,
                    height: size.width * 0.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.grey,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        onError: (object, stackTrace) {},
                        image: NetworkImage(
                          widget.post.profileImg,
                        ),
                      ),
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

  List<ExpansionPanelRadio> lecture(Size size) {
    final lecture = widget.post.lecture.toList();
    return lecture.asMap().entries.map((entry) {
      int value = entry.key;
      dynamic content = entry.value;
      return _capabilitiesGuideItem(size, value, content);
    }).toList();
  }

  List<ExpansionPanelRadio> major(Size size) {
    final major = widget.post.major.toList();
    return major.asMap().entries.map((entry) {
      int value = entry.key;
      dynamic content = entry.value;
      return _capabilitiesGuideItem(size, value, content);
    }).toList();
  }

  List<ExpansionPanelRadio> vLog(Size size) {
    final vLog = widget.post.vLog.toList();
    return vLog.asMap().entries.map((entry) {
      int value = entry.key;
      dynamic content = entry.value;
      return _capabilitiesGuideItem(size, value, content);
    }).toList();
  }

  Widget _capabilitiesGuide(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '역량 가이드',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '추천 강의',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.all(0.0),
            children: [
              ...lecture(size),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '추천 전공',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.all(0.0),
            children: [
              ...major(size),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '추천 브이로그',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.all(0.0),
            children: [
              ...vLog(size),
            ],
          ),
        ],
      ),
    );
  }

  ExpansionPanelRadio _capabilitiesGuideItem(Size size, int index, dynamic content) {
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
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        content['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        content['desc'],
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      child: Text(
                        content['url'],
                        style: TextStyle(
                            color: Colors.blue,
                            overflow: TextOverflow.ellipsis),
                      ),
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

  Column _recommendedBook(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '추천 도서',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        ExpansionPanelList.radio(
          expandedHeaderPadding: EdgeInsets.all(0.0),
          elevation: 0.0,
          dividerColor: Theme.of(context).scaffoldBackgroundColor,
          children: [
            ExpansionPanelRadio(
              value: 0,
              canTapOnHeader: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerBuilder: (context, isExpanded) {
                return IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2 * 1.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: mainBlueGreen),
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
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Author',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 12.0),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                                "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
            ),
            ExpansionPanelRadio(
              value: 1,
              canTapOnHeader: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerBuilder: (context, isExpanded) {
                return IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2 * 1.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: mainBlueGreen),
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
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Author',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 12.0),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                                "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
            ),
            ExpansionPanelRadio(
              value: 2,
              canTapOnHeader: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              headerBuilder: (context, isExpanded) {
                return IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2 * 1.4,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              color: mainBlueGreen),
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
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Author',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 12.0),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                                "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
            ),
          ],
        ),
      ],
    );
  }
}
