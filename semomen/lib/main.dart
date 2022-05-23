import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:semomen/pages/root_page.dart';
import 'package:semomen/pages/auth/sign_in_page.dart';
import 'package:semomen/providers/review_provider.dart';
import 'package:semomen/providers/user_provider.dart';
import 'package:semomen/repositories/review_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await Firebase.initializeApp();

  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
  ); // firebase 앱 시작
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) =>
                  ReviewProvider(reviewRepository: ReviewRepository())),
        ],
        child: MaterialApp(
          title: 'Semomen',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // routes: {'/': (context) => RootPage()},
          home: user != null ? RootPage() : SignInPage(),
        ));
  }
}
