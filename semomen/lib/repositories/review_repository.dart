import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/review_model.dart';

class ReviewRepository {
  // post의 리뷰들을 가져오는 함수
  Future<List<ReviewModel>> getReviews({required String postId}) async {
    if (await existReviewCollection(postId: postId) == 0) {
      // postId의 post document에 review 컬렉션에 존재하지 않는 경우
      return [];
    } else {
      // review 컬렉션이 존재하는 경우
      try {
        final QuerySnapshot reviews = await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('reviews')
            .where(
              'uid',
              isNotEqualTo: postId.substring(0, postId.length - 1),
            )
            .get();
        return reviews.docs.map((e) => ReviewModel.fromDoc(e)).toList();
      } on FirebaseException catch (e) {
        throw e;
      } catch (e) {
        throw e;
      }
    }
  }

  Future<int> existReviewCollection({required String postId}) async {
    final test = await postRef
        .doc(postId)
        .collection('reviews')
        .limit(1)
        .get()
        .then((value) => value);

    return test.size;
  }
}
