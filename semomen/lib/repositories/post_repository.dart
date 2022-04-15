import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/post_model.dart';

class PostRepository {
  final FirebaseFirestore firebaseFirestore;
  PostRepository({
    required this.firebaseFirestore,
  });

  Future<PostModel> getPost({required String postId}) async {
    try {
      final DocumentSnapshot postDoc = await postRef.doc(postId).get();
      final PostModel post = PostModel.fromDoc(postDoc);

      return post;
    } on FirebaseException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<PostModel> getJobOfThisWeek() async {
    try {
      final DocumentSnapshot adminDoc = await adminRef.doc('zf1ISrDcXIkzxeDpv0Ua').get();
      String postId = adminDoc.get('recommended_job');
      final DocumentSnapshot postDoc = await postRef.doc(postId).get();

      final PostModel post = PostModel.fromDoc(postDoc);

      return post;
    } on FirebaseException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  /// 인기 가이드의 리스트를 반환하는 함수
  /// 현재는 모든 인기 가이드를 받아온다.(구현 당시 인기 가이드 개수 2개)
  /// 인기 가이드가 5개 이상일 때, 그 중 랜덤으로 5개만 받아올 수 있도록 수정할 것.
  Future<List<PostModel>> getPopularPosts() async {

    final DocumentSnapshot adminDoc = await adminRef.doc('zf1ISrDcXIkzxeDpv0Ua').get();
    List<dynamic> popularPostIds = adminDoc.get('popular_post');
    final QuerySnapshot result = await postRef.get();
    List<QueryDocumentSnapshot<Object?>> posts = result.docs.where((element) => popularPostIds.contains(element.id)).toList();

    List<PostModel> postList = posts.map((e) => PostModel.fromDoc(e)).toList();

    return postList;
  }

  Future<List<PostModel>> getNewGuides() async{
    final QuerySnapshot snapshot = await postRef.get();
    final List<QueryDocumentSnapshot<Object?>> posts = snapshot.docs;
    List<PostModel> result = [];
    posts.sort((a, b) => b.get('date_time').toString().compareTo(a.get('date_time').toString()));
    result = posts.map((e) => PostModel.fromDoc(e)).take(3).toList(); // 가장 최신의 post를 3개만 가져오기
    return result;
  }


}



