import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semomen/pages/chat/chat_page.dart';
import 'package:semomen/pages/home/home_page.dart';
import 'package:semomen/pages/profile/profile_page.dart';
import 'package:semomen/pages/search/search_page.dart';
import 'package:semomen/providers/mentee_provider.dart';

import 'package:semomen/providers/user_provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ChatPage(),
    ProfilePage(),
  ];
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => MenteeProvider(firebaseAuth: FirebaseAuth.instance)),
      ],
      child: Scaffold(
        body: IndexedStack(
            index: _selectedIndex,
            children: _pages),
        bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      ),
    );
  }
}
