import 'package:flutter/foundation.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/post_model.dart';
import 'package:semomen/repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository postRepository;

  PostProvider({
    required this.postRepository,
  });

  Future<PostModel> getPost({required String postId}) async {
    final PostModel post = await postRepository.getPost(postId: postId);
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

  Future<List<PostModel>> getNewGuides() async {
    List<PostModel> newGuides = await postRepository.getNewGuides();
    return newGuides;
  }
}
