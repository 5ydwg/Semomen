import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);  // 세로 방향 고정
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('검색', style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchTypeIndicator(size),
          _searchField(size),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('검색 결과', style: TextStyle(fontSize:16.0,fontWeight: FontWeight.bold),),
          ),
          _searchResult(size),
        ],
      ),
    );
  }

  Widget _searchTypeIndicator(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            height: 50.0,
            width: (size.width-48.0)/3,
            decoration: BoxDecoration(
              color: Color(0xfff6f6fd),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text('멘토', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
          ),
          Container(
            alignment: Alignment.center,
            height: 50.0,
            width: (size.width-48.0)/3,
            decoration: BoxDecoration(
              color: Color(0xff05445e),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text('가이드', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
          ),
          Container(
            alignment: Alignment.center,
            height: 50.0,
            width: (size.width-48.0)/3,
            decoration: BoxDecoration(
              color: Color(0xfff6f6fd),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text('직업', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
          ),
        ],),
    );
  }
  Widget _searchField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: TextField(
        controller: _searchTextController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey,),
          suffixIcon: IconButton(
            splashRadius: 1.0,
            onPressed: () {
              _searchTextController.clear();
            },
            icon: Icon(Icons.cancel, color: Colors.grey,),
          ),
          hintText: '검색 단어를 입력해주세요.',
          filled: true,
          fillColor: Color(0xfff6f6fd),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onChanged: (String text) {
          debugPrint(text);
        },
        onSubmitted: (String text) {
          debugPrint("on submitted: "+text);
        },

      ),
    );
  }
  Widget _searchResult(Size size) {
    return Expanded(
      child: ListView.builder(
          itemCount: 40,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.3,
                        height: size.width * 0.3,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      SizedBox(width: 12.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title $index', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                          Text('Description $index', style: TextStyle(color: Colors.grey),),
                          Text('⭐⭐⭐⭐⭐ 5.0', style: TextStyle(color: Colors.yellow[600], fontWeight: FontWeight.bold),),
                        ],),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
