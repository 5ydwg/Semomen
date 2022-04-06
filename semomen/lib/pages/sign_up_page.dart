import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:semomen/constants/constant.dart';
import 'package:semomen/model/user_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdConfirmController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _birthController = TextEditingController();
  TextEditingController _jobController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();



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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '회원가입',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
           children: [
             ListView(
               children: [
                 _emailInput(),
                 Divider(),
                 _pwdInput(),
                 Divider(),
                 _pwdConfirmInput(),
                 Divider(),
                 _userNameInput(),
                 Divider(),
                 _dateOfBirthInput(context),
                 Divider(),
                 _jobInput(),
                 Divider(),
                 _phoneNumberInput(),
                 SizedBox(height: 70.0,),
               ],
             ),
             Positioned(
               bottom: 0.0,
               child: SizedBox(
                 width: size.width - 24.0,
                 child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                     primary: mainNavyBlue
                   ),
                     onPressed: () {
                       createUserData(users);
                     },
                     child: Text('가입하기')),
               ),
             ),

           ],
          ),
        ),
      ),
    );
  }

  Widget _phoneNumberInput() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('휴대폰 번호', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                TextField(
                  controller: _phoneNumberController,
                  cursorColor: Colors.black,
                  maxLength: 11,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone_android_outlined, color: Colors.grey,),
                    suffixIcon: IconButton(
                      splashRadius: 1.0,
                      onPressed: () {
                        _phoneNumberController.clear();
                      },
                      icon: Icon(Icons.cancel, color: Colors.grey,),
                    ),
                    hintText: '숫자만 입력해주세요',
                    filled: true,
                    fillColor: Color(0xfff6f6fd),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (String text) {
                  },
                  onSubmitted: (String text) {
                  },
                ),
              ],
            );
  }

  Widget _dateOfBirthInput(BuildContext context) {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('생년월일', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                TextField(
                  controller: _birthController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      splashRadius: 1.0,
                      onPressed: () {
                        showPickerDate(context);
                      },
                      icon: Icon(Icons.arrow_drop_down, color: Colors.grey,),
                    ),
                    hintText: '생년월일을 선택해주세요.',
                    filled: true,
                    fillColor: Color(0xfff6f6fd),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (String text) {
                  },
                  onSubmitted: (String text) {
                  },
                ),
              ],
            );
  }

  // use flutter_picker: ^2.0.3
  void showPickerDate(BuildContext context) {
    Picker(
        hideHeader: true,
        adapter: DateTimePickerAdapter(),
        title: Text("생년월일"),
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancelText: '취소',
        confirmText: '확인',
        onConfirm: (Picker picker, List value) {
          DateTime? _selectDate = (picker.adapter as DateTimePickerAdapter).value;
          String _year;
          String _month;
          String _date;
          if(_selectDate != null) {
            _year = _selectDate.year.toString();
            _month = _selectDate.month.toString();
            _date = _selectDate.day.toString();
            _birthController.text = '$_year'+'-'+'$_month'+'-'+'$_date';
          } else {
            _birthController.text = 'error';
          }
        })
        .showDialog(context);
  }

  Widget _jobInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('직업', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
        TextField(
          controller: _jobController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.badge_outlined, color: Colors.grey,),
            suffixIcon: IconButton(
              splashRadius: 1.0,
              onPressed: () {
                _jobController.clear();
              },
              icon: Icon(Icons.cancel, color: Colors.grey,),
            ),
            hintText: '직업을 입력해주세요.',
            filled: true,
            fillColor: Color(0xfff6f6fd),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onChanged: (String text) {
          },
          onSubmitted: (String text) {
          },
        ),
      ],);
  }
  Widget _userNameInput() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이름', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                TextField(
                  controller: _userNameController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined, color: Colors.grey,),
                    suffixIcon: IconButton(
                      splashRadius: 1.0,
                      onPressed: () {
                        _userNameController.clear();
                      },
                      icon: Icon(Icons.cancel, color: Colors.grey,),
                    ),
                    hintText: '이름을 입력해주세요.',
                    filled: true,
                    fillColor: Color(0xfff6f6fd),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (String text) {
                  },
                  onSubmitted: (String text) {
                  },
                ),
            ],);
  }

  Widget _pwdConfirmInput() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('비밀번호 확인', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                TextField(
                  controller: _pwdConfirmController,
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
                    suffixIcon: IconButton(
                      splashRadius: 1.0,
                      onPressed: () {
                        _pwdConfirmController.clear();
                      },
                      icon: Icon(Icons.cancel, color: Colors.grey,),
                    ),
                    hintText: '비밀번호를 한 번 더 입력해주세요.',
                    filled: true,
                    fillColor: Color(0xfff6f6fd),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (String text) {
                  },
                  onSubmitted: (String text) {
                  },
                ),
            ],);
  }

  Widget _pwdInput() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                TextField(
                  controller: _pwdController,
                  cursorColor: Colors.black,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.grey,),
                    suffixIcon: IconButton(
                      splashRadius: 1.0,
                      onPressed: () {
                        _pwdController.clear();
                      },
                      icon: Icon(Icons.cancel, color: Colors.grey,),
                    ),
                    hintText: '비밀번호를 입력해주세요.',
                    filled: true,
                    fillColor: Color(0xfff6f6fd),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (String text) {
                  },
                  onSubmitted: (String text) {
                  },
                ),
              ],
            );
  }

  Widget _emailInput() {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이메일', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),),
                TextField(
                  controller: _emailController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey,),
                    suffixIcon: IconButton(
                      splashRadius: 1.0,
                      onPressed: () {
                        _emailController.clear();
                      },
                      icon: Icon(Icons.cancel, color: Colors.grey,),
                    ),
                    hintText: '이메일을 입력해주세요.',
                    filled: true,
                    fillColor: Color(0xfff6f6fd),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (String text) {
                  },
                  onSubmitted: (String text) {
                  },
                ),
              ],
            );
  }

  Future<void> createUserData(CollectionReference users) async{
    Map<String, dynamic> _userMap = UserModel(uid: '', userName: '', email: '', phoneNumber: '', birth: '', job: '').toJson();

    return await users.doc('1asfgh254tazsf').set(_userMap)
        .then((value) {
      print("User Added");
    })
        .catchError((error) => print("Failed to add user: $error"));
  }


}
