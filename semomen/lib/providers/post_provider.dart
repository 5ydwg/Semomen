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
  Future<PostModel> getJobOfThisWeek() async {
    final PostModel post = await postRepository.getJobOfThisWeek();
    return post;
  }

  Future<List<PostModel>> getPopularPosts() async {
    List<PostModel> postList = await postRepository.getPopularPosts();

    return postList;
  }

}