import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/model/user_model.dart';
import 'package:semomen/pages/my_coupon_page.dart';
import 'package:semomen/pages/profile/profile_page_update.dart';
import 'package:semomen/pages/ticket_page.dart';
import 'package:semomen/providers/user_provider.dart';
import 'package:semomen/pages/profile/mentor_list.dart';
import '../service_center_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return StreamBuilder<DocumentSnapshot>(
            stream: userProvider.getCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                UserModel _user = UserModel.fromDoc(snapshot.data!);
                return Scaffold(
                  body: SafeArea(
                    child: Column(
                      children: [
                        _profileBox(size, _user),
                        _puchasedBox(),
                        _couponBox(),
                        _mentorBox(),
                        _settingsBox(),
                        Spacer(),
                        _signOutBox(),
                      ],
                    ),
                  ),
                );
              }
            });
      },
    );
  }

  Widget _profileBox(Size size, UserModel user) {
    return SizedBox(
      height: size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
              child: Image.network(
            user.profileImg != ''
                ? user.profileImg
                : 'https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_1280.png',
            fit: BoxFit.cover,
            width: size.width * 0.2,
            height: size.width * 0.2,
            errorBuilder: (context, error, stackTrace) => Container(
              height: size.width * 0.2,
              width: size.width * 0.2,
              color: mainBabyBlue,
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              user.userName,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff05445e)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePageUpdate()),
                );
              },
              child: Text('프로필 수정')),
        ],
      ),
    );
  }

  Widget _couponBox() {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCouponPage()),
          );
        },
        leading: Text('쿠폰함'),
        dense: true,
      ),
    );
  }

  Widget _puchasedBox() {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TicketPage()),
          );
        },
        leading: Text('이용권 구매'),
        dense: true,
      ),
    );
  }

  Widget _settingsBox() {
    return Card(
      child: Column(
        children: [
          Divider(
            height: 0.0,
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceCenterPage()),
              );
            },
            leading: Text('고객센터'),
            dense: true,
          ),
          Divider(
            height: 0.0,
          ),
        ],
      ),
    );
  }

  Widget _mentorBox() {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MentorList()),
          );
        },
        leading: Text('내 멘토 리스트'),
        dense: true,
      ),
    );
  }

  Widget _signOutBox() {
    return Card(
      child: ListTile(
        onTap: () {
          String currentUid = FirebaseAuth.instance.currentUser!.uid;
          final userStatusDatabaseRef =
              FirebaseDatabase.instance.ref("status/" + currentUid);

          userStatusDatabaseRef.set({'state': 'offline'});
          FirebaseAuth.instance.signOut();
        },
        leading: Text(
          '로그아웃',
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        dense: true,
      ),
    );
  }
}
