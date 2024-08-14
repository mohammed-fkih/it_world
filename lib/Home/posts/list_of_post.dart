import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/Home/posts/addPost.dart';
import 'package:it_world/Home/posts/command.dart';
import 'package:it_world/profile/showProfile.dart';

class PostWidget extends StatefulWidget {
  final String userId;
  final String postContent;
  final String imageUrl;
  final String vedioUrl;
  final String fileUrl;
  final int like;
  final int comments;
  final String? postId;
  final Timestamp postDate;

  const PostWidget({
    super.key,
    required this.postContent,
    this.like = 0,
    this.comments = 0,
    required this.postDate,
    required this.userId,
    required this.imageUrl,
    required this.vedioUrl,
    required this.fileUrl,
   required this.postId,
  });

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  List<Map<String, dynamic>> users = [];
  Map<String, dynamic> userpup = {};
  Map<String, dynamic> curent = {};
  List<dynamic> follower = [];
  List<dynamic> followed = [];
  int statue = 0;
  bool _showOptions = false;
  @override
  void initState() {
    super.initState();
    getUersData();
  }

  Future<void> getUersData() async {
    users = await FireBase().fetchAllDataFromFirebase('users');
    final user = FirebaseAuth.instance.currentUser;
    if (mounted) {
      setState(() {
        userpup = users.firstWhere((element) => element['id'] == widget.userId,
            orElse: () => {});
        curent = users.firstWhere((element) => element['id'] == user!.uid,
            orElse: () => {});
      });
    }
    follower = curent['follower'] ?? [];
    followed = userpup['followed'] ?? [];
  }

  String formatPostDate(Timestamp dateTime) {
    DateTime dateTimeObject = dateTime.toDate();
    final now = DateTime.now();
    final difference = now.difference(dateTimeObject);
    if (difference.inSeconds < 60) {
      return "الآن";
    } else if (difference.inMinutes < 60) {
      return 'قبل  ${difference.inMinutes}  دقيقة';
    } else if (difference.inHours < 24) {
      return 'قبل  ${difference.inHours} ساعة';
    } else {
      final formattedDate =
          '${dateTimeObject.day}-${dateTimeObject.month}-${dateTimeObject.year}';
      return formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        DialogRoute(
                            context: context,
                            builder: (context) => ShowProfile(
                                  userId: userpup['id'],
                                )));
                  },
                  child: Row(
                    children: [
                      if (userpup['imageUrl'] != null) ...[
                        CircleAvatar(
                            backgroundImage:
                                NetworkImage(userpup['imageUrl'] ?? "")),
                      ] else ...[
                        CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                      ],
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userpup['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatPostDate(widget.postDate),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if( (userpup['id'] ==
                                    FirebaseAuth.instance.currentUser!.uid || follower.contains(userpup['id']) ))...[]else...[
                    SizedBox(
                      height: 35,
                      width: 75,
                      child: Center(
                        child: InkWell(
                            onTap: () async {
                              if (follower.contains(userpup['id'])) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: SingleChildScrollView(
                                          child: AlertDialog(
                                            content: const Center(
                                              child: Text(
                                                  "هل تريد بالفعل إلغاء المتابعة"),
                                            ),
                                            title: const Text(
                                              "إلغاء المتابعة",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        final user =
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser;
                                                        follower.remove(
                                                            userpup['id']);
                                                        followed
                                                            .remove(user!.uid);

                                                        FireBase()
                                                            .updateDataInFirebase(
                                                                'users',
                                                                user.uid, {
                                                          'follower': follower
                                                        });
                                                        FireBase()
                                                            .updateDataInFirebase(
                                                                'users',
                                                                userpup['id'], {
                                                          'followed': followed
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                        "إلغاء المتابعة"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("إلغاء "),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                follower.add(userpup['id']);

                                setState(() {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  followed.add(user!.uid);
                                  FireBase().updateDataInFirebase('users',
                                      user.uid, {'follower': follower});
                                  FireBase().updateDataInFirebase('users',
                                      userpup['id'], {'followed': followed});
                                });
                              }
                            },
                            child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: follower.contains(userpup['id'])
                                            ? Colors.white
                                            : Colors.blueGrey,
                                        border: Border.all(
                                            color: Colors.blueGrey, width: 0.7),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Text(
                                            "متابعة",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                    // follower.contains(userpup['id'])
                                    //     ? const Text(
                                    //         "إلغاء المتابعة",
                                    //         style: TextStyle(
                                    //             color: Colors.blueGrey),
                                    //       )
                                    //     : 
                                  )
                                ),
                      ),
                    ),],
                    IconButton(
          onPressed: () {
            final user=FirebaseAuth.instance.currentUser;
            setState(() {
              _showOptions = !_showOptions;
            });
            if (_showOptions) {
            showDialog(context: context, builder: (context){
              return AlertDialog(
                content: SingleChildScrollView(
                  child: Column(
                              children: [
                  ListTile(
                    leading: const Icon(Icons.share),
                    title: const Text('مشاركة المنشور'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.repeat),
                    title: const Text('إعادة نشر'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  if(widget.userId==user!.uid)...[
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('حذف المنشور'),
                    onTap: () async{
                     await FireBase().deleteDataFromFirebase('posts', widget.postId.toString());
                      Navigator.pop(context);
                    },
                  ),],
                              ]),
                ),
              );
          
        
             } );}
          },
          icon: const Icon(Icons.more_vert),
        ),
        
                  ],
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.postContent,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            widget.imageUrl.isNotEmpty && Uri.parse(widget.imageUrl).isAbsolute
                ? Image.network(widget.imageUrl)
                : const SizedBox(),
            widget.vedioUrl.isNotEmpty && Uri.parse(widget.vedioUrl).isAbsolute
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 0.5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: VideoPlayers(videoPath: widget.vedioUrl),
                      ),
                    ),
                  )
                : const SizedBox(),
            widget.fileUrl.isNotEmpty && Uri.parse(widget.fileUrl).isAbsolute
                ? Image.network(widget.fileUrl)
                : const SizedBox(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  IconButton(
                    icon: const Icon(
                      Icons.thumb_up_outlined,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {},
                  ),
                  Text(widget.like.toString()),
                  IconButton(
                    icon: const Icon(
                      Icons.thumb_down_off_alt_outlined,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {},
                  ),
                  Text(widget.like.toString()),
                ]),
                const SizedBox(width: 10),
                Row(children: [
                  IconButton(
                    icon: const Icon(
                      Icons.comment,
                      color: Colors.blueGrey,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommandScreen(
                                    postId: widget.postId!,
                                  )));
                    },
                  ),
                  Text(widget.comments.toString()),
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
