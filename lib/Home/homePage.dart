import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Home/posts/addPost.dart';

import 'posts/list_of_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    // setData();
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  text: 'المنشورات العامة',
                ),
                Tab(
                  text: 'منشورات من تتابعهم',
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PostScreen()),
              );
            },
            child: const Icon(Icons.edit_outlined),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              Page1(),
              Page2(),
            ],
          ),
        ));
  }
}

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List<Map<String, dynamic>> post = [];
  bool isDataLoaded = false;
  List<Map<String, dynamic>> commands = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    List<Map<String, dynamic>> fetchedData =
        await FireBase().fetchAllDataFromFirebase('posts');
    fetchedData.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));
    if (mounted) {
      setState(() {
        post = fetchedData;
        isDataLoaded = true;
         
      });
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isDataLoaded
        ? RefreshIndicator(
            onRefresh: () {
              getData();
              return Future.delayed(const Duration(seconds: 2), () {});
            },
            child: ListView.builder(
              itemCount: post.length,
              itemBuilder: (context, index) {
               commands = (post[index]['commends'] ?? []).cast<Map<String, dynamic>>();
                return PostWidget(
                  postId: post[index]['gID'] ?? '',
                  postContent: post[index]['text'] ?? '',
                  postDate: post[index]['timeStamp'],
                  imageUrl: post[index]['imageUrl'] ?? '',
                  vedioUrl: post[index]['vedioUrl'] ?? '',
                  fileUrl: post[index]['fileUrl'] ?? '',
                  userId: post[index]['userId'] ?? '',
                  comments: commands.length,

                  like: post[index]['like'] ?? 0,
                );
              },
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<Map<String, dynamic>> post = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    List<Map<String, dynamic>> fetchedData =
        await FireBase().fetchAllDataFromFirebase('posts');

    if (mounted) {
      setState(() {
        post = fetchedData;
        isDataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isDataLoaded
        ? ListView.builder(
            itemCount: post.length,
            itemBuilder: (context, index) {
              return PostWidget(
                postId: post[index]['gID'] ?? '',
                postContent: post[index]['text'] ?? '',
                postDate: post[index]['timeStamp'],
                imageUrl: post[index]['imageUrl'] ?? '',
                vedioUrl: post[index]['vedioUrl'] ?? '',
                fileUrl: post[index]['fileUrl'] ?? '',
                userId: post[index]['userId'] ?? '',
                comments: post[index]['command'] ?? [],
                like: post[index]['like'] ?? 0,
              );
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
