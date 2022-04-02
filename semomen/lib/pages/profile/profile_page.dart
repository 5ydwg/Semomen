import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semomen/pages/my_coupon_page.dart';
import 'package:semomen/pages/purchased_guide_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _profileBox(size),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Text('구매 가이드'),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PurchasedGuidePage()),
                        );
                      },
                      icon: Icon(Icons.chevron_right),
                    ),
                    dense: true,
                  ),
                  Divider(
                    height: 0.0,
                  ),
                  ListTile(
                    leading: Text('쿠폰함'),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCouponPage()),
                        );
                      },
                      icon: Icon(Icons.chevron_right),
                    ),
                    dense: true,
                  ),
                ],
              ),
            ),
            _settingsBox(),
            Spacer(),
            _signOutBox(),
          ],
        ),
      ),
    );
  }

  Widget _signOutBox() {
    return Card(
      child: ListTile(
        leading: Text(
          '로그아웃',
          style:
              TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          icon: Icon(Icons.chevron_right),
        ),
        dense: true,
      ),
    );
  }

  Widget _settingsBox() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Text('계정 관리'),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
            dense: true,
          ),
          Divider(
            height: 0.0,
          ),
          ListTile(
            leading: Text('고객 센터'),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
            dense: true,
          ),
          Divider(
            height: 0.0,
          ),
          ListTile(
            leading: Text('환경 설정'),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.chevron_right),
            ),
            dense: true,
          ),
        ],
      ),
    );
  }

  Widget _profileBox(Size size) {
    return SizedBox(
      height: size.height * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: size.width * 0.1,
            backgroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2018/04/27/03/50/portrait-3353699_1280.jpg"),
            backgroundColor: Colors.transparent,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'name',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff05445e)),
              onPressed: () {},
              child: Text('프로필 수정')),
        ],
      ),
    );
  }
}
