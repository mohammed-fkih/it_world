import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Home/posts/commandElelemnt.dart';
import 'package:it_world/Home/posts/list_of_post.dart';

class CommandScreen extends StatefulWidget {
  const CommandScreen({super.key, required this.postId});
  final String postId;

  @override
  State<CommandScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<CommandScreen> {
  Map<String, dynamic> command = {};
  Map<String, dynamic> postData = {};
  List<Map<String, dynamic>> comments = [];
  
 List<Map<String, dynamic>> userData = [];
  TextEditingController commendControl = TextEditingController();
  @override
  void initState() {
    super.initState();

    getPostData();
    setState(() {});
  }
  Future<void> getPostData() async {
  postData = (await FireBase()
      .fetchDataFromFirebase_DoucmentID('posts', widget.postId))!;
  comments = (postData['commends'] ?? []).cast<Map<String, dynamic>>();
  setState(() {});
}

  
 
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المنشور'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: PostWidget(
                    postId: postData['gID'] ?? '',
                    postContent: postData['text'] ?? '',
                    postDate: postData['timeStamp'] != null
                        ? postData['timeStamp'] as Timestamp
                        : Timestamp.now(),
                    imageUrl: postData['imageUrl'] ?? '',
                    vedioUrl: postData['vedioUrl'] ?? '',
                    fileUrl: postData['fileUrl'] ?? '',
                    userId: postData['userId'] ?? '',
                    comments: comments.length,
                    like: postData['like'] ?? 0,
                  ),
                ),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'التعليقات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ElementCommend(content:comment['content'] ,userId:comment['commenterId'] ,);
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: commendControl,
                          decoration: const InputDecoration(
                            hintText: ' إكتب تعليقك هنا ...',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            if (commendControl.text.isNotEmpty &&
                                commendControl.text != " ") {
                              final user = FirebaseAuth.instance.currentUser;
                              command = {
                                'commenterId': user?.uid,
                                'postId': widget.postId,
                                'content': commendControl.text,
                                'createdAt': DateTime.now(),
                              };
                              comments.add(command);
                              FireBase().updateDataInFirebase(
                                  'posts', widget.postId, {
                                'commends': comments,
                              });
                              commendControl.clear();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("لايمكن أن يكون ألتعليق فارغ")));
                            }
                          });
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
