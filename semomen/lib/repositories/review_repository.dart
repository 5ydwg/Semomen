import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semomen/model/review_model.dart';

class ReviewRepository {

  // post의 리뷰들을 가져오는 함수
  Future<List<ReviewModel>> getReviews({required String postId}) async{
    try {
      final QuerySnapshot reviews = await FirebaseFirestore.instance.collection('posts').doc(postId).collection('reviews')
          .where('uid',
          isNotEqualTo:
          postId.substring(0, postId.length - 1)).get();

      return reviews.docs.map((e) => ReviewModel.fromDoc(e)).toList();
    } on FirebaseException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

}