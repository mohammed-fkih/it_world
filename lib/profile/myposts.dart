import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Home/posts/list_of_post.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key, required this.userId, required this.showFollow});
  final String userId;
  final int showFollow;
  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
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
    fetchedData.sort((a, b) => b['timeStamp'].compareTo(a['timeStamp']));

    List<Map<String, dynamic>> myPosts =
        fetchedData.where((post) => post['userId'] == widget.userId).toList();

    if (mounted) {
      setState(() {
        post = myPosts;
        isDataLoaded = true;
      });
    }
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
              shrinkWrap: true,
              itemCount: post.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return PostWidget(
                  postId: post[index]['gID'] ?? '' ,
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
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
