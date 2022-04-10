import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/post_model.dart';

class PostRepository {
  final FirebaseFirestore firebaseFirestore;
  PostRepository({
    required this.firebaseFirestore,
  });

  Future<PostModel> getPost({required String uid}) async {
    try {
      final DocumentSnapshot postDoc = await postRef.doc(uid).get();
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

  Future<DocumentSnapshot> getPopularGuide() async {
    try {
      final DocumentSnapshot adminDoc = await adminRef.doc('zf1ISrDcXIkzxeDpv0Ua').get();
      String postId = adminDoc.get('popular_guide');
      final DocumentSnapshot postDoc = await postRef.doc(postId).get();

      return postDoc;
    } on FirebaseException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }


}



