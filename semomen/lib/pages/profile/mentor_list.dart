import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semomen/model/post_model.dart';
import 'package:semomen/pages/detail_guide_info_page.dart';
import '../../constants/db_constants.dart';

class MentorList extends StatefulWidget {
  const MentorList({Key? key}) : super(key: key);

  @override
  State<MentorList> createState() => _MentorListState();
}

class _MentorListState extends State<MentorList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: menteeRef.doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          List data = snapshot.data!.get('mentor');
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text(
                '멘토 리스트',
                style: TextStyle(color: Colors.black),
              ),
              leading: IconButton(
                icon: Icon(Icons.chevron_left),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: ListView.separated(
                  itemBuilder: (context, index) =>
                      data[index]['uid'] != 'undefined'
                          ? MentorTile(data: data[index])
                          : SizedBox(),
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: data.length),
            ),
          );
        }
      },
    );
  }
}

class MentorTile extends StatelessWidget {
  const MentorTile({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            goPost(data['uid'], context);
          },
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(
                data['profile_img'] == null ? '' : data['profile_img']),
            backgroundColor: Colors.transparent,
          ),
          title: Text(
            data['user_name'],
          ),
        ),
      ],
    );
  }
}

void goPost(mentorUid, context) async {
  print(mentorUid);
  await FirebaseFirestore.instance
      .collection('posts')
      .doc(mentorUid + 'p')
      .get()
      .then(
    (DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        PostModel postDoc = PostModel.fromDoc(documentSnapshot);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailGuideInfoPage(post: postDoc)));
      }
    },
  );
}
