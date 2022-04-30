import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:semomen/model/post_model.dart';
import 'package:semomen/pages/detail_guide_info_page.dart';
import 'package:semomen/providers/post_provider.dart';
import 'package:semomen/providers/search_provider.dart';

enum searchCategory { title, mentor, job }

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchTextController = TextEditingController();
  late String selectedCategory;

  @override
  void initState() {
    selectedCategory = searchCategory.title.name;
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]); // 세로 방향 고정
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          '검색',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchTypeIndicator(size),
          _searchField(size),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Text(
                '검색 결과',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            ),
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
          GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = searchCategory.title.name;
                context.read<SearchProvider>().resetResults();
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              width: (size.width - 48.0) / 3,
              decoration: BoxDecoration(
                color: selectedCategory == searchCategory.title.name
                    ? Color(0xff05445e)
                    : Color(0xfff6f6fd),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                '제목',
                style: TextStyle(
                    color: selectedCategory == searchCategory.title.name
                        ? Colors.white
                        : Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = searchCategory.mentor.name;
                context.read<SearchProvider>().resetResults();
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              width: (size.width - 48.0) / 3,
              decoration: BoxDecoration(
                color: selectedCategory == searchCategory.mentor.name
                    ? Color(0xff05445e)
                    : Color(0xfff6f6fd),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                '멘토',
                style: TextStyle(
                    color: selectedCategory == searchCategory.mentor.name
                        ? Colors.white
                        : Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = searchCategory.job.name;
                context.read<SearchProvider>().resetResults();
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              width: (size.width - 48.0) / 3,
              decoration: BoxDecoration(
                color: selectedCategory == searchCategory.job.name
                    ? Color(0xff05445e)
                    : Color(0xfff6f6fd),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                '직업',
                style: TextStyle(
                    color: selectedCategory == searchCategory.job.name
                        ? Colors.white
                        : Colors.grey,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: TextField(
        controller: _searchTextController,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            splashRadius: 1.0,
            onPressed: () {
              _searchTextController.clear();
              context.read<SearchProvider>().resetResults();
            },
            icon: Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
          hintText: '검색 단어를 입력해주세요.',
          filled: true,
          fillColor: Color(0xfff6f6fd),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        onChanged: (String text) {},
        onSubmitted: (String text) {
          context.read<SearchProvider>().getSearchResult(
              category: selectedCategory,
              searchText: _searchTextController.text);
        },
      ),
    );
  }

  Widget _searchResult(Size size) {
    List<PostModel> posts = context.watch<SearchProvider>().searchResults;
    return Expanded(
      child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            PostModel post = posts[index];
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailGuideInfoPage(post: post)));
                },
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
                              borderRadius: BorderRadius.circular(4.0),
                              color: Colors.grey,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                onError: (object, stackTrace) {},
                                image: NetworkImage(
                                  post.jobImgUrl,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          SizedBox(
                            width: size.width * 0.55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.introTitle,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  post.userName + ' 멘토',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  post.intro,
                                  style: TextStyle(color: Colors.grey),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '⭐⭐⭐⭐⭐ 5.0',
                                  style: TextStyle(
                                      color: Colors.yellow[600],
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
