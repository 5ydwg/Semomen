import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/model/post_model.dart';

class DetailGuideInfoPage extends StatefulWidget {
  final PostModel post;
  const DetailGuideInfoPage({Key? key, required this.post}) : super(key: key);

  @override
  _DetailGuideInfoPageState createState() => _DetailGuideInfoPageState();
}

class _DetailGuideInfoPageState extends State<DetailGuideInfoPage> {
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
          _jobIntroduction(size),
          Divider(
            height: 20.0,
          ),
          _mentorInformation(),
          Divider(
            height: 20.0,
          ),
          _review(size),
          Divider(
            height: 20.0,
          ),
          _capabilitiesGuide(size),
          Divider(
            height: 20.0,
          ),
          //_detailVideo(size),
          // Divider(
          //   height: 20.0,
          // ),
          //_recommendedBook(context, size),
          SizedBox(height: 100.0,),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainNavyBlue,
        onPressed: () {  },
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
        _detailVideo(size),
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
                        widget.post.introTitle,
                        style: TextStyle(fontWeight: FontWeight.bold),
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
      ],
    );
  }

  Widget _review(Size size) {
    return Column(
      children: [
        Text(
          '리뷰',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        Text(
          '⭐⭐⭐⭐⭐',
          style:
              TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.bold),
        ),
        Text(
          '5.0',
          style:
              TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.bold),
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
    );
  }


  Widget _mentorInformation() {
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
                CircleAvatar(
                  radius: 24.0,
                  backgroundColor: Colors.grey,
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
              ...widget.post.career.map((e) => Text('- ' + e, style: TextStyle(color: Colors.grey),)),
            ],
          ),
        )
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
            child: Text('추천 강의', style: TextStyle(fontWeight: FontWeight.bold),),
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
            child: Text('추천 전공', style: TextStyle(fontWeight: FontWeight.bold),),
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
            child: Text('추천 브이로그', style: TextStyle(fontWeight: FontWeight.bold),),
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
                        style: TextStyle(color: Colors.blue, overflow: TextOverflow.ellipsis),
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

  Container _detailVideo(Size size) {
    return Container(
      width: size.width,
      height: size.width * 0.625,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0), color: mainBabyBlue),
      child: Center(
        child: Icon(
          Icons.play_circle_outline,
          color: Colors.grey,
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
                        SizedBox(width: 8.0,),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Author',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12.0),),
                              SizedBox(height: 8.0,),
                              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
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
                        SizedBox(width: 8.0,),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Author',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12.0),),
                              SizedBox(height: 8.0,),
                              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
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
                        SizedBox(width: 8.0,),
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Author',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12.0),),
                              SizedBox(height: 8.0,),
                              Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
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
