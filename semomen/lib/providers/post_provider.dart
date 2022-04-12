import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:semomen/model/post_model.dart';
import 'package:semomen/repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository postRepository;



  PostProvider({
    required this.postRepository,
  });

  Future<PostModel> getPost({required String uid}) async {
    final PostModel post = await postRepository.getPost(uid: uid);
    return post;
  }

  Future<DocumentSnapshot> getPopularPost() async {
    final DocumentSnapshot postDoc = await postRepository.getPopularPost();
    return postDoc;
  }

  Future<PostModel> getJobOfThisWeek() async {
    final PostModel post = await postRepository.getJobOfThisWeek();
    return post;
  }

  Future<void> getPopularTest() async {
    List<DocumentSnapshot> postList = await postRepository.popularTest();

    print('어쩌고저쩌고');

  }

}