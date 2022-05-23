import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:semomen/providers/review_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/constant.dart';

class CreateReviewPage extends StatefulWidget {
  final String postId;
  const CreateReviewPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CreateReviewPageState createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  TextEditingController _reviewTextController = TextEditingController();
  double reviewRating = 5.0;
  @override
  void dispose() {
    _reviewTextController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); //화면을 세로 방향으로 고정하기
    Size size = MediaQuery.of(context).size; //화면의 size 가져오기
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '리뷰 작성',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            ListView(
              children: [
                Text('가이드 만족도', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36.0),
                  child: Center(
                    child: RatingBar.builder(
                      initialRating: 5,
                      itemCount: 5,
                        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.yellow[600], size: 36.0,),
                        onRatingUpdate: (rating) {
                          reviewRating = rating;
                        }),
                  ),
                ),
                Text('가이드 리뷰', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: TextField(
                    maxLines: 10,
                    controller: _reviewTextController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: '가이드에 대한 솔직한 리뷰를 남겨주세요.',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
                      filled: true,
                      fillColor: Color(0xfff6f6fd),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onChanged: (String text) {
                      debugPrint(text);
                    },
                    onSubmitted: (String text) {
                      debugPrint("on submitted: "+text);
                    },

                  ),
                ),
              ],
            ),
            _completeButton(size),
          ],
        ),
      ),
    );
  }

  Widget _completeButton(Size size) {
    return Positioned(
        bottom: 30.0,
        child: SizedBox(
            width: size.width - 24.0,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: mainNavyBlue,
                ),
                onPressed: () {
                  debugPrint(reviewRating.toString());
                  debugPrint(_reviewTextController.text);
                  context.read<ReviewProvider>().addReview(text: _reviewTextController.text, rating: reviewRating, postId: widget.postId).then((_) {
                    Navigator.pop(context);
                  });
                }, child: Text('완료'))));
  }

}
