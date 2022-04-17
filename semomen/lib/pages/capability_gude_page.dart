import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/model/post_model.dart';

class CapabilityGuidePage extends StatefulWidget {
  final PostModel post;
  const CapabilityGuidePage({Key? key, required this.post}) : super(key: key);

  @override
  _CapabilityGuidePageState createState() => _CapabilityGuidePageState();
}

class _CapabilityGuidePageState extends State<CapabilityGuidePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //화면을 세로 방향으로 고정하기
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '역량 가이드',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          _capabilitiesGuide(size),
        ],
      ),
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

  // List<ExpansionPanelRadio> youTube(Size size) {
  //   final youTube = widget.post.youtube!.toList();
  //   return youTube.asMap().entries.map((entry) {
  //     int value = entry.key;
  //     dynamic content = entry.value;
  //     return _capabilitiesGuideItem(size, value, content);
  //   }).toList();
  // }

  Widget _capabilitiesGuide(Size size) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          widget.post.major.isNotEmpty ? Column(
            children: [
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
            ],
          ) : Container(),

          widget.post.vLog.isNotEmpty ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Divider(),
            ],
          ) : Container(),
          // widget.post.youtube!.isNotEmpty ? Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 8.0),
          //       child: Text(
          //         '추천 유튜브',
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     ExpansionPanelList.radio(
          //       expandedHeaderPadding: EdgeInsets.all(0.0),
          //       children: [
          //         ...youTube(size),
          //       ],
          //     ),
          //   ],
          // ) : Container(),

        ],
      ),
    );
  }

  ExpansionPanelRadio _capabilitiesGuideItem(
      Size size, int index, dynamic content) {
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
                        maxLines: 2,
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
                  Text(content['desc']),
                  SizedBox(height: 8.0,),
                  Text(content['url'], style: TextStyle(color: Colors.blue),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
