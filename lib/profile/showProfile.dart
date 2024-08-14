import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:it_world/Chat/chat/chatScreen.dart';
import 'package:it_world/DataBase/firebase_database.dart';
import 'package:it_world/profile/myposts.dart';
import 'package:it_world/profile/showProfileData.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<ShowProfile> createState() => _ShowState();
}

class _ShowState extends State<ShowProfile> {
  List<dynamic> follower = [];
  List<dynamic> followed = [];
  List<dynamic> followerCount = [];
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

  // Future<void> getUserData() async {}
  Map<String, dynamic> userData = {};
  Map<String, dynamic> curent = {};
  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    userData = (await FireBase()
        .fetchDataFromFirebase_DoucmentID('users', widget.userId))!;
    curent = (await FireBase()
        .fetchDataFromFirebase_DoucmentID('users', user!.uid))!;
    followerCount = userData['follower'] ?? [];
    followed = userData['followed'] ?? [];
    follower = curent['follower']??[];
    setState(() {});
  }

  // ignore: non_constant_identifier_names
  List<dynamic> Page = [];
  @override
  void initState() {
    getUserData();
    super.initState();
    Page = [
      MyPosts(userId: widget.userId, showFollow: 0),
      ShowProFileData(userId: widget.userId),
    ];
    setState(() {});
  }

  // ignore: non_constant_identifier_names

  int index1 = 0;
  double valution = 0;
  int countVotes = 1000;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الملف الشخصي"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(1),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueGrey, width: 0.5),
                borderRadius: BorderRadius.circular(10)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 140,
                          height: 140,
                          child: userData['imageUrl'] != null
                              ? Image.network(
                                  userData['imageUrl']!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.black12,
                                ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userData['name'] ?? "",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 35,
                    width: 75,
                    child: Center(
                      child: InkWell(
                          onTap: () async {
                            setState(() {
                              if (follower.contains(userData['id'])) {
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
                                                            userData['id']);
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
                                                                userData['id'],
                                                                {
                                                              'followed':
                                                                  followed
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
                                follower.add(userData['id']);
                                setState(() {
                                  final user =
                                      FirebaseAuth.instance.currentUser;
                                  followed.add(user!.uid);
                                  FireBase().updateDataInFirebase('users',
                                      user.uid, {'follower': follower});
                                  FireBase().updateDataInFirebase('users',
                                      userData['id'], {'followed': followed});
                                });
                              }
                            });
                          },
                          child: userData['id'] !=
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: follower.contains(userData['id'])
                                          ? Colors.white
                                          : Colors.blueGrey,
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 0.7),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: follower.contains(userData['id'])
                                      ? const Text(
                                          "إلغاء المتابعة",
                                          style:
                                              TextStyle(color: Colors.blueGrey),
                                        )
                                      : const Text(
                                          "متابعة",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                )
                              : null),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text(
                     'هندسة حاسبات',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.message,
                      color: Colors.blueGrey,
                      size: 30,
                    ),
                    onPressed: () {
                       Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                          email: userData['email']??'',
                          name: userData['name']??"",
                          image: userData['imageUrl'] ?? ''),
                    ),
                  );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text("${follower.length} يتابع"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("${followed.length} يتابعه"),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("قيم الحساب  : "),
                Column(
                  children: [
                    RatingBar.builder(
                      initialRating: valution,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, index) {
                        return Icon(
                          index < 3 ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        );
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          valution = rating;
                          countVotes++;
                        });
                      },
                    ),
                    Text(
                      "$countVotes  مقيم",
                      style: const TextStyle(fontSize: 10),
                    )
                  ],
                )
              ]),
              const SizedBox(
                height: 15,
              ),
              Text(userData['createdAt'] != null
                  ? "إلتحق بالتطيبق في  ${formatPostDate(userData['createdAt'])}"
                  : " "),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          index1 = 0;
                        });
                      },
                      child: Text(
                        'المنشورات ',
                        style: TextStyle(
                            fontWeight: index1 == 0
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          index1 = 1;
                        });
                      },
                      child: Text(
                        'الملف الشخصي',
                        style: TextStyle(
                            fontWeight: index1 == 1
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ))
                ],
              ),
              const Divider(),
              Container(
                child: Page[index1],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
