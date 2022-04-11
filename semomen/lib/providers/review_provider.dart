import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/review_model.dart';
import 'package:semomen/repositories/review_repository.dart';

class ReviewProvider extends ChangeNotifier {
  final ReviewRepository reviewRepository;
  List<ReviewModel> _reviews = [];
  List<ReviewModel> get reviews => _reviews;


  ReviewProvider({
    required this.reviewRepository,
  });

  // post id를 통해 헤당 post의 모든 review를 받아오는 함수
  Future<void> getReviews({required String postId}) async {
    _reviews = await reviewRepository.getReviews(postId: postId);

    notifyListeners();
  }

  // 리뷰의 평점을 소수점 첫 번째까지 반환하는 함수 ex)4.5
  double getRating() {
    List<int> star = _reviews.map((e) {
      int star = e.star;
      return star;
    }).toList();
    int sum = star.reduce((value, element) => value + element);
    double average = (sum / _reviews.length).toDouble();

    return double.parse(average.toStringAsFixed(1));
  }

// 리뷰 평점 별 퍼센트를 반환하는 함수
  double getScorePercent(int score) {
    final int num = _reviews.where((element) => element.star == score).length; // score 점수를 준 인원 수

    return num / _reviews.length;  // score 점수를 준 인원 수 / 전체 리뷰의 수
  }

  Future<void> addReview({required String text, required double rating, required String postId}) async {
    Map<String, dynamic> test = ReviewModel(
        review: text,
        star: rating.toInt(),
        uid: FirebaseAuth.instance.currentUser!.uid,
        uploadTime: DateTime.now()).toJson();

    postRef.doc(postId).collection('reviews').add(test);
    _reviews = await reviewRepository.getReviews(postId: postId);

    notifyListeners();
  }


}