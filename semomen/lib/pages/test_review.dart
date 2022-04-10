import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/review_model.dart';

import '../providers/review_provider.dart';

class TestReview extends StatefulWidget {
  final String postId;
  const TestReview({Key? key, required this.postId}) : super(key: key);

  @override
  State<TestReview> createState() => _TestReviewState();
}


class _TestReviewState extends State<TestReview> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('aaa'),
            // Consumer<ReviewProvider>(
            //     builder: (context, reviewProvider, child) => FutureBuilder<List<ReviewModel>>(
            //         //future: reviewProvider.getPostReviews(postId: widget.postId),
            //       future: null,
            //         builder: (context, snapshot) {
            //           if (snapshot.hasError) {
            //             return Text("Something went wrong");
            //           }
            //           if (snapshot.hasData && !snapshot.data!.isNotEmpty) {
            //             return Text("Document does not exist");
            //           }
            //           if (snapshot.connectionState == ConnectionState.done) {
            //             return Column(
            //               children: [
            //                 Text(snapshot.data!.length.toString()),
            //                 ElevatedButton(onPressed: () {
            //                   postRef.doc(widget.postId).collection('reviews').add(
            //                       {
            //                         'review': 'eeee',
            //                         'uid': 'easd',
            //                         'star': 5,
            //                         'upload_time':DateTime.now(),
            //                       }
            //                       );
            //                 }, child: Text('go')),
            //                 Divider(),
            //                 Text(context.watch<ReviewProvider>().test.length.toString()),
            //                 ElevatedButton(onPressed: () {
            //                   postRef.doc(widget.postId).collection('reviews').add(
            //                       {
            //                         'review': 'eeee',
            //                         'uid': 'easd',
            //                         'star': 5,
            //                         'upload_time':DateTime.now(),
            //                       }
            //                   );
            //                   context.read<ReviewProvider>().testMethod(postId: widget.postId);
            //                 }, child: Text('go')),
            //                 Divider(),
            //                 Text(reviewProvider.test.length.toString()),
            //                 ElevatedButton(onPressed: () {
            //                   postRef.doc(widget.postId).collection('reviews').add(
            //                       {
            //                         'review': 'eeee',
            //                         'uid': 'easd',
            //                         'star': 5,
            //                         'upload_time':DateTime.now(),
            //                       }
            //                   );
            //                   context.read<ReviewProvider>().testMethod(postId: widget.postId);
            //                 }, child: Text('go')),
            //
            //
            //               ],
            //             );
            //           }
            //           return Text('loading');
            //
            //         }
            //     ))
          ],
        ),
      ),
    );
  }
}
