import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/pages/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Container(
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [mainBlueGreen, mainBlueGrotto],
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '&.ssul',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(
                        '진로 고민\n해결 가이드',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 10.0,
                  color: Colors.grey[200],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          '이메일',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                cursorColor: Colors.grey,
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(
                                  hintText: '이메일을 입력하세요.',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (String text) {},
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          '비밀번호',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                cursorColor: Colors.grey,
                                obscureText: isObscure,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(
                                  hintText: '비밀번호를 입력하세요.',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.text,
                                onChanged: (String text) {},
                              ),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                                child: isObscure
                                    ? Icon(
                                        Icons.visibility_off_outlined,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        Icons.remove_red_eye_outlined,
                                        color: Colors.grey,
                                      )),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '비밀번호를 잊어버리셨나요?',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' 비밀번호 재설정',
                              style: TextStyle(
                                  color: mainBlueGrotto,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          width: size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                emailSignIn(
                                    _emailController, _passwordController);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: mainNavyBlue),
                              child: Text('로그인')),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 16.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '계정이 없으신가요?',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SignUpPage()));
                                },
                                child: Text(
                                  ' 계정 생성하기',
                                  style: TextStyle(
                                      color: mainBlueGrotto,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void emailSignIn(TextEditingController _emailController,
      TextEditingController _passwordController) async {
    // 이메일 & 패스워드 로그인을 위한 정해진 폼.
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
