// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/constants/db_constants.dart';
import 'package:semomen/model/mentee_model.dart';
import 'package:semomen/model/user_model.dart';

import '../../providers/user_provider.dart';

class ProfilePageUpdate extends StatefulWidget {
  ProfilePageUpdate({Key? key}) : super(key: key);

  @override
  State<ProfilePageUpdate> createState() => _ProfilePageUpdateState();
}

class _ProfilePageUpdateState extends State<ProfilePageUpdate> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference mentees =
      FirebaseFirestore.instance.collection('mentees');
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdConfirmController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _birthController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool isLoading = false; // 계정 생성 과정을 나타내는 변수

  File? image;
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _pwdConfirmController.dispose();
    _userNameController.dispose();
    _birthController.dispose();
    _jobController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<DocumentSnapshot>(
      stream: userRef.doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          UserModel _user = UserModel.fromDoc(snapshot.data!);
          return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  '프로필 수정',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Stack(
                        children: [
                          ListView(
                            children: [
                              _profileBox(size, _user),
                              Divider(),
                              _emailInput(_user),
                              Divider(),
                              _pwdInput(_user),
                              Divider(),
                              _pwdConfirmInput(_user),
                              Divider(),
                              _userNameInput(_user),
                              Divider(),
                              _dateOfBirthInput(context, _user),
                              Divider(),
                              _jobInput(_user),
                              Divider(),
                              _phoneNumberInput(_user),
                              SizedBox(
                                height: 70.0,
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0.0,
                            child: SizedBox(
                              width: size.width - 24.0,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: mainNavyBlue),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    _requestMentoringButton(
                                        context, size, _user); // 포커스 해제
                                  },
                                  child: Text('수정하기')),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                      visible: isLoading,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(child: CircularProgressIndicator()),
                      )),
                ],
              ));
        }
      },
    );
  }

  Widget _phoneNumberInput(_user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '휴대폰 번호',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        TextField(
          controller: _phoneNumberController,
          cursorColor: Colors.black,
          maxLength: 11,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone_android_outlined,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              splashRadius: 1.0,
              onPressed: () {
                _phoneNumberController.clear();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
            hintText: '숫자만 입력해주세요',
            filled: true,
            fillColor: Color(0xfff6f6fd),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (String text) {},
          onSubmitted: (String text) {},
        ),
      ],
    );
  }

  Widget _dateOfBirthInput(BuildContext context, _user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '생년월일',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        GestureDetector(
          onTap: () {
            showPickerDate(context, _user);
          },
          child: TextField(
            controller: _birthController,
            enabled: false,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: '생년월일을 선택해주세요.',
              filled: true,
              fillColor: Color(0xfff6f6fd),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            onChanged: (String text) {},
            onSubmitted: (String text) {},
          ),
        ),
      ],
    );
  }

  // use flutter_picker: ^2.0.3
  void showPickerDate(BuildContext context, _user) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: Text("생년월일"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancelText: '취소',
        confirmText: '확인',
        onConfirm: (Picker picker, List value) {
          DateTime? _selectDate =
              (picker.adapter as DateTimePickerAdapter).value;
          String _year;
          String _month;
          String _date;
          if (_selectDate != null) {
            _year = _selectDate.year.toString();
            _month = _selectDate.month.toString();
            _date = _selectDate.day.toString();
            _birthController.text = '$_year' + '-' + '$_month' + '-' + '$_date';
          } else {
            _birthController.text = 'error';
          }
        }).showDialog(context);
  }

  Widget _jobInput(_user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '직업',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        TextField(
          controller: _jobController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.badge_outlined,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              splashRadius: 1.0,
              onPressed: () {
                _jobController.clear();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
            hintText: '직업을 입력해주세요.',
            filled: true,
            fillColor: Color(0xfff6f6fd),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (String text) {},
          onSubmitted: (String text) {},
        ),
      ],
    );
  }

  Widget _userNameInput(_user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이름',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        TextField(
          controller: _userNameController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle_outlined,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              splashRadius: 1.0,
              onPressed: () {
                _userNameController.clear();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
            hintText: _user.userName,
            filled: true,
            fillColor: Color(0xfff6f6fd),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (String text) {},
          onSubmitted: (String text) {},
        ),
      ],
    );
  }

  Widget _pwdConfirmInput(_user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호 확인',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        TextField(
          controller: _pwdConfirmController,
          cursorColor: Colors.black,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              splashRadius: 1.0,
              onPressed: () {
                _pwdConfirmController.clear();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
            hintText: '비밀번호를 한 번 더 입력해주세요.',
            filled: true,
            fillColor: Color(0xfff6f6fd),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (String text) {},
          onSubmitted: (String text) {},
        ),
      ],
    );
  }

  Widget _pwdInput(_user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        TextField(
          controller: _pwdController,
          cursorColor: Colors.black,
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              splashRadius: 1.0,
              onPressed: () {
                _pwdController.clear();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
            hintText: '비밀번호를 입력해주세요.',
            filled: true,
            fillColor: Color(0xfff6f6fd),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (String text) {},
          onSubmitted: (String text) {},
        ),
      ],
    );
  }


  Widget _emailInput(_user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이메일',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
        TextField(
          controller: _emailController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              splashRadius: 1.0,
              onPressed: () {
                _emailController.clear();
              },
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
            hintText: _user.email,
            filled: true,
            fillColor: Color(0xfff6f6fd),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (String text) {},
          onSubmitted: (String text) {},
        ),
      ],
    );
  }

  Widget _profileBox(Size size, UserModel user) {
    return SizedBox(
      height: size.height * 0.3,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipOval(
          child: image != null
              ? Image.file(
                  image!,
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  fit: BoxFit.cover,
                )
              : Image.network(
                  'https://cdn.pixabay.com/photo/2012/04/26/19/43/profile-42914_1280.png',
                  fit: BoxFit.cover,
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: size.width * 0.2,
                    width: size.width * 0.2,
                    color: mainBabyBlue,
                  ),
                ),
        ),
        const SizedBox(height: 28),
        ElevatedButton.icon(
          label: Text('Pick Gallery'),
          icon: Icon(Icons.camera_alt_outlined),
          onPressed: () => pickImage(ImageSource.gallery),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          label: Text('Pick Camera'),
          icon: Icon(Icons.camera_alt_outlined),
          onPressed: () => pickImage(ImageSource.camera),
        )
      ]),
    );
  }

  void showSnackBar(String text) {
    final snackBar =
        SnackBar(duration: Duration(milliseconds: 500), content: Text(text));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _requestMentoringButton(BuildContext context, Size size, _user) async {
    //mentor 컬렉션 내 mentee_uid에 필요한 데이터 객체 생성
    Map<String, dynamic>? myData = {};

    //내 정보 받아오기
    myData = {
      'job': _jobController.text,
      'phoneNumber': _phoneNumberController.text,
    };

    await FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
      'job': myData['job'],
      'phone_number': myData['phoneNumber'],
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('수정 완료'),
      ));
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });

      return debugPrint("Failed to add user: $error");
    });
  }
}
